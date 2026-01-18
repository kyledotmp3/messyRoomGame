import SpriteKit

// MARK: - Base Scene

/// Base class for all game scenes.
/// Provides common functionality like scene transitions and setup hooks.
class BaseScene: SKScene {

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }

    // MARK: - Setup Hook

    /// Override in subclasses to setup scene content.
    /// Called automatically when scene is presented.
    func setupScene() {
        // Override in subclasses
    }

    // MARK: - Scene Transitions

    /// Transition to another scene with fade effect
    func transitionTo(_ scene: BaseScene, duration: TimeInterval = 0.5) {
        let transition = SKTransition.fade(withDuration: duration)
        view?.presentScene(scene, transition: transition)
    }

    /// Transition to another scene with push effect
    func pushTo(_ scene: BaseScene, direction: SKTransitionDirection = .up) {
        let transition = SKTransition.push(with: direction, duration: 0.3)
        view?.presentScene(scene, transition: transition)
    }

    // MARK: - Button Helpers

    /// Create a simple text button
    func createButton(
        text: String,
        fontSize: CGFloat = 24,
        color: SKColor = .white,
        position: CGPoint
    ) -> SKLabelNode {
        let button = SKLabelNode(text: text)
        button.fontSize = fontSize
        button.fontColor = color
        button.fontName = "Helvetica-Bold"
        button.position = position
        button.name = text.lowercased().replacingOccurrences(of: " ", with: "_")
        return button
    }

    /// Check if a point is inside a node's bounds
    func nodeContains(_ node: SKNode, point: CGPoint) -> Bool {
        return node.contains(point)
    }

    // MARK: - Layout Helpers

    /// Get center point of the scene
    var centerPoint: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }

    /// Get top center point
    var topCenter: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height * 0.8)
    }

    /// Get bottom center point
    var bottomCenter: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height * 0.2)
    }
}
