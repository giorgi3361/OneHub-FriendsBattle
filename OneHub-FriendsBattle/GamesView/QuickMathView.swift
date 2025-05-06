import SwiftUI

struct QuickMathGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var players: [Player]
    private let gameName = "Quick Math"

    @State private var currentPlayerIndex = 0
    @State private var question: String = ""
    @State private var correctAnswer: Int = 0
    @State private var options: [Int] = []
    @State private var showPlusOne = false
    @State private var answered = false
    @State private var timeLeft = 10
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Back()

            VStack(spacing: 24) {
                HStack{
                 
                    CustomBackButton{
                        dismiss()
                    }
                    
                    Text("Quick Math")
                        .font(.largeTitle.bold())
                        .foregroundColor(.orange)
                    
                }
                Text("Solve the equation:")
                    .foregroundColor(.white.opacity(0.7))

                Text(question)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                Text("Time Left: \(timeLeft)s")
                    .font(.headline)
                    .foregroundColor(timeLeft <= 3 ? .red : .white)

                VStack(spacing: 10) {
                    Text("Current Player")
                        .foregroundColor(.white.opacity(0.6))
                    HStack{
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
                }

                Divider()
                    .frame(maxWidth: 300)
                    .background(Color.white.opacity(0.2))

                VStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            if answered { return }
                            answered = true
                            stopTimer()
                            if option == correctAnswer {
                                awardPoint()
                            } else {
                                nextTurn()
                            }
                        }) {
                            Text("\(option)")
                                .font(.title3.bold())
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.orange)
                                .foregroundColor(.black)
                                .cornerRadius(14)
                        }
                    }
                }

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 26).fill(.black.opacity(0.3)))
        }
        .onAppear {
            generateQuestion()
        }
        .onDisappear {
            stopTimer()
        }
        .navigationBarBackButtonHidden(true)
    }

    private func generateQuestion() {
        answered = false
        timeLeft = 10
        startTimer()

        let a = Int.random(in: 1...10)
        let b = Int.random(in: 1...10)
        let operation = ["+", "-", "×"].randomElement()!

      question = GameQuestionBase.shared.generateMathQuestion().question
      correctAnswer =  GameQuestionBase.shared.generateMathQuestion().answer

        var allAnswers: Set<Int> = [correctAnswer]
        while allAnswers.count < 4 {
            allAnswers.insert(Int.random(in: correctAnswer - 10...correctAnswer + 10))
        }
        
        options = Array(allAnswers).shuffled()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                answered = true
                stopTimer()
                nextTurn()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
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
        generateQuestion()
    }
}
