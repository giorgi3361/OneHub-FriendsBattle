import SwiftUI

struct GuessTheWordGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [Player]
    private let gameName = "Guess the Word"

    @State private var currentHostIndex = 0
    @State private var currentWord: String = ""
    @State private var guessedPlayerID: UUID? = nil
    @State private var showPlusOne = false
    @State private var timeLeft = 15
    @State private var timer: Timer?

    private let words = ["Banana", "Airplane", "Snowman", "Guitar", "Robot", "Elephant"]

    var body: some View {
        ZStack {
            Back()

            VStack(spacing: 24) {
                HStack{
                    CustomBackButton{
                        dismiss()
                    }
                    
                    Text("Guess the Word")
                        .font(.largeTitle.bold())
                        .foregroundColor(.orange)
                    
                }
                    
                Divider()
                    .frame(maxWidth: 300)
                    .background(Color.white.opacity(0.2))
                
                Text("Time Left: \(timeLeft)s")
                    .font(.headline)
                    .foregroundColor(timeLeft <= 3 ? .red : .white)

                Text("Word to explain:")
                    .foregroundColor(.white.opacity(0.7))

                Text(currentWord)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                VStack(spacing: 8) {
                    Text("Host")
                        .foregroundColor(.white.opacity(0.6))
                    HStack{
                        ZStack {
                            Text(players[currentHostIndex].avatar)
                                .font(.system(size: 40))

                            if showPlusOne {
                                Text("+1")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.green)
                                    .offset(y: 40)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        Text(players[currentHostIndex].name)
                            .foregroundColor(.white)
                            .font(.title2.bold())
                    }
                }

                Divider()
                    .frame(maxWidth: 300)
                    .background(Color.white.opacity(0.2))

                VStack(spacing: 12) {
                    Text("Tap who guessed it!")
                        .foregroundColor(.white.opacity(0.7))

                    ForEach(players.filter { $0.id != players[currentHostIndex].id }) { player in
                        Button(action: {
                            if guessedPlayerID == nil {
                                guessedPlayerID = player.id
                                awardPoint(to: player.id)
                            }
                        }) {
                            HStack {
                                Text(player.avatar)
                                Text(player.name)
                            }
                            .padding()
                            .frame(maxWidth: 300)
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                        }
                        .disabled(guessedPlayerID != nil)
                        .opacity(guessedPlayerID != nil ? 0.4 : 1.0)
                    }
                }

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 26).fill(.black.opacity(0.3)))
        }
        .onAppear {
            generateWord()
        }
        .onDisappear {
            stopTimer()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func generateWord() {
        guessedPlayerID = nil
        timeLeft = 15
        currentWord = GameQuestionBase.shared.randomWord()
        startTimer()
    }

    private func awardPoint(to id: UUID) {
        stopTimer()
        if let index = players.firstIndex(where: { $0.id == id }) {
            withAnimation {
                players[index].increaseScore(for: gameName)
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
    }

    private func nextTurn() {
        currentHostIndex = (currentHostIndex + 1) % players.count
        generateWord()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                stopTimer()
                nextTurn()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
