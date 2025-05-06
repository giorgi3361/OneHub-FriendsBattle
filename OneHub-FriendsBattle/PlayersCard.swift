import SwiftUI

struct PlayerCardView: View {
    @Binding var player: Player
    @Binding var radialCenter: CGPoint
    @Binding var showRadialMenu: Bool
    @Binding var selectedPlayerID: UUID?
    var onDelete: () -> Void
    

    private let avatars = ["😎", "🤖", "🐱", "🦊", "👽", "🎃", "🧠", "👾"]

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("Player name", text: $player.name)
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.vertical, 6)

                    
                    Button {
                        selectedPlayerID = player.id
                        withAnimation {
                            showRadialMenu = true
                        }
                    } label: {
                        Text(player.avatar)
                            .font(.system(size: 32))
                            .frame(width: 48, height: 48)
                            .background(Color.black.opacity(0.15))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    DispatchQueue.main.async {
                                        let frame = proxy.frame(in: .global)
                                        radialCenter = CGPoint(x: frame.midX, y: frame.midY)
                                    }
                                }
                        }
                    )
                    
                    Spacer()

                    Button(action: onDelete) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.95), Color(red: 1.0, green: 0.4, blue: 0.0)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.orange.opacity(0.4), radius: 8, x: 0, y: 6)
            .padding(.horizontal)

        }
    }
}

