import Foundation

class StoreManager {
    private let key = "savedPlayers"

    func save(players: [Player]) {
        if let data = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> [Player] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let players = try? JSONDecoder().decode([Player].self, from: data) else {
            return []
        }
        return players
    }
}
