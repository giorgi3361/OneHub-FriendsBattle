import SwiftUI

struct TruthOrDareGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [Player]
    private let gameName = "Truth or Dare"

    @State private var currentPlayerIndex = 0
    @State private var currentChallenge: String = ""
    @State private var isTruth = true
    @State private var round = 1
    @State private var showPlusOne = false
    
    private let truths = [
        "What’s your biggest fear?",
        "What’s something you've never told anyone?",
        "Have you ever lied in this game?"
    ]

    private let dares = [
        "Do a silly dance.",
        "Speak like a robot for 1 minute.",
        "Do 5 push-ups."
    ]

    var body: some View {
        ZStack {
            Back()

            VStack(spacing: 32) {
                VStack(spacing: 6) {
                    HStack{
                        CustomBackButton{
                            dismiss()
                        }
                        
                        Text("Truth or Dare")
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundColor(.orange)
                        
                    }
                    Text("Round \(round)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                VStack(spacing: 10) {
                    Text("Current Player")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.subheadline)

                    
                    
                    HStack(spacing: 10) {
                        ZStack {
                            Text(players[currentPlayerIndex].avatar)
                                .font(.system(size: 36))

                            if showPlusOne {
                                Text("+1")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.green)
                                    .offset(y: 40)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }

                        Text(players[currentPlayerIndex].name)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                }

                if currentChallenge.isEmpty {
                    HStack(spacing: 24) {
                        GameButton(title: "Truth", icon: "text.bubble") {
                            isTruth = true
                            currentChallenge = GameQuestionBase.shared.randomTruth()
                        }

                        GameButton(title: "Dare", icon: "flame") {
                            isTruth = false
                            currentChallenge = GameQuestionBase.shared.randomDare()
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Text(currentChallenge)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()

                        HStack(spacing: 16) {
                            GameButton(title: "Completed", icon: "checkmark") {
                                players[currentPlayerIndex].increaseScore(for: gameName)
                                StoreManager().save(players: players)
                                withAnimation(.spring()) {
                                    showPlusOne = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation {
                                        showPlusOne = false
                                        nextTurn()
                                    }
                                }
                                
                            }

                            GameButton(title: "Skip", icon: "arrow.right") {
                                nextTurn()
                            }
                        }
                    }
                    .transition(.opacity)
                }

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).fill(.black.opacity(0.3)))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .animation(.easeInOut, value: currentChallenge)
    }

    private func nextTurn() {
        currentChallenge = ""
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        if currentPlayerIndex == 0 { round += 1 }
    }
}

struct GameButton: View {
    var title: String
    var icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(minWidth: 120)
            .background(Color.orange)
            .foregroundColor(.black)
            .cornerRadius(14)
            .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 4)
        }
    }
}
