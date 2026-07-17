import SwiftUI

struct ModelSettingsView: View {
    @ObservedObject var whisperPrompt: WhisperPrompt
    @AppStorage("SelectedLanguage") private var selectedLanguage: String = "en"
    @AppStorage("IsTextFormattingEnabled") private var isTextFormattingEnabled = true
    @AppStorage("IsVADEnabled") private var isVADEnabled = true
    @AppStorage("AppendTrailingSpace") private var appendTrailingSpace = true
    @AppStorage("PrewarmModelOnWake") private var prewarmModelOnWake = true
    @AppStorage("showLiveTextPreview") private var showLiveTextPreview = true
    @State private var customPrompt: String = ""
    @State private var isEditing: Bool = false

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    if isEditing {
                        TextEditor(text: $customPrompt)
                            .font(.system(size: 12))
                            .frame(minHeight: 40, maxHeight: 80)
                            .fixedSize(horizontal: false, vertical: true)
                            .scrollContentBackground(.hidden)

                        Button("Enregistrer") {
                            whisperPrompt.setCustomPrompt(customPrompt, for: selectedLanguage)
                            isEditing = false
                        }
                    } else {
                        Text(whisperPrompt.getLanguagePrompt(for: selectedLanguage))
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button("Modifier") {
                            customPrompt = whisperPrompt.getLanguagePrompt(for: selectedLanguage)
                            isEditing = true
                        }
                    }
                }
            } header: {
                HStack(spacing: 4) {
                    Text("Format de sortie")
                    InfoTip(
                        "Supporté uniquement pour les modèles Whisper locaux. Contrairement à GPT, les modèles de voix (Whisper) suivent le style de ton assistant plutôt que des instructions. Utilise des exemples du format de sortie désiré au lieu de commandes.",
                        learnMoreURL: "https://cookbook.openai.com/examples/whisper_prompting_guide#comparison-with-gpt-prompting"
                    )
                }
            }

            Section {
                Toggle(isOn: $appendTrailingSpace) {
                    Text("Ajouter un espace après le collage")
                }
                .toggleStyle(.switch)

                Toggle(isOn: $isTextFormattingEnabled) {
                    HStack(spacing: 4) {
                        Text("Formatage auto du texte")
                        InfoTip("Applique un formatage intelligent pour découper les gros blocs de texte en paragraphes.")
                    }
                }
                .toggleStyle(.switch)

                Toggle(isOn: $isVADEnabled) {
                    HStack(spacing: 4) {
                        Text("Détection d'activité vocale (VAD)")
                        InfoTip("Détecte les segments de parole et filtre les silences pour améliorer la précision des modèles locaux.")
                    }
                }
                .toggleStyle(.switch)

                Toggle(isOn: $prewarmModelOnWake) {
                    HStack(spacing: 4) {
                        Text("Préchauffer le modèle (Expérimental)")
                        InfoTip("Active ceci si les transcriptions avec les modèles locaux prennent plus de temps que prévu. Lance une transcription silencieuse en arrière-plan au démarrage et au réveil pour déclencher l'optimisation.")
                    }
                }
                .toggleStyle(.switch)

                Toggle(isOn: $showLiveTextPreview) {
                    HStack(spacing: 4) {
                        Text("Afficher l'aperçu texte en direct")
                        InfoTip("Affiche l'aperçu de la transcription en direct dans l'enregistreur pendant que tu parles. S'applique uniquement aux modèles de streaming temps réel.")
                    }
                }
                .toggleStyle(.switch)
            } header: {
                Text("Transcription")
            }

            Section {
                FillerWordsSettingsView()
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .onChange(of: selectedLanguage) { oldValue, newValue in
            if isEditing {
                customPrompt = whisperPrompt.getLanguagePrompt(for: selectedLanguage)
            }
        }
    }
}
