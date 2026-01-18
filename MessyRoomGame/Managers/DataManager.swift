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
    func loadMen() -> [Man] {
        guard let url = Bundle.main.url(forResource: "Men", withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            print("Warning: Could not load Men.plist, using hardcoded Gary")
            return [Man.gamerGary]
        }

        do {
            let decoder = PropertyListDecoder()
            let men = try decoder.decode([Man].self, from: data)
            print("Successfully loaded \(men.count) men from Men.plist")
            return men
        } catch {
            print("Error decoding Men.plist: \(error)")
            print("Falling back to hardcoded Gary")
            return [Man.gamerGary]
        }
    }

    /// Load a specific man by ID
    func loadMan(withId id: String) -> Man? {
        return loadMen().first { $0.id == id }
    }

    // MARK: - Room Loading

    /// Load room data for a specific man
    func loadRoom(for manId: String) -> Room? {
        // Construct filename: Room_gamer_gary.plist
        let resourceName = "Room_\(manId)"

        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "plist"),
              let data = try? Data(contentsOf: url) else {
            print("Warning: Could not load \(resourceName).plist")
            return nil
        }

        do {
            let decoder = PropertyListDecoder()
            let room = try decoder.decode(Room.self, from: data)
            print("Successfully loaded room '\(room.id)' with \(room.items.count) items")
            return room
        } catch {
            print("Error decoding \(resourceName).plist: \(error)")
            return nil
        }
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
