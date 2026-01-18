# Xcode Project Setup Instructions

This guide explains how to create the Xcode project and wire up all the Swift files.

## Step 1: Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose **Game** template (under iOS or macOS)
4. Configure:
   - Product Name: `MessyRoomGame`
   - Team: Your team
   - Organization Identifier: Your identifier
   - Interface: **SpriteKit**
   - Language: **Swift**
   - Game Technology: **SpriteKit**
   - Devices: **iPhone, iPad, Mac** (for universal)
5. Save to `/Users/kyleb/projects/messyRoomGame/`

## Step 2: Add Existing Swift Files to Project

The Swift files are already created in the correct folders. You need to add them to the Xcode project:

1. In Xcode, right-click on the `MessyRoomGame` group
2. Select "Add Files to MessyRoomGame..."
3. Navigate to `/Users/kyleb/projects/messyRoomGame/MessyRoomGame/`
4. Select ALL folders:
   - `Models/`
   - `Managers/`
   - `Scenes/`
5. **IMPORTANT**: Check "Create groups" (not folder references)
6. **IMPORTANT**: Check "Add to targets: MessyRoomGame"
7. Click Add

Your Xcode project structure should now look like:

```
MessyRoomGame
├── Models
│   ├── Man
│   │   ├── Man.swift
│   │   └── Trait.swift
│   ├── Room
│   │   ├── RoomItem.swift
│   │   └── Interaction.swift
│   ├── Scoring
│   │   ├── SatisfactionMeter.swift
│   │   └── DifferenceMeter.swift
│   └── Progress
│       ├── GameSession.swift
│       └── GameResult.swift
├── Managers
│   ├── GameManager.swift
│   ├── DataManager.swift
│   └── SceneManager.swift
├── Scenes
│   ├── Base
│   │   └── BaseScene.swift
│   ├── Menu
│   │   └── MainMenuScene.swift
│   ├── Gameplay
│   │   ├── GameplayScene.swift
│   │   └── Nodes
│   │       ├── HUDNode.swift
│   │       └── InteractionMenuNode.swift
│   └── Results
│       └── ResultsScene.swift
└── Resources (create this group)
```

## Step 3: Add Data Files

1. In Xcode, right-click on `MessyRoomGame` group
2. Add New Group → name it `Resources`
3. Add New Group under Resources → name it `Data`
4. Right-click on `Data` group → "Add Files..."
5. Navigate to `MessyRoomGame/Resources/Data/`
6. Add both:
   - `Men.plist`
   - `Room_gary.plist`
7. Ensure "Add to targets: MessyRoomGame" is checked

## Step 4: Configure App Entry Point

Delete or replace the default `GameViewController.swift` with this:

```swift
import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as? SKView else { return }

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
```

For macOS, update `GameViewController.swift`:

```swift
import Cocoa
import SpriteKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = self.view as? SKView else { return }

        // Create and present main menu
        let mainMenu = SceneManager.shared.createMainMenuScene()

        view.presentScene(mainMenu)
        view.ignoresSiblingOrder = true

        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        #endif
    }
}
```

## Step 5: Delete Unused Template Files

Delete these files created by the template (we don't need them):
- `GameScene.swift`
- `GameScene.sks`
- `Actions.sks`

## Step 6: Update Info.plist

Ensure your Info.plist has:

```xml
<key>UIRequiresFullScreen</key>
<true/>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>
```

## Step 7: Build and Run

1. Select your target device (iPhone simulator or Mac)
2. Press ⌘R to build and run
3. You should see the main menu!

## Step 8: Fix Any Build Errors

If you get errors about missing files:
- Make sure all Swift files are added to the target
- Check that plists are in the "Copy Bundle Resources" build phase

If you get "Cannot find 'GameManager' in scope":
- Files might not be added to target
- Clean build folder (⌘⇧K) and rebuild

## Expected Behavior

When you run the app:

1. **Main Menu** appears with "Play" button
2. Tap **Play** → Loads Gary's room
3. **Gameplay Scene** shows:
   - HUD with meters at top
   - Colored squares representing 26 items
   - Tap any item → Interaction menu appears
4. **Select an action** → Meters update, budget decreases, time decreases
5. **Continue until time runs out** or tap "Done Early"
6. **Results Scene** shows:
   - Star rating
   - Narrative text
   - Final statistics
7. Tap **Try Again** or **Main Menu**

## Testing Checklist

- [ ] App launches without crashing
- [ ] Main menu displays
- [ ] Can start new game
- [ ] Gameplay scene shows room and items
- [ ] Can tap items to see interaction menu
- [ ] Can perform actions (meters update)
- [ ] HUD displays correctly
- [ ] Game ends when time runs out
- [ ] Results screen shows correct outcome
- [ ] Can return to main menu

## Common Issues

### "Could not load Men.plist"
- Check that Men.plist is in "Copy Bundle Resources" in Build Phases
- Verify path in DataManager.swift

### "Items are not tappable"
- Check that itemNodes are being created in GameplayScene
- Verify touch handling is working

### "Meters not updating"
- Check that HUDNode.update() is being called after actions
- Verify session is properly initialized

## Next Steps: Add Real Assets

Currently using placeholder colored squares for items. To add real sprites:

1. Create `Assets.xcassets` catalog
2. Add sprite images for each item (26 items × states)
3. Update `createItemNode()` in GameplayScene to load actual sprites
4. Add room background image

## Testing the Full Game Flow

Try this sequence to test all mechanics:

1. Start game
2. Remove pizza boxes (+8 sat, +5 diff)
3. Clean gaming console (+10 sat with trait, +2 diff)
4. Try to remove old trophy → Discovery popup!
5. Clean trophy instead (+2 sat, +1 diff)
6. Continue cleaning until time runs out
7. Check results screen for outcome

## Debug Commands

In GameManager.swift (DEBUG section):
- `GameManager.shared.resetProgress()` - Reset all progress
- `GameManager.shared.unlockAllMen()` - Unlock future characters
