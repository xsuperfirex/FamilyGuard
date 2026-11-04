# FamilyGuard V5 pairing design

## State
The app contains a **local demonstration** of invitation and confirmation.
It does not communicate with a second phone or Firebase.

## Intended production flow
1. Parent authenticates and creates a family.
2. Server issues a cryptographically random, short-lived, one-use invite.
3. Child authenticates on their own device and enters the invite.
4. Server validates expiry, rate limits, role, and invite ownership.
5. Parent approves the pending request from an authenticated session.
6. Server atomically binds membership and invalidates the invitation.
7. Both devices may synchronize only authorized policy metadata.
8. Location and Screen Time permissions are obtained separately using iOS APIs.
9. Either authorized party can revoke access; deletion and retention policies apply.

## Security checklist
- Never infer parent status from a local UI picker.
- Never treat six-digit demo codes as real credentials.
- Never send precise location to Firestore before explicit permission and pairing.
- Never expose API secrets or service account keys in the repository.
- Use server-verified membership, expiring invitations, rate limiting, audit trail.
- Test cross-family isolation and revocation before deployment.
