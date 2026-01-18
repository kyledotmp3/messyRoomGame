import SpriteKit

// MARK: - Gameplay Scene

/// Main gameplay scene where cleaning happens.
/// Displays the room, items, HUD, and handles interactions.
class GameplayScene: BaseScene {

    // MARK: - Properties

    var session: GameSession!

    private var hudNode: HUDNode!
    private var roomNode: SKNode!
    private var itemNodes: [String: SKSpriteNode] = [:]
    private var interactionMenu: InteractionMenuNode?
    private var doneButton: SKLabelNode!

    // MARK: - Setup

    override func setupScene() {
        backgroundColor = SKColor(red: 0.9, green: 0.88, blue: 0.85, alpha: 1.0)

        guard session != nil else {
            print("Error: GameplayScene requires a session!")
            return
        }

        setupRoom()
        setupItems()
        setupHUD()
        setupDoneButton()
    }

    private func setupRoom() {
        // Room container
        roomNode = SKNode()
        roomNode.position = CGPoint(x: 0, y: 120) // Offset for HUD
        addChild(roomNode)

        // Room background (placeholder - would be actual sprite)
        let roomBg = SKShapeNode(rectOf: size)
        roomBg.fillColor = SKColor(red: 0.85, green: 0.83, blue: 0.80, alpha: 1.0)
        roomBg.strokeColor = .clear
        roomBg.position = CGPoint(x: size.width / 2, y: size.height / 2 - 60)
        roomBg.zPosition = -1
        roomNode.addChild(roomBg)

        // Room label
        let roomLabel = SKLabelNode(text: "\(session.man.name)'s Room")
        roomLabel.fontSize = 24
        roomLabel.fontColor = SKColor(white: 0.5, alpha: 0.5)
        roomLabel.fontName = "Helvetica-Bold"
        roomLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        roomLabel.zPosition = -0.5
        roomNode.addChild(roomLabel)
    }

    private func setupItems() {
        for item in session.room.items {
            let itemNode = createItemNode(for: item)
            roomNode.addChild(itemNode)
            itemNodes[item.id] = itemNode
        }
    }

    private func createItemNode(for item: RoomItem) -> SKSpriteNode {
        // Convert normalized position (0-1) to scene coordinates
        let x = item.position.x * size.width
        let y = item.position.y * (size.height - 120) // Account for HUD

        // Create a placeholder colored square
        // In real game, this would load the actual sprite
        let nodeSize = CGSize(width: 40, height: 40)
        let texture = createPlaceholderTexture(for: item, size: nodeSize)

        let node = SKSpriteNode(texture: texture, size: nodeSize)
        node.position = CGPoint(x: x, y: y)
        node.name = item.id

        // Add label with item name
        let label = SKLabelNode(text: item.name)
        label.fontSize = 10
        label.fontColor = .white
        label.fontName = "Helvetica-Bold"
        label.position = CGPoint(x: 0, y: -25)
        node.addChild(label)

        return node
    }

