import Cocoa

class kingGameState {
    let deck: [Int] = Array(0...51).shuffled()
    var played: [Bool] = Array(repeating: false, count: 52)
    var playable: [Bool] = Array(repeating: false, count: 52)
    var middle: [Bool] = Array(repeating: false, count: 52)
    let pIdx: [Int] = [0, 13, 26, 39, 52]
    var (turn, round): (Int, Int) = (0, 0)
    var (suit, type): (Int, Int) = (-1, -1)
    init(suit: Int, type: Int) {
        if (suit >= 0 && suit <= 3) { self.suit = suit }
        else { print("Suit \(suit) is out of range.") }
        if (type >= 0 && type <= 10) { self.type = type }
        else { print("Type \(type) is out of range.") }
    }

    func whoHas(card: Int) -> Int {
        var who: Int = -1
        for idx in 0...51 {
            if card == self.deck[idx] {
                who = idx / 13
            }
        }
        
        return who
    }
    
    func step() {
        let range = self.pIdx[turn]...pIdx[turn + 1] - 1
        
        var hasSuit: Bool = false
        for idx in range {
            if self.deck[idx] / 13 == self.suit && !self.played[idx] {
                hasSuit = true
            }
        }
        
        if hasSuit {
            for idx in range {
                if self.deck[idx] / 13 == self.suit && !self.played[idx]{
                    self.playable[idx] = true
                }
            }
        } else {
            for idx in range {
                if !self.played[idx] {
                    self.playable[idx] = true
                }
            }
        }
        
        var playableIndices: [Int] = []
        for idx in range {
            if self.playable[idx] {
                playableIndices.append(idx)
            }
        }
        
        /* MOVE FROM PLAYER */
        let move: Int = playableIndices.randomElement()!
        /* ---------------- */
        
        self.played[move] = true
        self.middle[move] = true
        
        self.playable = Array(repeating: false, count: 52)
        self.turn = (self.turn + 1) % 4
    }
}

let test: [Bool] = [true, true, false, false, true, false]
var go: [Int] = []
for i in 0...test.count - 1{
    if test[i] {
        go.append(i)
    }
}
go.randomElement()
