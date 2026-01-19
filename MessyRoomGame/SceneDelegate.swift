import UIKit
import SpriteKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("🎬 SceneDelegate scene:willConnectTo called")
        guard let windowScene = (scene as? UIWindowScene) else {
            print("❌ Not a UIWindowScene")
            return
        }

        let window = UIWindow(windowScene: windowScene)
        print("✓ Created UIWindow")

        // Create and present the main game view controller
        let viewController = GameViewController()
        print("✓ Created GameViewController")

        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
        print("✅ SceneDelegate setup complete")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save session when going to background
        GameManager.shared.saveCurrentSession()
    }
}
