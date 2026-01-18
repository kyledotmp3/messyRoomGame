# AUDIO Swimlane - Agent Task List

> **Owner**: agent-audio
> **Purpose**: Sound effects, music, audio management

## How to Use This File

1. Pick the next `[ ]` task in your current phase
2. Change `[ ]` to `[~]` when starting (in progress)
3. Change `[~]` to `[x]` when complete
4. Add notes in the Notes column if needed
5. Update STATUS.md progress counter

---

## Phase 1: Foundation

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| U1.1 | Create AudioManager.swift | [ ] | SCENES S1.1 | Managers/AudioManager.swift | Playback system |
| U1.2 | Add placeholder sounds | [ ] | U1.1 | Sounds/placeholder_*.wav | Simple beeps |

**Phase 1 Complete**: [ ] (all 2 tasks done)

---

## Phase 2: Core Systems

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| U2.1 | Add cleaning sound effect | [ ] | U1.1 | Sounds/SFX/clean_sparkle.wav | Sparkle/scrub |
| U2.2 | Add organizing sound effect | [ ] | U1.1 | Sounds/SFX/organize_shuffle.wav | Shuffle |
| U2.3 | Add removal sound effect | [ ] | U1.1 | Sounds/SFX/remove_poof.wav | Poof/trash |
| U2.4 | Add fixing sound effect | [ ] | U1.1 | Sounds/SFX/fix_wrench.wav | Repair |

**Phase 2 Complete**: [ ] (all 4 tasks done)

---

## Phase 3: Gameplay

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| U3.1 | Add discovery sound | [ ] | U1.1 | Sounds/SFX/trait_reveal.wav | "Aha!" moment |
| U3.2 | Add satisfaction up sound | [ ] | U1.1 | Sounds/SFX/satisfaction_up.wav | Positive chime |
| U3.3 | Add satisfaction down sound | [ ] | U1.1 | Sounds/SFX/satisfaction_down.wav | Negative buzz |
| U3.4 | Add timer warning sound | [ ] | U1.1 | Sounds/SFX/timer_tick.wav | Low time tick |

**Phase 3 Complete**: [ ] (all 4 tasks done)

---

## Phase 4: Integration

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| U4.1 | Add positive results music | [ ] | U1.1 | Sounds/Music/results_positive.mp3 | Happy outcome |
| U4.2 | Add negative results music | [ ] | U1.1 | Sounds/Music/results_negative.mp3 | Sad outcome |
| U4.3 | Add menu music | [ ] | U1.1 | Sounds/Music/menu_theme.mp3 | Main menu |

**Phase 4 Complete**: [ ] (all 3 tasks done)

---

## Phase 5: Polish

| ID | Task | Status | Depends On | Output File | Notes |
|----|------|--------|------------|-------------|-------|
| U5.1 | Add gameplay music | [ ] | U1.1 | Sounds/Music/gameplay_theme.mp3 | Background loop |
| U5.2 | Final audio mix | [ ] | All audio | All | Balance volumes |
| U5.3 | Add UI sounds | [ ] | U1.1 | Sounds/UI/*.wav | Buttons, hovers |

**Phase 5 Complete**: [ ] (all 3 tasks done)

---

## Audio Specifications

### File Formats
| Type | Format | Sample Rate | Notes |
|------|--------|-------------|-------|
| SFX | .wav or .caf | 44.1kHz | Short sounds |
| Music | .mp3 or .m4a | 44.1kHz | Loopable |

### Volume Levels (0.0 - 1.0)
| Category | Default | Notes |
|----------|---------|-------|
| Music | 0.5 | Background, unobtrusive |
| SFX | 0.8 | Clear but not jarring |
| UI | 0.6 | Subtle feedback |

### Sound Descriptions

#### Action SFX
| Sound | Description | Duration | Tone |
|-------|-------------|----------|------|
| clean_sparkle | Satisfying sparkle/chime | 0.5s | Bright, pleasant |
| organize_shuffle | Papers/items shuffling | 0.8s | Gentle rustling |
| remove_poof | Soft poof/disappear | 0.4s | Light, airy |
| fix_wrench | Mechanical click/wrench | 0.6s | Satisfying clunk |
| replace_whoosh | Quick swap sound | 0.3s | Whoosh |
| move_slide | Furniture sliding | 0.5s | Smooth scrape |
| deep_clean_scrub | Extended scrubbing | 1.0s | Vigorous |

#### Feedback SFX
| Sound | Description | Duration | Tone |
|-------|-------------|----------|------|
| satisfaction_up | Positive chime | 0.3s | Happy, ascending |
| satisfaction_down | Negative buzz | 0.3s | Concerned, descending |
| trait_reveal | Discovery "aha" | 0.5s | Curious, magical |
| timer_tick | Clock tick | 0.2s | Urgent |
| timer_warning | Alarm-ish | 0.5s | Anxious |
| difference_warning | Cautionary tone | 0.4s | Warning |

#### UI SFX
| Sound | Description | Duration | Tone |
|-------|-------------|----------|------|
| button_click | Standard tap | 0.1s | Neutral |
| button_hover | Subtle highlight | 0.1s | Soft |
| menu_open | Panel appears | 0.2s | Welcoming |
| menu_close | Panel closes | 0.2s | Dismissive |
| error_buzz | Can't afford | 0.2s | Blocked |
| success_ding | Action complete | 0.2s | Confirming |

### Music Tracks
| Track | BPM | Duration | Mood | Loop Point |
|-------|-----|----------|------|------------|
| menu_theme | 100 | 60s | Welcoming, cozy | Yes |
| gameplay_theme | 110 | 120s | Casual, slightly tense | Yes |
| results_positive | 120 | 30s | Celebratory | No |
| results_negative | 80 | 30s | Melancholic | No |

---

## AudioManager Template

```swift
import AVFoundation
import SpriteKit

class AudioManager {
    static let shared = AudioManager()

    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayers: [String: AVAudioPlayer] = [:]

    var musicVolume: Float = 0.5 {
        didSet { musicPlayer?.volume = musicVolume }
    }

    var sfxVolume: Float = 0.8

    // MARK: - Music

    func playMusic(_ filename: String, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Music file not found: \(filename)")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = loop ? -1 : 0
            musicPlayer?.volume = musicVolume
            musicPlayer?.play()
        } catch {
            print("Error playing music: \(error)")
        }
    }

    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }

    // MARK: - SFX

    func playSFX(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("SFX file not found: \(filename)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = sfxVolume
            player.play()
            sfxPlayers[filename] = player
        } catch {
            print("Error playing SFX: \(error)")
        }
    }

    // MARK: - Convenience

    func playCleanSound() { playSFX("clean_sparkle.wav") }
    func playOrganizeSound() { playSFX("organize_shuffle.wav") }
    func playRemoveSound() { playSFX("remove_poof.wav") }
    func playFixSound() { playSFX("fix_wrench.wav") }
    func playSatisfactionUp() { playSFX("satisfaction_up.wav") }
    func playSatisfactionDown() { playSFX("satisfaction_down.wav") }
    func playDiscovery() { playSFX("trait_reveal.wav") }
}
```

---

## Placeholder Sound Generation

For Phase 1, use simple generated tones:

```swift
// Generate placeholder beeps using AVAudioEngine or AudioToolbox
// Or use free sound generators like:
// - https://sfxr.me/ (retro game sounds)
// - https://freesound.org/ (free sound library)
```
