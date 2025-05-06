import SwiftUI

extension Text {
    func hubTitle() -> some View {
        self.font(.largeTitle).foregroundColor(.yellow)
    }

    func hubBody() -> some View {
        self.font(.body).foregroundColor(.white)
    }
}
