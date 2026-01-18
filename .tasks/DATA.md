# DATA Swimlane - Agent Task List

> **Owner**: agent-data
> **Purpose**: Plist files, game content, balancing

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
| D1.1 | Define plist schema for Men | [ ] | MODELS M1.1, M1.2 | Documentation | Men.plist structure |
| D1.2 | Define plist schema for Rooms | [ ] | MODELS M1.3, M1.4 | Documentation | Room_*.plist structure |
| D1.3 | Create DataManager.swift | [ ] | D1.1, D1.2 | Managers/DataManager.swift | Load/decode plists |

**Phase 1 Complete**: [ ] (all 3 tasks done)

---

## Phase 2: Core Systems

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| D2.1 | Create Men.plist with Gary | [ ] | D1.1 | Resources/Data/Men.plist | Gary's traits |
| D2.2 | Create Room_gary.plist | [ ] | D1.2 | Resources/Data/Room_gary.plist | All 26 items |
| D2.3 | Create Interactions.plist | [ ] | MODELS M1.4 | Resources/Data/Interactions.plist | 7 action types |
| D2.4 | Create Traits.plist | [ ] | MODELS M1.2 | Resources/Data/Traits.plist | All trait definitions |

**Phase 2 Complete**: [ ] (all 4 tasks done)

---

## Phase 3: Gameplay

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| D3.1 | Add sentimental flags to items | [ ] | D2.2 | Room_gary.plist | Hidden trait connections |
| D3.2 | Balance item costs/effects | [ ] | D2.2, D2.3 | All data files | First balance pass |
| D3.3 | Add discovery text for items | [ ] | D3.1 | Room_gary.plist | "This trophy..." text |

**Phase 3 Complete**: [ ] (all 3 tasks done)

---

## Phase 4: Integration

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| D4.1 | Add outcome text to data | [ ] | SCENES S4.1 | Resources/Data/Outcomes.plist | 5 outcome descriptions |
| D4.2 | Second balance pass | [ ] | D3.2 | All data files | Post-playtest adjustments |
| D4.3 | Add unlock requirements | [ ] | MODELS M4.3 | Men.plist | Stars for future chars |

**Phase 4 Complete**: [ ] (all 3 tasks done)

---

## Phase 5: Polish

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| D5.1 | Create additional characters | [ ] | D4.3 | Men.plist | Brad, Alex, etc. (future) |
| D5.2 | Create additional rooms | [ ] | D5.1 | Room_*.plist | Per character (future) |

**Phase 5 Complete**: [ ] (all 2 tasks done)

---

## Data Schemas

### Men.plist Schema
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<array>
    <dict>
        <key>id</key>
        <string>gamer_gary</string>

        <key>name</key>
        <string>Gary</string>

        <key>nickname</key>
        <string>Gamer Gary</string>

        <key>toleranceForChange</key>
        <real>60.0</real>

        <key>backstory</key>
        <string>Gary is a software developer...</string>

        <key>difficultyRating</key>
        <integer>1</integer>

        <key>traits</key>
        <array>
            <dict>
                <key>type</key>
                <string>needs_gaming_accessible</string>
                <key>intensity</key>
                <string>high</string>
                <key>isRevealed</key>
                <true/>
            </dict>
            <!-- more traits -->
        </array>
    </dict>
</array>
</plist>
```

### Room_gary.plist Schema
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>roomId</key>
    <string>gary_room</string>

    <key>backgroundSprite</key>
    <string>room_gary_bg</string>

    <key>startingBudget</key>
    <integer>150</integer>

    <key>startingTime</key>
    <integer>180</integer> <!-- minutes -->

    <key>items</key>
    <array>
        <dict>
            <key>id</key>
            <string>gaming_console</string>

            <key>name</key>
            <string>Gaming Console</string>

            <key>category</key>
            <string>gaming</string>

            <key>state</key>
            <string>dirty</string>

            <key>position</key>
            <dict>
                <key>x</key><real>400</real>
                <key>y</key><real>300</real>
            </dict>

            <key>availableActions</key>
            <array>
                <string>clean</string>
            </array>

            <key>isSentimental</key>
            <false/>

            <key>sentimentalTraitType</key>
            <string></string>

            <key>discoveryText</key>
            <string></string>

            <key>actionEffects</key>
            <dict>
                <key>clean</key>
                <dict>
                    <key>satisfactionBase</key><integer>5</integer>
                    <key>differenceBase</key><integer>2</integer>
                    <key>cost</key><integer>5</integer>
                    <key>time</key><integer>10</integer>
                </dict>
            </dict>
        </dict>
        <!-- more items -->
    </array>
</dict>
</plist>
```

### Gary's 26 Items Reference (from GAME_DESIGN.md)

| # | ID | Category | State | Actions |
|---|-----|----------|-------|---------|
| 1 | gaming_console | gaming | dirty | clean |
| 2 | controllers | gaming | dirty | clean, organize |
| 3 | gaming_chair | gaming | dirty | clean, move |
| 4 | game_cases | gaming | disorganized | organize |
| 5 | computer | electronics | dirty | clean |
| 6 | monitor | electronics | dirty | clean |
| 7 | cables | electronics | tangled | organize |
| 8 | phone_charger | electronics | clean | move |
| 9 | couch | furniture | very_dirty | clean, deep_clean |
| 10 | bed | furniture | dirty | clean, deep_clean |
| 11 | desk | furniture | dirty | clean, organize |
| 12 | nightstand | furniture | dirty | clean |
| 13 | dresser | furniture | dirty | clean, organize |
| 14 | clothes_pile | clothing | dirty | organize, remove |
| 15 | laundry_basket | clothing | overflowing | organize |
| 16 | shoes | clothing | scattered | organize |
| 17 | pizza_boxes | food_trash | dirty | remove |
| 18 | dishes_pile | food_trash | very_dirty | clean |
| 19 | soda_cans | food_trash | empty | remove |
| 20 | snack_wrappers | food_trash | trash | remove |
| 21 | poster_gaming | decor | crooked | clean, remove |
| 22 | dead_plant | decor | dead | remove, replace |
| 23 | lamp | decor | broken | fix, replace |
| 24 | old_trophy | junk | dusty | clean, remove* |
| 25 | random_box | junk | dusty | clean, remove*, organize |
| 26 | childhood_toy | junk | dusty | clean, remove* |

*Items marked with `*` trigger hidden trait discovery on remove attempt
