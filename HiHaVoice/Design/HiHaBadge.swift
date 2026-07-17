import SwiftUI

struct HiHaBadge: View {
    enum Tone {
        case neutral, primary, accent, destructive, brand
    }

    let text: String
    var tone: Tone = .neutral

    var body: some View {
        Text(text)
            .font(Font.HiHa.caption)
            .foregroundStyle(foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(Capsule().fill(background))
    }

    private var foreground: Color {
        switch tone {
        case .neutral: return Color.HiHa.mutedForeground
        case .primary: return Color.HiHa.primaryOn
        case .accent: return Color.HiHa.abyssalNavy
        case .destructive: return Color.white
        case .brand: return Color.HiHa.fgOnAccent
        }
    }

    private var background: AnyShapeStyle {
        switch tone {
        case .neutral: return AnyShapeStyle(Color.HiHa.muted)
        case .primary: return AnyShapeStyle(Color.HiHa.primary)
        case .accent: return AnyShapeStyle(Color.HiHa.auroraCyan.opacity(0.25))
        case .destructive: return AnyShapeStyle(Color.HiHa.destructive)
        case .brand: return AnyShapeStyle(LinearGradient.hiHaBrand)
        }
    }
}
