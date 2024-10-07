import Cocoa

class kingGameState {
    let deck: [Int] = Array(0...52).shuffled()
    var hands: [[Int]] = Array(repeating: Array(repeating: -1, count: 13), count: 4)
    var (dealer, turn, round) = (0, 0, 0)
    
    func whoHas(card:Int) -> Int {
        var who = -1
        if self.hands[0].contains(card) {
            who = 0
        } else if self.hands[1].contains(card) {
            who = 1
        } else if self.hands[2].contains(card) {
            who = 2
        } else if self.hands[3].contains(card) {
            who = 3
        }
        
        return who
    }
    
    func step() {
        
        self.turn += 1
    }
    
    init() {
        for i in 0...3 {
            for j in 0...12 {
                hands[i][j] = deck[i * 13 + j]
            }
            hands[i] = hands[i].sorted()
        }
        
    }
    
}

let state = kingGameState()
print(41 / 13)
