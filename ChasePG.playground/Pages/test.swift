import Cocoa

class kingGameState {
    let deck: [Int] = Array(0...51).shuffled()
    var played: [Bool] = Array(repeating: false, count: 52)
    var playable: [Bool] = Array(repeating: false, count: 52)
    var middle: [Bool] = Array(repeating: false, count: 52)
    var banks: [Int] = Array(repeating: -1, count: 52)
    let pIdx: [Int] = [0, 13, 26, 39, 52]
    let erkekIdx: [Int] = [10, 12, 23, 25, 36, 38, 49, 51]
    let kizIdx: [Int] = [11, 24, 37, 50]
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
        // Pre Action
        var hasSuit: Bool = false
        var midMax: Int = -1
        if self.turn != 0 {
            for idx: ClosedRange<Int>.Element in range {
                if self.deck[idx] / 13 == self.suit && !self.played[idx] {
                    hasSuit = true
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

        if self.type == 0 || self.type == 1 {  // El Almaz & Son Iki Almaz
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.turn == 0 || !hasSuit {
                        self.playable[idx] = true
                    } else {
                        if self.deck[idx] / 13 == self.suit {
                            self.playable[idx] = true
                        }
                    }
                }
            }
        } else if self.type == 2 {  // Kupa Almaz
            var hasKupa: Bool = false
            var onlyKupa: Bool = true
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.deck[idx] / 13 == 1 {
                        hasKupa = true
                    } else {
                        onlyKupa = false
                    }
                }
            }

            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.turn == 0 || !hasSuit {
                        if self.kupaDustu || onlyKupa {
                            self.playable[idx] = true
                        } else {
                            if self.deck[idx] / 13 != 1 {
                                self.playable[idx] = true
                            }
                        }
                    } else {
                        if self.deck[idx] / 13 == self.suit {
                            self.playable[idx] = true
                        }
                    }
                }
            }

        } else if self.type == 3 || self.type == 4{  // Erkek Almaz Kiz Almaz
            let ditchableRange: [Int] = self.type == 3 ? self.erkekIdx: self.kizIdx
            var hasDitchable: Bool = false
            var ditchableIdx: Int = -1
            var ditchable: Int = -1
            for idx: ClosedRange<Int>.Element in range {
                if !self.played[idx] {
                    if self.turn == 0 {
                        self.playable[idx] = true
                    } else if hasSuit {
                        if self.deck[idx] / 13 == self.suit {
                            for idxx: Int in ditchableRange {
                                if idx == idxx && self.deck[idx] % 13 > midMax {
                                    hasDitchable = true
                                    if self.deck[idx] % 13 > ditchable {
                                        ditchableIdx = idx
                                        ditchable = self.deck[idx] % 13
                                    }
                                }
                            }

                            if hasDitchable {
                                for idxx: ClosedRange<Int>.Element in range {
                                    self.playable[idxx] = false
                                }
                                self.playable[ditchableIdx] = true
                                break
                            } else {
                                self.playable[idx] = true
                            }
                        }
                    } else {
                        for idxx: Int in ditchableRange {
                            if idx == idxx && self.deck[idx] % 13 > midMax {
                                hasDitchable = true
                                if self.deck[idx] % 13 > ditchable {
                                    ditchableIdx = idx
                                    ditchable = self.deck[idx] % 13
                                }
                            }
                        }

                        if hasDitchable {
                            for idxx: ClosedRange<Int>.Element in range {
                                self.playable[idxx] = false
                            }
                            self.playable[ditchableIdx] = true
                            break
                        } else {
                            self.playable[idx] = true
                        }
                    }
                }
            }

        } else if self.type == 5 {

        } else if self.type == 6 || self.type == 7 || self.type == 8 || self.type == 9 {
            var koz: Int = self.type - 6

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
