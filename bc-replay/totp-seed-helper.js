/**
 * TOTP Seed Helper Utilities
 * 
 * Utilities to help with TOTP seed extraction, validation, and testing.
 * Use this during initial MFA setup to verify your seed works correctly.
 */

const { authenticator } = require('otplib');
const QRCode = require('qrcode');

/**
 * Validate a TOTP seed format
 * @param {string} seed - Base32-encoded seed to validate
 * @returns {Object} Validation result with isValid and message
 */
function validateSeed(seed) {
  if (!seed || typeof seed !== 'string') {
    return { isValid: false, message: 'Seed is required and must be a string' };
  }
  
  // Remove any whitespace
  const cleanSeed = seed.replace(/\s+/g, '');
  
  // Check if it's valid base32 (A-Z, 2-7)
  const base32Regex = /^[A-Z2-7]+$/;
  if (!base32Regex.test(cleanSeed)) {
    return { 
      isValid: false, 
      message: 'Invalid base32 format. Seed should only contain A-Z and 2-7 (no 0, 1, 8, 9)',
      cleanSeed
    };
  }
  
  // Check length (typically 16 or 32 characters)
  if (cleanSeed.length < 16) {
    return { 
      isValid: false, 
      message: 'Seed seems too short (typically 16-32 characters)',
      cleanSeed
    };
  }
  
  // Try to generate a code to verify it works
  try {
    const code = authenticator.generate(cleanSeed);
    return { 
      isValid: true, 
      message: 'Seed is valid!',
      cleanSeed,
      sampleCode: code
    };
  } catch (error) {
    return { 
      isValid: false, 
      message: `Seed validation failed: ${error.message}`,
      cleanSeed
    };
  }
}

/**
 * Generate TOTP codes continuously for testing
 * @param {string} seed - TOTP seed
 * @param {number} count - Number of codes to generate
 * @param {number} interval - Seconds between each generation
 */
async function generateContinuousCodes(seed, count = 5, interval = 5) {
  console.log('\n🔑 TOTP Code Generator');
  console.log('Compare these codes with your authenticator app:\n');
  
  for (let i = 0; i < count; i++) {
    const code = authenticator.generate(seed);
    const timeRemaining = 30 - (Math.floor(Date.now() / 1000) % 30);
    
    console.log(`[${new Date().toLocaleTimeString()}] Code: ${code} (valid for ${timeRemaining}s)`);
    
    if (i < count - 1) {
      await new Promise(resolve => setTimeout(resolve, interval * 1000));
    }
  }
}

/**
 * Generate a QR code from seed for scanning
 * @param {string} seed - TOTP seed
 * @param {string} account - Account name (e.g., user@tenant.com)
 * @param {string} issuer - Issuer name (e.g., Microsoft)
 * @returns {Promise<string>} QR code as data URL
 */
async function generateQRCode(seed, account, issuer = 'Microsoft') {
  const otpauthUrl = authenticator.keyuri(account, issuer, seed);
  
  try {
    const qrDataUrl = await QRCode.toDataURL(otpauthUrl);
    return qrDataUrl;
  } catch (error) {
    throw new Error(`Failed to generate QR code: ${error.message}`);
  }
}

/**
 * Parse otpauth URL to extract seed
 * @param {string} url - otpauth:// URL from QR code
 * @returns {Object} Parsed components
 */
function parseOTPAuthURL(url) {
  try {
    // Example: otpauth://totp/Microsoft:user@tenant.com?secret=ABC123&issuer=Microsoft
    const urlObj = new URL(url);
    
    if (urlObj.protocol !== 'otpauth:') {
      throw new Error('URL must start with otpauth://');
    }
    
    const type = urlObj.hostname; // totp or hotp
    const label = decodeURIComponent(urlObj.pathname.slice(1));
    const params = new URLSearchParams(urlObj.search);
    
    const secret = params.get('secret');
    const issuer = params.get('issuer');
    const algorithm = params.get('algorithm') || 'SHA1';
    const digits = params.get('digits') || '6';
    const period = params.get('period') || '30';
    
    return {
      type,
      label,
      secret,
      issuer,
      algorithm,
      digits: parseInt(digits),
      period: parseInt(period),
      isValid: !!secret
    };
  } catch (error) {
    return {
      isValid: false,
      error: error.message
    };
  }
}

