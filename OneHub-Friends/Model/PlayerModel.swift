import Foundation

struct Player: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var avatar: String
    var gameScores: [String: Int]

    init(id: UUID = UUID(), name: String, avatar: String = "😎", gameScores: [String: Int] = [:]) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.gameScores = gameScores
    }

    func score(for game: String) -> Int {
        return gameScores[game] ?? 0
    }

    mutating func increaseScore(for game: String) {
        gameScores[game, default: 0] += 1
    }
}
