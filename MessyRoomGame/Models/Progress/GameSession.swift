import Foundation

// MARK: - Game Session

/// Represents a single cleaning session (one playthrough).
/// Tracks all state including meters, time, budget, and action history.
class GameSession: ObservableObject, Codable {

    // MARK: - Identifiers

    let id: String
    let manId: String
    let roomId: String

    // MARK: - Game State

    var man: Man
    var room: Room

    // MARK: - Meters

    @Published var satisfactionMeter: SatisfactionMeter
    @Published var differenceMeter: DifferenceMeter

    // MARK: - Resources

    /// Remaining budget in dollars
    @Published var remainingBudget: Int

    /// Remaining time in game minutes
    @Published var remainingTimeMinutes: Int

    /// Starting budget (for reference)
    let startingBudget: Int

    /// Starting time (for reference)
    let startingTimeMinutes: Int

    // MARK: - History

    /// All interactions performed this session
    var actionHistory: [PerformedAction]

    /// When this session was started
    let startDate: Date

    /// Whether the session has ended
    var hasEnded: Bool

    // MARK: - Computed Properties

    /// Budget spent so far
    var budgetSpent: Int {
        return startingBudget - remainingBudget
    }

    /// Time elapsed in minutes
    var timeElapsed: Int {
        return startingTimeMinutes - remainingTimeMinutes
    }

    /// Number of actions taken
    var actionCount: Int {
        return actionHistory.count
    }

    /// Whether player can afford an action
    func canAfford(_ cost: Int) -> Bool {
        return remainingBudget >= cost
    }

    /// Whether player has enough time for an action
    func hasTime(_ minutes: Int) -> Bool {
        return remainingTimeMinutes >= minutes
    }

    /// Whether player is out of time
    var isOutOfTime: Bool {
        return remainingTimeMinutes <= 0
    }

    /// Whether player is out of money
    var isOutOfMoney: Bool {
        return remainingBudget <= 0
    }

    // MARK: - Initialization

    init(man: Man, room: Room) {
        self.id = UUID().uuidString
        self.manId = man.id
        self.roomId = room.id
        self.man = man
        self.room = room

        // Initialize meters
        self.satisfactionMeter = SatisfactionMeter(startingValue: 50)
        self.differenceMeter = DifferenceMeter(tolerance: man.toleranceForChange)

        // Initialize resources
        self.startingBudget = room.startingBudget
        self.remainingBudget = room.startingBudget
        self.startingTimeMinutes = room.startingTimeMinutes
        self.remainingTimeMinutes = room.startingTimeMinutes

        // Initialize history
        self.actionHistory = []
        self.startDate = Date()
        self.hasEnded = false
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, manId, roomId, man, room
        case satisfactionMeter, differenceMeter
        case remainingBudget, remainingTimeMinutes
        case startingBudget, startingTimeMinutes
        case actionHistory, startDate, hasEnded
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        manId = try container.decode(String.self, forKey: .manId)
        roomId = try container.decode(String.self, forKey: .roomId)
        man = try container.decode(Man.self, forKey: .man)
        room = try container.decode(Room.self, forKey: .room)
        satisfactionMeter = try container.decode(SatisfactionMeter.self, forKey: .satisfactionMeter)
        differenceMeter = try container.decode(DifferenceMeter.self, forKey: .differenceMeter)
        remainingBudget = try container.decode(Int.self, forKey: .remainingBudget)
        remainingTimeMinutes = try container.decode(Int.self, forKey: .remainingTimeMinutes)
        startingBudget = try container.decode(Int.self, forKey: .startingBudget)
        startingTimeMinutes = try container.decode(Int.self, forKey: .startingTimeMinutes)
        actionHistory = try container.decode([PerformedAction].self, forKey: .actionHistory)
        startDate = try container.decode(Date.self, forKey: .startDate)
        hasEnded = try container.decode(Bool.self, forKey: .hasEnded)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(manId, forKey: .manId)
        try container.encode(roomId, forKey: .roomId)
        try container.encode(man, forKey: .man)
        try container.encode(room, forKey: .room)
        try container.encode(satisfactionMeter, forKey: .satisfactionMeter)
        try container.encode(differenceMeter, forKey: .differenceMeter)
        try container.encode(remainingBudget, forKey: .remainingBudget)
        try container.encode(remainingTimeMinutes, forKey: .remainingTimeMinutes)
        try container.encode(startingBudget, forKey: .startingBudget)
        try container.encode(startingTimeMinutes, forKey: .startingTimeMinutes)
        try container.encode(actionHistory, forKey: .actionHistory)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(hasEnded, forKey: .hasEnded)
    }

