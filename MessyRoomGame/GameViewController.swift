import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as? SKView else {
            print("Error: View is not an SKView")
            return
        }

        // Create and present main menu
        let mainMenu = SceneManager.shared.createMainMenuScene()

        view.presentScene(mainMenu)
        view.ignoresSiblingOrder = true

        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
