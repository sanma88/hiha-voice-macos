import Foundation
import SwiftUI
import AppKit

struct EmailSupport {
    static func generateSupportEmailURL() -> URL? {
        let subject = "Demande de support Hi-Ha Voice"
        let systemInfo = SystemInfoService.shared.getSystemInfoString()

        let body = """

        ------------------------
        ✨ **ENREGISTREMENT D'ÉCRAN TRÈS RECOMMANDÉ** ✨
        ▶️ Fais un petit enregistrement d'écran qui montre le problème !
        ▶️ Ça m'aide à comprendre et corriger le souci beaucoup plus vite.

        📝 DÉTAILS DU PROBLÈME :
        - Quelles étapes as-tu suivies avant que le problème n'apparaisse ?
        - Qu'est-ce que tu attendais comme résultat ?
        - Qu'est-ce qui s'est passé à la place ?


        ## 📋 PROBLÈMES FRÉQUENTS :
        Jette un œil à la page des problèmes fréquents avant d'envoyer un e-mail : https://hi-ha.be
        ------------------------

        Informations système :
        \(systemInfo)


        """
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return URL(string: "mailto:mariano@hi-ha.be?subject=\(encodedSubject)&body=\(encodedBody)")
    }
    
    static func openSupportEmail() {
        if let emailURL = generateSupportEmailURL() {
            NSWorkspace.shared.open(emailURL)
        }
    }
    
    
}