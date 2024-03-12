import SwiftUI

enum Choice: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
}

struct ContentView: View {
    @State private var userChoice: Choice?
    @State private var computerChoice: Choice?
    @State private var result: String = "Make your choice!"
    
    var body: some View {
        VStack(spacing: 20) {
            Text(result).padding()
            
            ForEach(Choice.allCases, id: \.self) { choice in
                Button(action: {
                    self.play(userChoice: choice)
                }) {
                    Text(choice.rawValue)
                        .padding()
                        .border(Color.black, width: 2)
                }
            }
        }
    }
    
    private func play(userChoice: Choice) {
        self.userChoice = userChoice
        self.computerChoice = Choice.allCases.randomElement() ?? .rock
        self.result = determineWinner(userChoice: userChoice, computerChoice: self.computerChoice!)
    }
    
    private func determineWinner(userChoice: Choice, computerChoice: Choice) -> String {
        if userChoice == computerChoice {
            return "It's a tie!"
        } else {
            switch (userChoice, computerChoice) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                return "You win! \(userChoice.rawValue) beats \(computerChoice.rawValue)"
            default:
                return "You lose! \(computerChoice.rawValue) beats \(userChoice.rawValue)"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
