import SwiftUI

struct GameItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

struct GamesHubView: View {
    let games: [GameItem] = [
        GameItem(name: "Truth or Dare", icon: "questionmark.circle"),
        GameItem(name: "Emoji Battle", icon: "face.smiling"),
        GameItem(name: "Guess the Word", icon: "textformat.abc"),
        GameItem(name: "Quick Math", icon: "plus.slash.minus"),
    ]

    @ObservedObject var viewModel: FriendsViewModel
    @Binding var isTabBarHidden: Bool
    @State private var selectedGame: GameItem?
    
    @State private var showAlert = false
    @State private var navigateToGame = false
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Back()
                
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    Text("Games")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(games) { game in
                                Button(action: {
                                    selectedGame = game
                                    
                                    if viewModel.players.isEmpty {
                                        withAnimation {
                                            showAlert = true
                                        }
                                        
                                    } else {
                                        withAnimation {
                                            isTabBarHidden = true
                                            navigateToGame = true
                                        }
                                    }
                                    
                                }) {
                                    HStack(spacing: 16) {
                                        Image(systemName: game.icon)
                                            .font(.system(size: 24))
                                            .foregroundColor(.white)
                                        
                                        Text(game.name)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .semibold))
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [Color.orange, Color(red: 1.0, green: 0.4, blue: 0.0)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(18)
                                    .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .overlay(
                    Group {
                        if showAlert, let game = selectedGame {
                            VStack {
                                Spacer()
                                CustomAlertView(
                                    title: "No Players",
                                    subtitle: "You need at least one player to play \"\(game.name)\". Please add them in the menu above.",
                                    buttonText: "Okay"
                                ) {
                                    withAnimation {
                                        showAlert = false
                                    }
                                }
                                Spacer()
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                )
                
                .onAppear{
                    isTabBarHidden = false
                }
                
                .navigationDestination(isPresented: $navigateToGame) {
                    if let game = selectedGame {
                        switch game.name{
                        case "Truth or Dare" :    TruthOrDareGameView(players: $viewModel.players)
                                .toolbar(.hidden, for: .tabBar)
                            
                        case "Emoji Battle": EmojiBattleGameView(players: $viewModel.players)
                            
                        case "Quick Math": QuickMathGameView(players: $viewModel.players)
                            
                        case "Guess the Word": GuessTheWordGameView(players: $viewModel.players)
                        default:
                            GameDetailView(game: game, players: $viewModel.players)
                        }
                    }
                }
            }
        }
    }
}
