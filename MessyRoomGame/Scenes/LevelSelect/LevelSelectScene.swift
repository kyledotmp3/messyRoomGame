import SpriteKit

// MARK: - Level Select Scene

/// Character selection screen showing all unlocked boyfriends.
/// Displays each character's traits, difficulty, and best result.
/// Matches design spec in GAME_DESIGN.md section 9.2
class LevelSelectScene: BaseScene {

    // MARK: - Properties

    private var titleLabel: SKLabelNode!
    private var backButton: SKLabelNode!
    private var characterCards: [SKNode] = []
    private var unlockMessage: SKLabelNode!

    // MARK: - Setup

    override func setupScene() {
        backgroundColor = SKColor(red: 0.95, green: 0.93, blue: 0.90, alpha: 1.0)

        setupHeader()
        setupCharacterCards()
        setupUnlockMessage()
    }

    private func setupHeader() {
        // Title
        titleLabel = SKLabelNode(text: "SELECT BOYFRIEND")
        titleLabel.fontSize = 28
        titleLabel.fontColor = SKColor(white: 0.2, alpha: 1.0)
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        addChild(titleLabel)

        // Back button
        backButton = createButton(
            text: "← Back",
            fontSize: 20,
            color: SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
            position: CGPoint(x: 80, y: size.height - 60)
        )
        addChild(backButton)
    }

    private func setupCharacterCards() {
        let unlockedMen = GameManager.shared.unlockedMen
        let yStart = size.height - 140

        for (index, man) in unlockedMen.enumerated() {
            let cardY = yStart - CGFloat(index) * 280
            let card = createCharacterCard(for: man, at: cardY)
            addChild(card)
            characterCards.append(card)
        }
    }

    private func createCharacterCard(for man: Man, at yPos: CGFloat) -> SKNode {
        let card = SKNode()
        card.position = CGPoint(x: size.width / 2, y: yPos)
        card.name = "card_\(man.id)"

        // Card background
        let cardWidth: CGFloat = min(size.width - 60, 450)
        let cardHeight: CGFloat = 250

        let background = SKShapeNode(rectOf: CGSize(width: cardWidth, height: cardHeight), cornerRadius: 12)
        background.fillColor = SKColor(white: 1.0, alpha: 1.0)
        background.strokeColor = SKColor(white: 0.8, alpha: 1.0)
        background.lineWidth = 2
        card.addChild(background)

        // Portrait placeholder
        let portrait = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 8)
        portrait.fillColor = SKColor(red: 0.85, green: 0.85, blue: 0.9, alpha: 1.0)
        portrait.strokeColor = SKColor(white: 0.7, alpha: 1.0)
        portrait.lineWidth = 2
        portrait.position = CGPoint(x: -cardWidth / 2 + 60, y: 40)
        card.addChild(portrait)

        let portraitLabel = SKLabelNode(text: "👨")
        portraitLabel.fontSize = 48
        portraitLabel.position = CGPoint(x: -cardWidth / 2 + 60, y: 20)
        card.addChild(portraitLabel)

