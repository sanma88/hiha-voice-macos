import SwiftUI

// MARK: - Size tokens
enum HiHaButtonSize {
    case sm, `default`, lg, icon

    var height: CGFloat {
        switch self {
        case .sm: return 32
        case .default: return 36
        case .lg: return 40
        case .icon: return 36
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .sm: return 12
        case .default: return 16
        case .lg: return 24
        case .icon: return 0
        }
    }

    var iconWidth: CGFloat? {
        self == .icon ? 36 : nil
    }

    var font: Font {
        switch self {
        case .sm: return Font.HiHa.inter(12, weight: .semibold)
        case .default: return Font.HiHa.inter(13, weight: .semibold)
        case .lg: return Font.HiHa.inter(14, weight: .semibold)
        case .icon: return Font.HiHa.inter(13, weight: .semibold)
        }
    }
}

// MARK: - Primary
struct HiHaPrimaryButtonStyle: ButtonStyle {
    var size: HiHaButtonSize = .default
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(Color.HiHa.primaryOn)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: size.iconWidth.map { _ in nil } ?? .infinity)
            .frame(width: size.iconWidth, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.HiHa.primary.opacity(configuration.isPressed ? 0.9 : 1.0))
            )
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Outline
struct HiHaOutlineButtonStyle: ButtonStyle {
    var size: HiHaButtonSize = .default
    @Environment(\.isEnabled) private var isEnabled
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(isHovering ? Color.HiHa.primary : Color.HiHa.foreground)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: size.iconWidth.map { _ in nil } ?? .infinity)
            .frame(width: size.iconWidth, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isHovering ? Color.HiHa.muted : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.HiHa.border, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .onHover { isHovering = $0 }
            .animation(.easeOut(duration: 0.15), value: isHovering)
    }
}

// MARK: - Ghost
struct HiHaGhostButtonStyle: ButtonStyle {
    var size: HiHaButtonSize = .default
    @Environment(\.isEnabled) private var isEnabled
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(Color.HiHa.foreground)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: size.iconWidth.map { _ in nil } ?? .infinity)
            .frame(width: size.iconWidth, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isHovering ? Color.HiHa.muted : Color.clear)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .onHover { isHovering = $0 }
            .animation(.easeOut(duration: 0.15), value: isHovering)
    }
}

// MARK: - Destructive
struct HiHaDestructiveButtonStyle: ButtonStyle {
    var size: HiHaButtonSize = .default
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(Color.white)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: size.iconWidth.map { _ in nil } ?? .infinity)
            .frame(width: size.iconWidth, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.HiHa.destructive.opacity(configuration.isPressed ? 0.9 : 1.0))
            )
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Accent pastel (action secondaire douce, style « chip » lilas de la charte)
struct HiHaCyanButtonStyle: ButtonStyle {
    var size: HiHaButtonSize = .default
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(Color.HiHa.fgOnAccent)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: size.iconWidth.map { _ in nil } ?? .infinity)
            .frame(width: size.iconWidth, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.HiHa.lilacCold.opacity(configuration.isPressed ? 0.85 : 1.0))
            )
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Brand gradient (signature pour actions phares)
struct HiHaBrandButtonStyle: ButtonStyle {
    var size: HiHaButtonSize = .default
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(Color.HiHa.fgOnAccent)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: size.iconWidth.map { _ in nil } ?? .infinity)
            .frame(width: size.iconWidth, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient.hiHaBrand)
                    .opacity(configuration.isPressed ? 0.85 : 1.0)
            )
            .opacity(isEnabled ? 1 : 0.5)
            .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Convenience modifiers
extension Button {
    func hiHaCyan(_ size: HiHaButtonSize = .default) -> some View {
        self.buttonStyle(HiHaCyanButtonStyle(size: size))
    }

    func hiHaBrand(_ size: HiHaButtonSize = .default) -> some View {
        self.buttonStyle(HiHaBrandButtonStyle(size: size))
    }
}

extension Button {
    func hiHaPrimary(_ size: HiHaButtonSize = .default) -> some View {
        self.buttonStyle(HiHaPrimaryButtonStyle(size: size))
    }

    func hiHaOutline(_ size: HiHaButtonSize = .default) -> some View {
        self.buttonStyle(HiHaOutlineButtonStyle(size: size))
    }

    func hiHaGhost(_ size: HiHaButtonSize = .default) -> some View {
        self.buttonStyle(HiHaGhostButtonStyle(size: size))
    }

    func hiHaDestructive(_ size: HiHaButtonSize = .default) -> some View {
        self.buttonStyle(HiHaDestructiveButtonStyle(size: size))
    }
}
