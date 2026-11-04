# FamilyGuard architecture (planned)

- iOS SwiftUI application: parent and child UI, separate authorized roles.
- FamilyControls + ManagedSettings + DeviceActivity for supported local device restrictions, subject to Apple authorization and entitlements.
- CoreLocation + MapKit for consent-based location on the device.
- Future backend: authenticated family pairing, least-privilege access control, encrypted transport, retention controls, and push notifications.
- Child location must never be uploaded before explicit family pairing and permissions.
- GitHub Actions currently builds only an unsigned iOS Simulator artifact. It cannot install on a physical iPhone.
- Future work: DeviceActivity extensions, family authorization flow, backend, tests, and signed TestFlight distribution.
