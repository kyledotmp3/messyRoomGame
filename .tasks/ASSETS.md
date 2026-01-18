# ASSETS Swimlane - Agent Task List

> **Owner**: agent-assets
> **Purpose**: Sprites, textures, visual effects

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
| A1.1 | Set up Assets.xcassets | [ ] | SCENES S1.1 | Assets.xcassets/ | Organized catalog |
| A1.2 | Create placeholder sprites | [ ] | A1.1 | Assets.xcassets/Items/ | Colored rectangles |
| A1.3 | Define sprite naming convention | [ ] | A1.1 | ASSETS_GUIDE.md | Documentation |

**Phase 1 Complete**: [ ] (all 3 tasks done)

---

## Phase 2: Core Systems

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| A2.1 | Create room background sprite | [ ] | A1.1 | room_gary_bg.png | Gary's room |
| A2.2 | Create item sprites (dirty) | [ ] | A1.2 | Items/*.png | 26 items dirty |
| A2.3 | Create item sprites (clean) | [ ] | A1.2 | Items/*.png | 26 items clean |
| A2.4 | Create HUD meter sprites | [ ] | A1.1 | UI/Meters/*.png | Backgrounds, fills |

**Phase 2 Complete**: [ ] (all 4 tasks done)

---

## Phase 3: Gameplay

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| A3.1 | Create interaction menu sprites | [ ] | A2.4 | UI/Menu/*.png | Button backgrounds |
| A3.2 | Create action icons | [ ] | A3.1 | UI/Icons/*.png | Clean, fix, etc. |
| A3.3 | Create trait icons | [ ] | A3.1 | UI/Traits/*.png | Gaming, etc. |
| A3.4 | Create popup backgrounds | [ ] | A3.1 | UI/Popups/*.png | Discovery frame |

**Phase 3 Complete**: [ ] (all 4 tasks done)

---

## Phase 4: Integration

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| A4.1 | Create Gary portrait | [ ] | A1.1 | Characters/gary_portrait.png | Level select |
| A4.2 | Create reaction sprites | [ ] | A4.1 | Characters/gary_*.png | Happy, upset, etc. |
| A4.3 | Create star rating sprites | [ ] | A2.4 | UI/Stars/*.png | 1-3 stars |
| A4.4 | Create locked char placeholder | [ ] | A4.1 | Characters/locked.png | Silhouette + lock |

**Phase 4 Complete**: [ ] (all 4 tasks done)

---

## Phase 5: Polish

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| A5.1 | Create cleaning particle | [ ] | A2.3 | Effects/sparkle_*.png | 8 frames |
| A5.2 | Create removal particle | [ ] | A5.1 | Effects/poof_*.png | 5 frames |
| A5.3 | Create highlight effect | [ ] | A2.2 | Effects/glow.png | Selection glow |
| A5.4 | Final sprite polish | [ ] | All sprites | All | Consistent style |
| A5.5 | App icon | [ ] | - | AppIcon | 1024x1024 |

**Phase 5 Complete**: [ ] (all 5 tasks done)

---

## Asset Specifications

### Sprite Naming Convention
```
{category}_{item}_{state}.png

Examples:
- gaming_console_dirty.png
- gaming_console_clean.png
- furniture_couch_very_dirty.png
- furniture_couch_dirty.png
- furniture_couch_clean.png
```

### Required Sizes
| Type | Size | Notes |
|------|------|-------|
| Room background | 1920x1080 | @2x for retina |
| Large items (couch, bed) | 256x256 | Furniture |
| Medium items (chair, desk) | 128x128 | Most items |
| Small items (cans, wrappers) | 64x64 | Trash, small objects |
| Icons | 48x48 | Action icons |
| Meter fills | 200x24 | Horizontal bars |
| Character portrait | 300x400 | Level select |
| App icon | 1024x1024 | All sizes generated |

### Color Palette (Suggested)
| Use | Color | Hex |
|-----|-------|-----|
| Clean state | Soft white | #F5F5F5 |
| Dirty state | Beige/tan | #D4C4A8 |
| Very dirty | Brown | #8B7355 |
| Satisfaction fill | Green | #4CAF50 |
| Difference fill | Orange | #FF9800 |
| Warning | Red | #F44336 |
| UI background | Light blue | #E3F2FD |
| Text | Dark gray | #333333 |

### Placeholder Sprite Colors (Phase 1)
| Category | Color | Hex |
|----------|-------|-----|
| Gaming | Purple | #9C27B0 |
| Electronics | Blue | #2196F3 |
| Furniture | Brown | #795548 |
| Clothing | Pink | #E91E63 |
| Food/Trash | Green | #4CAF50 |
| Decor | Yellow | #FFEB3B |
| Junk | Gray | #9E9E9E |

---

## Item Sprite Checklist

### Gaming (4 items)
| Item | Dirty | Clean | Other States |
|------|-------|-------|--------------|
| gaming_console | [ ] | [ ] | - |
| controllers | [ ] | [ ] | organized [ ] |
| gaming_chair | [ ] | [ ] | - |
| game_cases | [ ] | - | organized [ ] |

### Electronics (4 items)
| Item | Dirty | Clean | Other States |
|------|-------|-------|--------------|
| computer | [ ] | [ ] | - |
| monitor | [ ] | [ ] | - |
| cables | [ ] | - | organized [ ] |
| phone_charger | [ ] | [ ] | - |

### Furniture (5 items)
| Item | Dirty | Clean | Other States |
|------|-------|-------|--------------|
| couch | [ ] very_dirty | [ ] dirty | [ ] clean |
| bed | [ ] dirty | [ ] clean | - |
| desk | [ ] | [ ] | organized [ ] |
| nightstand | [ ] | [ ] | - |
| dresser | [ ] | [ ] | organized [ ] |

### Clothing (3 items)
| Item | Dirty | Clean | Other States |
|------|-------|-------|--------------|
| clothes_pile | [ ] | - | organized [ ] |
| laundry_basket | [ ] overflow | [ ] neat | - |
| shoes | [ ] scatter | [ ] organize | - |

### Food/Trash (4 items)
| Item | State | Removed |
|------|-------|---------|
| pizza_boxes | [ ] | N/A (disappears) |
| dishes_pile | [ ] dirty | [ ] clean |
| soda_cans | [ ] | N/A |
| snack_wrappers | [ ] | N/A |

### Decor (3 items)
| Item | Dirty/Bad | Clean/Good | Other |
|------|-----------|------------|-------|
| poster_gaming | [ ] crooked | [ ] straight | - |
| dead_plant | [ ] dead | - | new [ ] |
| lamp | [ ] broken | [ ] fixed | new [ ] |

### Junk (3 items)
| Item | Dusty | Clean |
|------|-------|-------|
| old_trophy | [ ] | [ ] |
| random_box | [ ] | [ ] |
| childhood_toy | [ ] | [ ] |
