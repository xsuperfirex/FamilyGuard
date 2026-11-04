import Foundation
import FirebaseCore
import FirebaseAuth

/// Authentication is disabled until a valid local Firebase configuration is bundled.
/// Do not confuse a demo role with an authenticated family membership.
@MainActor
final class FirebaseSession: ObservableObject {
    @Published private(set) var configured = false
    @Published private(set) var userID: String?
    @Published var message = "Firebase ещё не настроен на этом устройстве."

    init() {
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            message = "Добавьте GoogleService-Info.plist при подписанной сборке приложения."
            return
        }
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
        configured = true
        userID = Auth.auth().currentUser?.uid
        message = userID == nil ? "Можно войти в аккаунт." : "Вход выполнен."
    }

    func signIn(email: String, password: String) async {
        guard configured else { return }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userID = result.user.uid
            message = "Вход выполнен."
        } catch {
            message = "Не удалось войти: \(error.localizedDescription)"
        }
    }

    func createAccount(email: String, password: String) async {
        guard configured else { return }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            userID = result.user.uid
            message = "Аккаунт создан. Подключение семьи пока недоступно."
        } catch {
            message = "Не удалось создать аккаунт: \(error.localizedDescription)"
        }
    }

    func signOut() {
        guard configured else { return }
        do {
            try Auth.auth().signOut()
            userID = nil
            message = "Вы вышли из аккаунта."
        } catch {
            message = "Ошибка выхода: \(error.localizedDescription)"
        }
    }
}
