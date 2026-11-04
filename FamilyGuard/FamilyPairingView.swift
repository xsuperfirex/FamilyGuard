import SwiftUI

/// A non-networked onboarding preview. No pairing credentials are generated or accepted.
struct FamilyPairingView: View {
    @AppStorage("demoRole") private var roleRaw = DemoRole.parent.rawValue
    @AppStorage("onboarding.privacyReviewed") private var privacyReviewed = false
    @State private var showExplanation = false

    var body: some View {
        Form {
            Section("Выберите телефон") {
                Picker("Роль", selection: $roleRaw) {
                    ForEach(DemoRole.allCases) { role in
                        Text(role.rawValue).tag(role.rawValue)
                    }
                }
                Text(roleRaw == DemoRole.parent.rawValue
                     ? "На телефоне родителя появятся семейные настройки и подтверждения."
                     : "На телефоне ребёнка будут запрашиваться разрешения iOS и показываться применённые ограничения.")
                    .font(.footnote)
            }
            Section("Подключение двух iPhone") {
                Label("1. Вход родителя в аккаунт", systemImage: "person.crop.circle")
                Label("2. Приглашение ребёнка", systemImage: "envelope")
                Label("3. Подтверждение на устройстве ребёнка", systemImage: "checkmark.shield")
                Label("4. Разрешения геолокации и Screen Time", systemImage: "lock.shield")
                Label("5. Защищённая синхронизация", systemImage: "arrow.triangle.2.circlepath")
                Text("Эти шаги — план следующего этапа. Пока приложение не подключает устройства и не отправляет приглашения.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Конфиденциальность") {
                Toggle("Я прочитал описание будущей передачи данных", isOn: $privacyReviewed)
                Button("Какие данные планируются?") { showExplanation = true }
                Text("Отметка сохраняется локально и не является согласием на реальную передачу данных.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Section("Текущий статус") {
                Label("Сервер не подключён", systemImage: "server.rack")
                Label("Телефоны не связаны", systemImage: "iphone.slash")
                Label("Данные ребёнка не передаются", systemImage: "hand.raised")
            }
        }
        .navigationTitle("Семья")
        .alert("Будущая синхронизация", isPresented: $showExplanation) {
            Button("Понятно", role: .cancel) { }
        } message: {
            Text("После безопасной привязки планируется передавать только необходимые настройки и, при отдельном разрешении, местоположение. Нужны вход в аккаунт, защита доступа, отзыв согласия и удаление данных. Сейчас никакой передачи нет.")
        }
    }
}
