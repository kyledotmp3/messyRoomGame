# Messy Room Game - Complete Game Design Document

> **What is this document?**
> This is a comprehensive design document that explains EVERYTHING about how this game works. If you're not a game developer, that's okay - this document is written so you can understand every single mechanic, formula, and design decision. Read it top to bottom, or use the table of contents to jump to specific sections.

---

## Table of Contents

1. [Game Concept](#1-game-concept)
2. [The Core Loop](#2-the-core-loop)
3. [The Two Meters](#3-the-two-meters-your-main-constraints)
4. [Budget & Time](#4-budget--time)
5. [The Traits System](#5-the-traits-system)
6. [Room Items & Interactions](#6-room-items--interactions)
7. [Gary's Room - Complete Breakdown](#7-garys-room---complete-breakdown)
8. [Win, Lose, and Everything Between](#8-win-lose-and-everything-between)
9. [User Interface Screens](#9-user-interface-screens)
10. [Example Playthrough](#10-example-playthrough)
11. [Glossary](#11-glossary)
12. [Technical Notes for Implementation](#12-technical-notes-for-implementation)

---

## 1. Game Concept

### 1.1 The Premise

You're dating someone whose room is... well, let's call it "lived in." You love them, but their space could use some help. The catch? They're particular about their stuff. Clean too much and they feel like you're trying to change them. Don't clean enough and you're just visiting a messy room.

**You play as**: A girlfriend who wants to help her boyfriend by tidying up while he's at work.

**Your goal**: Make the room better without making it *too different*.

### 1.2 The Core Tension

This game is about balance. Two forces are constantly at odds:

| Force | What it means |
|-------|---------------|
| **Satisfaction** | How happy your boyfriend is with the changes |
| **Difference** | How much you've changed from how things were |

You want Satisfaction HIGH and Difference LOW. But here's the problem: most things that raise Satisfaction also raise Difference. You have to be strategic.

### 1.3 The Tone

This is a **cozy, wholesome** game. Think:
- The satisfying feeling of organizing in *Unpacking*
- The zen cleaning of *PowerWash Simulator*
- Gentle humor, not mean-spirited

Nobody is a villain here. Your boyfriend isn't a slob - he's just someone with a different relationship to mess. You're not controlling - you're trying to help. The "breakup" consequence is played for gentle stakes, not drama.

---

## 2. The Core Loop

### 2.1 What Happens in a Session

```
┌─────────────────────────────────────────────────────────────────┐
│                     ONE CLEANING SESSION                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. SETUP                                                       │
│     └── You see his room. It's messy.                          │
│     └── You see his REVEALED TRAITS (what you know about him)  │
│     └── You have a BUDGET (money) and TIME (clock)             │
│                                                                 │
│  2. CLEANING PHASE (the main gameplay)                          │
│     └── Tap/click on items in the room                         │
│     └── Choose an action (clean, fix, replace, etc.)           │
│     └── Watch your METERS change                                │
│     └── Repeat until time runs out or you're done              │
│                                                                 │
│  3. HE COMES HOME                                               │
│     └── Time's up! He walks in.                                │
│     └── He reacts based on Satisfaction & Difference           │
│     └── You see your RESULT (star rating, outcome)             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 How Long is a Session?

- **Game time**: 5-15 minutes of in-game time (the clock in the game world)
- **Real time**: Probably 10-20 minutes of actual play
- Actions don't happen instantly - cleaning takes "time" off your clock

---

## 3. The Two Meters (Your Main Constraints)

### 3.1 Satisfaction Meter

```
SATISFACTION METER
┌────────────────────────────────────────────────────────┐
│ 😊                                            [75/100] │
│ ████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░│
└────────────────────────────────────────────────────────┘
```

**What it represents**: How happy your boyfriend will be when he sees the room.

**Starts at**: 50 (neutral - room is messy but it's HIS mess)

**Goes UP when**:
- You clean something that was genuinely gross
- You fix something that was broken
- You organize something in a way that matches his preferences
- You do something that aligns with his TRAITS

**Goes DOWN when**:
- You touch something he's attached to
- You throw away something important
- You change something in a way that conflicts with his TRAITS
- You make things "too different" (he feels judged)

**Target**: 60+ for a passing result, 80+ for a great result

### 3.2 Difference Meter

```
DIFFERENCE METER
┌────────────────────────────────────────────────────────┐
│ 🔄                                            [45/100] │
│ █████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│
└────────────────────────────────────────────────────────┘
```

**What it represents**: How much you've changed from how things were.

**Starts at**: 0 (you haven't changed anything yet)

**Goes UP when**:
- You do ANYTHING to the room
- Bigger changes = more points (replacing >> cleaning)
- Moving things = points even if they're "better" positions

**Goes DOWN**: It doesn't go down. It only goes up. Every action is permanent.

**Target**: Stay BELOW his tolerance threshold (varies by character)

### 3.3 How The Meters Interact

Here's the tricky part: **most actions affect BOTH meters**.

| Action | Satisfaction | Difference |
|--------|-------------|------------|
| Clean a dirty dish | +5 to +10 | +2 |
| Throw away trash | +3 to +8 | +3 |
| Replace broken lamp | +8 to +15 | +25 |
| Move gaming chair | -5 to +5 | +8 |
| Throw away "junk" | ??? | +15 |

That "???" for throwing away junk is where TRAITS come in...

---

## 4. Budget & Time

### 4.1 Budget System

```
BUDGET: $150
┌─────────────────────────────┐
│ 💵 $150 remaining          │
└─────────────────────────────┘
```

**What it represents**: The money you're willing to spend on cleaning supplies, replacements, etc.

**Starting amount**: $150 for Gary's room (varies by level)

**What costs money**:
| Action | Typical Cost | Why |
|--------|-------------|-----|
| Quick Clean | $0-5 | Basic supplies |
| Deep Clean | $10-20 | Stronger supplies |
| Fix | $15-40 | Replacement parts |
| Replace | $30-100+ | Buying new items |
| Remove | $0 | Just throwing it out |
| Move | $0 | Just moving it |
| Organize | $0-10 | Maybe containers? |

**When you run out**: You can only do free actions (remove, move, basic organize)

### 4.2 Time System

```
TIME REMAINING: 2:45:00
┌─────────────────────────────┐
│ ⏰ 2h 45m until he's home  │
└─────────────────────────────┘
```

**What it represents**: How long until your boyfriend comes home from work.

**Starting amount**: 3 hours of "game time" for Gary's room

**What takes time**:
| Action | Time Cost | Why |
|--------|-----------|-----|
| Quick Clean | 5-10 min | Fast wipe down |
| Deep Clean | 20-45 min | Thorough scrubbing |
| Fix | 30-60 min | Actual repair work |
| Replace | 10-15 min | Swap old for new |
| Remove | 2-5 min | Carry to trash |
| Move | 5-10 min | Relocate item |
| Organize | 15-30 min | Sort and arrange |

**When you run out**: The session ENDS. He comes home. You get your result.

### 4.3 The Strategic Tradeoff

You never have enough time AND money to do everything. You have to choose:
- Do you deep clean the couch ($20, 45 min) or quick clean it ($5, 10 min)?
- Do you replace the broken lamp ($60, 15 min) or just remove it ($0, 5 min)?
- Is it worth spending time organizing his desk if it might upset him?

---

## 5. The Traits System

### 5.1 What Are Traits?

Traits define what your boyfriend cares about. They affect how your actions impact his Satisfaction.

Each character has 3-5 traits. Some are **revealed** (you know about them from the start) and some are **hidden** (you discover them by interacting with related items).

### 5.2 Trait Structure

Every trait has:

| Property | What it means |
|----------|---------------|
| **Type** | What the trait is about (gaming, cleanliness, etc.) |
| **Intensity** | How much he cares (Low, Medium, High) |
| **Is Revealed** | Do you know about it at the start? |
| **Affected Categories** | What item types this trait cares about |

### 5.3 All Possible Traits

Here are the traits that can appear in the game:

#### Positive Traits (things he LIKES)

| Trait | Description | Affected Items |
|-------|-------------|----------------|
| `needs_gaming_accessible` | Gaming setup must stay accessible | Console, controllers, gaming chair, monitor |
| `needs_books_accessible` | Likes his books where he can reach them | Bookshelf, book piles, magazines |
| `appreciates_cleanliness` | Genuinely likes when things are clean | Everything (bonus to cleaning) |
| `likes_organization` | Appreciates when things are in their place | Everything (bonus to organizing) |
| `values_electronics` | Cares about his tech being well-maintained | Computer, console, cables, phone |

#### Negative Traits (things he DISLIKES)

| Trait | Description | Affected Items |
|-------|-------------|----------------|
| `hates_art` | Doesn't want decorative art in his space | Posters, picture frames, plants |
| `hates_change` | Gets anxious when things are different | Everything (penalty to difference) |
| `dislikes_clutter` | Gets stressed by too many things | Junk items, excessive decoration |

#### Attachment Traits (things he's ATTACHED TO)

| Trait | Description | Affected Items |
|-------|-------------|----------------|
| `sentimental_junk` | That "junk" is actually meaningful to him | Random boxes, old trophies, childhood toys |
| `sentimental_clothing` | Those old clothes have memories | Specific clothing items |
| `sentimental_decor` | That ugly poster is special | Specific decor items |

### 5.4 How Traits Affect Satisfaction

When you perform an action on an item, the game checks:
1. What category is this item in?
2. Does this character have any traits that care about this category?
3. Is the action positive or negative for that trait?
4. How intense is the trait?

**Formula**:
```
Satisfaction Change = Base Action Effect × Trait Modifier × Intensity Multiplier

Where:
- Base Action Effect: How much this action normally affects satisfaction (-20 to +20)
- Trait Modifier: +1 if trait likes this, -1 if trait dislikes this, 0 if neutral
- Intensity Multiplier: Low = 1.0, Medium = 1.5, High = 2.0
```

**Example**:
- You CLEAN the gaming console (+5 base effect)
- Gary has `needs_gaming_accessible` (HIGH intensity, +1 modifier)
- Result: +5 × +1 × 2.0 = **+10 Satisfaction**

**Another Example**:
- You MOVE the gaming chair to a different spot (0 base effect, it's neutral)
- Gary has `needs_gaming_accessible` (HIGH intensity)
- The chair is now further from the TV (-1 modifier, he doesn't like this)
- Result: 0 + (-5 × 2.0) = **-10 Satisfaction**

### 5.5 Hidden Traits & Discovery

Some traits are HIDDEN. You don't know about them until you interact with a related item.

**How discovery works**:
1. You perform an action on an item
2. If that item is connected to a hidden trait, the trait is REVEALED
3. You see a popup: "You discovered: Gary is sentimental about his childhood toys!"
4. The trait now shows in your trait panel
5. You now know to be careful with related items

**Example**:
- You try to REMOVE an old trophy (looks like junk)
- POPUP: "Wait... this trophy has an inscription: 'First Place, 6th Grade Science Fair'"
- REVEALED: `sentimental_junk` (MEDIUM intensity)
- The remove action is CANCELLED (you stopped yourself)
- You now know: don't throw away his "junk" - it means something to him

---

## 6. Room Items & Interactions

### 6.1 Item Structure

Every item in the room has:

| Property | What it means |
|----------|---------------|
| **ID** | Unique identifier (e.g., `gaming_console_1`) |
| **Name** | Display name (e.g., "Gaming Console") |
| **Category** | Type of item (gaming, furniture, clothing, etc.) |
| **Position** | Where it is in the room (x, y coordinates) |
| **State** | Current condition (clean, dirty, very_dirty, broken, etc.) |
| **Available Actions** | What you can do to it |
| **Sprite Name** | Which image to show |
| **Is Moveable** | Can you move it? |
| **Is Removeable** | Can you throw it away? |
| **Sentimental Value** | Is it connected to a hidden trait? |

### 6.2 Item States

Items can be in different states:

| State | Visual | Description |
|-------|--------|-------------|
| `clean` | Normal sprite | Item is fine |
| `dirty` | Dirty overlay/variant | Needs cleaning |
| `very_dirty` | Extra dirty variant | Needs deep cleaning |
| `broken` | Broken variant | Needs fixing or replacing |
| `organized` | Organized variant | Has been tidied |
| `new` | New/shiny variant | Has been replaced |

### 6.3 All Possible Actions

Here are all the actions you can perform on items:

#### CLEAN (Quick Clean)
- **Cost**: $0-5
- **Time**: 5-10 minutes
- **Effect**: Makes dirty item clean
- **Satisfaction Impact**: +3 to +8 (varies by item)
- **Difference Impact**: +1 to +3 (low)
- **When Available**: Item state is `dirty`

#### DEEP CLEAN
- **Cost**: $10-20
- **Time**: 20-45 minutes
- **Effect**: Makes very dirty item clean
- **Satisfaction Impact**: +8 to +15 (high, it was really gross)
- **Difference Impact**: +5 to +8 (medium)
- **When Available**: Item state is `very_dirty`

#### FIX
- **Cost**: $15-40
- **Time**: 30-60 minutes
- **Effect**: Repairs broken item
- **Satisfaction Impact**: +10 to +20 (he's glad it works again)
- **Difference Impact**: +10 to +15 (medium-high)
- **When Available**: Item state is `broken`

#### REPLACE
- **Cost**: $30-100+
- **Time**: 10-15 minutes
- **Effect**: Removes old item, puts new one in its place
- **Satisfaction Impact**: +5 to +25 (depends on if he liked the old one)
- **Difference Impact**: +20 to +30 (HIGH - this is a big change)
- **When Available**: Item is replaceable
- **Risk**: If he was attached to the old one, NEGATIVE satisfaction

#### REMOVE
- **Cost**: $0
- **Time**: 2-5 minutes
- **Effect**: Throws item away
- **Satisfaction Impact**: -10 to +10 (depends on if it was junk or treasured)
- **Difference Impact**: +15 to +25 (high - something is GONE)
- **When Available**: Item is removeable
- **Risk**: If he was attached, VERY NEGATIVE satisfaction

#### MOVE
- **Cost**: $0
- **Time**: 5-10 minutes
- **Effect**: Changes item's position in the room
- **Satisfaction Impact**: -5 to +5 (depends on new position)
- **Difference Impact**: +5 to +10 (medium)
- **When Available**: Item is moveable
- **Note**: Some positions are "better" for certain items (gaming chair near TV)

#### ORGANIZE
- **Cost**: $0-10
- **Time**: 15-30 minutes
- **Effect**: Tidies up the item and surrounding area
- **Satisfaction Impact**: +5 to +12 (if he appreciates organization)
- **Difference Impact**: +5 to +8 (medium)
- **When Available**: Item can be organized (books, clothes, cables)

### 6.4 Item Categories

Items are grouped into categories that traits can affect:

| Category | Examples |
|----------|----------|
| `gaming` | Console, controllers, gaming chair, game cases |
| `electronics` | Computer, monitor, phone, cables, chargers |
| `furniture` | Couch, bed, desk, dresser, nightstand |
| `clothing` | Clothes pile, laundry basket, shoes |
| `food_trash` | Pizza boxes, dishes, soda cans, wrappers |
| `books` | Bookshelf, book piles, magazines |
| `decor` | Posters, plants, picture frames, lamp |
| `junk` | Random boxes, old trophies, childhood toys |

---

## 7. Gary's Room - Complete Breakdown

### 7.1 Meet Gary

```
┌────────────────────────────────────────────┐
│  GARY "Gamer Gary"                         │
│  ────────────────                          │
│  Age: 28                                   │
│  Job: Software Developer                   │
│  Hobbies: Gaming, streaming, coding        │
│                                            │
│  "His gaming setup is his sanctuary.       │
│   Just... maybe don't move the chair."     │
│                                            │
│  Difficulty: ★☆☆☆☆ (Easy - Good for       │
│  learning the mechanics)                   │
└────────────────────────────────────────────┘
```

### 7.2 Gary's Traits

| Trait | Intensity | Revealed? | Description |
|-------|-----------|-----------|-------------|
| `needs_gaming_accessible` | HIGH | Yes | His gaming setup is sacred. Don't mess with it. |
| `appreciates_cleanliness` | LOW | Yes | He does like things clean, just doesn't prioritize it |
| `sentimental_junk` | MEDIUM | **No** | Some of that "junk" has memories. You'll discover this. |

### 7.3 Gary's Room Parameters

| Parameter | Value |
|-----------|-------|
| Starting Budget | $150 |
| Time Until He's Home | 3 hours |
| Difference Tolerance | 60 (he can accept quite a bit of change) |
| Satisfaction Target | 65 (for a passing result) |

### 7.4 Complete Item List

Here is EVERY item in Gary's room, with all properties:

---

#### GAMING SETUP AREA

**1. Gaming Console**
| Property | Value |
|----------|-------|
| ID | `gaming_console` |
| Category | `gaming` |
| State | `dirty` (dusty) |
| Position | Living room, on TV stand |
| Available Actions | Clean |
| Base Clean Effect | +5 satisfaction, +2 difference |
| Trait Interaction | `needs_gaming_accessible`: Clean = +10 total satisfaction |
| Notes | Easy win - cleaning it makes him happy |

**2. Gaming Controllers (pile of 3)**
| Property | Value |
|----------|-------|
| ID | `controllers` |
| Category | `gaming` |
| State | `dirty` (sticky) |
| Position | On couch, scattered |
| Available Actions | Clean, Organize |
| Base Clean Effect | +3 satisfaction, +2 difference |
| Base Organize Effect | +5 satisfaction, +5 difference |
| Trait Interaction | `needs_gaming_accessible`: Organize to spot near console = +8 |
| Notes | Good target for organize |

**3. Gaming Chair**
| Property | Value |
|----------|-------|
| ID | `gaming_chair` |
| Category | `gaming` |
| State | `dirty` (crumbs, needs vacuuming) |
| Position | In front of TV (optimal position) |
| Available Actions | Clean, Move |
| Base Clean Effect | +4 satisfaction, +2 difference |
| Move Effect | VARIES based on where you put it |
| Trait Interaction | Moving it away from TV = -8 satisfaction |
| Notes | CAREFUL with Move action! |

**4. Game Cases (scattered)**
| Property | Value |
|----------|-------|
| ID | `game_cases` |
| Category | `gaming` |
| State | `disorganized` |
| Position | Floor near TV stand |
| Available Actions | Organize |
| Base Organize Effect | +6 satisfaction, +4 difference |
| Notes | Safe to organize |

---

#### ELECTRONICS AREA

**5. Desktop Computer**
| Property | Value |
|----------|-------|
| ID | `computer` |
| Category | `electronics` |
| State | `dirty` (dusty) |
| Position | On desk |
| Available Actions | Clean |
| Base Clean Effect | +4 satisfaction, +2 difference |
| Notes | Easy target |

**6. Monitor**
| Property | Value |
|----------|-------|
| ID | `monitor` |
| Category | `electronics` |
| State | `dirty` (fingerprints) |
| Position | On desk |
| Available Actions | Clean |
| Base Clean Effect | +3 satisfaction, +1 difference |
| Notes | Quick and easy |

**7. Cable Mess**
| Property | Value |
|----------|-------|
| ID | `cables` |
| Category | `electronics` |
| State | `tangled` |
| Position | Behind desk |
| Available Actions | Organize |
| Base Organize Effect | +7 satisfaction, +6 difference |
| Time Cost | 25 minutes (takes a while) |
| Notes | Good payoff but time-consuming |

**8. Phone Charger**
| Property | Value |
|----------|-------|
| ID | `phone_charger` |
| Category | `electronics` |
| State | `clean` |
| Position | On nightstand |
| Available Actions | Move |
| Notes | Probably don't need to touch this |

---

#### FURNITURE

**9. Couch**
| Property | Value |
|----------|-------|
| ID | `couch` |
| Category | `furniture` |
| State | `very_dirty` (stains, crumbs, needs deep cleaning) |
| Position | Center of living area |
| Available Actions | Clean, Deep Clean |
| Base Clean Effect | +3 satisfaction, +2 difference |
| Base Deep Clean Effect | +12 satisfaction, +7 difference |
| Cost | Clean: $5, Deep Clean: $20 |
| Time | Clean: 10 min, Deep Clean: 40 min |
| Notes | Deep clean is worth it if you have time |

**10. Bed**
| Property | Value |
|----------|-------|
| ID | `bed` |
| Category | `furniture` |
| State | `dirty` (unmade, sheets need changing) |
| Position | Bedroom area |
| Available Actions | Clean (make bed), Deep Clean (change sheets) |
| Base Clean Effect | +4 satisfaction, +2 difference |
| Base Deep Clean Effect | +8 satisfaction, +5 difference |
| Notes | Making the bed is quick and effective |

**11. Desk**
| Property | Value |
|----------|-------|
| ID | `desk` |
| Category | `furniture` |
| State | `dirty` (cluttered, dusty) |
| Position | Against wall |
| Available Actions | Clean, Organize |
| Base Clean Effect | +3 satisfaction, +2 difference |
| Base Organize Effect | +5 satisfaction, +5 difference |
| Notes | Safe to clean and organize |

**12. Nightstand**
| Property | Value |
|----------|-------|
| ID | `nightstand` |
| Category | `furniture` |
| State | `dirty` (dusty, water rings) |
| Position | Next to bed |
| Available Actions | Clean |
| Base Clean Effect | +2 satisfaction, +1 difference |
| Notes | Quick easy win |

**13. Dresser**
| Property | Value |
|----------|-------|
| ID | `dresser` |
| Category | `furniture` |
| State | `dirty` (dusty) |
| Position | Bedroom area |
| Available Actions | Clean, Organize (drawers) |
| Base Clean Effect | +3 satisfaction, +2 difference |
| Base Organize Effect | +4 satisfaction, +4 difference |
| Notes | Organizing drawers is optional |

---

#### CLOTHING

**14. Clothes Pile (floor)**
| Property | Value |
|----------|-------|
| ID | `clothes_pile` |
| Category | `clothing` |
| State | `dirty` |
| Position | Bedroom floor |
| Available Actions | Organize (put in hamper), Remove (throw away) |
| Base Organize Effect | +6 satisfaction, +4 difference |
| Remove Effect | +2 satisfaction, +10 difference (they're just clothes) |
| Notes | Organize, don't remove |

**15. Laundry Basket**
| Property | Value |
|----------|-------|
| ID | `laundry_basket` |
| Category | `clothing` |
| State | `overflowing` |
| Position | Bedroom corner |
| Available Actions | Organize |
| Base Organize Effect | +3 satisfaction, +3 difference |
| Notes | Just make it look neater |

**16. Shoes (scattered)**
| Property | Value |
|----------|-------|
| ID | `shoes` |
| Category | `clothing` |
| State | `scattered` |
| Position | Near door |
| Available Actions | Organize |
| Base Organize Effect | +4 satisfaction, +3 difference |
| Notes | Quick organization win |

---

#### FOOD & TRASH

**17. Pizza Boxes (stack of 3)**
| Property | Value |
|----------|-------|
| ID | `pizza_boxes` |
| Category | `food_trash` |
| State | `dirty` (old, needs throwing out) |
| Position | Coffee table |
| Available Actions | Remove |
| Base Remove Effect | +8 satisfaction, +5 difference |
| Notes | Definitely throw these away |

**18. Dirty Dishes (pile)**
| Property | Value |
|----------|-------|
| ID | `dishes_pile` |
| Category | `food_trash` |
| State | `very_dirty` |
| Position | Desk (yes, desk) |
| Available Actions | Clean (wash them) |
| Base Clean Effect | +10 satisfaction, +4 difference |
| Time | 20 minutes |
| Notes | High satisfaction, definitely do this |

**19. Soda Cans (several)**
| Property | Value |
|----------|-------|
| ID | `soda_cans` |
| Category | `food_trash` |
| State | `empty` |
| Position | Around gaming area |
| Available Actions | Remove |
| Base Remove Effect | +5 satisfaction, +2 difference |
| Notes | Quick and easy |

**20. Snack Wrappers**
| Property | Value |
|----------|-------|
| ID | `snack_wrappers` |
| Category | `food_trash` |
| State | `trash` |
| Position | Couch cushions, floor |
| Available Actions | Remove |
| Base Remove Effect | +4 satisfaction, +2 difference |
| Notes | Obvious trash, throw it away |

---

#### DECOR

**21. Poster (gaming)**
| Property | Value |
|----------|-------|
| ID | `poster_gaming` |
| Category | `decor` |
| State | `crooked` |
| Position | Wall near gaming setup |
| Available Actions | Clean (straighten), Remove |
| Base Clean Effect | +2 satisfaction, +1 difference |
| Remove Effect | -5 satisfaction, +15 difference (he likes this poster!) |
| Notes | Straighten it, don't remove |

**22. Dead Plant**
| Property | Value |
|----------|-------|
| ID | `dead_plant` |
| Category | `decor` |
| State | `dead` |
| Position | Window sill |
| Available Actions | Remove, Replace |
| Base Remove Effect | +3 satisfaction, +10 difference |
| Base Replace Effect | +5 satisfaction, +20 difference |
| Replace Cost | $15 |
| Notes | Can remove or replace, both are fine |

**23. Lamp**
| Property | Value |
|----------|-------|
| ID | `lamp` |
| Category | `decor` |
| State | `broken` (bulb burned out) |
| Position | Nightstand |
| Available Actions | Fix, Replace |
| Base Fix Effect | +6 satisfaction, +8 difference |
| Fix Cost | $5 (just a bulb) |
| Base Replace Effect | +8 satisfaction, +22 difference |
| Replace Cost | $40 |
| Notes | Fixing is better value |

---

#### JUNK (CAREFUL - HIDDEN TRAIT)

**24. Old Trophy**
| Property | Value |
|----------|-------|
| ID | `old_trophy` |
| Category | `junk` |
| State | `dusty` |
| Position | Shelf |
| Available Actions | Clean, Remove |
| **SENTIMENTAL**: Yes - connected to hidden trait |
| Base Clean Effect | +2 satisfaction, +1 difference |
| Remove Effect | **TRIGGERS HIDDEN TRAIT REVEAL** |
| If trait revealed: | -15 satisfaction, action cancelled |
| Notes | Clean it, DON'T remove it |

**25. Random Box**
| Property | Value |
|----------|-------|
| ID | `random_box` |
| Category | `junk` |
| State | `dusty` |
| Position | Closet floor |
| Available Actions | Clean, Remove, Organize |
| **SENTIMENTAL**: Yes - connected to hidden trait |
| Base Clean Effect | +1 satisfaction, +1 difference |
| Remove Effect | **TRIGGERS HIDDEN TRAIT REVEAL** |
| If trait revealed: | -12 satisfaction, action cancelled |
| Notes | Leave it alone or just clean |

**26. Childhood Toy**
| Property | Value |
|----------|-------|
| ID | `childhood_toy` |
| Category | `junk` |
| State | `dusty` |
| Position | Desk shelf |
| Available Actions | Clean, Remove |
| **SENTIMENTAL**: Yes - connected to hidden trait |
| Base Clean Effect | +1 satisfaction, +1 difference |
| Remove Effect | **TRIGGERS HIDDEN TRAIT REVEAL** |
| If trait revealed: | -20 satisfaction, action cancelled |
| Notes | DEFINITELY don't remove. Maybe clean. |

---

### 7.5 Room Layout Visualization

```
┌─────────────────────────────────────────────────────────────────────┐
│                          GARY'S ROOM                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌─────────┐                              ┌──────────────────┐     │
│   │  BED    │ NIGHTSTAND                   │   WINDOW         │     │
│   │  (dirty)│  [lamp]                      │   [dead plant]   │     │
│   └─────────┘  [charger]                   └──────────────────┘     │
│                                                                     │
│   ┌─────────┐                                                       │
│   │ DRESSER │   CLOTHES PILE                                        │
│   │ (dusty) │   (on floor)                 [poster - crooked]       │
│   └─────────┘                                                       │
│                                                                     │
│   LAUNDRY                                                           │
│   BASKET                                                            │
│                                                                     │
│   ═══════════════════════════════════════════════════════════       │
│                                                                     │
│                        LIVING AREA                                  │
│                                                                     │
│   ┌─────────────────────┐        ┌────────────────────────┐         │
│   │      COUCH          │        │     TV STAND           │         │
│   │   (very dirty)      │        │  [gaming console]      │         │
│   │   [controllers]     │        │  [game cases - floor]  │         │
│   │   [snack wrappers]  │        │                        │         │
│   └─────────────────────┘        └────────────────────────┘         │
│                                                                     │
│        [gaming chair]        COFFEE TABLE                           │
│           (dirty)            [pizza boxes]                          │
│                              [soda cans]                            │
│                                                                     │
│   ═══════════════════════════════════════════════════════════       │
│                                                                     │
│   ┌──────────────────────┐                                          │
│   │       DESK           │        ┌───────────┐                     │
│   │  [computer, monitor] │        │  CLOSET   │                     │
│   │  [dishes pile!!]     │        │ [random   │                     │
│   │  [cables - tangled]  │        │  box]     │                     │
│   └──────────────────────┘        └───────────┘                     │
│     SHELF: [old trophy] [childhood toy]                             │
│                                                                     │
│   ENTRY                                                             │
│   [shoes - scattered]                                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. Win, Lose, and Everything Between

### 8.1 End Conditions

The session ends when:
1. **Time runs out** - He comes home
2. **You press "Done"** - You decide you're finished early

### 8.2 Result Calculation

When the session ends, we calculate your result:

```
FINAL SATISFACTION = Current Satisfaction Value (0-100)
FINAL DIFFERENCE = Current Difference Value (0-100)
TOLERANCE = Character's Tolerance for Change (e.g., 60 for Gary)

IF FINAL_DIFFERENCE > TOLERANCE:
    → OUTCOME = "Too Different" (Bad)
ELSE IF FINAL_SATISFACTION < 50:
    → OUTCOME = "Not Enough" (Bad)
ELSE IF FINAL_SATISFACTION >= 50 AND FINAL_SATISFACTION < 65:
    → OUTCOME = "Okay" (Passable)
ELSE IF FINAL_SATISFACTION >= 65 AND FINAL_SATISFACTION < 80:
    → OUTCOME = "Good" (Nice!)
ELSE IF FINAL_SATISFACTION >= 80:
    → OUTCOME = "Great" (Excellent!)
```

### 8.3 Star Ratings

| Stars | Requirements |
|-------|--------------|
| ⭐ | Satisfaction 50-64, Difference under tolerance |
| ⭐⭐ | Satisfaction 65-79, Difference under tolerance |
| ⭐⭐⭐ | Satisfaction 80+, Difference under tolerance |
| 💔 | Difference over tolerance OR Satisfaction under 50 |

### 8.4 Outcome Descriptions

#### "Too Different" (💔)
> Gary walks in and stops at the door. He looks around slowly.
> "It's... different." He's quiet. "Really different."
> He doesn't seem angry, just... lost. This doesn't feel like his space anymore.
>
> *You wanted to help, but maybe you went too far.*

#### "Not Enough" (💔)
> Gary walks in and glances around.
> "Oh, you were here?" He doesn't seem to notice anything changed.
> You put in the work, but it didn't make an impact.
>
> *Maybe next time, focus on the things that matter more.*

#### "Okay" (⭐)
> Gary walks in and does a small double-take.
> "Hey, did you clean a little? That's nice." He smiles.
> It's not a transformation, but he appreciates the gesture.
>
> *A good start. You're learning what he likes.*

#### "Good" (⭐⭐)
> Gary walks in and his eyes light up.
> "Whoa! This looks great!" He gives you a hug.
> "Seriously, I can actually see my desk now."
>
> *You found the balance. He feels helped, not judged.*

#### "Great" (⭐⭐⭐)
> Gary walks in and stops, amazed.
> "This is... incredible. It's still MY room but... better?"
> He's genuinely touched. "You really get me."
>
> *Perfect balance. He feels loved and understood.*

---

## 9. User Interface Screens

### 9.1 Main Menu

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│                                                        │
│               MESSY ROOM GAME                          │
│               ───────────────                          │
│                                                        │
│                   [Play]                               │
│                                                        │
│                 [Continue]                             │
│              (if saved game)                           │
│                                                        │
│                 [Settings]                             │
│                                                        │
│                                                        │
│                     v1.0                               │
└────────────────────────────────────────────────────────┘
```

### 9.2 Level Select (Character Select)

```
┌────────────────────────────────────────────────────────┐
│  SELECT BOYFRIEND                         [← Back]     │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌─────────────────────────────────────────────────┐   │
│  │  [Portrait]                                     │   │
│  │                                                 │   │
│  │  GARY "Gamer Gary"                              │   │
│  │  ───────────────────                            │   │
│  │  Difficulty: ★☆☆☆☆                             │   │
│  │                                                 │   │
│  │  Known traits:                                  │   │
│  │  • Needs gaming accessible 🎮                   │   │
│  │  • Appreciates cleanliness 🧹                   │   │
│  │                                                 │   │
│  │  Best result: ⭐⭐ (or "Not yet played")        │   │
│  │                                                 │   │
│  │              [Start Cleaning]                   │   │
│  │                                                 │   │
│  └─────────────────────────────────────────────────┘   │
│                                                        │
│  🔒 More boyfriends unlock as you earn stars!          │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### 9.3 Gameplay HUD

```
┌────────────────────────────────────────────────────────────────────┐
│ ⏸️  GARY'S ROOM                                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  SATISFACTION                          TIME                        │
│  😊 ████████░░ 72/100                 ⏰ 1:45:30                   │
│                                                                    │
│  DIFFERENCE                            BUDGET                      │
│  🔄 ███░░░░░░░ 28/100                 💵 $85                       │
│           (Tolerance: 60)                                          │
│                                                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│                    [ROOM VIEW - Interactive]                       │
│                                                                    │
│              Items are tappable. Tap to select.                    │
│                                                                    │
│                                                                    │
├────────────────────────────────────────────────────────────────────┤
│  TRAITS (Known)                                                    │
│  🎮 Gaming (HIGH)  |  🧹 Cleanliness (LOW)  |  ❓ Hidden trait      │
│                                                                    │
│                                          [Done Early]              │
└────────────────────────────────────────────────────────────────────┘
```

### 9.4 Item Interaction Menu

When you tap an item, a menu appears:

```
┌────────────────────────────────────────┐
│  COUCH                                 │
│  State: Very Dirty 🟤                  │
├────────────────────────────────────────┤
│                                        │
│  [🧹 Quick Clean]                      │
│   $5  •  10 min                        │
│   +3 satisfaction  •  +2 difference    │
│                                        │
│  [🧽 Deep Clean]                       │
│   $20  •  40 min                       │
│   +12 satisfaction  •  +7 difference   │
│                                        │
│  [❌ Cancel]                           │
│                                        │
└────────────────────────────────────────┘
```

### 9.5 Trait Discovery Popup

When you discover a hidden trait:

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│     💡 You discovered something!                       │
│                                                        │
│  ─────────────────────────────────────────────────     │
│                                                        │
│  That old trophy isn't junk - it's from Gary's         │
│  6th grade science fair. First place!                  │
│                                                        │
│  NEW TRAIT REVEALED:                                   │
│  📦 Sentimental about "junk" (MEDIUM)                  │
│                                                        │
│  Be careful with items that look like junk -           │
│  they might mean something to him!                     │
│                                                        │
│                   [Got it]                             │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### 9.6 Results Screen

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│                    ⭐⭐ GOOD JOB! ⭐⭐                          │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Gary walks in and his eyes light up.                          │
│  "Whoa! This looks great!" He gives you a hug.                 │
│  "Seriously, I can actually see my desk now."                  │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  FINAL STATS                                                   │
│  ─────────────                                                 │
│  Satisfaction: 72/100  ████████░░                              │
│  Difference: 45/60     ████████░░ (Under tolerance!)           │
│                                                                │
│  Time used: 2h 15m                                             │
│  Budget spent: $65                                             │
│  Actions taken: 14                                             │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│       [Try Again]              [Level Select]                  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 10. Example Playthrough

Let me walk you through a sample game session to show how everything works together.

### Starting State
- **Satisfaction**: 50
- **Difference**: 0
- **Budget**: $150
- **Time**: 3:00:00

### Action 1: Remove Pizza Boxes
> I tap the pizza boxes on the coffee table.
> Menu shows: Remove ($0, 5 min) → +8 satisfaction, +5 difference
> I select REMOVE.

**New State**: Satisfaction 58, Difference 5, Budget $150, Time 2:55:00

### Action 2: Clean Gaming Console
> I tap the dusty gaming console.
> Menu shows: Clean ($5, 10 min) → +5 satisfaction, +2 difference
> But wait - Gary has "needs gaming accessible" (HIGH)!
> This means: +5 × 2.0 = +10 satisfaction actually!
> I select CLEAN.

**New State**: Satisfaction 68, Difference 7, Budget $145, Time 2:45:00

### Action 3: Organize Game Cases
> I tap the scattered game cases.
> Menu shows: Organize ($0, 15 min) → +6 satisfaction, +4 difference
> I select ORGANIZE.

**New State**: Satisfaction 74, Difference 11, Budget $145, Time 2:30:00

### Action 4: Remove Soda Cans
> Quick win. +5 satisfaction, +2 difference.

**New State**: Satisfaction 79, Difference 13, Budget $145, Time 2:25:00

### Action 5: Clean Dirty Dishes
> Those dishes on the desk are gross.
> Menu shows: Clean ($10, 20 min) → +10 satisfaction, +4 difference
> I select CLEAN.

**New State**: Satisfaction 89, Difference 17, Budget $135, Time 2:05:00

### Action 6: MISTAKE - Try to Remove Old Trophy
> Hmm, that dusty trophy looks like junk. Let me remove it...
> I tap it and select REMOVE.
>
> **POPUP**: "Wait... this trophy has an inscription: 'First Place, 6th Grade Science Fair - Gary'"
> **NEW TRAIT REVEALED**: Sentimental about junk (MEDIUM)
> The action is CANCELLED. You stopped yourself.
> But now you know!

**New State**: Same (action was cancelled), but now I know about the hidden trait!

### Action 7: Clean Old Trophy (instead)
> Now I know it's sentimental. Let me just dust it off.
> Clean ($0, 5 min) → +2 satisfaction, +1 difference.

**New State**: Satisfaction 91, Difference 18, Budget $135, Time 2:00:00

### Action 8: Deep Clean Couch
> That couch is really gross. Let's do it properly.
> Deep Clean ($20, 40 min) → +12 satisfaction, +7 difference

**New State**: Satisfaction 100* (capped), Difference 25, Budget $115, Time 1:20:00

### Action 9: Make the Bed
> Quick clean action.
> Clean ($0, 10 min) → +4 satisfaction, +2 difference

**New State**: Satisfaction 100, Difference 27, Budget $115, Time 1:10:00

### Decision Point
> I could keep going, but I'm already at 100 satisfaction and only 27 difference (well under the 60 tolerance).
> More actions will only add to Difference without improving Satisfaction.
> I press **[Done Early]**.

### Final Result
- **Satisfaction**: 100/100 ⭐⭐⭐
- **Difference**: 27/60 (under tolerance!)
- **Rating**: 3 STARS!
- **Outcome**: "Great"

> Gary walks in and stops, amazed.
> "This is... incredible. It's still MY room but... better?"
> He's genuinely touched. "You really get me."

---

## 11. Glossary

| Term | Definition |
|------|------------|
| **Satisfaction** | A meter (0-100) representing how happy your boyfriend will be with the room changes. Higher is better. |
| **Difference** | A meter (0-100) tracking how much you've changed the room. Lower is better. |
| **Tolerance** | The maximum Difference a character can accept before feeling the room is "too different." |
| **Trait** | A characteristic that defines what a character cares about (e.g., "needs gaming accessible"). |
| **Revealed Trait** | A trait you know about from the start of a level. |
| **Hidden Trait** | A trait you don't know about until you interact with a related item. |
| **Intensity** | How strongly a trait affects satisfaction changes (Low, Medium, High). |
| **Category** | A grouping of similar items (gaming, furniture, food_trash, etc.). |
| **State** | The current condition of an item (clean, dirty, very_dirty, broken, etc.). |
| **Action/Interaction** | Something you can do to an item (clean, deep_clean, fix, replace, remove, move, organize). |
| **Budget** | The money you have available to spend on cleaning supplies and replacements. |
| **Time** | How long until your boyfriend comes home (in game time). |
| **Session** | One playthrough of a level, from start to "he comes home." |

---

## 12. Technical Notes for Implementation

### 12.1 Data-Driven Design

All game content should be stored in `.plist` files, not hardcoded:
- `Men.plist` - All boyfriend characters and their traits
- `Room_gary.plist` - All items in Gary's room
- `Interactions.plist` - All possible interactions and their base effects
- `Traits.plist` - All trait definitions

This lets you balance the game without changing code.

### 12.2 Formula Reference

**Satisfaction Change**:
```swift
let baseEffect = interaction.baseSatisfactionEffect
let traitModifier = calculateTraitModifier(item: item, traits: man.traits)
let intensityMultiplier = trait.intensity.multiplier // 1.0, 1.5, or 2.0
let finalChange = baseEffect + (traitModifier * intensityMultiplier)
satisfactionMeter.add(finalChange)
```

**Difference Change**:
```swift
let baseDifference = interaction.baseDifferencePoints
differenceMeter.add(baseDifference)
// Note: Difference ONLY goes up, never down
```

### 12.3 SpriteKit Scene Structure

```
GameplayScene (SKScene)
├── backgroundNode (SKSpriteNode) - Room background
├── roomNode (SKNode) - Container for all room items
│   ├── itemNodes[] (RoomItemNode : SKSpriteNode) - Individual items
├── hudNode (SKNode) - Heads-up display
│   ├── satisfactionMeterNode
│   ├── differenceMeterNode
│   ├── timerNode
│   ├── budgetNode
│   └── traitDisplayNode
├── interactionMenuNode (SKNode) - Popup menu (hidden until item tapped)
└── pauseMenuNode (SKNode) - Pause menu (hidden until paused)
```

### 12.4 Key Classes to Implement

1. **Man** - Character model with traits
2. **Trait** - Individual trait with type, intensity, revealed status
3. **RoomItem** - Item model with state, position, available actions
4. **Interaction** - Action model with costs, effects
5. **SatisfactionMeter** - Observable meter class
6. **DifferenceMeter** - Observable meter class
7. **GameSession** - Tracks current session state
8. **GameManager** - Coordinates game state across scenes
9. **DataManager** - Loads/saves data from plists and user defaults

### 12.5 Testing Checklist

- [ ] Can start a new game
- [ ] Can tap items and see interaction menu
- [ ] Satisfaction meter updates correctly
- [ ] Difference meter updates correctly
- [ ] Budget decreases when spending
- [ ] Time decreases as actions are taken
- [ ] Hidden trait reveals when triggered
- [ ] Game ends when time runs out
- [ ] Results screen shows correct outcome
- [ ] Can save and resume a session
- [ ] All item states display correctly

---

## Document End

This document describes version 1.0 of the Messy Room Game design. It will be updated as the game evolves.

**Questions?** This document should answer them, but if something is unclear, ask and we'll clarify.
