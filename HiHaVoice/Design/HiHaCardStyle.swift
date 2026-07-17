import SwiftUI

struct HiHaCardModifier: ViewModifier {
    var padding: CGFloat = 24
    var cornerRadius: CGFloat = 8
    var showBorder: Bool = true
    var interactive: Bool = false
    @State private var isHovering = false

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.HiHa.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.HiHa.border, lineWidth: showBorder ? 1 : 0)
            )
            .modifier(CardShadow(isHovering: interactive && isHovering))
            .onHover { if interactive { isHovering = $0 } }
            .animation(.easeOut(duration: 0.3), value: isHovering)
    }
}

private struct CardShadow: ViewModifier {
    let isHovering: Bool
    func body(content: Content) -> some View {
        if isHovering {
            content.hiHaShadowLift()
        } else {
            content.hiHaShadowSoft()
        }
    }
}

extension View {
    /// Hi-Ha card: floating surface, soft shadow, subtle border, 24pt padding.
    func hiHaCard(padding: CGFloat = 24, cornerRadius: CGFloat = 8, border: Bool = true, interactive: Bool = false) -> some View {
        self.modifier(HiHaCardModifier(padding: padding, cornerRadius: cornerRadius, showBorder: border, interactive: interactive))
    }
}
