/**
 * BC-Replay MFA Authentication Module
 * 
 * Handles Azure AD authentication with TOTP-based MFA for automated testing.
 * This module creates an authenticated Playwright browser context that can be
 * used by bc-replay to execute scripts without manual MFA interaction.
 * 
 * Usage:
 *   const { authenticateWithMFA } = require('./mfa-auth');
 *   const context = await authenticateWithMFA({
 *     username: process.env.BC_USERNAME,
 *     password: process.env.BC_PASSWORD,
 *     mfaSeed: process.env.BC_MFA_SEED,
 *     startAddress: 'https://businesscentral.dynamics.com/tenant/environment',
 *     headless: false
 *   });
 */

const { chromium } = require('playwright');
const { authenticator } = require('otplib');

/**
 * Generate a TOTP code from a base32-encoded seed
 * @param {string} seed - Base32-encoded seed from authenticator app setup
 * @returns {string} Six-digit TOTP code
 */
function generateTOTPCode(seed) {
  try {
    // Configure TOTP settings to match Microsoft Authenticator
    authenticator.options = {
      step: 30,      // Code refreshes every 30 seconds (standard)
      window: 1,     // Allow 1 time window before/after for clock drift
      digits: 6      // Six-digit codes (Microsoft default)
    };
    
    const token = authenticator.generate(seed);
    console.log(`[MFA] Generated TOTP code: ${token.substring(0, 2)}****`);
    return token;
  } catch (error) {
    throw new Error(`Failed to generate TOTP code: ${error.message}`);
  }
}

/**
 * Detect MFA prompt pages by checking various indicators
 * @param {Page} page - Playwright page object
 * @returns {Promise<string|null>} MFA type detected or null
 */
async function detectMFAPrompt(page) {
  const url = page.url();
  const title = await page.title().catch(() => '');
  
  // Common Azure AD MFA indicators
  const indicators = {
    url: [
      'login.microsoftonline.com',
      'login.live.com',
      '/kmsi',               // Keep me signed in
      '/SAS/ProcessAuth',    // Microsoft auth processing
      '/proofs/Confirm'      // MFA proof/verification
    ],
    title: [
      'verify',
      'authentication',
      'security code',
      'enter code',
      'multi-factor',
      'sign in'
    ],
    text: [
      'Enter code',
      'Verify your identity',
      'More information required',
      'Enter the code from your authenticator app'
    ]
  };
  
  // Check URL
  if (indicators.url.some(pattern => url.toLowerCase().includes(pattern))) {
    console.log(`[MFA] Detected MFA prompt via URL: ${url}`);
    
    // Check for TOTP input field
    const totpInput = await page.locator('input[name="otc"], input[type="tel"], input[aria-label*="code"]').first().count();
    if (totpInput > 0) {
      return 'TOTP';
    }
  }
  
  // Check page title
  const lowerTitle = title.toLowerCase();
  if (indicators.title.some(keyword => lowerTitle.includes(keyword))) {
    console.log(`[MFA] Detected MFA prompt via title: ${title}`);
    return 'TOTP';
  }
  
  // Check for specific MFA text on page
  for (const text of indicators.text) {
    const textFound = await page.locator(`text=${text}`).first().count();
    if (textFound > 0) {
      console.log(`[MFA] Detected MFA prompt via text: "${text}"`);
      return 'TOTP';
    }
  }
  
  return null;
}

/**
 * Handle TOTP MFA challenge
 * @param {Page} page - Playwright page object
 * @param {string} seed - TOTP seed
 * @param {number} timeout - Max wait time in milliseconds
 */
async function handleTOTPChallenge(page, seed, timeout = 30000) {
  console.log('[MFA] Handling TOTP challenge...');
  
  try {
    // Generate TOTP code
    const code = generateTOTPCode(seed);
    
    // Find TOTP input field (try multiple selectors)
    const inputSelectors = [
      'input[name="otc"]',                          // Microsoft common
      'input[type="tel"]',                          // Phone number type
      'input[aria-label*="code"]',                  // Accessible label
      'input[placeholder*="code"]',                 // Placeholder text
      '#idTxtBx_SAOTCC_OTC',                       // Microsoft specific ID
      'input[data-testid="otc-input"]'             // Test ID
    ];
    
    let inputFound = false;
    for (const selector of inputSelectors) {
      const input = page.locator(selector).first();
      if (await input.count() > 0) {
        console.log(`[MFA] Found TOTP input: ${selector}`);
        
        // Clear any existing value and enter code
        await input.fill('');
        await input.fill(code);
        await page.waitForTimeout(500); // Brief pause for UI update
        
        inputFound = true;
        break;
      }
    }
    
    if (!inputFound) {
      throw new Error('Could not find TOTP input field');
    }
    
    // Find and click submit button
    const buttonSelectors = [
      'button:has-text("Verify")',
      'button:has-text("Submit")',
      'button:has-text("Sign in")',
      'input[type="submit"][value*="Verify"]',
      'input[type="submit"][value*="Submit"]',
      '#idSubmit_SAOTCC_Continue'                   // Microsoft specific
    ];
    
    let buttonClicked = false;
    for (const selector of buttonSelectors) {
      const button = page.locator(selector).first();
      if (await button.count() > 0) {
        console.log(`[MFA] Clicking submit button: ${selector}`);
        await button.click();
        buttonClicked = true;
        break;
      }
    }
    
    if (!buttonClicked) {
      console.warn('[MFA] No submit button found, code may auto-submit');
    }
    
    // Wait for navigation away from MFA page
    console.log('[MFA] Waiting for authentication to complete...');
    await page.waitForURL(url => !url.includes('login'), { timeout });
    console.log('[MFA] ✓ TOTP authentication successful');
    
  } catch (error) {
    throw new Error(`TOTP challenge failed: ${error.message}`);
  }
}

