# Physical iPhone distribution readiness

## Current status
- GitHub Actions builds an **unsigned simulator** target. This cannot be installed on physical iPhones.
- Firebase email authentication scaffold is present; Firestore denies client access.
- No production family pairing or Screen Time enforcement is implemented.

## Supported installation paths
1. **Free Personal Team**: use Xcode on a Mac, sign with Apple Account, connect/register devices and reinstall after 7-day provisioning expiry. This does not meet an iPhone-only workflow.
2. **Apple Developer Program**: build and sign a physical-device iOS app using a Mac or macOS CI, then use TestFlight for two devices. Membership and signing assets are required.
3. **Alternative distribution**: jurisdiction and developer eligibility restrictions apply; not a general free workaround.

Do not assume an unsigned .ipa can be installed directly through Safari, Files, GitHub Actions artifacts, or Firebase App Distribution.

## Engineering work before device testing
- Set a permanent unique bundle ID and register matching Firebase app.
- Resolve Firebase Swift Package dependencies and build for generic iOS device (CODE_SIGNING_ALLOWED=NO) in CI to catch compilation issues; do not label output installable.
- Securely inject GoogleService-Info.plist into signed builds without committing it to a public repository.
- Implement server-validated parent/child roles, expiring invitations, revocation and authorization.
- Test Firebase Auth, Firestore rules (cross-family isolation), privacy disclosures and deletion.
- Implement and obtain the Family Controls entitlement before Screen Time API use; implement required extensions.

## Current user constraint
Only two iPhones; no Mac and no paid Apple Developer membership. Under these constraints, an ordinary self-built native iOS app cannot currently be installed as a persistent fully functional parental-control app through the standard Apple development workflow.
