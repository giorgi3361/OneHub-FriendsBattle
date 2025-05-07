import SwiftUI

struct GameDetailView: View {
    let game: GameItem
    @Binding var players: [Player]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Text(game.name)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(players.indices, id: \.self) { index in
                            HStack(spacing: 16) {
                                Text(players[index].avatar)
                                    .font(.largeTitle)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(players[index].name)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("Score: \(players[index].score(for: game.name))")
                                        .foregroundColor(.orange)
                                }

                                Spacer()

                                Button(action: {
                                    players[index].increaseScore(for: game.name)
                                    StoreManager().save(players: players)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer()
            }
            .padding(.top)
        }
    }
}

