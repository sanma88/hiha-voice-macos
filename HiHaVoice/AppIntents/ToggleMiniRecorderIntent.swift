import AppIntents
import Foundation
import AppKit

struct ToggleMiniRecorderIntent: AppIntent {
    static var title: LocalizedStringResource = "Basculer l'enregistreur Hi-Ha Voice"
    static var description = IntentDescription("Démarre ou arrête le mini-enregistreur Hi-Ha Voice pour la transcription vocale.")
    
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        NotificationCenter.default.post(name: .toggleMiniRecorder, object: nil)
        
        let dialog = IntentDialog(stringLiteral: "Enregistreur Hi-Ha Voice basculé")
        return .result(dialog: dialog)
    }
}

enum IntentError: Error, LocalizedError {
    case appNotAvailable
    case serviceNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .appNotAvailable:
            return "L'application Hi-Ha Voice n'est pas disponible"
        case .serviceNotAvailable:
            return "Le service d'enregistrement Hi-Ha Voice n'est pas disponible"
        }
    }
}
