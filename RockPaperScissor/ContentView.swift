import SwiftUI
import Combine // Import Combine for the .onReceive modifier

enum Choice: String, CaseIterable {
    case rock = "🪨"
    case paper = "📄"
    case scissors = "✂️"
}

struct ContentView: View {
    @State private var userChoice: Choice?
    @State private var computerChoice: Choice?
    @State private var result: String = "Make your choice!"
    @State private var numberOfRounds: Int?
    @State private var currentRound: Int = 0
    @State private var userScore: Int = 0
    @State private var computerScore: Int = 0
    @State private var roundInput: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if numberOfRounds == nil {
                TextField("How many rounds do you want to play?", text: $roundInput)
                    .onReceive(Just(roundInput)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.roundInput = filtered
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                
                Button("Start Game") {
                    if let rounds = Int(roundInput), rounds > 0 {
                        self.numberOfRounds = rounds
                        self.currentRound = 1
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text("Round \(currentRound) of \(numberOfRounds!)")
                Text(result)
                    .padding()
                
                HStack(spacing: 20) {
                    ForEach(Choice.allCases, id: \.self) { choice in
                        Button(action: {
                            self.play(userChoice: choice)
                        }) {
                            Text(choice.rawValue)
                                .font(.largeTitle)
                        }
                    }
                }
                
                if currentRound >= numberOfRounds! {
                    Text("Game Over! Final Score: You \(userScore) - Computer \(computerScore)")
                        .padding()
                    
                    Button("Play Again") {
                        self.resetGame()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    private func play(userChoice: Choice) {
        self.userChoice = userChoice
        self.computerChoice = Choice.allCases.randomElement() ?? .rock
        let roundResult = determineWinner(userChoice: userChoice, computerChoice: self.computerChoice!)
        self.result = roundResult.message
        if roundResult.userWon {
            userScore += 1
        } else if roundResult.computerWon {
            computerScore += 1
        }
        if currentRound < numberOfRounds! {
            currentRound += 1
        }
    }
    
    private func determineWinner(userChoice: Choice, computerChoice: Choice) -> (message: String, userWon: Bool, computerWon: Bool) {
        if userChoice == computerChoice {
            return ("It's a tie!", false, false)
        } else {
            switch (userChoice, computerChoice) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                return ("You win! \(userChoice.rawValue) beats \(computerChoice.rawValue)", true, false)
            default:
                return ("You lose! \(computerChoice.rawValue) beats \(userChoice.rawValue)", false, true)
            }
        }
    }
    
    private func resetGame() {
        self.numberOfRounds = nil
        self.currentRound = 0
        self.userScore = 0
        self.computerScore = 0
        self.roundInput = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
