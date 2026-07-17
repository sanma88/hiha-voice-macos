import SwiftUI

extension View {
    /// Souffle — état au repos des cartes. Quasi-imperceptible.
    func hiHaShadowSoft() -> some View {
        self.shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    /// Soulèvement — état au survol des cartes interactives.
    func hiHaShadowLift() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
    }

    /// Présence — images hero, portraits, éléments qui s'ancrent.
    func hiHaShadowPresence() -> some View {
        self.shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
    }
}
