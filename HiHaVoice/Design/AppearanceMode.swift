import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "Système"
        case .light: return "Clair"
        case .dark: return "Sombre"
        }
    }

    var icon: String {
        switch self {
        case .system: return "desktopcomputer"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct AppearancePicker: View {
    @AppStorage("appearanceMode") private var storedMode: String = AppearanceMode.system.rawValue

    private var selected: AppearanceMode {
        AppearanceMode(rawValue: storedMode) ?? .system
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(AppearanceMode.allCases) { mode in
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        storedMode = mode.rawValue
                    }
                } label: {
                    Image(systemName: mode.icon)
                        .font(.system(size: 12, weight: .semibold))
                        .frame(width: 28, height: 24)
                        .foregroundStyle(selected == mode ? Color.HiHa.fgOnAccent : Color.HiHa.mutedForeground)
                        .background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(selected == mode ? AnyShapeStyle(LinearGradient.hiHaBrand) : AnyShapeStyle(Color.clear))
                        )
                        .help(mode.label)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color.HiHa.muted)
        )
    }
}
