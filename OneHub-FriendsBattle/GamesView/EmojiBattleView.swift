import SwiftUI

struct EmojiBattleGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [Player]
    private let gameName = "Emoji Battle"

    @State private var currentPlayerIndex = 0
    @State private var currentEmoji = ""
    @State private var hasVoted: Set<UUID> = []
    @State private var showPlusOne = false

    private let emojis = ["🤖", "🐸", "🧙‍♂️", "🕺", "🐍", "👶", "😱", "💃"]

    var body: some View {
        ZStack {
            Back()
            
            VStack(spacing: 24) {
                HStack{
                    
                    CustomBackButton{
                        dismiss()
                    }
                    
                    Text("Emoji Battle")
                        .font(.largeTitle.bold())
                        .foregroundColor(.orange)
                    
                }
                Text("Act like this emoji:")
                    .foregroundColor(.white.opacity(0.7))

                Text(currentEmoji)
                    .font(.system(size: 64))

                VStack(spacing: 12) {
                    Text("Current Performer")
                        .foregroundColor(.white.opacity(0.6))
                    ZStack {
                        Text(players[currentPlayerIndex].avatar)
                            .font(.system(size: 40))

                        if showPlusOne {
                            Text("+1")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.green)
                                .offset(y: 40)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    Text(players[currentPlayerIndex].name)
                        .foregroundColor(.white)
                        .font(.title2.bold())
                }

                Divider()
                    .frame(maxWidth: 250)
                    .background(Color.white.opacity(0.2))

                VStack(spacing: 16) {
                    Text("Did they perform well?")
                        .foregroundColor(.white.opacity(0.7))

                    Button(action: {
                        awardPoint()
                    }) {
                        Text("Performed")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                    }

                    Button(action: {
                        nextTurn()
                    }) {
                        Text("Didn't Perform")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: 250)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 26).fill(.black.opacity(0.3)))
        }
        .onAppear {
            generateEmoji()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func generateEmoji() {
        currentEmoji = GameQuestionBase.shared.randomEmoji()
    }

    private func awardPoint() {
        withAnimation {
            players[currentPlayerIndex].increaseScore(for: gameName)
            StoreManager().save(players: players)
            showPlusOne = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                showPlusOne = false
                nextTurn()
            }
        }
    }

    private func nextTurn() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        generateEmoji()
    }
}
