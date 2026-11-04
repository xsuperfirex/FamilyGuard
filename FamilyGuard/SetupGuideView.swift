import SwiftUI

/// A local setup checklist. It does not claim devices are paired.
struct SetupGuideView: View {
    @AppStorage("setup.developer") private var developer = false
    @AppStorage("setup.family") private var family = false
    @AppStorage("setup.entitlement") private var entitlement = false
    @AppStorage("setup.cloud") private var cloud = false

    var body: some View {
        Form {
            Section("Подготовка") {
                Toggle("Apple Developer активирован", isOn: $developer)
                Toggle("Семейный доступ Apple настроен", isOn: $family)
                Toggle("Family Controls одобрен Apple", isOn: $entitlement)
                Toggle("Облачная сборка настроена", isOn: $cloud)
            }
            Section("Следующие действия") {
                Link("Регистрация Apple Developer", destination: URL(string: "https://developer.apple.com/programs/enroll/")!)
                Link("App Store Connect", destination: URL(string: "https://appstoreconnect.apple.com/")!)
                Link("Family Controls: разрешение на распространение", destination: URL(string: "https://developer.apple.com/documentation/familycontrols/requesting-the-family-controls-entitlement")!)
            }
            Section("Безопасность") {
                Text("Отметки хранятся только на этом iPhone и не подтверждают реальную регистрацию. Приложение не отслеживает другой телефон без явного подключения и разрешений.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Настройка")
    }
}
