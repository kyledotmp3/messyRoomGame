import Foundation

// MARK: - Item State

/// Possible states an item can be in.
/// Determines which sprite to show and which actions are available.
enum ItemState: String, Codable, CaseIterable {
    case clean          // Normal, good condition
    case dirty          // Needs quick cleaning
    case veryDirty      // Needs deep cleaning
    case broken         // Needs fixing or replacing
    case disorganized   // Needs organizing
    case scattered      // Spread out, needs organizing
    case tangled        // Cables etc, needs organizing
    case overflowing    // Container too full
    case crooked        // Just needs straightening
    case dead           // Plant is dead, remove or replace
    case dusty          // Light dust, easy clean
    case empty          // Container/trash empty

    /// Human-readable description
    var displayName: String {
        switch self {
        case .clean: return "Clean"
        case .dirty: return "Dirty"
        case .veryDirty: return "Very Dirty"
        case .broken: return "Broken"
        case .disorganized: return "Disorganized"
        case .scattered: return "Scattered"
        case .tangled: return "Tangled"
        case .overflowing: return "Overflowing"
        case .crooked: return "Crooked"
        case .dead: return "Dead"
        case .dusty: return "Dusty"
        case .empty: return "Empty"
        }
    }

    /// Which interaction types can address this state
    var applicableActions: [InteractionType] {
        switch self {
        case .clean:
            return [.move] // Already clean, can only move
        case .dirty, .dusty, .crooked:
            return [.clean, .move]
        case .veryDirty:
            return [.clean, .deepClean, .move]
        case .broken:
            return [.fix, .replace, .remove]
        case .disorganized, .scattered, .tangled, .overflowing:
            return [.organize, .move]
        case .dead:
            return [.remove, .replace]
        case .empty:
            return [.remove] // Just trash
        }
    }
}

// MARK: - Room Item Position

/// Position of an item in the room (normalized 0-1 coordinates)
struct ItemPosition: Codable {
    /// X position (0 = left, 1 = right)
    var x: Double

    /// Y position (0 = bottom, 1 = top)
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

// MARK: - Room Item

/// An interactive item in a boyfriend's room.
/// Items can be cleaned, fixed, moved, organized, or removed.
///
/// # Example
/// ```swift
/// let console = RoomItem(
///     id: "gaming_console",
///     name: "Gaming Console",
///     category: .gaming,
///     state: .dirty,
///     position: ItemPosition(x: 0.7, y: 0.4),
///     availableActions: [.clean],
///     isSentimental: false
/// )
/// ```
struct RoomItem: Codable, Identifiable {

    // MARK: - Core Properties

    /// Unique identifier (e.g., "gaming_console")
    let id: String

    /// Display name (e.g., "Gaming Console")
    let name: String

    /// Category for trait matching
    let category: ItemCategory

    /// Current state of the item
    var state: ItemState

    /// Position in the room
    var position: ItemPosition

    // MARK: - Interaction Properties

    /// Actions that can be performed on this item
    let availableActions: [InteractionType]

    /// Whether this item can be moved
    var isMoveable: Bool

    /// Whether this item can be removed/thrown away
    var isRemoveable: Bool

    // MARK: - Sentimental Properties

    /// Whether this item is connected to a hidden sentimental trait
    let isSentimental: Bool

    /// Which trait type this triggers if sentimental
    let sentimentalTraitType: TraitType?

    /// Text shown when discovering the sentimental value
    let discoveryText: String?

    // MARK: - Sprite Properties

    /// Base sprite name (state suffix added automatically)
    let baseSpriteName: String

    // MARK: - Interaction Data

    /// Specific effects for each available action
    var interactions: [Interaction]

    // MARK: - Computed Properties

    /// Full sprite name including state (e.g., "gaming_console_dirty")
    var spriteName: String {
        return "\(baseSpriteName)_\(state.rawValue)"
    }

    /// Whether this item is in a "bad" state that should be addressed
    var needsAttention: Bool {
        switch state {
        case .clean:
            return false
        default:
            return true
        }
    }

    /// Whether removing this item would trigger a discovery
    var wouldTriggerDiscovery: Bool {
        return isSentimental && sentimentalTraitType != nil
    }

    // MARK: - Initialization

    init(
        id: String,
        name: String,
        category: ItemCategory,
        state: ItemState,
        position: ItemPosition,
        availableActions: [InteractionType],
        isMoveable: Bool = true,
        isRemoveable: Bool = true,
        isSentimental: Bool = false,
        sentimentalTraitType: TraitType? = nil,
        discoveryText: String? = nil,
        baseSpriteName: String? = nil,
        interactions: [Interaction] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.state = state
        self.position = position
        self.availableActions = availableActions
        self.isMoveable = isMoveable
        self.isRemoveable = isRemoveable
        self.isSentimental = isSentimental
        self.sentimentalTraitType = sentimentalTraitType
        self.discoveryText = discoveryText
        self.baseSpriteName = baseSpriteName ?? id
        self.interactions = interactions
    }

    // MARK: - Methods

    /// Get a specific interaction by type
    func interaction(ofType type: InteractionType) -> Interaction? {
        return interactions.first { $0.type == type }
    }

    /// Check if an action is available for this item
    func canPerform(_ action: InteractionType) -> Bool {
        // Must be in available actions list
        guard availableActions.contains(action) else { return false }

        // State must support this action
        guard state.applicableActions.contains(action) else { return false }

        // Special checks
        if action == .move && !isMoveable { return false }
        if action == .remove && !isRemoveable { return false }

        return true
    }

    /// Apply a state change after an interaction
    mutating func applyState(_ newState: ItemState) {
        self.state = newState
    }

    /// Move to a new position
    mutating func moveTo(_ newPosition: ItemPosition) {
        self.position = newPosition
    }
}

// MARK: - Room

/// A complete room layout containing all items
struct Room: Codable, Identifiable {

    /// Room identifier (e.g., "gary_room")
    let id: String

    /// Background sprite name
    let backgroundSprite: String

    /// Starting budget for this room
    let startingBudget: Int

    /// Starting time in minutes
    let startingTimeMinutes: Int

    /// All items in the room
    var items: [RoomItem]

    // MARK: - Computed

    /// Items that need attention (not clean)
    var itemsNeedingAttention: [RoomItem] {
        return items.filter { $0.needsAttention }
    }

    /// Total number of items
    var itemCount: Int {
        return items.count
    }

    // MARK: - Methods

    /// Get an item by ID
    func item(withId id: String) -> RoomItem? {
        return items.first { $0.id == id }
    }

    /// Get index of item by ID
    func itemIndex(withId id: String) -> Int? {
        return items.firstIndex { $0.id == id }
    }

    /// Update an item in place
    mutating func updateItem(_ item: RoomItem) {
        if let index = itemIndex(withId: item.id) {
            items[index] = item
        }
    }

    /// Remove an item from the room
    mutating func removeItem(withId id: String) {
        items.removeAll { $0.id == id }
    }
}
