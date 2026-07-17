import SwiftUI
import KeyboardShortcuts

struct MetricsSetupView: View {
    @EnvironmentObject private var transcriptionModelManager: TranscriptionModelManager
    @EnvironmentObject private var hotkeyManager: HotkeyManager
    @State private var isAccessibilityEnabled = AXIsProcessTrusted()
    @State private var isScreenRecordingEnabled = CGPreflightScreenCaptureAccess()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    AppIconView()
                        .frame(width: 80, height: 80)
                        .padding(.bottom, 20)
                       
                    VStack(spacing: 4) {
                        Text("Bienvenue sur Hi-Ha Voice")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                        
                        Text("Termine la configuration pour démarrer")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Setup Steps
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<4) { index in
                        setupStep(for: index)
                        if index < 3 {
                            Divider().padding(.leading, 70)
                        }
                    }
                }
                .background(Color(NSColor.textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                
                Spacer(minLength: 20)
                
                // Action Button
                actionButton
                    .frame(maxWidth: 400)
                
                // Help Text
                helpText
            }
            .padding()
        }
        .frame(minWidth: 500, minHeight: 600)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func setupStep(for index: Int) -> some View {
        let stepInfo: (isCompleted: Bool, icon: String, title: String, description: String)
        
        switch index {
        case 0:
            stepInfo = (
                isCompleted: hotkeyManager.selectedHotkey1 != .none,
                icon: "command",
                title: "Définir un raccourci clavier",
                description: "Utilise Hi-Ha Voice partout avec un raccourci."
            )
        case 1:
            stepInfo = (
                isCompleted: isAccessibilityEnabled,
                icon: "hand.raised.fill",
                title: "Activer l'accessibilité",
                description: "Colle le texte transcrit à l'emplacement du curseur."
            )
        case 2:
            stepInfo = (
                isCompleted: isScreenRecordingEnabled,
                icon: "video.fill",
                title: "Activer l'enregistrement d'écran",
                description: "Obtiens de meilleures transcriptions avec le contexte de l'écran."
            )
        default:
            stepInfo = (
                isCompleted: transcriptionModelManager.currentTranscriptionModel != nil,
                icon: "arrow.down.to.line",
                title: "Télécharger",
                description: "Choisis un modèle IA pour commencer à transcrire."
            )
        }
        
        return HStack(spacing: 16) {
            Image(systemName: stepInfo.icon)
                .font(.system(size: 18))
                .frame(width: 40, height: 40)
                .background((stepInfo.isCompleted ? Color.HiHa.auroraCyan : Color.HiHa.sovereignMarine).opacity(0.1))
                .foregroundColor(stepInfo.isCompleted ? .green : Color.HiHa.sovereignMarine)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 3) {
                Text(stepInfo.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(stepInfo.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if stepInfo.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color.HiHa.auroraCyan)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(NSColor.separatorColor))
            }
        }
        .padding()
    }
    
    private var actionButton: some View {
        Button(action: handleActionButton) {
            HStack {
                Text(getActionButtonTitle())
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(LinearGradient.hiHaBrand)
            .foregroundColor(Color.HiHa.fgOnAccent)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .shadow(color: Color.HiHa.sovereignMarine.opacity(0.3), radius: 8, y: 4)
    }
    
    private func handleActionButton() {
        if isShortcutAndAccessibilityGranted {
            openModelManagement()
        } else {
            // Handle different permission requests based on which one is missing
            if hotkeyManager.selectedHotkey1 == .none {
                openSettings()
            } else if !AXIsProcessTrusted() {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                    NSWorkspace.shared.open(url)
                }
            } else if !CGPreflightScreenCaptureAccess() {
                CGRequestScreenCaptureAccess()
                // After requesting, open system preferences as fallback
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
    
    private func getActionButtonTitle() -> String {
        if hotkeyManager.selectedHotkey1 == .none {
            return "Configurer le raccourci"
        } else if !AXIsProcessTrusted() {
            return "Activer l'accessibilité"
        } else if !CGPreflightScreenCaptureAccess() {
            return "Activer l'enregistrement d'écran"
        } else if transcriptionModelManager.currentTranscriptionModel == nil {
            return "Télécharger"
        }
        return "Commencer"
    }
    
    private var helpText: some View {
        Text("Besoin d'aide ? Consulte le menu Aide pour les options de support")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    
    private var isShortcutAndAccessibilityGranted: Bool {
        hotkeyManager.selectedHotkey1 != .none &&
        AXIsProcessTrusted() && 
        CGPreflightScreenCaptureAccess()
    }
    
    private func openSettings() {
        NotificationCenter.default.post(
            name: .navigateToDestination,
            object: nil,
            userInfo: ["destination": "Réglages"]
        )
    }
    
    private func openModelManagement() {
        NotificationCenter.default.post(
            name: .navigateToDestination,
            object: nil,
            userInfo: ["destination": "Modèles IA"]
        )
    }
}

