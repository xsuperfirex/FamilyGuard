# FamilyGuard V3

Prototype iOS application written in SwiftUI. The current build includes a demo parent/child role selector, local Screen Time authorization and restrictions, local device map, and setup checklist.

## Cloud simulator build

GitHub Actions runs on macOS, installs XcodeGen, generates an Xcode project from `project.yml`, and builds for iOS Simulator with code signing disabled. Go to Actions > Check iOS simulator build. A successful simulator build is **not** an installable IPA.

## Important limitations

- No parent-child device pairing, remote restrictions, server, or background location sharing yet.
- Demo roles are not authentication or authorization.
- Local Screen Time flow requests `individual` authorization; family controls require additional design and Apple entitlements.
- Family Controls distribution and device installation have Apple requirements. A free GitHub account does not bypass them.
- Do not store credentials, location histories, or child data in the repository.

## V4 family onboarding preview

The **Семья** tab now provides a local, privacy-first preview of parent/child onboarding and the required steps for future pairing. It deliberately does **not** generate invite codes, pair devices, send location, or imply that a backend exists. The privacy acknowledgement is local UI state only.

### Next implementation milestones

1. Select a backend and implement authenticated parent accounts.
2. Design short-lived, one-use pairing invitations, child confirmation and revocation.
3. Implement access-control rules and minimal location data retention.
4. Integrate Apple's family authorization and DeviceActivity extensions on eligible devices.
5. Add tests and privacy disclosures before device distribution.
