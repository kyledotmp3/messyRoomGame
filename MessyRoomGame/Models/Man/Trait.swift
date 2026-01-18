import Foundation

// MARK: - Trait Types
/// All possible traits a boyfriend can have.
/// These define what he cares about and how actions affect his satisfaction.
///
/// Traits are grouped into three categories:
/// - **Positive**: Things he LIKES (cleaning these = bonus satisfaction)
/// - **Negative**: Things he DISLIKES (doing these = penalty)
/// - **Attachment**: Things he's sentimentally attached to (removing = big penalty)
enum TraitType: String, Codable, CaseIterable {

    // MARK: Positive Traits (things he likes)

    /// Gaming setup must stay accessible and well-maintained
    case needsGamingAccessible = "needs_gaming_accessible"

    /// Likes his books where he can reach them
    case needsBooksAccessible = "needs_books_accessible"

    /// Genuinely appreciates when things are clean
    case appreciatesCleanliness = "appreciates_cleanliness"

    /// Likes when things are organized and in their place
    case likesOrganization = "likes_organization"

    /// Cares about electronics being well-maintained
    case valuesElectronics = "values_electronics"

    // MARK: Negative Traits (things he dislikes)

    /// Doesn't want decorative art in his space
    case hatesArt = "hates_art"

    /// Gets anxious when things are too different
    case hatesChange = "hates_change"

    /// Gets stressed by too many things
    case dislikesClutter = "dislikes_clutter"

    // MARK: Attachment Traits (sentimental items)

    /// That "junk" is actually meaningful to him
    case sentimentalJunk = "sentimental_junk"

    /// Those old clothes have memories
    case sentimentalClothing = "sentimental_clothing"

    /// That ugly poster/decor is special
    case sentimentalDecor = "sentimental_decor"

    // MARK: - Affected Categories

    /// Returns which item categories this trait cares about.
    /// Used to determine if an action on an item should trigger trait modifiers.
    var affectedCategories: [ItemCategory] {
        switch self {
        case .needsGamingAccessible:
            return [.gaming]
        case .needsBooksAccessible:
            return [.books]
        case .appreciatesCleanliness:
            return ItemCategory.allCases // Affects everything
        case .likesOrganization:
            return ItemCategory.allCases // Affects everything
        case .valuesElectronics:
            return [.electronics, .gaming]
        case .hatesArt:
            return [.decor]
        case .hatesChange:
            return ItemCategory.allCases // Affects everything
        case .dislikesClutter:
            return [.junk, .decor]
        case .sentimentalJunk:
            return [.junk]
        case .sentimentalClothing:
            return [.clothing]
        case .sentimentalDecor:
            return [.decor]
        }
    }

    /// Whether this is a "positive" trait (bonuses for good actions)
    /// vs "negative" (penalties) or "attachment" (penalties for removal)
    var traitCategory: TraitCategory {
        switch self {
        case .needsGamingAccessible, .needsBooksAccessible,
             .appreciatesCleanliness, .likesOrganization, .valuesElectronics:
            return .positive
        case .hatesArt, .hatesChange, .dislikesClutter:
            return .negative
        case .sentimentalJunk, .sentimentalClothing, .sentimentalDecor:
            return .attachment
        }
    }
}

// MARK: - Trait Category

/// High-level grouping of trait types
enum TraitCategory {
    case positive   // Bonuses for related actions
    case negative   // Penalties for related actions
    case attachment // Big penalties for removal, triggers discovery
}

// MARK: - Trait Intensity

/// How strongly a trait affects satisfaction calculations.
/// Higher intensity = bigger impact on satisfaction changes.
enum TraitIntensity: String, Codable {
    case low
    case medium
    case high

    /// Multiplier applied to satisfaction changes for this trait.
    /// - low: 1.0x (no change)
    /// - medium: 1.5x
    /// - high: 2.0x
    var multiplier: Double {
        switch self {
        case .low: return 1.0
        case .medium: return 1.5
        case .high: return 2.0
        }
    }
}

// MARK: - Trait Model

/// A single trait belonging to a boyfriend character.
/// Traits define personality and affect how actions impact satisfaction.
struct Trait: Codable, Identifiable {

    /// Unique identifier (auto-generated from type if not specified)
    var id: String { type.rawValue }

    /// What kind of trait this is
    let type: TraitType

    /// How strongly this trait affects satisfaction
    let intensity: TraitIntensity

    /// Whether the player knows about this trait.
    /// Hidden traits are revealed when the player interacts with related items.
    var isRevealed: Bool

    // MARK: - Initialization

    init(type: TraitType, intensity: TraitIntensity, isRevealed: Bool = true) {
        self.type = type
        self.intensity = intensity
        self.isRevealed = isRevealed
    }

    // MARK: - Methods

    /// Check if this trait cares about a given item category
    func affectsCategory(_ category: ItemCategory) -> Bool {
        return type.affectedCategories.contains(category)
    }

    /// Reveal this trait (mutating)
    mutating func reveal() {
        isRevealed = true
    }
}

// MARK: - Item Category

/// Categories of items in a room. Used to match traits to items.
enum ItemCategory: String, Codable, CaseIterable {
    case gaming       // Console, controllers, gaming chair, game cases
    case electronics  // Computer, monitor, phone, cables, chargers
    case furniture    // Couch, bed, desk, dresser, nightstand
    case clothing     // Clothes pile, laundry basket, shoes
    case foodTrash    // Pizza boxes, dishes, soda cans, wrappers
    case books        // Bookshelf, book piles, magazines
    case decor        // Posters, plants, picture frames, lamp
    case junk         // Random boxes, old trophies, childhood toys
}
