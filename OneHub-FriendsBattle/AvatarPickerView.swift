import SwiftUI

struct RadialAvatarMenu: View {
    let center: CGPoint
    let avatars: [String]
    let onSelect: (String) -> Void
    let onClose: () -> Void

    @State private var isVisible = false

    var body: some View {
        ZStack {
            // затемнений фон
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { onClose() }
                }

            // кнопки по колу
            ZStack {
                ForEach(avatars.indices, id: \.self) { index in
                    let angle = Angle(degrees: Double(index) / Double(avatars.count) * 360)
                    let radius: CGFloat = 80
                    let x = cos(angle.radians) * radius
                    let y = sin(angle.radians) * radius

                    Text(avatars[index])
                        .font(.system(size: 28))
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.9))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                        .shadow(color: Color.orange.opacity(0.7), radius: 6)
                        .opacity(isVisible ? 1 : 0)
                        .scaleEffect(isVisible ? 1 : 0.3)
                        .offset(x: isVisible ? x : 0, y: isVisible ? y : 0)
                        .animation(.spring().delay(Double(index) * 0.03), value: isVisible)
                        .onTapGesture {
                            withAnimation {
                                onSelect(avatars[index])
                            }
                        }
                }

                // центральна кнопка X
                Button(action: {
                    withAnimation { onClose() }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .position(center)
        }
        .onAppear {
            withAnimation(.spring()) {
                isVisible = true
            }
        }
    }
}
