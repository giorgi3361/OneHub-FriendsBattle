import SwiftUI

struct Back: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(animate ? 1 : 0.8)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
        }
        .ignoresSafeArea()
    }
}
