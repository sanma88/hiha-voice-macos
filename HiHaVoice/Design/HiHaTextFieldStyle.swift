import SwiftUI

struct HiHaTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .font(Font.HiHa.body)
            .foregroundStyle(Color.HiHa.foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(height: 36)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.HiHa.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(isFocused ? Color.HiHa.focusRing : Color.HiHa.border,
                                  lineWidth: isFocused ? 2 : 1)
            )
            .focused($isFocused)
            .animation(.easeOut(duration: 0.15), value: isFocused)
    }
}

extension TextField {
    func hiHaStyle() -> some View {
        self.textFieldStyle(HiHaTextFieldStyle())
    }
}
