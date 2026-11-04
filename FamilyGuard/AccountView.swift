import SwiftUI

struct AccountView: View {
    @StateObject private var session = FirebaseSession()
    @State private var email = ""
    @State private var password = ""
    @State private var busy = false

    var body: some View {
        Form {
            Section("Firebase Authentication") {
                Text(session.message).font(.footnote)
                if session.configured {
                    if session.userID != nil {
                        Label("Вход выполнен", systemImage: "checkmark.shield")
                        Button("Выйти", role: .destructive) { session.signOut() }
                    } else {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        SecureField("Пароль", text: $password)
                            .textContentType(.password)
                        Button("Войти") {
                            busy = true
                            Task {
                                await session.signIn(email: email, password: password)
                                busy = false
                            }
                        }.disabled(busy || email.isEmpty || password.isEmpty)
                        Button("Создать тестовый аккаунт взрослого") {
                            busy = true
                            Task {
                                await session.createAccount(email: email, password: password)
                                busy = false
                            }
                        }.disabled(busy || email.isEmpty || password.count < 6)
                    }
                }
            }
            Section("Ограничения") {
                Text("Пока это только вход в Firebase. Роль родителя, возраст, членство в семье и разрешение на управление ребёнком сервером ещё не проверяются.")
                Text("Не регистрируйте здесь ребёнка и не загружайте его данные до внедрения правил доступа и согласия.")
            }.font(.footnote).foregroundStyle(.secondary)
        }
        .navigationTitle("Аккаунт")
    }
}
