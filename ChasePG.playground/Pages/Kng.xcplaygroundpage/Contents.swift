import Cocoa

class kingGameState {
    let deck: [Int] = Array(0...52).shuffled()
    var hands: [String: [Int]] = ["p1":[], "p2":[], "p3":[], "p4":[]]
    var banks: [String: [Int]] = ["p1":[], "p2":[], "p3":[], "p4":[]]
    var mid: [Int] = []
    var type: gameType
    var (turn, round) = (0, 0)

    //Find who has a card
    func whoHas(card:Int) -> String {
        for i in self.hands.keys {
            if self.hands.values[i].contains(card) {
                let who = i
            }
        }

        return who
    }

    init(typeOfGame: gameType) {
        //Set game type
        type = typeOfGame
        //Deal hands
        for i in 0...3 {
            var key = Array(hands.Keys)[i]
            for j in 0...12 {
                hands[key].append(deck[i * 13 + j])
            }
            hands[key] = hands[key].sorted()
        }
    }

    func incTurn() {
        self.turn = self.turn + 1 % 4
    }

    func doRound() {
        let suit: Int
        switch self.type {
            case .KozMaca:
                suit = 0
            case .KozKupa:
                suit = 1
            case .KozSinek:
                suit = 2
            case .KozKaro:
                suit = 3
            default:
                suit = -1
        }
        for player in hands.Keys {
            var playableCards: [Int] = []
            for j in hands[player] {
                if hands[player][j] % suit == 0 {
                    playableCards.append(hands[player][j])
                }
            }
            incTurn()
        }

    }
}

let state = kingGameState()
print(41 / 13)
