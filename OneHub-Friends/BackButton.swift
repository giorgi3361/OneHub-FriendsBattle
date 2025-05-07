import SwiftUI

struct CustomBackButton: View {
    var action: () -> Void
    var title: String = "Back"

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.black)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.orange)
            .cornerRadius(12)
            .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 4)
        }
    }
}
