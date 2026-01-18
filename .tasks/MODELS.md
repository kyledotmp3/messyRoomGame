# MODELS Swimlane - Agent Task List

> **Owner**: agent-models
> **Purpose**: Core data structures and game logic

## How to Use This File

1. Pick the next `[ ]` task in your current phase
2. Change `[ ]` to `[~]` when starting (in progress)
3. Change `[~]` to `[x]` when complete
4. Add notes in the Notes column if needed
5. Update STATUS.md progress counter

---

## Phase 1: Foundation

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| M1.1 | Create Man.swift | [ ] | - | Models/Man/Man.swift | Character model with traits array |
| M1.2 | Create Trait.swift | [ ] | - | Models/Man/Trait.swift | Trait enum + TraitIntensity |
| M1.3 | Create RoomItem.swift | [ ] | - | Models/Room/RoomItem.swift | Item with state, position, actions |
| M1.4 | Create Interaction.swift | [ ] | - | Models/Room/Interaction.swift | Action types enum |
| M1.5 | Create SatisfactionMeter.swift | [ ] | - | Models/Scoring/SatisfactionMeter.swift | Observable 0-100 meter |
| M1.6 | Create DifferenceMeter.swift | [ ] | - | Models/Scoring/DifferenceMeter.swift | Observable 0-100 meter (only increases) |

**Phase 1 Complete**: [ ] (all 6 tasks done)

---

## Phase 2: Core Systems

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| M2.1 | Implement trait satisfaction formula | [ ] | M1.1-M1.6 | ScoreManager.swift | calculateSatisfactionChange() |
| M2.2 | Implement difference calculation | [ ] | M1.6 | ScoreManager.swift | calculateDifferencePoints() |
| M2.3 | Create ScoreManager.swift | [ ] | M2.1, M2.2 | Managers/ScoreManager.swift | Centralized scoring |
| M2.4 | Implement intensity multipliers | [ ] | M2.1 | ScoreManager.swift | Low=1.0, Med=1.5, High=2.0 |

**Phase 2 Complete**: [ ] (all 4 tasks done)

---

## Phase 3: Gameplay

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| M3.1 | Create GameSession.swift | [ ] | M2.3 | Models/Progress/GameSession.swift | Session state tracking |
| M3.2 | Implement time tracking | [ ] | M3.1 | GameSession.swift | Countdown timer logic |
| M3.3 | Implement budget tracking | [ ] | M3.1 | GameSession.swift | Spending/remaining |
| M3.4 | Implement hidden trait discovery | [ ] | M2.1 | ScoreManager.swift | Reveal mechanic |

**Phase 3 Complete**: [ ] (all 4 tasks done)

---

## Phase 4: Integration

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| M4.1 | Create GameResult.swift | [ ] | M3.1 | Models/Progress/GameResult.swift | Final stats + outcome |
| M4.2 | Implement star rating calculation | [ ] | M4.1 | GameResult.swift | 0-3 stars logic |
| M4.3 | Create PlayerProgress.swift | [ ] | M4.2 | Models/Progress/PlayerProgress.swift | Best results, unlocks |
| M4.4 | Implement save/load for progress | [ ] | M4.3 | DataManager.swift | UserDefaults |
| M4.5 | Implement save/load for sessions | [ ] | M3.1 | DataManager.swift | Mid-game save |

**Phase 4 Complete**: [ ] (all 5 tasks done)

---

## Phase 5: Polish

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| M5.1 | Final balance tuning | [ ] | M4.* | Data files | All numbers finalized |
| M5.2 | Add settings model | [ ] | M4.4 | Models/GameSettings.swift | Volume, haptics |

**Phase 5 Complete**: [ ] (all 2 tasks done)

---

## Code Templates

### Man.swift Template
```swift
import Foundation

struct Man: Codable, Identifiable {
    let id: String
    let name: String
    let nickname: String
    var traits: [Trait]
    let toleranceForChange: Double  // 0-100, max difference allowed
    let backstory: String
    let difficultyRating: Int  // 1-5

    func satisfactionModifier(for item: RoomItem, action: Interaction) -> Double {
        // TODO: Implement trait-based calculation
        return 0
    }
}
```

### Trait.swift Template
```swift
import Foundation

enum TraitType: String, Codable, CaseIterable {
    case needsGamingAccessible = "needs_gaming_accessible"
    case needsBooksAccessible = "needs_books_accessible"
    case appreciatesCleanliness = "appreciates_cleanliness"
    case likesOrganization = "likes_organization"
    case valuesElectronics = "values_electronics"
    case hatesArt = "hates_art"
    case hatesChange = "hates_change"
    case dislikesClutter = "dislikes_clutter"
    case sentimentalJunk = "sentimental_junk"
    case sentimentalClothing = "sentimental_clothing"
    case sentimentalDecor = "sentimental_decor"
}

enum TraitIntensity: String, Codable {
    case low, medium, high

    var multiplier: Double {
        switch self {
        case .low: return 1.0
        case .medium: return 1.5
        case .high: return 2.0
        }
    }
}

struct Trait: Codable {
    let type: TraitType
    let intensity: TraitIntensity
    var isRevealed: Bool
}
```
