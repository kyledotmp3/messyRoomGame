import SpriteKit

// MARK: - Results Scene

/// Shows the outcome of a cleaning session.
/// Displays narrative text, star rating, and final statistics.
class ResultsScene: BaseScene {

    // MARK: - Properties

    var result: GameResult!
    var man: Man!

    private var starsLabel: SKLabelNode!
    private var outcomeLabel: SKLabelNode!
    private var narrativeLabel: SKLabelNode!
    private var statsLabel: SKLabelNode!
    private var tryAgainButton: SKLabelNode!
    private var menuButton: SKLabelNode!

    // MARK: - Setup

    override func setupScene() {
        guard result != nil && man != nil else {
            print("Error: ResultsScene requires result and man!")
            return
        }

        backgroundColor = result.isPassed ?
            SKColor(red: 0.92, green: 0.95, blue: 0.92, alpha: 1.0) :
            SKColor(red: 0.95, green: 0.92, blue: 0.92, alpha: 1.0)

        setupOutcome()
        setupNarrative()
        setupStats()
        setupButtons()
    }

    private func setupOutcome() {
        // Stars
        let starsText = result.outcome.emoji
        starsLabel = SKLabelNode(text: starsText)
        starsLabel.fontSize = 48
        starsLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        addChild(starsLabel)

        // Outcome title
        outcomeLabel = SKLabelNode(text: result.outcome.displayName)
        outcomeLabel.fontSize = 32
        outcomeLabel.fontColor = result.isPassed ?
            SKColor(red: 0.3, green: 0.7, blue: 0.4, alpha: 1.0) :
            SKColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
        outcomeLabel.fontName = "Helvetica-Bold"
        outcomeLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.76)
        addChild(outcomeLabel)
    }

    private func setupNarrative() {
        // Get narrative text for this outcome
        let narrativeText = result.outcome.narrativeText(manName: man.name)

        narrativeLabel = SKLabelNode()
        narrativeLabel.text = narrativeText
        narrativeLabel.fontSize = 16
        narrativeLabel.fontColor = SKColor(white: 0.3, alpha: 1.0)
        narrativeLabel.fontName = "Helvetica"
        narrativeLabel.numberOfLines = 0
        narrativeLabel.preferredMaxLayoutWidth = size.width - 60
        narrativeLabel.verticalAlignmentMode = .top
        narrativeLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        addChild(narrativeLabel)
    }

    private func setupStats() {
        let yPos = size.height * 0.35

        // Stats title
        let statsTitle = SKLabelNode(text: "FINAL STATS")
        statsTitle.fontSize = 18
        statsTitle.fontColor = SKColor(white: 0.4, alpha: 1.0)
        statsTitle.fontName = "Helvetica-Bold"
        statsTitle.position = CGPoint(x: size.width / 2, y: yPos + 20)
        addChild(statsTitle)

        // Stats breakdown
        let satisfaction = Int(result.finalSatisfaction)
        let difference = Int(result.finalDifference)
        let tolerance = Int(result.tolerance)
        let budgetSpent = result.budgetSpent
        let timeUsed = result.timeUsed
        let actions = result.actionsPerformed

        let statsText = """
        Satisfaction: \(satisfaction)/100
        Difference: \(difference)/\(tolerance) \(difference <= Int(tolerance) ? "✓" : "✗")

        Budget spent: $\(budgetSpent)
        Time used: \(timeUsed / 60)h \(timeUsed % 60)m
        Actions taken: \(actions)
        """

        statsLabel = SKLabelNode()
        statsLabel.text = statsText
        statsLabel.fontSize = 14
        statsLabel.fontColor = SKColor(white: 0.4, alpha: 1.0)
        statsLabel.fontName = "Helvetica"
        statsLabel.numberOfLines = 0
        statsLabel.verticalAlignmentMode = .top
        statsLabel.position = CGPoint(x: size.width / 2, y: yPos - 10)
        addChild(statsLabel)
    }

    private func setupButtons() {
        let yPos = size.height * 0.15

        // Try Again button
        tryAgainButton = createButton(
            text: "Try Again",
            fontSize: 24,
            color: SKColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 1.0),
            position: CGPoint(x: size.width / 2, y: yPos + 30)
        )
        addChild(tryAgainButton)

        // Level Select button
        menuButton = createButton(
            text: "Level Select",
            fontSize: 20,
            color: SKColor(white: 0.5, alpha: 1.0),
            position: CGPoint(x: size.width / 2, y: yPos - 10)
        )
        addChild(menuButton)
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
        // Check Try Again button
        if tryAgainButton.contains(location) {
            tryAgain()
            return
        }

        // Check Main Menu button
        if menuButton.contains(location) {
            goToMainMenu()
            return
        }
    }

    // MARK: - Actions

    private func tryAgain() {
        // Start a new session with the same man
        guard let session = GameManager.shared.startSession(for: man) else {
            print("Error: Could not create new session")
            return
        }

        let gameplayScene = SceneManager.shared.createGameplayScene(for: session)
        transitionTo(gameplayScene)
    }

    private func goToMainMenu() {
        let levelSelect = SceneManager.shared.createLevelSelectScene()
        transitionTo(levelSelect)
    }
}
