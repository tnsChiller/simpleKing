import Cocoa

class kingGameState {
    let deck: [Int] = Array(0...51).shuffled()
    var played: [Bool] = Array(repeating: false, count: 52)
    var playable: [Bool] = Array(repeating: false, count: 52)
    var middle: [Bool] = Array(repeating: false, count: 52)
    var banks: [Int] = Array(repeating: -1, count: 52)
    let pIdx: [Int] = [0, 13, 26, 39, 52]
    let erkekIdx: [Int] = [10, 12, 23, 25, 36, 38, 49, 51]
    var (turn, round, gameNo): (Int, Int, Int) = (0, 0, 0)
    var (suit, type, start): (Int, Int, Int) = (-1, -1, -1)
    var kupaDustu: Bool = false

    func whoHas(card: Int) -> Int {
        var who: Int = -1
        for idx in 0...51 {
            if card == self.deck[idx] { who = idx / 13 }
        }

        return who
    }

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

    func step() {
        let anchor: Int = (start + turn) % 4
        let range: ClosedRange<Int> = self.pIdx[anchor]...pIdx[anchor + 1] - 1

        var hasSuit: Bool = false
        if self.turn != 0 {
            for idx: ClosedRange<Int>.Element in range {
                if self.deck[idx] / 13 == self.suit && !self.played[idx] {
                    hasSuit = true
                }
            }
        }

        var hasKupa = false
        var onlyKupa: Bool = true
        var maxKupa: Int = 0
        if self.type == 1 {
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.deck[idx] / 13 == 1 {
                        hasKupa = true
                        if self.deck[idx] % 13 > maxKupa {
                            maxKupa = self.deck[idx] % 13
                        }
                    } else {
                        onlyKupa = false
                    }
                }
            }
        }

        var hasErkek: Bool = false
        if self.type == 2 {
            for idx: ClosedRange<Int>.Element in range {
                for idxx: Int in erkekIdx {
                    if idx == idxx {
                        hasErkek = true
                        }
                    }
                }
            }

        var midMax: Int = -1
        for idx: Int in 0...51 {
            if self.middle[idx] {
                if self.deck[idx] % 13 > midMax {
                    midMax = self.deck[idx]
                }
            }
        }

        if self.turn == 0 {
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.type == 1 && hasKupa {
                        if onlyKupa {
                            if self.deck[idx] % 13 == maxKupa {
                                self.playable[idx] = true
                            }
                        } else if kupaDustu {
                            self.playable[idx] = true
                        } else {
                            if self.deck[idx] / 13 != 1 {
                                self.playable[idx] = true
                            }
                        }
                    } else {
                        self.playable[idx] = true
                    }
                }
            }
        } else if hasSuit {
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.type == 2 {

                    } else if self.deck[idx] / 13 == self.suit {
                        self.playable[idx] = true
                    }
                }
            }
        } else if self.type == 1 {  // Kupa Almaz
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if hasKupa {
                        if onlyKupa {
                            if self.deck[idx] % 13 == maxKupa {
                                self.playable[idx] = true
                            }
                        } else {
                            if self.deck[idx] / 13 == 1 {
                                self.playable[idx] = true
                            }
                        }
                    } else {
                        self.playable[idx] = true
                    }
                }
            }
        } else {
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] { self.playable[idx] = true }
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
