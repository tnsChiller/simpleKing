import Foundation

class kingGameState {
    let deck: [Int] = Array(0...51).shuffled()
    var played: [Bool] = Array(repeating: false, count: 52)
    var playable: [Bool] = Array(repeating: false, count: 52)
    var middle: [Bool] = Array(repeating: false, count: 52)
    var banks: [Int] = Array(repeating: -1, count: 52)
    var scores: [Int] = [0, 0, 0, 0]
    let pIdx: [Int] = [0, 13, 26, 39, 52]
    var (turn, round, gameNo): (Int, Int, Int) = (0, 0, 0)
    var (suit, type, start): (Int, Int, Int) = (-1, -1, -1)
    var kupaDustu: Bool = false
    
    init(type: Int, turn: Int, gameNo: Int) {
        if type >= 0 && type <= 10 {
            self.type = type
        } else {
            print("Type \(type) is out of range.")
        }
        if turn >= 0 && turn <= 3 {
            self.turn = turn
        } else {
            print("Turn \(turn) is out of range.")
        }
        if gameNo >= 0 && gameNo <= 19 {
            self.gameNo = gameNo
        } else {
            print("Game Number \(gameNo) is out of range.")
        }

        self.start = whoHas(card: 39)
    }

    func whoHas(card: Int) -> Int {
        var who: Int = -1
        for idx in 0...51 {
            if card == self.deck[idx] { who = idx / 13 }
        }

        return who
    }

    func canDitch(card: Int, midMax: Int, hasSuit: Bool) -> Bool {
        var canDitch: Bool = false
        if card / 13 == self.suit && card % 13 < midMax {
            canDitch = true
        } else if !hasSuit && self.turn != 0 {
            canDitch = true
        }

        return canDitch
    }
    
    func doRound() {
        for idx: ClosedRange<Int>.Element in 0...3 {
            step()
        }
        
        var winIdx: Int = -1
        var winNo: Int = -1
        for idx: ClosedRange<Int>.Element in 0...51 {
            if self.middle[idx] {
                if self.deck[idx] % 13 > winNo && self.deck[idx] / 13 == self.suit {
                    winIdx = idx
                    winNo = self.deck[idx] % 13
                }
            }
        }
        
        let winner: Int = winNo / 13
        var middle: [Bool] = Array(repeating: false, count: 52)
    }

    func step() {
        let anchor: Int = (self.start + turn) % 4
        let range: ClosedRange<Int> = self.pIdx[anchor]...pIdx[anchor + 1] - 1
        // Pre Action
        var hasSuit: Bool = false
        var midMax: Int = -1
        if self.turn != 0 {
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.deck[idx] / 13 == self.suit {
                        hasSuit = true
                    }
                }
            }

            for idx: ClosedRange<Int>.Element in 0...51 {
                if self.middle[idx] {
                    if self.deck[idx] % 13 > midMax
                        && self.deck[idx] / 13 == self.suit
                    {
                        midMax = self.deck[idx] % 13
                    }
                }
            }
        }

        let ditchables: [Int] =
            switch self.type {
            case 2:
                Array(13...25)
            case 3:
                [9, 11, 22, 24, 35, 37, 48, 50]
            case 4:
                [10, 23, 36, 49]
            case 5:
                [9, 11, 22, 24, 35, 37, 48, 50]
            case 6:
                Array(0...12)
            case 7:
                Array(13...25)
            case 8:
                Array(26...38)
            case 9:
                Array(39...51)
            default:
                []
            }

        var rifDitch: Bool = false
        var ditchableKs: [Int] = []
        var ditchableQs: [Int] = []
        var ditchableJs: [Int] = []
        var ditchableCups: [Int] = []
        var trumps: [Int] = []
        for idx: ClosedRange<Int>.Element in range {
            if !self.played[idx] {
                if ditchables.contains(idx) {
                    if canDitch(card: idx, midMax: midMax, hasSuit: hasSuit) {
                        if self.type == 5 && idx == 24 {
                            rifDitch = true
                        } else if self.type == 3 {
                            if idx % 13 == 11 {
                                ditchableKs.append(idx)
                            } else {
                                ditchableJs.append(idx)
                            }
                        } else if self.type == 4 {
                            ditchableQs.append(idx)
                        } else if self.type == 2 {
                            ditchableCups.append(idx)
                        } else {
                            trumps.append(idx)
                        }
                    }
                }
            }
        }

        for idx: ClosedRange<Int>.Element in range {
            if !self.played[idx] {
                if rifDitch {
                    if self.deck[idx] == 24 {
                        self.playable[idx] = true
                    }
                } else if !ditchableKs.isEmpty {
                    if ditchableKs.contains(idx) {
                        self.playable[idx] = true
                    }
                } else if !ditchableJs.isEmpty {
                    if ditchableJs.contains(idx) {
                        self.playable[idx] = true
                    }
                } else if !ditchableQs.isEmpty {
                    if ditchableQs.contains(idx) {
                        self.playable[idx] = true
                    }
                } else if !ditchableCups.isEmpty {
                    if ditchableCups.contains(idx) {
                        self.playable[idx] = true
                    }
                } else if !trumps.isEmpty {
                    if trumps.contains(idx) {
                        self.playable[idx] = true
                    }
                } else if self.turn == 0 {
                    if self.type == 2 || self.type == 5 {
                        if self.kupaDustu {
                            self.playable[idx] = true
                        } else if self.deck[idx] / 13 != 1 {
                            self.playable[idx] = true
                        }
                    } else {
                        self.playable[idx] = true
                    }
                } else if hasSuit {
                    if self.deck[idx] / 13 == self.suit {
                        self.playable[idx] = true
                    }
                } else {
                    self.playable[idx] = true
                }
            }
        }

        var playableIndices: [Int] = []
        for idx: ClosedRange<Int>.Element in range {
            if self.playable[idx] {
                playableIndices.append(idx)
            }
        }

        /* MOVE FROM PLAYER */
        let move: Int = playableIndices.randomElement()!
        /* ---------------- */

        self.played[move] = true
        self.middle[move] = true
        if self.turn == 0 { self.suit = move % 13 }
        if move % 13 == 1 { self.kupaDustu = true }

        self.playable = Array(repeating: false, count: 52)
        self.turn = (self.turn + 1) % 4
    }
}
var a: [Int] = [5]
a[0] = a[0] + 5
a[0] += 10
print(a)
