import SwiftUI
import AppKit

extension Font {
    enum HiHa {
        private static let family = "Inter"

        static func inter(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            Font.custom(family, size: size).weight(weight)
        }

        static let heroH1      = inter(44, weight: .bold)
        static let sectionH2   = inter(28, weight: .bold)
        static let cardTitle   = inter(20, weight: .semibold)
        static let columnH4    = inter(14, weight: .semibold)
        static let lead        = inter(17, weight: .regular)
        static let body        = inter(13, weight: .regular)
        static let bodyMedium  = inter(13, weight: .medium)
        static let label       = inter(12, weight: .medium)
        static let caption     = inter(11, weight: .semibold)
    }

    static func registerInter() {
        guard let bundle = Bundle.main.resourcePath else { return }
        let fontFiles = ["InterVariable.ttf", "InterVariable-Italic.ttf"]
        for file in fontFiles {
            let url = URL(fileURLWithPath: bundle).appendingPathComponent(file)
            guard FileManager.default.fileExists(atPath: url.path) else { continue }
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
        }
    }
}
