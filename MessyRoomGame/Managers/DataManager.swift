import Foundation

// MARK: - Data Manager

/// Manages loading and saving all game data.
/// Responsibilities:
/// - Loading men and room data from plist files
/// - Saving/loading player progress
/// - Saving/loading in-progress sessions
class DataManager {

    // MARK: - Singleton

    static let shared = DataManager()

    private init() {}

    // MARK: - File Paths

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var progressFilePath: URL {
        documentsDirectory.appendingPathComponent("player_progress.json")
    }

    private var sessionFilePath: URL {
        documentsDirectory.appendingPathComponent("current_session.json")
    }

    // MARK: - Men Loading

    /// Load all men from Men.plist
    /// Returns hardcoded Gary for now (plist implementation comes later)
    func loadMen() -> [Man] {
        // TODO: Load from Men.plist when created
        // For now, return the hardcoded Gary
        return [Man.gamerGary]
    }

    /// Load a specific man by ID
    func loadMan(withId id: String) -> Man? {
        return loadMen().first { $0.id == id }
    }

    // MARK: - Room Loading

    /// Load room data for a specific man
    /// Returns hardcoded Gary's room for now (plist implementation comes later)
    func loadRoom(for manId: String) -> Room? {
        // TODO: Load from Room_*.plist when created
        // For now, return a basic room structure
        return createGaryRoom()
    }

    /// Create Gary's room (temporary until plist is ready)
    private func createGaryRoom() -> Room {
        let items: [RoomItem] = [
            // Gaming console
            RoomItem(
                id: "gaming_console",
                name: "Gaming Console",
                category: .gaming,
                state: .dirty,
                position: ItemPosition(x: 0.7, y: 0.4),
                availableActions: [.clean],
                interactions: [
                    Interaction(
                        itemId: "gaming_console",
                        type: .clean,
                        cost: 5,
                        timeMinutes: 10,
                        baseSatisfaction: 5,
                        baseDifference: 2,
                        resultingState: .clean
                    )
                ]
            ),
            // Pizza boxes
            RoomItem(
                id: "pizza_boxes",
                name: "Pizza Boxes",
                category: .foodTrash,
                state: .dirty,
                position: ItemPosition(x: 0.5, y: 0.3),
                availableActions: [.remove],
                isMoveable: false,
                interactions: [
                    Interaction(
                        itemId: "pizza_boxes",
                        type: .remove,
                        cost: 0,
                        timeMinutes: 5,
                        baseSatisfaction: 8,
                        baseDifference: 5
                    )
                ]
            )
            // More items will be added from plist
        ]

        return Room(
            id: "gary_room",
            backgroundSprite: "room_gary_bg",
            startingBudget: 150,
            startingTimeMinutes: 180,
            items: items
        )
    }

    // MARK: - Player Progress

    /// Load player progress from disk
    func loadPlayerProgress() -> PlayerProgress {
        guard FileManager.default.fileExists(atPath: progressFilePath.path),
              let data = try? Data(contentsOf: progressFilePath) else {
            // Return fresh progress if no save file exists
            return PlayerProgress()
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(PlayerProgress.self, from: data)
        } catch {
            print("Error loading player progress: \(error)")
            return PlayerProgress()
        }
    }

    /// Save player progress to disk
    func savePlayerProgress(_ progress: PlayerProgress) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(progress)
            try data.write(to: progressFilePath)
            print("Player progress saved successfully")
        } catch {
            print("Error saving player progress: \(error)")
        }
    }

    // MARK: - Session Persistence

    /// Save current session to disk (for pause/resume)
    func saveSession(_ session: GameSession) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(session)
            try data.write(to: sessionFilePath)
            print("Session saved successfully")
        } catch {
            print("Error saving session: \(error)")
        }
    }

    /// Load saved session from disk
    func loadSavedSession() -> GameSession? {
        guard FileManager.default.fileExists(atPath: sessionFilePath.path),
              let data = try? Data(contentsOf: sessionFilePath) else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(GameSession.self, from: data)
        } catch {
            print("Error loading saved session: \(error)")
            return nil
        }
    }

    /// Delete saved session from disk
    func deleteSavedSession() {
        try? FileManager.default.removeItem(at: sessionFilePath)
        print("Saved session deleted")
    }

    /// Check if there's a saved session
    func hasSavedSession() -> Bool {
        return FileManager.default.fileExists(atPath: sessionFilePath.path)
    }
}
