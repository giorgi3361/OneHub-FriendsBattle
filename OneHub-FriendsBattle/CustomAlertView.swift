import SwiftUI

struct CustomAlertView: View {
    var title: String
    var subtitle: String
    var buttonText: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))

            Button(action: action) {
                Text(buttonText)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(14)
            }
        }
        .padding()
        .background(Color.black.opacity(0.9))
        .cornerRadius(20)
        .shadow(color: Color.orange.opacity(0.4), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 32)
    }
}
