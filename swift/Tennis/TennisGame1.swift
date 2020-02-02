import Foundation

class TennisGame1: TennisGame {
    private var player1: Player
    private var player2: Player
    
    required init(player1: String, player2: String) {
        self.player1 = Player(name: player1)
        self.player2 = Player(name: player2)
    }
    
    func wonPoint(_ playerName: String) {
        if player1.name == playerName {
            player1.score += 1
        } else {
            player2.score += 1
        }
    }
    
    var score: String? {
        
        guard !GameState.isRunning(player1, player2) else {
            return GameState.running(player1, player2).score
        }

        guard !GameState.isInDeuce(player1, player2) else {
            return GameState.inDeuce(player1, player2).score
        }
        
        return GameState.end(player1, player2).score
    }
}

extension TennisGame1 {
    struct Player {
        let name: String
        var score: Int
        
        init(name: String) {
            self.name = name
            self.score = 0
        }
    }
    
    enum GameState {
        case running(_ player1: Player, _ player2: Player)
        case inDeuce(_ player1: Player, _ player2: Player)
        case end(_ player1: Player, _ player2: Player)
        
        var score: String {
            switch self {
                
            case .running(let player1, let player2) where GameState.isAll(player1, player2) && 0...2 ~= player1.score:
                return "\(TennisScore(player1.score).rawValue)-All"

            case .running(let player1, let player2) where GameState.isAll(player1, player2):
                return "Deuce"
                
            case .running(let player1, let player2):
                return TennisScore(player1.score).rawValue + "-" + TennisScore(player2.score).rawValue
                
            case .inDeuce(let player1, let player2) where GameState.isAll(player1, player2):
                return "Deuce"
                
            case .inDeuce(let player1, let player2):
                let advantagePlayer = player1.score > player2.score ? player1 : player2
                return "Advantage \(advantagePlayer.name)"
                
            case .end(let player1, let player2):
                let winner = player1.score > player2.score ? player1 : player2
                return "Win for \(winner.name)"
            }
        }
                        
        static func isAll(_ player1: Player, _ player2: Player) -> Bool {
            player1.score == player2.score
        }
        
        static func isRunning(_ player1: Player, _ player2: Player) -> Bool {
            !(player1.score >= 4 || player2.score >= 4)
        }
        
        static func isInDeuce(_ player1: Player, _ player2: Player) -> Bool {
            return abs(player1.score - player2.score) < 2
        }
    }
    
    enum TennisScore: String {
        case Love
        case Fifteen
        case Thirty
        case Forty
        
        init(_ score: Int) {
            switch score {
            case 0: self = .Love
            case 1: self = .Fifteen
            case 2: self = .Thirty
            case 3: self = .Forty
            default: fatalError()
            }
        }
    }
}
