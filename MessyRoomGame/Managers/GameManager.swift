import Foundation

// MARK: - Game Manager

/// Central coordinator for all game state.
/// Acts as the single source of truth for:
/// - Player progress
/// - Current game session
/// - Game content (men, rooms)
///
/// Access via `GameManager.shared` throughout the app.
class GameManager: ObservableObject {

    // MARK: - Singleton

    static let shared = GameManager()

    private init() {
        self.playerProgress = dataManager.loadPlayerProgress()
        self.allMen = dataManager.loadMen()
    }

    // MARK: - Dependencies

    private let dataManager = DataManager.shared

    // MARK: - State

    /// Player's long-term progress
    @Published private(set) var playerProgress: PlayerProgress

    /// Currently active session (nil if not in gameplay)
    @Published private(set) var currentSession: GameSession?

    /// All available men (loaded from data)
    private(set) var allMen: [Man]

    // MARK: - Content Access

    /// Get all unlocked men for level select
    var unlockedMen: [Man] {
        return allMen.filter { playerProgress.isUnlocked($0.id) }
    }

    /// Get a specific man by ID
    func man(withId id: String) -> Man? {
        return allMen.first { $0.id == id }
    }

    /// Get best result for a man (if any)
    func bestResult(for manId: String) -> BestResult? {
        return playerProgress.bestResult(for: manId)
    }

    // MARK: - Session Management

    /// Start a new game session for a specific man
    func startSession(for man: Man) -> GameSession? {
        guard let room = dataManager.loadRoom(for: man.id) else {
            print("Error: Could not load room for \(man.id)")
            return nil
        }

        let session = GameSession(man: man, room: room)
        currentSession = session
        return session
    }

    /// Resume a saved session from disk
    func resumeSavedSession() -> GameSession? {
        if let session = dataManager.loadSavedSession() {
            currentSession = session
            return session
        }
        return nil
    }

    /// Save current session to disk (for pause)
    func saveCurrentSession() {
        guard let session = currentSession else { return }
        dataManager.saveSession(session)
    }

    /// End current session and record result
    func endSession(with result: GameResult) {
        playerProgress.recordCompletion(result: result)
        dataManager.savePlayerProgress(playerProgress)
        dataManager.deleteSavedSession()
        currentSession = nil
    }

    /// Abandon current session without saving
    func abandonSession() {
        dataManager.deleteSavedSession()
        currentSession = nil
    }

    /// Check if there's a saved session available
    var hasSavedSession: Bool {
        return dataManager.hasSavedSession()
    }

    // MARK: - Settings

    /// Update player settings
    func updateMusicVolume(_ volume: Float) {
        playerProgress.musicVolume = volume
        dataManager.savePlayerProgress(playerProgress)
    }

    func updateSFXVolume(_ volume: Float) {
        playerProgress.sfxVolume = volume
        dataManager.savePlayerProgress(playerProgress)
    }

    func updateTutorialHints(_ enabled: Bool) {
        playerProgress.showTutorialHints = enabled
        dataManager.savePlayerProgress(playerProgress)
    }

    // MARK: - Debug Helpers

    #if DEBUG
    /// Reset all progress (debug only)
    func resetProgress() {
        playerProgress = PlayerProgress()
        dataManager.savePlayerProgress(playerProgress)
        currentSession = nil
        dataManager.deleteSavedSession()
    }

    /// Unlock all men (debug only)
    func unlockAllMen() {
        for man in allMen {
            playerProgress.unlockedMenIds.insert(man.id)
        }
        dataManager.savePlayerProgress(playerProgress)
    }
    #endif
}
