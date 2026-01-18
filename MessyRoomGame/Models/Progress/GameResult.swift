import Foundation

// MARK: - Relationship Outcome

/// The narrative outcome of the cleaning session
enum RelationshipOutcome: String, Codable {
    case tooDifferent   // Difference exceeded tolerance
    case notEnough      // Satisfaction < 50
    case okay           // Satisfaction 50-64
    case good           // Satisfaction 65-79
    case great          // Satisfaction 80+

    var displayName: String {
        switch self {
        case .tooDifferent: return "Too Different"
        case .notEnough: return "Not Enough"
        case .okay: return "Okay"
        case .good: return "Good"
        case .great: return "Great"
        }
    }

    var emoji: String {
        switch self {
        case .tooDifferent, .notEnough: return "💔"
        case .okay: return "⭐"
        case .good: return "⭐⭐"
        case .great: return "⭐⭐⭐"
        }
    }

    var isPositive: Bool {
        switch self {
        case .okay, .good, .great: return true
        case .tooDifferent, .notEnough: return false
        }
    }

    /// Narrative text shown to player (from GAME_DESIGN.md)
    func narrativeText(manName: String) -> String {
        switch self {
        case .tooDifferent:
            return """
            \(manName) walks in and stops at the door. He looks around slowly.
            "It's... different." He's quiet. "Really different."
            He doesn't seem angry, just... lost. This doesn't feel like his space anymore.

            You wanted to help, but maybe you went too far.
            """

        case .notEnough:
            return """
            \(manName) walks in and glances around.
            "Oh, you were here?" He doesn't seem to notice anything changed.
            You put in the work, but it didn't make an impact.

            Maybe next time, focus on the things that matter more.
            """

        case .okay:
            return """
            \(manName) walks in and does a small double-take.
            "Hey, did you clean a little? That's nice." He smiles.
            It's not a transformation, but he appreciates the gesture.

            A good start. You're learning what he likes.
            """

        case .good:
            return """
            \(manName) walks in and his eyes light up.
            "Whoa! This looks great!" He gives you a hug.
            "Seriously, I can actually see my desk now."

            You found the balance. He feels helped, not judged.
            """

        case .great:
            return """
            \(manName) walks in and stops, amazed.
            "This is... incredible. It's still MY room but... better?"
            He's genuinely touched. "You really get me."

            Perfect balance. He feels loved and understood.
            """
        }
    }
}

// MARK: - Game Result

/// Final result of a completed game session
struct GameResult: Codable {

    // MARK: - Identification

    let manId: String
    let sessionId: String

    // MARK: - Final Metrics

    let finalSatisfaction: Double
    let finalDifference: Double
    let tolerance: Double

    // MARK: - Resource Usage

    let budgetSpent: Int
    let timeUsed: Int
    let actionsPerformed: Int

    // MARK: - Outcome

    let outcome: RelationshipOutcome
    let starRating: Int  // 0-3 stars

    // MARK: - Metadata

    let completedDate: Date

    // MARK: - Computed Properties

    /// Whether this was a passing result
    var isPassed: Bool {
        return outcome.isPositive
    }

    /// Whether difference was within tolerance
    var wasWithinTolerance: Bool {
        return finalDifference <= tolerance
    }

    /// Satisfaction level achieved
    var satisfactionLevel: SatisfactionLevel {
        switch finalSatisfaction {
        case 0..<50: return .notEnough
        case 50..<65: return .okay
        case 65..<80: return .good
        default: return .great
        }
    }

    // MARK: - Static Calculation Methods

    /// Calculate the outcome based on final metrics
    static func calculateOutcome(
        satisfaction: Double,
        difference: Double,
        tolerance: Double
    ) -> RelationshipOutcome {
        // Check tolerance first - this overrides satisfaction
        if difference > tolerance {
            return .tooDifferent
        }

        // Then check satisfaction thresholds
        switch satisfaction {
        case 0..<50:
            return .notEnough
        case 50..<65:
            return .okay
        case 65..<80:
            return .good
        default:
            return .great
        }
    }

    /// Calculate star rating (0-3 stars)
    static func calculateStars(
        satisfaction: Double,
        difference: Double,
        tolerance: Double
    ) -> Int {
        // No stars if failed
        if difference > tolerance || satisfaction < 50 {
            return 0
        }

        // Star thresholds
        if satisfaction >= 80 {
            return 3
        } else if satisfaction >= 65 {
            return 2
        } else {
            return 1
        }
    }
}

// MARK: - Player Progress

/// Long-term player progress across all sessions
struct PlayerProgress: Codable {

    // MARK: - Unlocks

    /// Men that have been unlocked
    var unlockedMenIds: Set<String>

    // MARK: - Best Results

    /// Best result achieved for each man
    var bestResults: [String: BestResult]

    // MARK: - Statistics

    /// Total cleaning sessions completed
    var totalSessionsCompleted: Int

    /// Total stars earned across all best results
    var totalStarsEarned: Int

    // MARK: - Settings

    var musicVolume: Float
    var sfxVolume: Float
    var showTutorialHints: Bool

    // MARK: - Metadata

    let firstPlayDate: Date
    var lastPlayDate: Date

    // MARK: - Initialization

    init() {
        self.unlockedMenIds = ["gamer_gary"] // Gary unlocked by default
        self.bestResults = [:]
        self.totalSessionsCompleted = 0
        self.totalStarsEarned = 0
        self.musicVolume = 0.7
        self.sfxVolume = 1.0
        self.showTutorialHints = true
        self.firstPlayDate = Date()
        self.lastPlayDate = Date()
    }

    // MARK: - Methods

    /// Record a completed session
    mutating func recordCompletion(result: GameResult) {
        totalSessionsCompleted += 1
        lastPlayDate = Date()

        // Update best result if better
        if let existing = bestResults[result.manId] {
            if result.starRating > existing.starRating ||
               (result.starRating == existing.starRating &&
                result.finalSatisfaction > existing.satisfaction) {
                // New best!
                let starsGained = result.starRating - existing.starRating
                totalStarsEarned += starsGained
                bestResults[result.manId] = BestResult(from: result)
            }
        } else {
            // First completion for this man
            bestResults[result.manId] = BestResult(from: result)
            totalStarsEarned += result.starRating
        }

        // Check for unlocks
        checkUnlocks()
    }

    /// Check if new characters should be unlocked
    private mutating func checkUnlocks() {
        // Example unlock progression (can be customized)
        if totalStarsEarned >= 3 {
            unlockedMenIds.insert("sports_brad")
        }
        if totalStarsEarned >= 8 {
            unlockedMenIds.insert("artist_alex")
        }
        if totalStarsEarned >= 15 {
            unlockedMenIds.insert("minimalist_mike")
        }
    }

    /// Check if a man is unlocked
    func isUnlocked(_ manId: String) -> Bool {
        return unlockedMenIds.contains(manId)
    }

    /// Get best result for a man
    func bestResult(for manId: String) -> BestResult? {
        return bestResults[manId]
    }
}

// MARK: - Best Result

/// Best result achieved for a specific man
struct BestResult: Codable {
    let manId: String
    let starRating: Int
    let satisfaction: Double
    let outcome: RelationshipOutcome
    let achievedDate: Date

    init(from result: GameResult) {
        self.manId = result.manId
        self.starRating = result.starRating
        self.satisfaction = result.finalSatisfaction
        self.outcome = result.outcome
        self.achievedDate = result.completedDate
    }
}
