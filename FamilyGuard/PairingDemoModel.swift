import Foundation

/// Local-only simulation for designing the pairing flow.
/// Never use these codes as credentials for a real backend.
@MainActor
final class PairingDemoModel: ObservableObject {
    enum Phase: Equatable {
        case notConnected
        case invitationCreated
        case awaitingApproval
        case connectedDemo
    }

    @Published private(set) var phase: Phase = .notConnected
    @Published private(set) var invitationCode: String?
    @Published var message = "Два iPhone ещё не подключены."

    func createDemoInvitation() {
        // An illustrative code, not a security token.
        invitationCode = String(format: "%06d", Int.random(in: 0...999999))
        phase = .invitationCreated
        message = "Демо-код создан только на этом iPhone."
    }

    func enterDemoInvitation(_ code: String) {
        guard code.count == 6, code.allSatisfy({ $0.isNumber }) else {
            message = "Введите 6 цифр."
            return
        }
        phase = .awaitingApproval
        message = "Демонстрация: ожидание подтверждения родителя. Код никуда не отправлен."
    }

    func approveDemo() {
        guard phase == .awaitingApproval else { return }
        phase = .connectedDemo
        message = "Демо-подключение показано. Реальной связи между телефонами нет."
    }

    func reset() {
        phase = .notConnected
        invitationCode = nil
        message = "Демонстрация сброшена. Данные не передавались."
    }
}
