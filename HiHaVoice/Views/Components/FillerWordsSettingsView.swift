import SwiftUI

struct FillerWordChip: View {
    let word: String
    let onDelete: () -> Void
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 4) {
            Text(word)
                .font(.system(size: 12))
                .foregroundColor(.primary)

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(isHovered ? .red : .secondary)
                    .font(.system(size: 10))
            }
            .buttonStyle(.borderless)
            .onHover { hover in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hover
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.windowBackgroundColor).opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}

struct FillerWordsSettingsView: View {
    @AppStorage("RemoveFillerWords") private var removeFillerWords = true
    @StateObject private var fillerWordManager = FillerWordManager.shared
    @State private var newWord = ""
    @State private var showDuplicateAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Supprimer les mots de remplissage")
                InfoTip("Retire automatiquement les mots de remplissage comme « euh », « hum », « bah » des transcriptions.")
                Spacer()
                Toggle("", isOn: $removeFillerWords)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            if removeFillerWords {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        TextField("Ajouter un mot de remplissage", text: $newWord)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit { addWord() }

                        Button(action: addWord) {
                            Image(systemName: "plus.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.blue)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .buttonStyle(.borderless)
                        .help("Ajouter un mot de remplissage")
                        .disabled(newWord.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.vertical, 4)

                    if !fillerWordManager.fillerWords.isEmpty {
                        FlowLayout(spacing: 6) {
                            ForEach(fillerWordManager.fillerWords, id: \.self) { word in
                                FillerWordChip(word: word) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        fillerWordManager.removeWord(word)
                                    }
                                }
                            }
                        }
                    }

                }
                .padding(.leading, 4)
            }
        }
        .alert("Mot en double", isPresented: $showDuplicateAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Ce mot de remplissage est déjà dans la liste.")
        }
    }

    private func addWord() {
        let trimmed = newWord.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if fillerWordManager.addWord(trimmed) {
            newWord = ""
        } else {
            showDuplicateAlert = true
        }
    }
}
