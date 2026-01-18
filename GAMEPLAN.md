# Messy Room Game - Concurrent Agent Gameplan

## Overview

This gameplan is structured for **5 concurrent agents** to work in parallel. Each agent owns a swimlane and updates its own task file.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CONCURRENT AGENT ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐                      │
│   │   MODELS    │   │   SCENES    │   │    DATA     │                      │
│   │   Agent     │   │   Agent     │   │   Agent     │                      │
│   │             │   │             │   │             │                      │
│   │ .tasks/     │   │ .tasks/     │   │ .tasks/     │                      │
│   │ MODELS.md   │   │ SCENES.md   │   │ DATA.md     │                      │
│   └──────┬──────┘   └──────┬──────┘   └──────┬──────┘                      │
│          │                 │                 │                              │
│          └────────────────┼────────────────┘                              │
│                           │                                                │
│                    ┌──────┴──────┐                                         │
│                    │  STATUS.md  │  ← Central coordination                 │
│                    └──────┬──────┘                                         │
│                           │                                                │
│          ┌────────────────┼────────────────┐                              │
│          │                │                │                              │
│   ┌──────┴──────┐   ┌─────┴─────┐   ┌─────┴─────┐                         │
│   │   ASSETS    │   │   AUDIO   │   │  (Future  │                         │
│   │   Agent     │   │   Agent   │   │  Agents)  │                         │
│   │             │   │           │   │           │                         │
│   │ .tasks/     │   │ .tasks/   │   │           │                         │
│   │ ASSETS.md   │   │ AUDIO.md  │   │           │                         │
│   └─────────────┘   └───────────┘   └───────────┘                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## File Structure

```
messyRoomGame/
├── .tasks/                    ← Agent task tracking
│   ├── STATUS.md              ← Central status (all agents read/write)
│   ├── MODELS.md              ← agent-models owns this
│   ├── SCENES.md              ← agent-scenes owns this
│   ├── DATA.md                ← agent-data owns this
│   ├── ASSETS.md              ← agent-assets owns this
│   └── AUDIO.md               ← agent-audio owns this
├── GAME_DESIGN.md             ← Reference document (read-only)
├── GAMEPLAN.md                ← This file (read-only)
└── MessyRoomGame/             ← Xcode project (agents write here)
```

---

## Agent Definitions

### agent-models
**Purpose**: Core data structures and game logic
**Owns**: `.tasks/MODELS.md`
**Writes to**: `MessyRoomGame/Models/`, `MessyRoomGame/Managers/`
**Dependencies**: None initially, later depends on project setup

### agent-scenes
**Purpose**: SpriteKit scenes, nodes, UI
**Owns**: `.tasks/SCENES.md`
**Writes to**: `MessyRoomGame/Scenes/`, `MessyRoomGame/Managers/`
**Dependencies**: Models for data types, Assets for sprites

### agent-data
**Purpose**: Plist files, game content, balancing
**Owns**: `.tasks/DATA.md`
**Writes to**: `MessyRoomGame/Resources/Data/`
**Dependencies**: Model schemas to know structure

### agent-assets
**Purpose**: Sprites, textures, visual effects
**Owns**: `.tasks/ASSETS.md`
**Writes to**: `MessyRoomGame/Assets.xcassets/`
**Dependencies**: Project setup, design specs

### agent-audio
**Purpose**: Sound effects, music
**Owns**: `.tasks/AUDIO.md`
**Writes to**: `MessyRoomGame/Resources/Sounds/`
**Dependencies**: Project setup

---

## How Agents Work

### Starting an Agent

Each agent should be spawned with these instructions:

```
You are {agent-name} working on the Messy Room Game.

Your task file: .tasks/{SWIMLANE}.md
Status file: .tasks/STATUS.md

Instructions:
1. Read your task file to see pending tasks
2. Check STATUS.md for current phase and blocking issues
3. Pick the next [ ] task in the current phase
4. Mark it [~] (in progress) in your task file
5. Complete the task (write code/files)
6. Mark it [x] (complete) in your task file
7. Update STATUS.md progress counter
8. Repeat until no more tasks in current phase

Phase Rules:
- Only work on tasks in the CURRENT PHASE (check STATUS.md)
- If blocked by another agent's task, note in STATUS.md and skip
- When your phase is complete, update STATUS.md

File Locking:
- Only modify YOUR task file
- STATUS.md can be modified by any agent (update your row)
```

### Task Status Markers

| Marker | Meaning |
|--------|---------|
| `[ ]` | Not started |
| `[~]` | In progress |
| `[x]` | Complete |
| `[!]` | Blocked |

### Cross-Agent Dependencies

When a task depends on another agent's work:

1. Check if dependency is complete (marked `[x]` in their file)
2. If not, mark your task `[!]` with note
3. Add blocking issue to STATUS.md
4. Move to next non-blocked task
5. Other agent will notify in STATUS.md when unblocked

