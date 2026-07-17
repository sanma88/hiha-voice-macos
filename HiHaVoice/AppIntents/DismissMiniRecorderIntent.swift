import AppIntents
import Foundation
import AppKit

struct DismissMiniRecorderIntent: AppIntent {
    static var title: LocalizedStringResource = "Fermer l'enregistreur Hi-Ha Voice"
    static var description = IntentDescription("Ferme le mini-enregistreur Hi-Ha Voice et annule tout enregistrement en cours.")
    
    static var openAppWhenRun: Bool = false
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        NotificationCenter.default.post(name: .dismissMiniRecorder, object: nil)
        
        let dialog = IntentDialog(stringLiteral: "Enregistreur Hi-Ha Voice fermé")
        return .result(dialog: dialog)
    }
}
