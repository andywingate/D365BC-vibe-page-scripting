/**
 * MFA Authentication Test Script
 * 
 * Tests the MFA authentication module independently before integrating with bc-replay.
 * This script validates that we can successfully authenticate to BC using TOTP MFA.
 * 
 * Prerequisites:
 *   npm install playwright otplib
 * 
 * Usage:
 *   # Set environment variables
 *   $env:BC_USERNAME = "testuser@tenant.onmicrosoft.com"
 *   $env:BC_PASSWORD = "YourPassword123"
 *   $env:BC_MFA_SEED = "JBSWY3DPEHPK3PXP"  # Your TOTP seed (base32)
 *   $env:BC_URL = "https://businesscentral.dynamics.com/tenant/sandbox"
 *   
 *   # Run test
 *   node test-mfa-auth.js
 */

const { authenticateWithMFA, cleanup } = require('./mfa-auth');

async function testMFAAuthentication() {
  console.log('\n🧪 Testing MFA Authentication Module\n');
  
  // Get credentials from environment variables
  const username = process.env.BC_USERNAME;
  const password = process.env.BC_PASSWORD;
  const mfaSeed = process.env.BC_MFA_SEED;
  const startAddress = process.env.BC_URL;
  
  // Validate environment variables
  const missing = [];
  if (!username) missing.push('BC_USERNAME');
  if (!password) missing.push('BC_PASSWORD');
  if (!mfaSeed) missing.push('BC_MFA_SEED');
  if (!startAddress) missing.push('BC_URL');
  
  if (missing.length > 0) {
    console.error('❌ Missing required environment variables:');
    missing.forEach(varName => console.error(`   - ${varName}`));
    console.error('\nSet them using:');
    console.error('   $env:BC_USERNAME = "your-email@tenant.com"');
    console.error('   $env:BC_PASSWORD = "YourPassword"');
    console.error('   $env:BC_MFA_SEED = "YOUR_BASE32_SEED"');
    console.error('   $env:BC_URL = "https://businesscentral.dynamics.com/tenant/sandbox"');
    process.exit(1);
  }
  
  console.log('Configuration:');
  console.log(`  Username: ${username}`);
  console.log(`  Password: ${'*'.repeat(password.length)}`);
  console.log(`  MFA Seed: ${mfaSeed.substring(0, 4)}${'*'.repeat(mfaSeed.length - 4)}`);
  console.log(`  BC URL: ${startAddress}`);
  console.log('');
  
  let browser = null;
  try {
    // Test authentication with MFA
    const result = await authenticateWithMFA({
      username,
      password,
      mfaSeed,
      startAddress,
      headless: false,  // Show browser for testing
      timeout: 90000    // 90 seconds total timeout
    });
    
    const { context, page, browser: browserInstance } = result;
    browser = browserInstance;
    
    // Verify we're logged in to BC
    const currentUrl = page.url();
    const title = await page.title();
    
    console.log('\n✅ Authentication Test PASSED!');
    console.log(`   Final URL: ${currentUrl}`);
    console.log(`   Page Title: ${title}`);
    
    // Take a screenshot as proof
    const screenshotPath = 'mfa-auth-success.png';
    await page.screenshot({ path: screenshotPath, fullPage: false });
    console.log(`   Screenshot saved: ${screenshotPath}`);
    
    // Keep browser open for 10 seconds so you can see it worked
    console.log('\n⏳ Keeping browser open for 10 seconds...');
    await page.waitForTimeout(10000);
    
    return true;
    
  } catch (error) {
    console.error('\n❌ Authentication Test FAILED!');
    console.error(`   Error: ${error.message}`);
    console.error(`   Stack: ${error.stack}`);
    return false;
    
  } finally {
    if (browser) {
      await cleanup(browser);
      console.log('\n🧹 Cleanup complete.');
    }
  }
}

// Run the test
testMFAAuthentication()
  .then(success => {
    console.log('\n' + '='.repeat(60));
    if (success) {
      console.log('🎉 Test completed successfully!');
      console.log('');
      console.log('Next steps:');
      console.log('  1. Verify the screenshot shows BC home page');
      console.log('  2. Integrate with bc-replay using npx-run-mfa.ps1');
      console.log('  3. Test with actual BC page scripts');
      process.exit(0);
    } else {
      console.log('💥 Test failed - see errors above');
      console.log('');
      console.log('Troubleshooting:');
      console.log('  - Verify username/password are correct');
      console.log('  - Verify MFA seed matches your authenticator app');
      console.log('  - Check if MFA codes from seed match app codes');
      console.log('  - Try running with headless: false to watch the process');
      process.exit(1);
    }
  })
  .catch(error => {
    console.error('\n💥 Unexpected error:', error);
    process.exit(1);
  });
