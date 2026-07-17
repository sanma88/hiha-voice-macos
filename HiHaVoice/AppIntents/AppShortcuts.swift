import AppIntents
import Foundation

struct AppShortcuts : AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
            AppShortcut(
                intent: ToggleMiniRecorderIntent(),
                phrases: [
                    "Afficher l'enregistreur \(.applicationName)",
                    "Démarrer l'enregistrement \(.applicationName)",
                    "Arrêter l'enregistrement \(.applicationName)",
                    "Basculer l'enregistreur dans \(.applicationName)",
                    "Commencer l'enregistrement dans \(.applicationName)",
                    "Stopper l'enregistrement dans \(.applicationName)"
                ],
                shortTitle: "Afficher l'enregistreur",
                systemImageName: "mic.circle"
            )

            AppShortcut(
                intent: DismissMiniRecorderIntent(),
                phrases: [
                    "Fermer l'enregistreur \(.applicationName)",
                    "Annuler l'enregistrement \(.applicationName)",
                    "Masquer l'enregistreur \(.applicationName)",
                    "Cacher l'enregistreur \(.applicationName)"
                ],
                shortTitle: "Fermer l'enregistreur",
                systemImageName: "xmark.circle"
            )
    }
}
