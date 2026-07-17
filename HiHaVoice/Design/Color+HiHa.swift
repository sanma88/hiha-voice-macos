import SwiftUI
import AppKit

extension Color {
    init(light: Color, dark: Color) {
        self.init(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(isDark ? dark : light)
        })
    }

    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }

    enum HiHa {
        // MARK: - Charte hi-ha.be — primitives claires
        // Les identifiants historiques sont conservés (148 usages hors Design/),
        // les valeurs correspondent aux tokens du site hi-ha.be (colors_and_type.css).
        static let glacialMist    = Color(hex: 0xF4F7FB)  // Blanc Glacé (--bg light)
        static let abyssalNavy    = Color(hex: 0x2C2F36)  // Encre graphite (--fg light)
        static let pureCanvas     = Color(hex: 0xFFFFFF)  // Surface (--surface light)
        static let sovereignMarine = Color(hex: 0x363B41) // Graphite profond — autorité calme
        static let electricViolet = Color(hex: 0x7E7BC4)  // Lilas encre (--accent-ink light)
        static let auroraCyan     = Color(hex: 0x7E7BC4)  // Lilas encre — le cyan disparaît de la charte
        static let paleLinen      = Color(hex: 0xEDF0F6)  // Fond discret (--bg-subtle light)
        static let slateMist      = Color(hex: 0x6B7079)  // Gris texte tertiaire (--fg-3 light)
        static let mistedSilver   = Color(hex: 0xDFE1E9)  // Perle Givrée (--border light)
        static let signalCoral    = Color(hex: 0xB22A44)  // Danger (--danger light)
        static let obsidianRing   = Color(hex: 0x7E7BC4)  // Focus (--focus-ring light)

        // MARK: - Charte hi-ha.be — primitives sombres
        static let lunarWhite     = Color(hex: 0xE7EAF0)  // Brume claire (--fg dark)
        static let graphiteBlue   = Color(hex: 0x22262D)  // Gris interface (--surface-2 dark)
        static let starlightGrey  = Color(hex: 0x9CA1AC)  // Gris texte tertiaire (--fg-3 dark)
        static let emberRust      = Color(hex: 0xB22A44)  // Danger fond (dark)
        static let dawnRing       = Color(hex: 0xB9B7E6)  // Lilas clair (--accent-ink / focus dark)
        static let nightBlack     = Color(hex: 0x0B0B0C)  // Noir nuancé (--bg dark)
        static let graphiteNight  = Color(hex: 0x16181D)  // Nuit graphite (--surface dark)
        static let mutedNight     = Color(hex: 0x1B1E24)  // Surface discrète (--surface-2 dark)
        static let borderNight    = Color(hex: 0x2A2E36)  // Bordure (--border dark)

        // MARK: - Pastels iridescents (accents décoratifs, jamais de texte long dessus)
        static let peachSoft      = Color(hex: 0xECDAD3)  // Pêche douce
        static let roseMist       = Color(hex: 0xE2D0D4)  // Rose brume
        static let lilacCold      = Color(hex: 0xDAD9EE)  // Lilas froid
        static let peachInk       = Color(hex: 0xC98E76)  // Encre pêche
        static let roseInk        = Color(hex: 0xBE8791)  // Encre rose
        static let dangerSoft     = Color(hex: 0xFF8A9D)  // Danger texte (dark)
        static let fgOnAccent     = Color(hex: 0x2C2F36)  // Texte posé sur un accent pastel (--fg-on-accent)

        // MARK: - Semantic tokens (auto light/dark)
        static let background      = Color(light: glacialMist, dark: nightBlack)
        static let foreground      = Color(light: abyssalNavy, dark: lunarWhite)
        static let cardBackground  = Color(light: pureCanvas, dark: graphiteNight)
        static let primary         = Color(light: sovereignMarine, dark: lunarWhite)
        static let primaryOn       = Color(light: glacialMist, dark: graphiteNight)
        static let secondary       = Color(light: electricViolet, dark: graphiteBlue)
        static let muted           = Color(light: paleLinen, dark: mutedNight)
        static let mutedForeground = Color(light: slateMist, dark: starlightGrey)
        static let accent          = Color(light: electricViolet, dark: dawnRing)
        static let destructive     = Color(light: signalCoral, dark: emberRust)
        static let border          = Color(light: mistedSilver, dark: borderNight)
        static let focusRing       = Color(light: obsidianRing, dark: dawnRing)
    }
}
