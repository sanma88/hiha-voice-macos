import SwiftUI
import SwiftData

struct AudioCleanupSettingsView: View {
    @Environment(\.modelContext) private var modelContext

    // Audio cleanup settings
    @AppStorage("IsTranscriptionCleanupEnabled") private var isTranscriptionCleanupEnabled = false
    @AppStorage("TranscriptionRetentionMinutes") private var transcriptionRetentionMinutes = 24 * 60
    @AppStorage("IsAudioCleanupEnabled") private var isAudioCleanupEnabled = false
    @AppStorage("AudioRetentionPeriod") private var audioRetentionPeriod = 7
    @State private var isPerformingCleanup = false
    @State private var isShowingConfirmation = false
    @State private var cleanupInfo: (fileCount: Int, totalSize: Int64, transcriptions: [Transcription]) = (0, 0, [])
    @State private var showResultAlert = false
    @State private var cleanupResult: (deletedCount: Int, errorCount: Int) = (0, 0)
    @State private var showTranscriptCleanupResult = false

    // Expansion states - collapsed by default
    @State private var isTranscriptExpanded = false
    @State private var isAudioExpanded = false
    @State private var isHandlingTranscriptToggle = false
    @State private var isHandlingAudioToggle = false

    var body: some View {
        Group {
            // Transcript cleanup - hierarchical
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Toggle(isOn: $isTranscriptionCleanupEnabled) {
                        HStack(spacing: 4) {
                            Text("Supprimer auto les transcriptions")
                            InfoTip("Supprime automatiquement l'historique des transcriptions selon la période de conservation que tu définis.")
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isTranscriptionCleanupEnabled && isTranscriptExpanded ? 90 : 0))
                        .opacity(isTranscriptionCleanupEnabled ? 1 : 0.4)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard !isHandlingTranscriptToggle else { return }
                    if isTranscriptionCleanupEnabled {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isTranscriptExpanded.toggle()
                        }
                    }
                }

                if isTranscriptionCleanupEnabled && isTranscriptExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        Picker("Supprimer après", selection: $transcriptionRetentionMinutes) {
                            Text("Immédiatement").tag(0)
                            Text("1 heure").tag(60)
                            Text("1 jour").tag(24 * 60)
                            Text("3 jours").tag(3 * 24 * 60)
                            Text("7 jours").tag(7 * 24 * 60)
                        }

                        Button("Lancer le nettoyage") {
                            Task {
                                await TranscriptionAutoCleanupService.shared.runManualCleanup(modelContext: modelContext)
                                await MainActor.run {
                                    showTranscriptCleanupResult = true
                                }
                            }
                        }
                    }
                    .padding(.top, 12)
                    .padding(.leading, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isTranscriptExpanded)
            .alert("Nettoyage des transcriptions", isPresented: $showTranscriptCleanupResult) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Nettoyage terminé.")
            }
            .onChange(of: isTranscriptionCleanupEnabled) { _, newValue in
                isHandlingTranscriptToggle = true
                if newValue {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isTranscriptExpanded = true
                    }
                    AudioCleanupManager.shared.stopAutomaticCleanup()
                } else {
                    isTranscriptExpanded = false
                    if isAudioCleanupEnabled {
                        AudioCleanupManager.shared.startAutomaticCleanup(modelContext: modelContext)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isHandlingTranscriptToggle = false
                }
            }

            // Audio cleanup - only show if transcript cleanup is disabled
            if !isTranscriptionCleanupEnabled {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Toggle(isOn: $isAudioCleanupEnabled) {
                            HStack(spacing: 4) {
                                Text("Supprimer auto les fichiers audio")
                                InfoTip("Supprime automatiquement les enregistrements audio tout en conservant les transcriptions textuelles.")
                            }
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(isAudioCleanupEnabled && isAudioExpanded ? 90 : 0))
                            .opacity(isAudioCleanupEnabled ? 1 : 0.4)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard !isHandlingAudioToggle else { return }
                        if isAudioCleanupEnabled {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isAudioExpanded.toggle()
                            }
                        }
                    }

                    if isAudioCleanupEnabled && isAudioExpanded {
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Conserver l'audio pendant", selection: $audioRetentionPeriod) {
                                Text("1 jour").tag(1)
                                Text("3 jours").tag(3)
                                Text("7 jours").tag(7)
                                Text("14 jours").tag(14)
                                Text("30 jours").tag(30)
                            }

                            Button(isPerformingCleanup ? "Analyse..." : "Lancer le nettoyage") {
                                Task {
                                    await MainActor.run { isPerformingCleanup = true }
                                    let info = await AudioCleanupManager.shared.getCleanupInfo(modelContext: modelContext)
                                    await MainActor.run {
                                        cleanupInfo = info
                                        isPerformingCleanup = false
                                        isShowingConfirmation = true
                                    }
                                }
                            }
                            .disabled(isPerformingCleanup)
                        }
                        .padding(.top, 12)
                        .padding(.leading, 4)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isAudioExpanded)
                .alert("Nettoyage audio", isPresented: $isShowingConfirmation) {
                    Button("Annuler", role: .cancel) { }

                    if cleanupInfo.fileCount > 0 {
                        Button("Supprimer \(cleanupInfo.fileCount) fichiers", role: .destructive) {
                            Task {
                                await MainActor.run { isPerformingCleanup = true }
                                let result = await AudioCleanupManager.shared.runCleanupForTranscriptions(
                                    modelContext: modelContext,
                                    transcriptions: cleanupInfo.transcriptions
                                )
                                await MainActor.run {
                                    cleanupResult = result
                                    isPerformingCleanup = false
                                    showResultAlert = true
                                }
                            }
                        }
                    }
                } message: {
                    if cleanupInfo.fileCount > 0 {
                        Text("Ceci supprimera \(cleanupInfo.fileCount) fichiers audio (\(AudioCleanupManager.shared.formatFileSize(cleanupInfo.totalSize))).")
                    } else {
                        Text("Aucun fichier audio trouvé de plus de \(audioRetentionPeriod) jour\(audioRetentionPeriod > 1 ? "s" : "").")
                    }
                }
                .alert("Nettoyage terminé", isPresented: $showResultAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    if cleanupResult.errorCount > 0 {
                        Text("\(cleanupResult.deletedCount) fichiers supprimés. Échecs : \(cleanupResult.errorCount).")
                    } else {
                        Text("\(cleanupResult.deletedCount) fichiers audio supprimés.")
                    }
                }
                .onChange(of: isAudioCleanupEnabled) { _, newValue in
                    isHandlingAudioToggle = true
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isAudioExpanded = true
                        }
                    } else {
                        isAudioExpanded = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isHandlingAudioToggle = false
                    }
                }
            }
        }
    }
}
