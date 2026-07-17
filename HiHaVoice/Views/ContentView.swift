import SwiftUI
import SwiftData
import KeyboardShortcuts
import OSLog

// ViewType enum — rawValue reste en anglais pour stabilité des notifications internes
enum ViewType: String, CaseIterable, Identifiable {
    case metrics = "Dashboard"
    case transcribeAudio = "Transcrire un fichier"
    case history = "Historique"
    case models = "Modèles IA"
    case enhancement = "Amélioration IA"
    case powerMode = "Mode Puissance"
    case permissions = "Autorisations"
    case audioInput = "Entrée audio"
    case dictionary = "Dictionnaire"
    case settings = "Réglages"

    var id: String { rawValue }

    /// Libellé affiché dans l'UI (français).
    var title: String {
        switch self {
        case .metrics: return "Tableau de bord"
        case .transcribeAudio: return "Transcrire un fichier"
        case .history: return "Historique"
        case .models: return "Modèles IA"
        case .enhancement: return "Amélioration IA"
        case .powerMode: return "Mode Puissance"
        case .permissions: return "Autorisations"
        case .audioInput: return "Entrée audio"
        case .dictionary: return "Dictionnaire"
        case .settings: return "Réglages"
        }
    }

    var icon: String {
        switch self {
        case .metrics: return "chart.bar.xaxis"
        case .transcribeAudio: return "waveform"
        case .history: return "clock.arrow.circlepath"
        case .models: return "cpu"
        case .enhancement: return "sparkles"
        case .powerMode: return "bolt.fill"
        case .permissions: return "lock.shield"
        case .audioInput: return "mic.fill"
        case .dictionary: return "text.book.closed"
        case .settings: return "slider.horizontal.3"
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct ContentView: View {
    private let logger = Logger(subsystem: "be.hiha.voice", category: "ContentView")
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var engine: HiHaVoiceEngine
    @EnvironmentObject private var whisperModelManager: WhisperModelManager
    @EnvironmentObject private var transcriptionModelManager: TranscriptionModelManager
    @EnvironmentObject private var hotkeyManager: HotkeyManager
    @AppStorage("powerModeUIFlag") private var powerModeUIFlag = false
    @State private var selectedView: ViewType? = .metrics
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"

    private var visibleViewTypes: [ViewType] {
        ViewType.allCases.filter { viewType in
            if viewType == .powerMode {
                return powerModeUIFlag
            }
            return true
        }
    }

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                // App header — lockup de marque hi-ha.be (bascule light/dark via le catalogue d'assets)
                HStack(spacing: 10) {
                    Image("HorseLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .accessibilityHidden(true)

                    Image("Wordmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                        .accessibilityLabel("hi-ha.be")

                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Navigation items (custom Buttons pour full control sur la sélection)
                ScrollView {
                    VStack(spacing: 2) {
                        ForEach(visibleViewTypes) { viewType in
                            Button {
                                selectedView = viewType
                            } label: {
                                SidebarItemView(viewType: viewType, isSelected: selectedView == viewType)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }

                Divider()

                HStack {
                    Spacer()
                    AppearancePicker()
                    Spacer()
                }
                .padding(.vertical, 10)
            }
            .background(Color.HiHa.background.opacity(0.5))
            .navigationTitle("Hi-Ha Voice")
            .navigationSplitViewColumnWidth(220)
        } detail: {
            if let selectedView = selectedView {
                detailView(for: selectedView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle(selectedView.title)
            } else {
                Text("Sélectionne une vue")
                    .foregroundColor(.secondary)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .frame(width: 950)
        .frame(minHeight: 730)
        .onAppear {
            logger.notice("ContentView appeared")
        }
        .onDisappear {
            logger.notice("ContentView disappeared")
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToDestination)) { notification in
            if let destination = notification.userInfo?["destination"] as? String {
                logger.notice("navigateToDestination received: \(destination, privacy: .public)")
                switch destination {
                case "Réglages":
                    selectedView = .settings
                case "Modèles IA":
                    selectedView = .models
                case "Historique":
                    selectedView = .history
                case "Autorisations":
                    selectedView = .permissions
                case "Amélioration IA":
                    selectedView = .enhancement
                case "Transcrire un fichier":
                    selectedView = .transcribeAudio
                case "Mode Puissance":
                    selectedView = .powerMode
                default:
                    break
                }
            }
        }
    }
    
    @ViewBuilder
    private func detailView(for viewType: ViewType) -> some View {
        switch viewType {
        case .metrics:
            MetricsView()
        case .models:
            ModelManagementView()
        case .enhancement:
            EnhancementSettingsView()
        case .transcribeAudio:
            AudioTranscribeView()
        case .history:
            InlineHistoryView()
        case .audioInput:
            AudioInputSettingsView()
        case .dictionary:
            DictionarySettingsView(whisperPrompt: whisperModelManager.whisperPrompt)
        case .powerMode:
            PowerModeView()
        case .settings:
            SettingsView()
        case .permissions:
            PermissionsView()
        }
    }
}

private struct SidebarItemView: View {
    let viewType: ViewType
    var isSelected: Bool = false
    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: viewType.icon)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 22, height: 22)
                .foregroundStyle(isSelected ? Color.HiHa.fgOnAccent : Color.HiHa.mutedForeground)

            Text(viewType.title)
                .font(Font.HiHa.inter(13, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? Color.HiHa.fgOnAccent : Color.HiHa.foreground)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(backgroundStyle)
        )
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.18), value: isSelected)
        .animation(.easeOut(duration: 0.15), value: isHovering)
    }

    private var backgroundStyle: AnyShapeStyle {
        if isSelected {
            return AnyShapeStyle(LinearGradient.hiHaBrand)
        } else if isHovering {
            return AnyShapeStyle(Color.HiHa.muted.opacity(0.6))
        } else {
            return AnyShapeStyle(Color.clear)
        }
    }
}

