import SpriteKit

// MARK: - Main Menu Scene

/// The main menu - entry point of the game.
/// Shows Play, Continue (if save exists), and Settings options.
class MainMenuScene: BaseScene {

    // MARK: - Nodes

    private var titleLabel: SKLabelNode!
    private var playButton: SKLabelNode!
    private var continueButton: SKLabelNode?
    private var settingsButton: SKLabelNode!

    // MARK: - Setup

    override func setupScene() {
        print("🎮 MainMenuScene setupScene called")
        print("📐 Scene size: \(size)")
        backgroundColor = SKColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)

        setupTitle()
        setupButtons()
        print("✅ MainMenuScene setup complete")
    }

    private func setupTitle() {
        titleLabel = SKLabelNode(text: "Messy Room")
        titleLabel.fontSize = 48
        titleLabel.fontColor = SKColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(titleLabel)

        let subtitle = SKLabelNode(text: "Clean with care")
        subtitle.fontSize = 20
        subtitle.fontColor = SKColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)
        subtitle.fontName = "Helvetica"
        subtitle.position = CGPoint(x: size.width / 2, y: size.height * 0.64)
        addChild(subtitle)
    }

    private func setupButtons() {
        let centerX = size.width / 2
        var yPosition = size.height * 0.5

        // Play button
        playButton = createButton(
            text: "Play",
            fontSize: 32,
            color: SKColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1.0),
            position: CGPoint(x: centerX, y: yPosition)
        )
        addChild(playButton)
        yPosition -= 60

        // Continue button (only if there's a saved session)
        if GameManager.shared.hasSavedSession {
            continueButton = createButton(
                text: "Continue",
                fontSize: 28,
                color: SKColor(red: 0.4, green: 0.5, blue: 0.7, alpha: 1.0),
                position: CGPoint(x: centerX, y: yPosition)
            )
            addChild(continueButton!)
            yPosition -= 60
        }

        // Settings button
        settingsButton = createButton(
            text: "Settings",
            fontSize: 24,
            color: SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0),
            position: CGPoint(x: centerX, y: yPosition)
        )
        addChild(settingsButton)

        // Version label
        let version = SKLabelNode(text: "v1.0")
        version.fontSize = 14
        version.fontColor = SKColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        version.fontName = "Helvetica"
        version.position = CGPoint(x: size.width / 2, y: 20)
        addChild(version)
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
        // Check play button
        if playButton.contains(location) {
            startNewGame()
            return
        }

        // Check continue button
        if let continueBtn = continueButton, continueBtn.contains(location) {
            continueGame()
            return
        }

        // Check settings button
        if settingsButton.contains(location) {
            openSettings()
            return
        }
    }

    // MARK: - Actions

    private func startNewGame() {
        // Navigate to level select (character select) screen
        let levelSelectScene = SceneManager.shared.createLevelSelectScene()
        transitionTo(levelSelectScene)
    }

    private func continueGame() {
        // Resume saved session
        guard let session = GameManager.shared.resumeSavedSession() else {
            print("Error: Could not load saved session")
            return
        }

        // Transition to gameplay
        let gameplayScene = SceneManager.shared.createGameplayScene(for: session)
        transitionTo(gameplayScene)
    }

    private func openSettings() {
        // TODO: Implement settings scene
        print("Settings tapped - not yet implemented")
    }
}
