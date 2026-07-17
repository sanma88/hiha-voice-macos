import SwiftUI

/// Border statique en dégradé signature violet→cyan.
struct HiHaBrandBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 8
    var width: CGFloat = 1

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(LinearGradient.hiHaBrand, lineWidth: width)
        )
    }
}

/// Border animée multi-couleur (violet → cyan → marine) tournant en continu.
/// Signature Hi-Ha, à réserver aux éléments phares (hero, carte pro, état actif).
struct HiHaAnimatedBorderModifier: ViewModifier {
    @State private var rotation: Double = 0
    var cornerRadius: CGFloat = 12
    var width: CGFloat = 1.5
    var duration: Double = 8

    private let colors: [Color] = [
        Color.HiHa.peachInk,
        Color.HiHa.roseInk,
        Color.HiHa.electricViolet,
        Color.HiHa.peachInk
    ]

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center,
                            startAngle: .degrees(rotation),
                            endAngle: .degrees(rotation + 360)
                        ),
                        lineWidth: width
                    )
            )
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

extension View {
    /// Border statique dégradé brand (violet → cyan).
    func hiHaBrandBorder(cornerRadius: CGFloat = 8, width: CGFloat = 1) -> some View {
        self.modifier(HiHaBrandBorderModifier(cornerRadius: cornerRadius, width: width))
    }

    /// Border animée multi-couleur rotative — signature pour éléments phares.
    func hiHaAnimatedBorder(cornerRadius: CGFloat = 12, width: CGFloat = 1.5, duration: Double = 8) -> some View {
        self.modifier(HiHaAnimatedBorderModifier(cornerRadius: cornerRadius, width: width, duration: duration))
    }
}
