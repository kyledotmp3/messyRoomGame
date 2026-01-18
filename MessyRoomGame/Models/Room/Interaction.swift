import Foundation

// MARK: - Interaction Type

/// All possible actions the player can perform on room items.
/// Each action has different costs, time requirements, and effects.
enum InteractionType: String, Codable, CaseIterable {

    /// Quick surface cleaning (dusting, wiping)
    /// - Cost: $0-5
    /// - Time: 5-10 minutes
    /// - Satisfaction: +3 to +8
    /// - Difference: +1 to +3
    case clean

    /// Thorough deep cleaning (scrubbing, shampooing)
    /// - Cost: $10-20
    /// - Time: 20-45 minutes
    /// - Satisfaction: +8 to +15
    /// - Difference: +5 to +8
    case deepClean = "deep_clean"

    /// Repair a broken item
    /// - Cost: $15-40
    /// - Time: 30-60 minutes
    /// - Satisfaction: +10 to +20
    /// - Difference: +10 to +15
    case fix

    /// Replace item with a new one
    /// - Cost: $30-100+
    /// - Time: 10-15 minutes
    /// - Satisfaction: +5 to +25 (risky if attached)
    /// - Difference: +20 to +30
    case replace

    /// Throw item away
    /// - Cost: $0
    /// - Time: 2-5 minutes
    /// - Satisfaction: -10 to +10 (very risky)
    /// - Difference: +15 to +25
    case remove

    /// Move item to different position
    /// - Cost: $0
    /// - Time: 5-10 minutes
    /// - Satisfaction: -5 to +5
    /// - Difference: +5 to +10
    case move

    /// Tidy up and arrange item
    /// - Cost: $0-10
    /// - Time: 15-30 minutes
    /// - Satisfaction: +5 to +12
    /// - Difference: +5 to +8
    case organize

    // MARK: - Display Properties

    /// Human-readable name for UI
    var displayName: String {
        switch self {
        case .clean: return "Quick Clean"
        case .deepClean: return "Deep Clean"
        case .fix: return "Fix"
        case .replace: return "Replace"
        case .remove: return "Remove"
        case .move: return "Move"
        case .organize: return "Organize"
        }
    }

    /// Icon name for UI (SF Symbol or custom asset)
    var iconName: String {
        switch self {
        case .clean: return "sparkles"
        case .deepClean: return "bubbles.and.sparkles"
        case .fix: return "wrench.and.screwdriver"
        case .replace: return "arrow.triangle.2.circlepath"
        case .remove: return "trash"
        case .move: return "arrow.up.and.down.and.arrow.left.and.right"
        case .organize: return "square.stack.3d.up"
        }
    }

    /// Short description for UI
    var description: String {
        switch self {
        case .clean: return "Wipe down and dust"
        case .deepClean: return "Thorough scrubbing"
        case .fix: return "Repair what's broken"
        case .replace: return "Swap for something new"
        case .remove: return "Throw it away"
        case .move: return "Change its position"
        case .organize: return "Tidy and arrange"
        }
    }

    /// Whether this action is considered "risky" (might upset him)
    var isRisky: Bool {
        switch self {
        case .remove, .replace: return true
        default: return false
        }
    }
}

// MARK: - Interaction

/// A specific interaction available on a room item, with costs and effects.
struct Interaction: Codable, Identifiable {

    var id: String { "\(itemId)_\(type.rawValue)" }

    /// ID of the item this interaction belongs to
    let itemId: String

    /// Type of action
    let type: InteractionType

    /// Money cost in dollars
    let cost: Int

    /// Time cost in game minutes
    let timeMinutes: Int

    /// Base satisfaction change (before trait modifiers)
    let baseSatisfaction: Double

    /// Base difference points added
    let baseDifference: Double

    /// Optional: New state the item transitions to after this action
    let resultingState: ItemState?

    /// Optional: Custom description for this specific interaction
    let customDescription: String?

    // MARK: - Computed Properties

    /// Formatted cost string (e.g., "$15" or "Free")
    var costDisplay: String {
        return cost > 0 ? "$\(cost)" : "Free"
    }

    /// Formatted time string (e.g., "10 min" or "45 min")
    var timeDisplay: String {
        return "\(timeMinutes) min"
    }

    /// Formatted satisfaction preview (e.g., "+5" or "-3")
    var satisfactionPreview: String {
        let sign = baseSatisfaction >= 0 ? "+" : ""
        return "\(sign)\(Int(baseSatisfaction))"
    }

    /// Formatted difference preview
    var differencePreview: String {
        return "+\(Int(baseDifference))"
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case itemId
        case type
        case cost
        case timeMinutes
        case baseSatisfaction
        case baseDifference
        case resultingState
        case customDescription
    }

    // MARK: - Initialization

    init(
        itemId: String,
        type: InteractionType,
        cost: Int,
        timeMinutes: Int,
        baseSatisfaction: Double,
        baseDifference: Double,
        resultingState: ItemState? = nil,
        customDescription: String? = nil
    ) {
        self.itemId = itemId
        self.type = type
        self.cost = cost
        self.timeMinutes = timeMinutes
        self.baseSatisfaction = baseSatisfaction
        self.baseDifference = baseDifference
        self.resultingState = resultingState
        self.customDescription = customDescription
    }
}

// MARK: - Interaction Result

/// The result of performing an interaction
struct InteractionResult {

    /// The interaction that was performed
    let interaction: Interaction

    /// Actual satisfaction change (after trait modifiers)
    let satisfactionChange: Double

    /// Actual difference change
    let differenceChange: Double

    /// Whether a hidden trait was discovered
    let traitDiscovered: Trait?

    /// Whether the action was cancelled (e.g., discovery prevented removal)
    let wasCancelled: Bool

    /// New state of the item (if changed)
    let newItemState: ItemState?

    // MARK: - Computed

    /// Whether this was a positive result overall
    var isPositive: Bool {
        return satisfactionChange > 0 && !wasCancelled
    }

    /// Summary message for this result
    var summaryMessage: String {
        if wasCancelled {
            return "You stopped yourself..."
        }
        if let trait = traitDiscovered {
            return "You discovered something about \(trait.type.rawValue)!"
        }
        if satisfactionChange > 0 {
            return "Nice! That helped."
        } else if satisfactionChange < 0 {
            return "Hmm, maybe that wasn't the best choice."
        } else {
            return "Done."
        }
    }
}