// CLI Interface
if (require.main === module) {
  const args = process.argv.slice(2);
  const command = args[0];
  
  if (!command || command === 'help') {
    console.log(`
TOTP Seed Helper - Usage:

  Validate a seed:
    node totp-seed-helper.js validate YOUR_SEED_HERE
    
  Generate test codes:
    node totp-seed-helper.js generate YOUR_SEED_HERE [count] [interval]
    
  Parse otpauth URL:
    node totp-seed-helper.js parse "otpauth://totp/Microsoft:user@tenant.com?secret=ABC123"
    
  Generate QR code:
    node totp-seed-helper.js qrcode YOUR_SEED_HERE user@tenant.com [issuer]
    
Examples:
  node totp-seed-helper.js validate "JBSWY3DPEHPK3PXP"
  node totp-seed-helper.js generate "JBSWY3DPEHPK3PXP" 10 5
  node totp-seed-helper.js parse "otpauth://totp/Microsoft:user@tenant.com?secret=JBSWY3DPEHPK3PXP"
    `);
    process.exit(0);
  }
  
  switch (command) {
    case 'validate': {
      const seed = args[1];
      if (!seed) {
        console.error('Error: Seed is required');
        console.log('Usage: node totp-seed-helper.js validate YOUR_SEED');
        process.exit(1);
      }
      
      const result = validateSeed(seed);
      console.log('\n🔍 Seed Validation Result:');
      console.log(`   Status: ${result.isValid ? '✅ Valid' : '❌ Invalid'}`);
      console.log(`   Message: ${result.message}`);
      if (result.cleanSeed && result.cleanSeed !== seed) {
        console.log(`   Cleaned: ${result.cleanSeed}`);
      }
      if (result.sampleCode) {
        console.log(`   Sample Code: ${result.sampleCode}`);
        console.log('\n   Compare this code with your authenticator app!');
      }
      console.log('');
      process.exit(result.isValid ? 0 : 1);
    }
    
    case 'generate': {
      const seed = args[1];
      const count = parseInt(args[2]) || 5;
      const interval = parseInt(args[3]) || 5;
      
      if (!seed) {
        console.error('Error: Seed is required');
        console.log('Usage: node totp-seed-helper.js generate YOUR_SEED [count] [interval]');
        process.exit(1);
      }
      
      // Validate first
      const validation = validateSeed(seed);
      if (!validation.isValid) {
        console.error(`Error: ${validation.message}`);
        process.exit(1);
      }
      
      generateContinuousCodes(validation.cleanSeed, count, interval)
        .then(() => {
          console.log('\n✓ Code generation complete');
          process.exit(0);
        })
        .catch(error => {
          console.error(`Error: ${error.message}`);
          process.exit(1);
        });
      break;
    }
    
    case 'parse': {
      const url = args[1];
      if (!url) {
        console.error('Error: otpauth URL is required');
        console.log('Usage: node totp-seed-helper.js parse "otpauth://..."');
        process.exit(1);
      }
      
      const result = parseOTPAuthURL(url);
      console.log('\n🔍 OTPAuth URL Parsing Result:');
      if (result.isValid) {
        console.log('   Status: ✅ Valid');
        console.log(`   Type: ${result.type}`);
        console.log(`   Label: ${result.label}`);
        console.log(`   Secret: ${result.secret}`);
        console.log(`   Issuer: ${result.issuer || '(not specified)'}`);
        console.log(`   Algorithm: ${result.algorithm}`);
        console.log(`   Digits: ${result.digits}`);
        console.log(`   Period: ${result.period}s`);
        console.log('\n   Use this secret for BC_MFA_SEED:');
        console.log(`   $env:BC_MFA_SEED = "${result.secret}"`);
      } else {
        console.log('   Status: ❌ Invalid');
        console.log(`   Error: ${result.error}`);
      }
      console.log('');
      process.exit(result.isValid ? 0 : 1);
    }
    
    case 'qrcode': {
      const seed = args[1];
      const account = args[2];
      const issuer = args[3] || 'Microsoft';
      
      if (!seed || !account) {
        console.error('Error: Seed and account are required');
        console.log('Usage: node totp-seed-helper.js qrcode YOUR_SEED user@tenant.com [issuer]');
        process.exit(1);
      }
      
      // Validate seed first
      const validation = validateSeed(seed);
      if (!validation.isValid) {
        console.error(`Error: ${validation.message}`);
        process.exit(1);
      }
      
      generateQRCode(validation.cleanSeed, account, issuer)
        .then(qrDataUrl => {
          console.log('\n📱 QR Code Generated:');
          console.log(`   Account: ${account}`);
          console.log(`   Issuer: ${issuer}`);
          console.log(`   Seed: ${validation.cleanSeed}`);
          console.log('\n   QR Code Data URL (paste in browser):');
          console.log(`   ${qrDataUrl.substring(0, 100)}...`);
          console.log('\n   To use: Open this data URL in a browser and scan with authenticator app');
          console.log('');
          process.exit(0);
        })
        .catch(error => {
          console.error(`Error: ${error.message}`);
          process.exit(1);
        });
      break;
    }
    
    default:
      console.error(`Unknown command: ${command}`);
      console.log('Run "node totp-seed-helper.js help" for usage information');
      process.exit(1);
  }
}

module.exports = {
  validateSeed,
  generateContinuousCodes,
  generateQRCode,
  parseOTPAuthURL
};
