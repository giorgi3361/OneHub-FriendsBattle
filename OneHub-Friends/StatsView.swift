import SwiftUI
import Charts

struct PlayerStats: Identifiable {
    var id: UUID { player.id }
    let player: Player
    var totalScore: Int {
        player.gameScores.values.reduce(0, +)
    }
    var bestGame: String {
        player.gameScores.max(by: { $0.value < $1.value })?.key ?? "-"
    }
}

struct GameStats: Identifiable {
    var id: String { gameName }
    let gameName: String
    let scores: [(Player, Int)]
}

struct StatsView: View {
    @Binding var players: [Player]

    var playerStats: [PlayerStats] {
        players.map { PlayerStats(player: $0) }.sorted { $0.totalScore > $1.totalScore }
    }

    var gameStats: [GameStats] {
        let allGames = Set(players.flatMap { $0.gameScores.keys })
        return allGames.map { game in
            let scores = players.compactMap { player in
                player.gameScores[game].map { (player, $0) }
            }.sorted { $0.1 > $1.1 }
            return GameStats(gameName: game, scores: scores)
        }
    }

    var body: some View {
        ZStack{
            Back()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    Text("Player Stats")
                        .font(.title.bold())
                        .foregroundColor(.orange)
                        .padding(.horizontal)

                    ForEach(playerStats) { stat in
                        HStack(spacing: 12) {
                            Text(stat.player.avatar)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(stat.player.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Total: \(stat.totalScore) pts")
                                    .foregroundColor(.orange)
                                Text("Best: \(stat.bestGame)")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }

                    Divider().background(Color.white.opacity(0.3))

                    Text("Game Stats")
                        .font(.title.bold())
                        .foregroundColor(.orange)
                        .padding(.horizontal)

                    ForEach(gameStats) { game in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(game.gameName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)


                            Chart(game.scores, id: \.0) { item in
                                BarMark(
                                    x: .value("Player", item.0.name),
                                    y: .value("Points", item.1)
                                )
                                .foregroundStyle(Color.orange.gradient)
                            }
                            .chartXAxis {
                                AxisMarks { value in
                                    AxisValueLabel()
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Color.white)
                                }
                            }
                            .chartYAxis {
                                AxisMarks(preset: .extended, position: .leading)
                            }
                            .frame(height: 160)
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
            }
        }
    }
}
