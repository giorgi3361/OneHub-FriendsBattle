import SwiftUI

struct FriendsView: View {
    @ObservedObject var viewModel: FriendsViewModel
    @State private var showLimitAlert = false
    @State private var showRadialMenu = false
    @State var radialCenter: CGPoint = .zero
    @State var selectedPlayerID: UUID?
    @State private var avatars = ["😎", "🤖", "🐱", "🦊", "👽", "🎃", "🧠", "👾"]

    
    var body: some View {
        ZStack {
            Back()

            VStack(alignment: .leading,spacing: 0) {
                // Header
                
                Text("Players")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading,20)
                
                // Player list
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if viewModel.players.isEmpty {
                            Text("No players added yet 😢")
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                        } else {
                            ForEach($viewModel.players) { $player in
                                //                                if let selected = selectedPlayerID
                                PlayerCardView(player: $player, radialCenter: $radialCenter, showRadialMenu: $showRadialMenu, selectedPlayerID: $selectedPlayerID) {
                                    withAnimation {
                                        if let index = viewModel.players.firstIndex(of: player) {
                                            viewModel.removePlayer(at: IndexSet(integer: index))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                if viewModel.canAddMore{
                    Button(action: {
                        if viewModel.canAddMore {
                            withAnimation(.spring()) {
                                viewModel.addPlayer()
                            }
                        } else {
                            showLimitAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Player")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [Color.orange, Color(red: 1.0, green: 0.4, blue: 0.0)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.black)
                        .cornerRadius(18)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 6)
                    }
                }
            }
        }
        .overlay(
            Group {
                if showRadialMenu, let id = selectedPlayerID,
                   let playerIndex = viewModel.players.firstIndex(where: { $0.id == id }) {

                    RadialAvatarMenu(
                        center: radialCenter,
                        avatars: avatars,
                        onSelect: { selectedEmoji in
                            viewModel.players[playerIndex].avatar = selectedEmoji
                            showRadialMenu = false
                        },
                        onClose: {
                            showRadialMenu = false
                        }
                    )
                }
            }
        )

        .alert(isPresented: $showLimitAlert) {
            Alert(
                title: Text("Player Limit Reached"),
                message: Text("You can add up to 6 players."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