    private func createPlaceholderTexture(for item: RoomItem, size: CGSize) -> SKTexture {
        // Create colored square based on category
        let color: SKColor
        switch item.category {
        case .gaming:
            color = SKColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0) // Purple
        case .electronics:
            color = SKColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 1.0) // Blue
        case .furniture:
            color = SKColor(red: 0.6, green: 0.4, blue: 0.3, alpha: 1.0) // Brown
        case .clothing:
            color = SKColor(red: 0.9, green: 0.5, blue: 0.7, alpha: 1.0) // Pink
        case .foodTrash:
            color = SKColor(red: 0.5, green: 0.8, blue: 0.4, alpha: 1.0) // Green
        case .books:
            color = SKColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0) // Yellow
        case .decor:
            color = SKColor(red: 0.9, green: 0.9, blue: 0.5, alpha: 1.0) // Light yellow
        case .junk:
            color = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) // Gray
        }

        // Create texture
        let renderer = SKView()
        let square = SKShapeNode(rectOf: size, cornerRadius: 4)
        square.fillColor = color
        square.strokeColor = .white
        square.lineWidth = 2

        return renderer.texture(from: square)!
    }

    private func setupHUD() {
        hudNode = HUDNode(session: session, size: size)
        hudNode.zPosition = 100
        addChild(hudNode)
    }

    private func setupDoneButton() {
        doneButton = createButton(
            text: "Done Early",
            fontSize: 18,
            color: SKColor(red: 0.4, green: 0.6, blue: 0.9, alpha: 1.0),
            position: CGPoint(x: size.width - 80, y: 30)
        )
        doneButton.zPosition = 100
        addChild(doneButton)
    }

    // MARK: - Input Handling

    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        handleInput(at: location)
    }
    #else
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        handleInput(at: location)
    }
    #endif

    private func handleInput(at location: CGPoint) {
        // Check if interaction menu is open
        if let menu = interactionMenu {
            menu.handleTouch(at: convert(location, to: menu))
            return
        }

        // Check done button
        if doneButton.contains(location) {
            endSessionEarly()
            return
        }

        // Check item taps
        let roomLocation = convert(location, to: roomNode)
        for (itemId, node) in itemNodes {
            if node.contains(roomLocation) {
                handleItemTapped(itemId: itemId)
                return
            }
        }
    }

    // MARK: - Game Logic

    private func handleItemTapped(itemId: String) {
        guard let item = session.room.item(withId: itemId) else { return }

        // Show interaction menu
        showInteractionMenu(for: item)
    }

    private func showInteractionMenu(for item: RoomItem) {
        // Remove existing menu if any
        interactionMenu?.removeFromParent()

        // Create new menu
        let menu = InteractionMenuNode(item: item, session: session) { [weak self] interaction in
            self?.performInteraction(interaction, on: item)
        }
        menu.position = centerPoint
        menu.zPosition = 200
        addChild(menu)
        interactionMenu = menu
    }

    private func performInteraction(_ interaction: Interaction, on item: RoomItem) {
        // Perform the interaction through the session
        let result = session.performInteraction(interaction, onItem: item)

        // Update HUD
        hudNode.update()

        // Update item visual if it changed state
        if let newState = result.newItemState {
            updateItemVisual(itemId: item.id, newState: newState)
        }

        // Remove item visual if it was removed
        if interaction.type == .remove {
            itemNodes[item.id]?.removeFromParent()
            itemNodes.removeValue(forKey: item.id)
        }

        // Show discovery popup if trait was discovered
        if let trait = result.traitDiscovered {
            showDiscoveryPopup(for: trait, item: item)
        }

        // Check if time ran out
        if session.isOutOfTime {
            endSession()
        }
    }

    private func updateItemVisual(itemId: String, newState: ItemState) {
        // In real game, would change sprite
        // For now, just flash the node
        guard let node = itemNodes[itemId] else { return }

        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        node.run(SKAction.repeat(flash, count: 2))
    }

    private func showDiscoveryPopup(for trait: Trait, item: RoomItem) {
        // Create discovery popup
        let popup = SKNode()
        popup.position = centerPoint
        popup.zPosition = 300

        // Background
        let bg = SKShapeNode(rectOf: CGSize(width: 350, height: 200), cornerRadius: 12)
        bg.fillColor = SKColor(white: 0.95, alpha: 1.0)
        bg.strokeColor = SKColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0)
        bg.lineWidth = 3
        popup.addChild(bg)

        // Title
        let title = SKLabelNode(text: "💡 Discovery!")
        title.fontSize = 24
        title.fontColor = SKColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
        title.fontName = "Helvetica-Bold"
        title.position = CGPoint(x: 0, y: 60)
        popup.addChild(title)

        // Discovery text
        let text = SKLabelNode(text: item.discoveryText ?? "You discovered something!")
        text.fontSize = 14
        text.fontColor = SKColor(white: 0.3, alpha: 1.0)
        text.fontName = "Helvetica"
        text.position = CGPoint(x: 0, y: 20)
        text.numberOfLines = 3
        text.preferredMaxLayoutWidth = 300
        popup.addChild(text)

        // Trait revealed
        let traitLabel = SKLabelNode(text: "Trait Revealed: \(trait.type.rawValue)")
        traitLabel.fontSize = 16
        traitLabel.fontColor = SKColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0)
        traitLabel.fontName = "Helvetica-Bold"
        traitLabel.position = CGPoint(x: 0, y: -30)
        popup.addChild(traitLabel)

        // OK button
        let okButton = SKLabelNode(text: "Got it")
        okButton.fontSize = 18
        okButton.fontColor = SKColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 1.0)
        okButton.fontName = "Helvetica-Bold"
        okButton.position = CGPoint(x: 0, y: -70)
        okButton.name = "discovery_ok"
        popup.addChild(okButton)

        addChild(popup)

        // Auto-dismiss after tap or 5 seconds
        let wait = SKAction.wait(forDuration: 5)
        let remove = SKAction.removeFromParent()
        popup.run(SKAction.sequence([wait, remove]))
    }

    private func endSessionEarly() {
        endSession()
    }

    private func endSession() {
        // Calculate final result
        let result = session.endSession()

        // Save result
        GameManager.shared.endSession(with: result)

        // Transition to results
        let resultsScene = SceneManager.shared.createResultsScene(result: result, man: session.man)
        transitionTo(resultsScene)
    }

    // MARK: - Update Loop

    override func update(_ currentTime: TimeInterval) {
        // Could update timer countdown here if implementing real-time clock
        // For now, time only advances when actions are performed
    }
}