/**
 * Handle "Stay signed in?" prompt
 * @param {Page} page - Playwright page object
 */
async function handleStaySignedInPrompt(page) {
  try {
    // Check for "Stay signed in?" prompt
    const kmsiText = await page.locator('text=Stay signed in?').count();
    if (kmsiText > 0) {
      console.log('[Auth] Handling "Stay signed in?" prompt...');
      
      // Click "No" to avoid storing credentials
      const noButton = page.locator('button:has-text("No"), input[type="button"][value="No"]').first();
      if (await noButton.count() > 0) {
        await noButton.click();
        await page.waitForTimeout(1000);
        console.log('[Auth] ✓ Dismissed "Stay signed in?" prompt');
      }
    }
  } catch (error) {
    console.warn(`[Auth] Could not handle stay signed in prompt: ${error.message}`);
  }
}

/**
 * Authenticate to BC with username, password, and MFA
 * @param {Object} options - Authentication options
 * @param {string} options.username - Azure AD username
 * @param {string} options.password - Azure AD password
 * @param {string} options.mfaSeed - Base32-encoded TOTP seed
 * @param {string} options.startAddress - BC URL to navigate to
 * @param {boolean} [options.headless=true] - Run browser in headless mode
 * @param {number} [options.timeout=60000] - Overall timeout in milliseconds
 * @returns {Promise<{context: BrowserContext, page: Page}>} Authenticated browser context and page
 */
async function authenticateWithMFA(options) {
  const {
    username,
    password,
    mfaSeed,
    startAddress,
    headless = true,
    timeout = 60000
  } = options;
  
  // Validate inputs
  if (!username || !password || !mfaSeed || !startAddress) {
    throw new Error('Missing required authentication parameters: username, password, mfaSeed, startAddress');
  }
  
  console.log('='.repeat(60));
  console.log('[Auth] Starting BC authentication with MFA support');
  console.log(`[Auth] Username: ${username}`);
  console.log(`[Auth] Target URL: ${startAddress}`);
  console.log(`[Auth] Headless mode: ${headless}`);
  console.log('='.repeat(60));
  
  let browser = null;
  try {
    // Launch browser
    browser = await chromium.launch({
      headless,
      timeout
    });
    
    const context = await browser.newContext({
      viewport: { width: 1920, height: 1080 },
      locale: 'en-US',
      timezoneId: 'America/New_York'
    });
    
    const page = await context.newPage();
    
    // Navigate to BC
    console.log('[Auth] Navigating to Business Central...');
    await page.goto(startAddress, { waitUntil: 'networkidle', timeout });
    
    // Wait for username field
    console.log('[Auth] Entering username...');
    await page.waitForSelector('input[type="email"], input[name="loginfmt"]', { timeout: 10000 });
    await page.fill('input[type="email"], input[name="loginfmt"]', username);
    await page.click('input[type="submit"], button[type="submit"]');
    
    // Wait for password field
    console.log('[Auth] Entering password...');
    await page.waitForSelector('input[type="password"], input[name="passwd"]', { timeout: 10000 });
    await page.fill('input[type="password"], input[name="passwd"]', password);
    await page.click('input[type="submit"], button[type="submit"]');
    
    // Wait for next page (could be MFA or "Stay signed in?")
    await page.waitForTimeout(2000);
    
    // Check for MFA prompt
    const mfaType = await detectMFAPrompt(page);
    if (mfaType === 'TOTP') {
      await handleTOTPChallenge(page, mfaSeed, timeout);
    } else {
      console.log('[Auth] No MFA prompt detected (may have been skipped)');
    }
    
    // Handle "Stay signed in?" if it appears
    await handleStaySignedInPrompt(page);
    
    // Wait for BC to fully load
    console.log('[Auth] Waiting for Business Central to load...');
    await page.waitForURL(url => url.includes('businesscentral'), { timeout: 30000 });
    await page.waitForTimeout(3000); // Extra time for BC initialization
    
    console.log('='.repeat(60));
    console.log('[Auth] ✓ Authentication complete!');
    console.log(`[Auth] Current URL: ${page.url()}`);
    console.log('='.repeat(60));
    
    return { context, page, browser };
    
  } catch (error) {
    if (browser) {
      await browser.close();
    }
    throw new Error(`Authentication failed: ${error.message}`);
  }
}

/**
 * Close browser and clean up
 * @param {Browser} browser - Playwright browser instance
 */
async function cleanup(browser) {
  if (browser) {
    console.log('[Cleanup] Closing browser...');
    await browser.close();
  }
}

module.exports = {
  authenticateWithMFA,
  generateTOTPCode,
  detectMFAPrompt,
  handleTOTPChallenge,
  cleanup
};