        // Name
        let nameLabel = SKLabelNode(text: "\(man.name) \"\(man.nickname)\"")
        nameLabel.fontSize = 22
        nameLabel.fontColor = SKColor(white: 0.2, alpha: 1.0)
        nameLabel.fontName = "Helvetica-Bold"
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: -cardWidth / 2 + 120, y: 80)
        card.addChild(nameLabel)

        // Difficulty
        let stars = String(repeating: "★", count: man.difficultyRating) +
                    String(repeating: "☆", count: 5 - man.difficultyRating)
        let difficultyLabel = SKLabelNode(text: "Difficulty: \(stars)")
        difficultyLabel.fontSize = 14
        difficultyLabel.fontColor = SKColor(white: 0.4, alpha: 1.0)
        difficultyLabel.fontName = "Helvetica"
        difficultyLabel.horizontalAlignmentMode = .left
        difficultyLabel.position = CGPoint(x: -cardWidth / 2 + 120, y: 55)
        card.addChild(difficultyLabel)

        // Known traits
        let revealedTraits = man.traits.filter { $0.isRevealed }
        let traitsLabel = SKLabelNode(text: "Known traits:")
        traitsLabel.fontSize = 14
        traitsLabel.fontColor = SKColor(white: 0.4, alpha: 1.0)
        traitsLabel.fontName = "Helvetica-Bold"
        traitsLabel.horizontalAlignmentMode = .left
        traitsLabel.position = CGPoint(x: -cardWidth / 2 + 120, y: 25)
        card.addChild(traitsLabel)

        var traitY: CGFloat = 5
        for trait in revealedTraits.prefix(2) {
            let emoji = trait.type.emoji
            let traitText = SKLabelNode(text: "• \(emoji) \(trait.type.displayName)")
            traitText.fontSize = 12
            traitText.fontColor = SKColor(white: 0.5, alpha: 1.0)
            traitText.fontName = "Helvetica"
            traitText.horizontalAlignmentMode = .left
            traitText.position = CGPoint(x: -cardWidth / 2 + 130, y: traitY)
            card.addChild(traitText)
            traitY -= 18
        }

        // Best result
        let bestResult = GameManager.shared.bestResult(for: man.id)
        let resultText: String
        if let result = bestResult {
            let stars = String(repeating: "⭐", count: result.stars)
            resultText = "Best result: \(stars)"
        } else {
            resultText = "Best result: Not yet played"
        }

        let resultLabel = SKLabelNode(text: resultText)
        resultLabel.fontSize = 14
        resultLabel.fontColor = SKColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0)
        resultLabel.fontName = "Helvetica"
        resultLabel.horizontalAlignmentMode = .left
        resultLabel.position = CGPoint(x: -cardWidth / 2 + 120, y: -25)
        card.addChild(resultLabel)

        // Backstory
        let backstory = SKLabelNode()
        backstory.text = man.backstory
        backstory.fontSize = 11
        backstory.fontColor = SKColor(white: 0.5, alpha: 1.0)
        backstory.fontName = "Helvetica"
        backstory.numberOfLines = 2
        backstory.preferredMaxLayoutWidth = cardWidth - 140
        backstory.horizontalAlignmentMode = .left
        backstory.verticalAlignmentMode = .top
        backstory.position = CGPoint(x: -cardWidth / 2 + 120, y: -50)
        card.addChild(backstory)

        // Start button
        let startButton = createButton(
            text: "Start Cleaning",
            fontSize: 20,
            color: SKColor(red: 0.3, green: 0.7, blue: 0.4, alpha: 1.0),
            position: CGPoint(x: cardWidth / 2 - 100, y: -90)
        )
        startButton.name = "start_\(man.id)"
        card.addChild(startButton)

        return card
    }

    private func setupUnlockMessage() {
        unlockMessage = SKLabelNode(text: "🔒 More boyfriends unlock as you earn stars!")
        unlockMessage.fontSize = 14
        unlockMessage.fontColor = SKColor(white: 0.5, alpha: 1.0)
        unlockMessage.fontName = "Helvetica"
        unlockMessage.position = CGPoint(x: size.width / 2, y: 50)
        addChild(unlockMessage)
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
        // Check back button
        if backButton.contains(location) {
            goBack()
            return
        }

        // Check start buttons in character cards
        for card in characterCards {
            let cardLocation = convert(location, to: card)
            for child in card.children {
                if let button = child as? SKLabelNode,
                   button.name?.starts(with: "start_") == true,
                   button.contains(cardLocation) {
                    // Extract man ID from button name
                    let manId = button.name!.replacingOccurrences(of: "start_", with: "")
                    startGame(for: manId)
                    return
                }
            }
        }
    }

    // MARK: - Actions

    private func goBack() {
        let mainMenu = SceneManager.shared.createMainMenuScene()
        transitionTo(mainMenu)
    }

    private func startGame(for manId: String) {
        guard let man = GameManager.shared.man(withId: manId) else {
            print("Error: Could not find man with ID \(manId)")
            return
        }

        guard let session = GameManager.shared.startSession(for: man) else {
            print("Error: Could not create session for \(manId)")
            return
        }

        let gameplayScene = SceneManager.shared.createGameplayScene(for: session)
        transitionTo(gameplayScene)
    }
}
