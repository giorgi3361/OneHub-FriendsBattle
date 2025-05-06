import Foundation
import Combine

class FriendsViewModel: ObservableObject {
    @Published var players: [Player] = []

    private let store = StoreManager()
    private let maxPlayers = 6

    init() {
        players = store.load()
    }

    func addPlayer() {
        guard players.count < maxPlayers else { return }
        players.append(Player(name: "Player \(players.count + 1)"))
        save()
    }

    func removePlayer(at offsets: IndexSet) {
        if !players.isEmpty{
            players.remove(atOffsets: offsets)
            save()
        }
    }

    func updatePlayer(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players[index] = player
            save()
        }
    }

    private func save() {
        store.save(players: players)
    }

    var canAddMore: Bool {
        players.count < maxPlayers
    }
}
