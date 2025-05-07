enum TabItem: String,CaseIterable {
    case friends = "Friends"
    case games = "Games"
    case stats = "Stats"
    
    var icon: String {
        switch self {
        case .friends: return "person.2.fill"
        case .games: return "gamecontroller.fill"
        case .stats: return "chart.bar.fill"
        }
    }
}
