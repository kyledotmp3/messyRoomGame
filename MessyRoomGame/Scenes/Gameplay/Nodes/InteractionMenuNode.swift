import SpriteKit

// MARK: - Interaction Menu Node

/// Popup menu showing available actions for a selected item.
/// Displays cost, time, and effect previews for each action.
class InteractionMenuNode: SKNode {

    // MARK: - Properties

    private let item: RoomItem
    private let session: GameSession
    private var onActionSelected: ((Interaction) -> Void)?

    private var background: SKShapeNode!
    private var titleLabel: SKLabelNode!
    private var actionButtons: [SKLabelNode] = []

    // MARK: - Constants

    private let menuWidth: CGFloat = 300
    private let menuHeight: CGFloat = 400
    private let buttonHeight: CGFloat = 60

    // MARK: - Initialization

    init(item: RoomItem, session: GameSession, onActionSelected: @escaping (Interaction) -> Void) {
        self.item = item
        self.session = session
        self.onActionSelected = onActionSelected
        super.init()

        setupMenu()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Setup

    private func setupMenu() {
        // Semi-transparent backdrop
        let backdrop = SKShapeNode(rectOf: CGSize(width: 2000, height: 2000))
        backdrop.fillColor = SKColor(white: 0, alpha: 0.5)
        backdrop.strokeColor = .clear
        backdrop.zPosition = -1
        backdrop.name = "backdrop"
        addChild(backdrop)

        // Menu background
        background = SKShapeNode(rectOf: CGSize(width: menuWidth, height: menuHeight), cornerRadius: 12)
        background.fillColor = SKColor(white: 0.95, alpha: 1.0)
        background.strokeColor = SKColor(white: 0.6, alpha: 1.0)
        background.lineWidth = 2
        addChild(background)

        // Title
        titleLabel = SKLabelNode(text: item.name)
        titleLabel.fontSize = 20
        titleLabel.fontColor = SKColor(white: 0.2, alpha: 1.0)
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.position = CGPoint(x: 0, y: menuHeight / 2 - 40)
        addChild(titleLabel)

        // State label
        let stateLabel = SKLabelNode(text: "State: \(item.state.displayName)")
        stateLabel.fontSize = 14
        stateLabel.fontColor = SKColor(white: 0.4, alpha: 1.0)
        stateLabel.fontName = "Helvetica"
        stateLabel.position = CGPoint(x: 0, y: menuHeight / 2 - 65)
        addChild(stateLabel)

        // Action buttons
        setupActionButtons()

        // Cancel button
        let cancelButton = SKLabelNode(text: "❌ Cancel")
        cancelButton.fontSize = 18
        cancelButton.fontColor = SKColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
        cancelButton.fontName = "Helvetica-Bold"
        cancelButton.position = CGPoint(x: 0, y: -menuHeight / 2 + 30)
        cancelButton.name = "cancel"
        addChild(cancelButton)
    }

    private func setupActionButtons() {
        let startY = menuHeight / 2 - 100
        var yPos = startY

        for interaction in item.interactions {
            let button = createActionButton(for: interaction, at: yPos)
            addChild(button)
            actionButtons.append(button)
            yPos -= buttonHeight + 10
        }
    }

    private func createActionButton(for interaction: Interaction, at yPos: CGFloat) -> SKLabelNode {
        // Check if affordable and enough time
        let canAfford = session.canAfford(interaction.cost)
        let hasTime = session.hasTime(interaction.timeMinutes)
        let isAvailable = canAfford && hasTime

        // Main button label
        let actionName = interaction.type.displayName
        let costText = interaction.costDisplay
        let timeText = interaction.timeDisplay

        let button = SKLabelNode()
        button.fontSize = 16
        button.fontName = "Helvetica"
        button.position = CGPoint(x: 0, y: yPos)
        button.name = "action_\(interaction.type.rawValue)"

        // Build button text with effects preview
        let satChange = interaction.satisfactionPreview
        let diffChange = interaction.differencePreview
        let buttonText = """
        \(actionName)
        \(costText) • \(timeText)
        Sat: \(satChange) | Diff: \(diffChange)
        """

        button.text = buttonText
        button.numberOfLines = 3

        // Color based on availability
        if isAvailable {
            button.fontColor = SKColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1.0)
        } else {
            button.fontColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        }

        // Add background for button
        let buttonBg = SKShapeNode(rectOf: CGSize(width: menuWidth - 40, height: buttonHeight), cornerRadius: 8)
        buttonBg.fillColor = isAvailable ?
            SKColor(red: 0.9, green: 0.95, blue: 0.9, alpha: 1.0) :
            SKColor(white: 0.85, alpha: 1.0)
        buttonBg.strokeColor = .clear
        buttonBg.zPosition = -1
        button.addChild(buttonBg)

        return button
    }

    // MARK: - Input Handling

    func handleTouch(at location: CGPoint) {
        // Check cancel button
        if let cancelNode = childNode(withName: "cancel") as? SKLabelNode,
           cancelNode.contains(location) {
            dismiss()
            return
        }

        // Check action buttons
        for button in actionButtons {
            if button.contains(location),
               let actionName = button.name?.replacingOccurrences(of: "action_", with: ""),
               let interaction = item.interactions.first(where: { $0.type.rawValue == actionName }) {
                // Verify can perform
                if session.canAfford(interaction.cost) && session.hasTime(interaction.timeMinutes) {
                    onActionSelected?(interaction)
                    dismiss()
                }
                return
            }
        }
    }

    // MARK: - Dismiss

    private func dismiss() {
        removeFromParent()
    }
}
