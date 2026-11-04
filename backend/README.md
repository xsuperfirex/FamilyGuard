# FamilyGuard V5 backend foundation

This directory is a **secure-by-default placeholder**, not a deployed backend.

## Proposed stack
- Firebase Authentication for verified parent and child accounts.
- Firestore for family membership, invitation metadata, and policy sync.
- Cloud Functions for issuing short-lived, one-time invitation codes and
  validating acceptance (never trust a client-generated pairing code).
- FCM/APNs for notifications.
- Location sharing requires separate permission, explicit disclosure,
  minimum retention, revocation, and authentication.

## Before deployment
1. Create a Firebase project owned by you.
2. Configure two iOS app identities and authentication.
3. Build server-validated membership rules and emulator tests.
4. Implement invitation issue/accept/revoke endpoints with rate limiting.
5. Enable App Check and audit logs, and document retention/deletion.
6. Add Apple Family Controls entitlements and appropriate iOS extensions.

`firestore.rules` intentionally denies all reads and writes. Do not
weaken it for production without implementing and testing membership checks.

No keys, certificates, personal information, or child locations belong in GitHub.
