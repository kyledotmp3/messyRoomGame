import Foundation

// MARK: - Satisfaction Meter

/// Tracks how happy the boyfriend will be with the changes to his room.
/// Range: 0-100
/// - 0-49: He's not happy
/// - 50-64: Okay, passable
/// - 65-79: Good, he's pleased
/// - 80-100: Great, he loves it
///
/// This meter can go UP or DOWN based on actions.
/// Most actions that improve the room raise satisfaction.
/// Actions that touch sentimental items or conflict with traits lower it.
final class SatisfactionMeter: ObservableObject {

    // MARK: - Properties

    /// Current satisfaction value (0-100)
    @Published private(set) var value: Double

    /// Starting value (typically 50 - neutral)
    let startingValue: Double

    /// Minimum allowed value
    let minValue: Double = 0

    /// Maximum allowed value
    let maxValue: Double = 100

    // MARK: - Computed Properties

    /// Current value as percentage (0.0 to 1.0)
    var percentage: Double {
        return value / maxValue
    }

    /// Current satisfaction level category
    var level: SatisfactionLevel {
        switch value {
        case 0..<50:
            return .notEnough
        case 50..<65:
            return .okay
        case 65..<80:
            return .good
        case 80...100:
            return .great
        default:
            return .notEnough
        }
    }

    /// How much satisfaction has changed from start
    var changeFromStart: Double {
        return value - startingValue
    }

    /// Whether satisfaction has improved from start
    var hasImproved: Bool {
        return value > startingValue
    }

    // MARK: - Initialization

    init(startingValue: Double = 50) {
        self.startingValue = startingValue
        self.value = startingValue
    }

    // MARK: - Methods

    /// Add satisfaction points (can be negative)
    /// - Parameter amount: Points to add (use negative to subtract)
    /// - Returns: Actual amount added after clamping
    @discardableResult
    func add(_ amount: Double) -> Double {
        let oldValue = value
        value = min(maxValue, max(minValue, value + amount))
        return value - oldValue
    }

    /// Set satisfaction to a specific value
    func set(_ newValue: Double) {
        value = min(maxValue, max(minValue, newValue))
    }

    /// Reset to starting value
    func reset() {
        value = startingValue
    }

    /// Check if meets minimum threshold for passing result
    func meetsThreshold(_ threshold: Double) -> Bool {
        return value >= threshold
    }
}

// MARK: - Satisfaction Level

/// Categorical satisfaction levels
enum SatisfactionLevel {
    case notEnough  // < 50
    case okay       // 50-64
    case good       // 65-79
    case great      // 80+

    var displayName: String {
        switch self {
        case .notEnough: return "Not Enough"
        case .okay: return "Okay"
        case .good: return "Good"
        case .great: return "Great"
        }
    }

    var emoji: String {
        switch self {
        case .notEnough: return "😕"
        case .okay: return "🙂"
        case .good: return "😊"
        case .great: return "🤩"
        }
    }
}
