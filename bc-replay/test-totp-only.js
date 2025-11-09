/**
 * Simple TOTP Generation Test
 * Tests that we can generate TOTP codes without requiring BC credentials
 */

const { authenticator } = require('otplib');

console.log('\n🔑 TOTP Generation Test\n');
console.log('='.repeat(60));

// Test with a known seed (example from Google Authenticator docs)
const testSeed = 'JBSWY3DPEHPK3PXP';

console.log('Test Seed:', testSeed);
console.log('');

try {
  // Configure TOTP settings
  authenticator.options = {
    step: 30,      // 30 second windows
    window: 1,     // Allow 1 window drift
    digits: 6      // 6 digit codes
  };
  
  // Generate code
  const code = authenticator.generate(testSeed);
  
  console.log('✅ TOTP generation successful!');
  console.log('');
  console.log('Generated code:', code);
  console.log('Code length:', code.length);
  console.log('Time remaining:', 30 - (Math.floor(Date.now() / 1000) % 30), 'seconds');
  console.log('');
  console.log('='.repeat(60));
  console.log('');
  console.log('Next steps:');
  console.log('  1. If you have this seed in your authenticator app, verify the codes match');
  console.log('  2. Run continuous generation:');
  console.log('     node totp-seed-helper.js generate "' + testSeed + '" 5');
  console.log('  3. Test with your actual BC account seed:');
  console.log('     $env:BC_MFA_SEED = "YOUR_SEED"');
  console.log('     node -e "const {authenticator} = require(\'otplib\'); console.log(authenticator.generate(process.env.BC_MFA_SEED));"');
  console.log('');
  
  process.exit(0);
  
} catch (error) {
  console.error('❌ TOTP generation failed!');
  console.error('Error:', error.message);
  console.error('');
  process.exit(1);
}
