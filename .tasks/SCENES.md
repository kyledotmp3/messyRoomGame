# SCENES Swimlane - Agent Task List

> **Owner**: agent-scenes
> **Purpose**: SpriteKit scenes, nodes, and UI components

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
| S1.1 | Create Xcode SpriteKit project | [ ] | - | MessyRoomGame.xcodeproj | iOS 17+, macOS 14+ |
| S1.2 | Create BaseScene.swift | [ ] | S1.1 | Scenes/Base/BaseScene.swift | Common scene functionality |
| S1.3 | Create SceneManager.swift | [ ] | S1.2 | Managers/SceneManager.swift | Scene transitions |
| S1.4 | Create MainMenuScene.swift | [ ] | S1.2 | Scenes/Menu/MainMenuScene.swift | Play button |

**Phase 1 Complete**: [ ] (all 4 tasks done)

---

## Phase 2: Core Systems

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| S2.1 | Create GameplayScene.swift | [ ] | S1.2 | Scenes/Gameplay/GameplayScene.swift | Main gameplay shell |
| S2.2 | Add HUD to GameplayScene | [ ] | S2.1 | Scenes/Gameplay/Nodes/HUDNode.swift | Meters, timer, budget |
| S2.3 | Create RoomNode.swift | [ ] | S2.1 | Scenes/Gameplay/Nodes/RoomNode.swift | Room container |
| S2.4 | Create RoomItemNode.swift | [ ] | S2.3, MODELS M1.3 | Scenes/Gameplay/Nodes/RoomItemNode.swift | Tappable item sprite |
| S2.5 | Implement item tap detection | [ ] | S2.4 | GameplayScene+Input.swift | Touch/click handling |

**Phase 2 Complete**: [ ] (all 5 tasks done)

---

## Phase 3: Gameplay

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| S3.1 | Create InteractionMenuNode.swift | [ ] | S2.5 | Scenes/Gameplay/Nodes/InteractionMenuNode.swift | Action popup |
| S3.2 | Show action costs in menu | [ ] | S3.1, MODELS M3.3 | InteractionMenuNode.swift | $, time, effects preview |
| S3.3 | Create TraitDiscoveryPopup.swift | [ ] | MODELS M3.4 | Scenes/Gameplay/Nodes/TraitDiscoveryPopup.swift | "You discovered!" |
| S3.4 | Add trait panel to HUD | [ ] | S2.2 | HUDNode.swift | Known traits display |
| S3.5 | Implement timer display | [ ] | S2.2, MODELS M3.2 | HUDNode.swift | Countdown |
| S3.6 | Implement budget display | [ ] | S2.2, MODELS M3.3 | HUDNode.swift | Remaining $ |

**Phase 3 Complete**: [ ] (all 6 tasks done)

---

## Phase 4: Integration

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| S4.1 | Create ResultsScene.swift | [ ] | MODELS M4.1 | Scenes/Results/ResultsScene.swift | Outcome display |
| S4.2 | Add narrative text to results | [ ] | S4.1 | ResultsScene.swift | "Gary walks in..." |
| S4.3 | Create LevelSelectScene.swift | [ ] | MODELS M4.3 | Scenes/LevelSelect/LevelSelectScene.swift | Character select |
| S4.4 | Add best result display | [ ] | S4.3 | LevelSelectScene.swift | Stars per character |
| S4.5 | Add "Continue" to main menu | [ ] | MODELS M4.5 | MainMenuScene.swift | Resume option |
| S4.6 | Implement "Done Early" button | [ ] | MODELS M3.1 | GameplayScene.swift | End session |

**Phase 4 Complete**: [ ] (all 6 tasks done)

---

## Phase 5: Polish

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| S5.1 | Add scene transitions | [ ] | S4.* | SceneManager.swift | Fade/slide effects |
| S5.2 | Add item state animations | [ ] | S2.4 | RoomItemNode.swift | Dirty→clean |
| S5.3 | Add meter fill animations | [ ] | S2.2 | HUDNode.swift | Smooth changes |
| S5.4 | Create SettingsScene.swift | [ ] | MODELS M5.2 | Scenes/Menu/SettingsScene.swift | Volume sliders |
| S5.5 | Add tutorial overlay | [ ] | S2.1 | Scenes/Gameplay/TutorialOverlay.swift | First-time hints |

**Phase 5 Complete**: [ ] (all 5 tasks done)

---

## Code Templates

### BaseScene.swift Template
```swift
import SpriteKit

class BaseScene: SKScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }

    func setupScene() {
        // Override in subclasses
    }

    func transitionTo(_ scene: BaseScene, duration: TimeInterval = 0.5) {
        let transition = SKTransition.fade(withDuration: duration)
        view?.presentScene(scene, transition: transition)
    }
}
```

### GameplayScene.swift Template
```swift
import SpriteKit

class GameplayScene: BaseScene {

    // MARK: - Nodes
    private var roomNode: RoomNode!
    private var hudNode: HUDNode!
    private var interactionMenu: InteractionMenuNode?

    // MARK: - Game State
    private var session: GameSession!

    // MARK: - Setup
    override func setupScene() {
        backgroundColor = .white
        setupRoom()
        setupHUD()
    }

    private func setupRoom() {
        roomNode = RoomNode()
        addChild(roomNode)
    }

    private func setupHUD() {
        hudNode = HUDNode()
        addChild(hudNode)
    }

    // MARK: - Input (see GameplayScene+Input.swift)
}
```

### RoomItemNode.swift Template
```swift
import SpriteKit

class RoomItemNode: SKSpriteNode {

    let item: RoomItem

    init(item: RoomItem) {
        self.item = item
        let texture = SKTexture(imageNamed: item.spriteName)
        super.init(texture: texture, color: .clear, size: texture.size())

        self.name = item.id
        self.isUserInteractionEnabled = true
        self.position = item.position
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    func updateForState(_ state: ItemState) {
        // Update sprite based on state
        let textureName = "\(item.baseSpriteName)_\(state.rawValue)"
        self.texture = SKTexture(imageNamed: textureName)
    }
}
```
