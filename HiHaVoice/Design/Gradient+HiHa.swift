import SwiftUI

extension LinearGradient {
    /// Dégradé signature iridescent (surfaces : boutons, badges, pastilles).
    /// Pêche douce → Rose brume → Lilas froid (≈ 120° de la charte hi-ha.be).
    /// ⚠️ Pastel : tout texte posé dessus doit être `Color.HiHa.fgOnAccent`.
    static let hiHaBrand = LinearGradient(
        colors: [Color.HiHa.peachSoft, Color.HiHa.roseMist, Color.HiHa.lilacCold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let hiHaBrandSoft = LinearGradient(
        colors: [
            Color.HiHa.peachSoft.opacity(0.8),
            Color.HiHa.roseMist.opacity(0.8),
            Color.HiHa.lilacCold.opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Version « encre » du dégradé signature — pour texte, icônes et traits fins
    /// (les pastels sont illisibles en petite surface sur fond clair).
    static let hiHaBrandInk = LinearGradient(
        colors: [Color.HiHa.peachInk, Color.HiHa.roseInk, Color.HiHa.electricViolet],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension View {
    /// Applies the Hi-Ha signature gradient to text (encres pêche → rose → lilas).
    /// Use only on short narrative elements (H1 hero, wordmark).
    func hiHaGradientText() -> some View {
        self.foregroundStyle(LinearGradient.hiHaBrandInk)
    }
}