    // MARK: - Actions

    /// Perform an interaction and update all state
    func performInteraction(_ interaction: Interaction, onItem item: RoomItem) -> InteractionResult {
        // Check if sentimental removal would trigger discovery
        if interaction.type == .remove && item.isSentimental,
           let traitType = item.sentimentalTraitType,
           !man.traits.first(where: { $0.type == traitType })!.isRevealed {

            // Trigger discovery and cancel the action
            man.revealTrait(ofType: traitType)
            let discoveredTrait = man.traits.first { $0.type == traitType }!

            return InteractionResult(
                interaction: interaction,
                satisfactionChange: -15, // Penalty for almost removing something precious
                differenceChange: 0,
                traitDiscovered: discoveredTrait,
                wasCancelled: true,
                newItemState: nil
            )
        }

        // Calculate actual satisfaction change with trait modifiers
        let satisfactionChange = man.calculateSatisfactionModifier(
            forItem: item,
            action: interaction.type,
            baseEffect: interaction.baseSatisfaction
        )

        // Apply changes
        satisfactionMeter.add(satisfactionChange)
        differenceMeter.add(interaction.baseDifference)
        remainingBudget -= interaction.cost
        remainingTimeMinutes -= interaction.timeMinutes

        // Update item state
        var newState: ItemState? = nil
        if let resultingState = interaction.resultingState {
            if var updatedItem = room.item(withId: item.id) {
                updatedItem.applyState(resultingState)
                room.updateItem(updatedItem)
                newState = resultingState
            }
        }

        // Handle removal
        if interaction.type == .remove {
            room.removeItem(withId: item.id)
        }

        // Record action
        let action = PerformedAction(
            interaction: interaction,
            itemId: item.id,
            satisfactionChange: satisfactionChange,
            differenceChange: interaction.baseDifference,
            timestamp: Date()
        )
        actionHistory.append(action)

        return InteractionResult(
            interaction: interaction,
            satisfactionChange: satisfactionChange,
            differenceChange: interaction.baseDifference,
            traitDiscovered: nil,
            wasCancelled: false,
            newItemState: newState
        )
    }

    /// End the session and calculate final result
    func endSession() -> GameResult {
        hasEnded = true

        let outcome = GameResult.calculateOutcome(
            satisfaction: satisfactionMeter.value,
            difference: differenceMeter.value,
            tolerance: differenceMeter.tolerance
        )

        let stars = GameResult.calculateStars(
            satisfaction: satisfactionMeter.value,
            difference: differenceMeter.value,
            tolerance: differenceMeter.tolerance
        )

        return GameResult(
            manId: manId,
            sessionId: id,
            finalSatisfaction: satisfactionMeter.value,
            finalDifference: differenceMeter.value,
            tolerance: differenceMeter.tolerance,
            budgetSpent: budgetSpent,
            timeUsed: timeElapsed,
            actionsPerformed: actionCount,
            outcome: outcome,
            starRating: stars,
            completedDate: Date()
        )
    }
}

// MARK: - Performed Action

/// Record of an action that was performed
struct PerformedAction: Codable {
    let interaction: Interaction
    let itemId: String
    let satisfactionChange: Double
    let differenceChange: Double
    let timestamp: Date
}

// MARK: - Make SatisfactionMeter and DifferenceMeter Codable

extension SatisfactionMeter: Codable {
    enum CodingKeys: String, CodingKey {
        case value, startingValue
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let startingValue = try container.decode(Double.self, forKey: .startingValue)
        let savedValue = try container.decode(Double.self, forKey: .value)

        self.init(startingValue: startingValue)
        self.set(savedValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(startingValue, forKey: .startingValue)
    }
}

extension DifferenceMeter: Codable {
    enum CodingKeys: String, CodingKey {
        case value, tolerance
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tolerance = try container.decode(Double.self, forKey: .tolerance)
        let savedValue = try container.decode(Double.self, forKey: .value)

        self.init(tolerance: tolerance)
        if savedValue > 0 {
            _ = self.add(savedValue)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(tolerance, forKey: .tolerance)
    }
}
