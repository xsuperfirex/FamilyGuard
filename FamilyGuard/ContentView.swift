import SwiftUI
import FamilyControls
import ManagedSettings
import CoreLocation
import MapKit

enum DemoRole: String, CaseIterable, Identifiable {
    case parent = "Родитель", child = "Ребёнок"
    var id: String { rawValue }
}

struct ContentView: View {
    @AppStorage("demoRole") private var roleRaw = DemoRole.parent.rawValue
    var body: some View {
        TabView {
            NavigationStack {
                Form {
                    Section("Демонстрационный режим") {
                        Picker("Интерфейс", selection: $roleRaw) {
                            ForEach(DemoRole.allCases) { Text($0.rawValue).tag($0.rawValue) }
                        }
                        Text("Роли пока не проверяются сервером. Это не привязка двух телефонов.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Section("Состояние") {
                        Label("Локальные ограничения", systemImage: "shield.lefthalf.filled")
                        Label("Местоположение только на этом iPhone", systemImage: "location")
                        Label("Связь с другим телефоном ещё не реализована", systemImage: "iphone")
                    }
                }.navigationTitle("FamilyGuard")
            }.tabItem { Label("Главная", systemImage: "house") }
            NavigationStack { FamilyPairingView() }.tabItem { Label("Семья", systemImage: "person.2") }
            NavigationStack { LimitsView() }.tabItem { Label("Лимиты", systemImage: "hourglass") }
            NavigationStack { SetupGuideView() }.tabItem { Label("Настройка", systemImage: "checklist") }
            NavigationStack { LocalLocationView() }.tabItem { Label("Карта", systemImage: "map") }
        }
    }
}

struct LimitsView: View {
    @State private var selection = FamilyActivitySelection()
    @State private var showingPicker = false
    @State private var message = "Не авторизовано"
    private let store = ManagedSettingsStore()
    var body: some View {
        Form {
            Section("Разрешение Screen Time") {
                Text(message).font(.footnote)
                Button("Запросить локальное разрешение") {
                    Task {
                        do {
                            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                            message = "Локальное разрешение получено"
                        } catch {
                            message = "Ошибка: \(error.localizedDescription)"
                        }
                    }
                }
            }
            Section("Выбор приложений на этом iPhone") {
                Button("Выбрать приложения") { showingPicker = true }
                Button("Включить ограничения") {
                    guard AuthorizationCenter.shared.authorizationStatus == .approved else {
                        message = "Сначала предоставьте разрешение Screen Time"
                        return
                    }
                    store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
                    store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
                    message = "Локальные ограничения обновлены"
                }
                Button("Снять локальные ограничения", role: .destructive) {
                    store.clearAllSettings()
                    message = "Локальные ограничения сняты"
                }
            }
            Section {
                Text("Это локальная individual-авторизация. Семейное управление потребует Family Sharing, разрешений Apple и отдельного процесса авторизации.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Лимиты")
        .familyActivityPicker(isPresented: $showingPicker, selection: $selection)
    }
}

@MainActor final class LocalLocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var status = "Местоположение не запрошено"
    private let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    func request() {
        guard CLLocationManager.locationServicesEnabled() else {
            status = "Службы геолокации отключены"
            return
        }
        manager.requestWhenInUseAuthorization()
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            status = "Разрешено — получаем координаты"
            manager.requestLocation()
        case .denied, .restricted: status = "Доступ к геолокации запрещён"
        case .notDetermined: status = "Ожидаем разрешение"
        @unknown default: status = "Неизвестное состояние разрешения"
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinate = locations.last?.coordinate
        status = "Координаты получены локально; никуда не отправляются"
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        status = "Ошибка геолокации: \(error.localizedDescription)"
    }
}

struct LocalLocationView: View {
    @StateObject private var location = LocalLocationModel()
    @State private var camera: MapCameraPosition = .automatic
    var body: some View {
        VStack(spacing: 12) {
            if let coordinate = location.coordinate {
                Map(position: $camera) {
                    Marker("Этот iPhone", coordinate: coordinate)
                }
                .onAppear {
                    camera = .region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                }
                .onChange(of: location.coordinate?.latitude) { _, _ in
                    if let point = location.coordinate {
                        camera = .region(MKCoordinateRegion(center: point, latitudinalMeters: 1000, longitudinalMeters: 1000))
                    }
                }
            } else {
                ContentUnavailableView("Карта этого iPhone", systemImage: "map", description: Text("Разрешите геолокацию, чтобы увидеть текущую позицию."))
            }
            Text(location.status).font(.footnote).foregroundStyle(.secondary)
            Button("Показать моё местоположение") { location.request() }
                .buttonStyle(.borderedProminent)
            Text("Геолокация другого телефона пока недоступна. Передача координат будет добавлена только после безопасной привязки и согласия.")
                .font(.caption).foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding(.bottom)
        .navigationTitle("Карта")
    }
}