---

## Spawning Agents

### Spawn All 5 Agents Concurrently

Use this prompt to spawn all agents at once:

```
Please spawn 5 concurrent agents for the Messy Room Game project:

1. agent-models (subagent_type: general-purpose)
   Task: Work through .tasks/MODELS.md Phase 1 tasks
   - Read GAME_DESIGN.md for model specifications
   - Create Swift files in MessyRoomGame/Models/

2. agent-scenes (subagent_type: general-purpose)
   Task: Work through .tasks/SCENES.md Phase 1 tasks
   - Start with Xcode project creation (S1.1)
   - Create scene files in MessyRoomGame/Scenes/

3. agent-data (subagent_type: general-purpose)
   Task: Work through .tasks/DATA.md Phase 1 tasks
   - Define plist schemas
   - Create DataManager.swift

4. agent-assets (subagent_type: general-purpose)
   Task: Work through .tasks/ASSETS.md Phase 1 tasks
   - Set up Assets.xcassets structure
   - Create placeholder sprites

5. agent-audio (subagent_type: general-purpose)
   Task: Work through .tasks/AUDIO.md Phase 1 tasks
   - Create AudioManager.swift
   - Add placeholder sounds

All agents should:
- Update their task file (.tasks/{NAME}.md) with progress
- Check .tasks/STATUS.md for phase and blocking issues
- Note dependencies on other agents
```

### Single Agent Spawn Template

```
Spawn agent-{name}:

You are agent-{name} for the Messy Room Game.

Read these files first:
- /Users/kyleb/projects/messyRoomGame/.tasks/{NAME}.md (your tasks)
- /Users/kyleb/projects/messyRoomGame/.tasks/STATUS.md (coordination)
- /Users/kyleb/projects/messyRoomGame/GAME_DESIGN.md (reference)

Work through Phase {N} tasks:
1. Find next [ ] task
2. Mark [~], do the work, mark [x]
3. Update STATUS.md counter
4. Repeat

Write output files to:
/Users/kyleb/projects/messyRoomGame/MessyRoomGame/{appropriate_folder}/
```

---

## Phase Progression

### Phase Complete Checklist

Before moving to next phase, ALL swimlanes must complete their current phase:

```
Phase 1 Complete when:
  [ ] MODELS: 6/6 tasks
  [ ] SCENES: 4/4 tasks
  [ ] DATA: 3/3 tasks
  [ ] ASSETS: 3/3 tasks
  [ ] AUDIO: 2/2 tasks
  → Update STATUS.md: Current Phase = 2
```

### Phase Dependencies

```
Phase 1 (Foundation)
├── All swimlanes can start immediately
├── SCENES creates project (S1.1) - others may need this
└── MODELS creates schemas - DATA needs these

Phase 2 (Core Systems)
├── All depend on Phase 1 complete
├── SCENES needs MODELS for data types
└── DATA needs MODELS schemas

Phase 3 (Gameplay)
├── MODELS needs SCENES for GameplayScene
├── SCENES needs MODELS for scoring
└── Strong interdependencies

Phase 4 (Integration)
├── All must work together
└── Sequential within swimlane

Phase 5 (Polish)
├── Can mostly parallel
└── Final integration at end
```

---

## Quick Reference

### What Each Agent Creates

| Agent | Phase 1 Output | Phase 2 Output |
|-------|----------------|----------------|
| MODELS | Man, Trait, RoomItem, Interaction, Meters | ScoreManager, formulas |
| SCENES | Xcode project, BaseScene, MainMenu, SceneManager | GameplayScene, HUD, RoomNodes |
| DATA | Schema docs, DataManager | Men.plist, Room_gary.plist, Interactions.plist |
| ASSETS | Assets.xcassets, placeholders, naming guide | Room bg, item sprites, HUD sprites |
| AUDIO | AudioManager, placeholder beeps | Action SFX (clean, fix, etc.) |

### File Ownership

| File/Folder | Owner |
|-------------|-------|
| Models/*.swift | agent-models |
| Scenes/*.swift | agent-scenes |
| Managers/DataManager.swift | agent-data |
| Managers/ScoreManager.swift | agent-models |
| Managers/SceneManager.swift | agent-scenes |
| Managers/AudioManager.swift | agent-audio |
| Resources/Data/*.plist | agent-data |
| Resources/Sounds/* | agent-audio |
| Assets.xcassets/* | agent-assets |

---

## Conflict Resolution

If two agents need to modify the same file:

1. **Prefer ownership** - Let the primary owner handle it
2. **Coordinate in STATUS.md** - Add note about shared work
3. **Sequential edit** - One agent finishes, then other continues

---

## Current Status

Check `.tasks/STATUS.md` for:
- Current phase
- Per-swimlane progress
- Active blocking issues
- Milestone status
