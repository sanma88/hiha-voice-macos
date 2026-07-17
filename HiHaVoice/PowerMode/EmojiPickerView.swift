import SwiftUI

struct EmojiPickerView: View {
    @StateObject private var emojiManager = EmojiManager.shared
    @Binding var selectedEmoji: String
    @Binding var isPresented: Bool
    @State private var newEmojiText: String = ""
    @State private var isAddingCustomEmoji: Bool = false
    @FocusState private var isEmojiTextFieldFocused: Bool
    @State private var inputFeedbackMessage: String = ""
    @State private var showingEmojiInUseAlert = false
    @State private var emojiForAlert: String? = nil
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 44), spacing: 10)]

    var body: some View {
        VStack(spacing: 12) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(emojiManager.allEmojis, id: \.self) { emoji in
                        EmojiButton(
                            emoji: emoji,
                            isSelected: selectedEmoji == emoji,
                            isCustom: emojiManager.isCustomEmoji(emoji),
                            removeAction: {
                                attemptToRemoveCustomEmoji(emoji)
                            }
                        ) {
                            selectedEmoji = emoji
                            inputFeedbackMessage = ""
                            isPresented = false
                        }
                    }

                    AddEmojiButton {
                        isAddingCustomEmoji.toggle()
                        newEmojiText = ""
                        inputFeedbackMessage = ""
                        if isAddingCustomEmoji {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isEmojiTextFieldFocused = true
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: 200)

            if isAddingCustomEmoji {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        TextField("➕", text: $newEmojiText)
                            .textFieldStyle(.roundedBorder)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 70)
                            .focused($isEmojiTextFieldFocused)
                            .onChange(of: newEmojiText) { _, newValue in
                                inputFeedbackMessage = ""
                                let cleaned = newValue.firstValidEmojiCharacter()
                                if newEmojiText != cleaned {
                                    newEmojiText = cleaned
                                }
                                if !newEmojiText.isEmpty && emojiManager.allEmojis.contains(newEmojiText) {
                                    inputFeedbackMessage = "Cet emoji existe déjà !"
                                } else if !newEmojiText.isEmpty && !newEmojiText.isValidEmoji {
                                    inputFeedbackMessage = "Emoji invalide."
                                } else {
                                    inputFeedbackMessage = ""
                                }
                            }
                            .onSubmit(attemptAddCustomEmoji)

                        Button("Ajouter") {
                            attemptAddCustomEmoji()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(newEmojiText.isEmpty || !newEmojiText.isValidEmoji || emojiManager.allEmojis.contains(newEmojiText))

                        Button("Annuler") {
                            isAddingCustomEmoji = false
                            newEmojiText = ""
                            inputFeedbackMessage = ""
                        }
                        .buttonStyle(.bordered)
                    }
                    if !inputFeedbackMessage.isEmpty {
                        Text(inputFeedbackMessage)
                            .font(.caption)
                            .foregroundColor(inputFeedbackMessage == "Cet emoji existe déjà !" || inputFeedbackMessage == "Emoji invalide." ? .red : .secondary)
                            .transition(.opacity)
                    }
                    Text("Astuce : utilise ⌃⌘Espace pour le sélecteur d'emoji ou colle un emoji.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
        }
        .padding()
        .frame(minWidth: 260, idealWidth: 300, maxWidth: 320, minHeight: 150, idealHeight: 280, maxHeight: 350)
        .alert("Emoji utilisé", isPresented: $showingEmojiInUseAlert, presenting: emojiForAlert) { emojiStr in
            Button("OK", role: .cancel) { }
        } message: { emojiStr in
            Text("L'emoji \"\(emojiStr)\" est actuellement utilisé par un ou plusieurs Modes Puissance et ne peut pas être supprimé.")
        }
    }

    private func attemptAddCustomEmoji() {
        let trimmedEmoji = newEmojiText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmoji.isEmpty else {
            inputFeedbackMessage = "L'emoji ne peut pas être vide."
            return
        }
        guard trimmedEmoji.isValidEmoji else {
            inputFeedbackMessage = "Caractère emoji invalide."
            return
        }
        guard !emojiManager.allEmojis.contains(trimmedEmoji) else {
            inputFeedbackMessage = "Cet emoji existe déjà !"
            return
        }

        if emojiManager.addCustomEmoji(trimmedEmoji) {
            selectedEmoji = trimmedEmoji
            inputFeedbackMessage = ""
            isAddingCustomEmoji = false
            newEmojiText = ""
        } else {
            inputFeedbackMessage = "Impossible d'ajouter l'emoji."
        }
    }

    private func attemptToRemoveCustomEmoji(_ emojiToRemove: String) {
        guard emojiManager.isCustomEmoji(emojiToRemove) else { return }

        if PowerModeManager.shared.isEmojiInUse(emojiToRemove) {
            emojiForAlert = emojiToRemove
            showingEmojiInUseAlert = true
        } else {
            if emojiManager.removeCustomEmoji(emojiToRemove) {
                if selectedEmoji == emojiToRemove {
                }
            }
        }
    }
}

private struct EmojiButton: View {
    let emoji: String
    let isSelected: Bool
    let isCustom: Bool
    let removeAction: () -> Void
    let selectAction: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: selectAction) {
                Text(emoji)
                    .font(.largeTitle) 
                    .frame(width: 44, height: 44)
                    .overlay( 
                        Circle()
                            .strokeBorder(isSelected ? Color.HiHa.sovereignMarine : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            }
            .buttonStyle(.plain) 

            if isCustom {
                Button(action: removeAction) {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, Color.HiHa.signalCoral)
                        .font(.caption2)
                        .background(Circle().fill(Color.white.opacity(0.8)))
                }
                .buttonStyle(.borderless) 
                .offset(x: 6, y: -6)
            }
        }
    }
}

private struct AddEmojiButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Ajouter un emoji", systemImage: "plus.circle.fill")
                .font(.title2)
                .labelStyle(.iconOnly)
                .foregroundColor(Color.HiHa.sovereignMarine)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .help("Ajouter un emoji personnalisé")
    }
}

extension String {
    var isValidEmoji: Bool {
        guard !self.isEmpty, self.count == 1, let char = self.first else { return false }
        let scalars = char.unicodeScalars
        if scalars.count > 1 {
            return scalars.contains { $0.properties.isEmoji }
        }
        return scalars.first?.properties.isEmojiPresentation == true
    }

    func firstValidEmojiCharacter() -> String {
        for char in self {
            if String(char).isValidEmoji {
                return String(char)
            }
        }
        return ""
    }
}

#if DEBUG
struct EmojiPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPickerView(
            selectedEmoji: .constant("😀"),
            isPresented: .constant(true)
        )
        .environmentObject(EmojiManager.shared)
    }
}
#endif

 