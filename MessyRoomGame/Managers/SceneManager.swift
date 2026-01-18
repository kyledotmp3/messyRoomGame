import SpriteKit

// MARK: - Scene Manager

/// Manages scene creation and transitions.
/// Provides factory methods for creating all game scenes.
class SceneManager {

    // MARK: - Singleton

    static let shared = SceneManager()

    private init() {}

    // MARK: - Scene Size

    /// Standard scene size (can be overridden per platform)
    var sceneSize: CGSize {
        #if os(iOS)
        return CGSize(width: 375, height: 667) // iPhone standard
        #else
        return CGSize(width: 1024, height: 768) // Mac/iPad
        #endif
    }

    // MARK: - Scene Factory Methods

    /// Create main menu scene
    func createMainMenuScene() -> MainMenuScene {
        let scene = MainMenuScene(size: sceneSize)
        scene.scaleMode = .aspectFill
        return scene
    }

    /// Create gameplay scene for a specific man
    func createGameplayScene(for session: GameSession) -> GameplayScene {
        let scene = GameplayScene(size: sceneSize)
        scene.scaleMode = .aspectFill
        scene.session = session
        return scene
    }

    /// Create results scene with game result
    func createResultsScene(result: GameResult, man: Man) -> ResultsScene {
        let scene = ResultsScene(size: sceneSize)
        scene.scaleMode = .aspectFill
        scene.result = result
        scene.man = man
        return scene
    }

    // MARK: - Scene Transitions

    /// Present a scene on a view
    func present(scene: BaseScene, on view: SKView, transition: SKTransition? = nil) {
        if let transition = transition {
            view.presentScene(scene, transition: transition)
        } else {
            let fadeTransition = SKTransition.fade(withDuration: 0.3)
            view.presentScene(scene, transition: fadeTransition)
        }
    }
}
