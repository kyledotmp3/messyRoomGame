import Foundation

// MARK: - Man (Boyfriend Character)

/// A boyfriend character whose room you're cleaning.
/// Each man has unique traits that affect how your actions impact his satisfaction.
///
/// # Example
/// ```swift
/// let gary = Man(
///     id: "gamer_gary",
///     name: "Gary",
///     nickname: "Gamer Gary",
///     traits: [
///         Trait(type: .needsGamingAccessible, intensity: .high),
///         Trait(type: .appreciatesCleanliness, intensity: .low),
///         Trait(type: .sentimentalJunk, intensity: .medium, isRevealed: false)
///     ],
///     toleranceForChange: 60,
///     backstory: "Gary is a software developer who unwinds with video games...",
///     difficultyRating: 1
/// )
/// ```
struct Man: Codable, Identifiable {

    // MARK: - Properties

    /// Unique identifier (e.g., "gamer_gary")
    let id: String

    /// Display name (e.g., "Gary")
    let name: String

    /// Fun nickname shown in UI (e.g., "Gamer Gary")
    let nickname: String

    /// Character traits that affect satisfaction calculations.
    /// Some may be hidden (isRevealed = false) until discovered.
    var traits: [Trait]

    /// Maximum difference points allowed before "Too Different" outcome.
    /// Higher = more tolerant of change. Range: 0-100.
    let toleranceForChange: Double

    /// Short description shown in level select.
    let backstory: String

    /// Difficulty rating 1-5 (1 = easiest).
    /// Affects starting budget, time, and trait complexity.
    let difficultyRating: Int

    /// Whether this character is unlocked for play
    var isUnlocked: Bool

    // MARK: - Computed Properties

    /// Traits the player currently knows about
    var revealedTraits: [Trait] {
        return traits.filter { $0.isRevealed }
    }

    /// Traits the player hasn't discovered yet
    var hiddenTraits: [Trait] {
        return traits.filter { !$0.isRevealed }
    }

    /// Whether there are still hidden traits to discover
    var hasHiddenTraits: Bool {
        return !hiddenTraits.isEmpty
    }

    // MARK: - Initialization

    init(
        id: String,
        name: String,
        nickname: String,
        traits: [Trait],
        toleranceForChange: Double,
        backstory: String,
        difficultyRating: Int,
        isUnlocked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.traits = traits
        self.toleranceForChange = toleranceForChange
        self.backstory = backstory
        self.difficultyRating = difficultyRating
        self.isUnlocked = isUnlocked
    }

    // MARK: - Trait Methods

    /// Get all traits (revealed or not) that affect a given item category
    func traits(affectingCategory category: ItemCategory) -> [Trait] {
        return traits.filter { $0.affectsCategory(category) }
    }

    /// Get only revealed traits that affect a given item category
    func revealedTraits(affectingCategory category: ItemCategory) -> [Trait] {
        return revealedTraits.filter { $0.affectsCategory(category) }
    }

    /// Check if any hidden trait would be triggered by an item in this category
    func hasHiddenTrait(forCategory category: ItemCategory) -> Bool {
        return hiddenTraits.contains { $0.affectsCategory(category) }
    }

    /// Reveal a hidden trait by type. Returns true if trait was found and revealed.
    @discardableResult
    mutating func revealTrait(ofType type: TraitType) -> Bool {
        guard let index = traits.firstIndex(where: { $0.type == type && !$0.isRevealed }) else {
            return false
        }
        traits[index].reveal()
        return true
    }

    // MARK: - Satisfaction Calculation

    /// Calculate satisfaction modifier for an action on an item.
    ///
    /// This considers all relevant traits and their intensities:
    /// - Positive traits give bonuses for good actions
    /// - Negative traits give penalties
    /// - Attachment traits give big penalties for removal
    ///
    /// - Parameters:
    ///   - item: The item being acted upon
    ///   - action: The action being performed
    ///   - baseEffect: The base satisfaction effect of this action
    /// - Returns: Modified satisfaction change (can be negative)
    func calculateSatisfactionModifier(
        forItem item: RoomItem,
        action: InteractionType,
        baseEffect: Double
    ) -> Double {
        var totalModifier: Double = 0

        // Get all traits that care about this item's category
        let relevantTraits = traits(affectingCategory: item.category)

        for trait in relevantTraits {
            let modifier = calculateTraitModifier(trait: trait, action: action, item: item)
            totalModifier += modifier * trait.intensity.multiplier
        }

        return baseEffect + totalModifier
    }

    /// Calculate modifier for a single trait based on action type
    private func calculateTraitModifier(
        trait: Trait,
        action: InteractionType,
        item: RoomItem
    ) -> Double {
        switch trait.type.traitCategory {
        case .positive:
            // Positive traits give bonuses for cleaning/organizing/fixing
            switch action {
            case .clean, .deepClean, .fix, .organize:
                return 5.0  // Bonus
            case .replace:
                return 2.0  // Small bonus (he appreciates improvement)
            case .remove, .move:
                return 0.0  // Neutral
            }

        case .negative:
            // Negative traits give penalties for changes
            switch action {
            case .remove, .replace:
                return -8.0  // Big penalty
            case .move, .organize:
                return -3.0  // Medium penalty
            case .clean, .deepClean, .fix:
                return 0.0   // Neutral (cleaning doesn't upset negative traits)
            }

        case .attachment:
            // Attachment traits ONLY care about removal
            switch action {
            case .remove:
                return -15.0  // Very big penalty (triggers discovery)
            case .replace:
                return -10.0  // Big penalty (getting rid of the original)
            default:
                return 0.0    // Other actions are fine
            }
        }
    }
}

// MARK: - Predefined Characters

extension Man {

    /// Gary "Gamer Gary" - The tutorial character
    /// Easy difficulty, intuitive traits
    static var gamerGary: Man {
        return Man(
            id: "gamer_gary",
            name: "Gary",
            nickname: "Gamer Gary",
            traits: [
                Trait(type: .needsGamingAccessible, intensity: .high, isRevealed: true),
                Trait(type: .appreciatesCleanliness, intensity: .low, isRevealed: true),
                Trait(type: .sentimentalJunk, intensity: .medium, isRevealed: false)
            ],
            toleranceForChange: 60,
            backstory: "Gary is a software developer who unwinds with video games after long coding sessions. His gaming setup is his sanctuary, but he wouldn't mind if you cleaned around it...",
            difficultyRating: 1,
            isUnlocked: true
        )
    }
}
