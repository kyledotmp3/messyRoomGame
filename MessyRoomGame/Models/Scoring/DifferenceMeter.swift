import Foundation

// MARK: - Difference Meter

/// Tracks how much the room has changed from its original state.
/// Range: 0-100
///
/// IMPORTANT: This meter ONLY goes UP. Every action increases difference.
/// The boyfriend has a tolerance threshold - if difference exceeds it,
/// the room feels "too different" and you get a bad outcome.
///
/// Different actions add different amounts:
/// - Quick clean: +1 to +3
/// - Deep clean: +5 to +8
/// - Fix: +10 to +15
/// - Replace: +20 to +30 (big change!)
/// - Remove: +15 to +25 (something is gone!)
/// - Move: +5 to +10
/// - Organize: +5 to +8
final class DifferenceMeter: ObservableObject {

    // MARK: - Properties

    /// Current difference value (0-100)
    @Published private(set) var value: Double

    /// The boyfriend's tolerance for change (set per character)
    let tolerance: Double

    /// Minimum value (always starts at 0)
    let minValue: Double = 0

    /// Maximum possible value
    let maxValue: Double = 100

    // MARK: - Computed Properties

    /// Current value as percentage (0.0 to 1.0)
    var percentage: Double {
        return value / maxValue
    }

    /// Percentage of tolerance used (0.0 to 1.0+)
    var tolerancePercentage: Double {
        return value / tolerance
    }

    /// Whether difference has exceeded tolerance
    var hasExceededTolerance: Bool {
        return value > tolerance
    }

    /// How close to tolerance threshold (0.0 = just started, 1.0 = at threshold, >1.0 = over)
    var proximityToTolerance: Double {
        return value / tolerance
    }

    /// Warning level based on proximity to tolerance
    var warningLevel: DifferenceWarningLevel {
        let proximity = proximityToTolerance
        switch proximity {
        case 0..<0.5:
            return .safe
        case 0.5..<0.75:
            return .caution
        case 0.75..<1.0:
            return .warning
        default:
            return .danger
        }
    }

    /// How much "headroom" is left before hitting tolerance
    var remainingTolerance: Double {
        return max(0, tolerance - value)
    }

    // MARK: - Initialization

    init(tolerance: Double) {
        self.tolerance = tolerance
        self.value = 0  // Always starts at 0
    }

    // MARK: - Methods

    /// Add difference points (always positive - meter only goes up!)
    /// - Parameter amount: Points to add (will be clamped to positive)
    /// - Returns: Actual amount added
    @discardableResult
    func add(_ amount: Double) -> Double {
        // Ensure amount is positive (can't reduce difference)
        let positiveAmount = max(0, amount)
        let oldValue = value
        value = min(maxValue, value + positiveAmount)
        return value - oldValue
    }

    /// Reset to zero (only used when starting a new session)
    func reset() {
        value = 0
    }

    /// Check if current difference is within tolerance
    func isWithinTolerance() -> Bool {
        return value <= tolerance
    }

    /// Estimate if an action would exceed tolerance
    func wouldExceedTolerance(adding amount: Double) -> Bool {
        return (value + amount) > tolerance
    }
}

// MARK: - Difference Warning Level

/// Visual warning levels for the difference meter
enum DifferenceWarningLevel {
    case safe       // < 50% of tolerance
    case caution    // 50-75% of tolerance
    case warning    // 75-100% of tolerance
    case danger     // > tolerance (too different!)

    var displayName: String {
        switch self {
        case .safe: return "Looking good"
        case .caution: return "Be careful"
        case .warning: return "Almost too different"
        case .danger: return "TOO DIFFERENT"
        }
    }

    var emoji: String {
        switch self {
        case .safe: return "✅"
        case .caution: return "⚠️"
        case .warning: return "🚨"
        case .danger: return "❌"
        }
    }

    /// Color for UI display
    var colorName: String {
        switch self {
        case .safe: return "green"
        case .caution: return "yellow"
        case .warning: return "orange"
        case .danger: return "red"
        }
    }
}
