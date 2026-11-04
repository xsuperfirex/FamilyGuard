# FamilyGuard — Firebase setup (iPhone-only)

## 1. Register an Apple app
In Firebase Console > Project settings > Your apps, register an Apple app with bundle ID `com.example.FamilyGuard` (temporary prototype identifier matching project.yml). A production bundle ID should be unique and stable.

## 2. Keep configuration out of public Git
Download `GoogleService-Info.plist` to your iPhone Files app. Do not upload it to this public repository or share private credentials. The plist contains Firebase project identifiers and an API key that is not a server secret by itself, but publishing it is unnecessary here. Never commit Firebase Admin service-account credentials.

## 3. Enable authentication
Firebase Console > Build > Authentication > Get started > Sign-in method > Email/Password. Do not create real child accounts or store child data until security rules, consent flows, and privacy disclosures have been reviewed.

## 4. Firestore
Create a Firestore database in a suitable region using production mode. The repository currently contains deny-all `backend/firestore.rules`; no Firestore access is enabled. Do not switch to test mode for production data.

## 5. Native iOS integration — not yet done
The Swift app does NOT currently initialize Firebase or include the Firebase iOS SDK. A later implementation must add FirebaseCore, FirebaseAuth, and FirebaseFirestore via Swift Package Manager, configure the app from its plist, and implement authenticated server-validated pairing.

## 6. GitHub Actions
Current Actions builds an unsigned iOS Simulator app and does not require Firebase configuration. A future build using Firebase SDK can use a dedicated non-production config supplied via GitHub Actions secrets; never print secrets to logs. Do not add a Firebase Admin private key to CI.

## Costs and limitations
Firebase Spark has free quotas and feature restrictions; check the current console before enabling paid services. Firebase configuration does not grant Apple Family Controls entitlements or install an app on physical iPhones.
