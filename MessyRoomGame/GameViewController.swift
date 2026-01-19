import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("🎮 GameViewController viewDidLoad called")
        print("📐 View bounds: \(self.view.bounds)")

        // Create SKView if not already created
        let skView: SKView
        if let existingView = self.view as? SKView {
            print("✓ Using existing SKView")
            skView = existingView
        } else {
            print("✓ Creating new SKView with bounds: \(self.view.bounds)")
            skView = SKView(frame: self.view.bounds)
            skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view = skView
        }

        // Create and present main menu
        print("✓ Creating main menu scene")
        let mainMenu = SceneManager.shared.createMainMenuScene()
        print("✓ Presenting main menu scene")
        skView.presentScene(mainMenu)
        skView.ignoresSiblingOrder = true

        #if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
        #endif
        print("✅ GameViewController setup complete")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
