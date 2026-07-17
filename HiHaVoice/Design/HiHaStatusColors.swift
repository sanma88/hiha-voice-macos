import SwiftUI

/// Tokens sémantiques pour états (remplace les Color.green/yellow/orange natifs).
/// Respecte strictement la charte hi-ha.be — statuts issus du kit admin du site.
extension Color.HiHa {
    /// État "succès / accordé" — vert doux « publié » du kit admin hi-ha.be.
    static let statusSuccess = Color(hex: 0x4A9A7A)

    /// État "en attente / avertissement" — encre pêche « relecture ».
    static let statusPending = peachInk

    /// État "erreur / refusé" — danger de la charte (rouge profond / rose clair en sombre).
    static let statusError = Color(light: signalCoral, dark: dangerSoft)

    /// État "information" — encre lilas (accent-ink).
    static let statusInfo = accent
}
