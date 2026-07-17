import SwiftUI
import KeyboardShortcuts

struct EnhancementShortcutsView: View {
    @ObservedObject private var shortcutSettings = EnhancementShortcutSettings.shared

    var body: some View {
        VStack(spacing: 8) {
            // Toggle AI Enhancement
            HStack(alignment: .center, spacing: 12) {
                HStack(spacing: 4) {
                    Text("Activer l'amélioration IA")
                        .font(.system(size: 13))

                    InfoTip(
                        "Active ou désactive rapidement l'amélioration IA pendant l'enregistrement. Disponible seulement quand Hi-Ha Voice est lancé et que l'enregistreur est visible.",
                        learnMoreURL: "https://hi-ha.be"
                    )
                }

                Spacer()

                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        KeyChip(label: "⌘")
                        KeyChip(label: "E")
                    }

                    Toggle("", isOn: $shortcutSettings.isToggleEnhancementShortcutEnabled)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
            }

            // Switch Enhancement Prompt
            HStack(alignment: .center, spacing: 12) {
                HStack(spacing: 4) {
                    Text("Changer d'assistant d'amélioration")
                        .font(.system(size: 13))

                    InfoTip(
                        "Bascule entre tes assistants sauvegardés avec ⌘1 à ⌘0 pour activer l'assistant correspondant dans l'ordre où ils sont sauvegardés. Disponible seulement quand Hi-Ha Voice est lancé et que l'enregistreur est visible.",
                        learnMoreURL: "https://hi-ha.be"
                    )
                }

                Spacer()

                HStack(spacing: 4) {
                    KeyChip(label: "⌘")
                    KeyChip(label: "1 – 0")
                }
            }
        }
        .background(Color.clear)
    }
}

// MARK: - Supporting Views
private struct KeyChip: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .foregroundColor(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(
                        Color(NSColor.separatorColor).opacity(0.5),
                        lineWidth: 0.5
                    )
            )
    }
}
