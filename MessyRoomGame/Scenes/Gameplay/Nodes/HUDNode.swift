import SpriteKit

// MARK: - HUD Node

/// Heads-up display showing meters, timer, and budget.
/// Updates automatically when session values change.
class HUDNode: SKNode {

    // MARK: - Properties

    private weak var session: GameSession?

    // MARK: - UI Elements

    private var satisfactionLabel: SKLabelNode!
    private var satisfactionBar: SKShapeNode!
    private var satisfactionFill: SKShapeNode!

    private var differenceLabel: SKLabelNode!
    private var differenceBar: SKShapeNode!
    private var differenceFill: SKShapeNode!

    private var timerLabel: SKLabelNode!
    private var budgetLabel: SKLabelNode!
    private var traitsLabel: SKLabelNode!

    // MARK: - Initialization

    init(session: GameSession, size: CGSize) {
        self.session = session
        super.init()

        setupSatisfactionMeter(size: size)
        setupDifferenceMeter(size: size)
        setupTimerAndBudget(size: size)
        setupTraitsDisplay(size: size)

        // Initial update
        update()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Setup

    private func setupSatisfactionMeter(size: CGSize) {
        let yPos = size.height - 40

        // Label
        satisfactionLabel = SKLabelNode(text: "Satisfaction")
        satisfactionLabel.fontSize = 14
        satisfactionLabel.fontColor = .white
        satisfactionLabel.fontName = "Helvetica"
        satisfactionLabel.horizontalAlignmentMode = .left
        satisfactionLabel.position = CGPoint(x: 20, y: yPos)
        addChild(satisfactionLabel)

        // Bar background
        let barWidth: CGFloat = 150
        let barHeight: CGFloat = 16
        satisfactionBar = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight), cornerRadius: 4)
        satisfactionBar.fillColor = SKColor(white: 0.3, alpha: 0.5)
        satisfactionBar.strokeColor = .clear
        satisfactionBar.position = CGPoint(x: 140, y: yPos)
        addChild(satisfactionBar)

        // Fill
        satisfactionFill = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight), cornerRadius: 4)
        satisfactionFill.fillColor = SKColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0)
        satisfactionFill.strokeColor = .clear
        satisfactionFill.position = CGPoint(x: 140, y: yPos)
        satisfactionFill.xScale = 0.5 // Start at 50%
        addChild(satisfactionFill)
    }

    private func setupDifferenceMeter(size: CGSize) {
        let yPos = size.height - 70

        // Label
        differenceLabel = SKLabelNode(text: "Difference")
        differenceLabel.fontSize = 14
        differenceLabel.fontColor = .white
        differenceLabel.fontName = "Helvetica"
        differenceLabel.horizontalAlignmentMode = .left
        differenceLabel.position = CGPoint(x: 20, y: yPos)
        addChild(differenceLabel)

        // Bar background
        let barWidth: CGFloat = 150
        let barHeight: CGFloat = 16
        differenceBar = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight), cornerRadius: 4)
        differenceBar.fillColor = SKColor(white: 0.3, alpha: 0.5)
        differenceBar.strokeColor = .clear
        differenceBar.position = CGPoint(x: 140, y: yPos)
        addChild(differenceBar)

        // Fill
        differenceFill = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight), cornerRadius: 4)
        differenceFill.fillColor = SKColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0)
        differenceFill.strokeColor = .clear
        differenceFill.position = CGPoint(x: 140, y: yPos)
        differenceFill.xScale = 0 // Start at 0%
        addChild(differenceFill)
    }

    private func setupTimerAndBudget(size: CGSize) {
        let yPos = size.height - 40

        // Timer
        timerLabel = SKLabelNode(text: "⏰ 3:00:00")
        timerLabel.fontSize = 16
        timerLabel.fontColor = .white
        timerLabel.fontName = "Helvetica-Bold"
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.position = CGPoint(x: size.width - 20, y: yPos)
        addChild(timerLabel)

        // Budget
        budgetLabel = SKLabelNode(text: "💵 $150")
        budgetLabel.fontSize = 16
        budgetLabel.fontColor = .white
        budgetLabel.fontName = "Helvetica-Bold"
        budgetLabel.horizontalAlignmentMode = .right
        budgetLabel.position = CGPoint(x: size.width - 20, y: yPos - 30)
        addChild(budgetLabel)
    }

    private func setupTraitsDisplay(size: CGSize) {
        let yPos = size.height - 110

        traitsLabel = SKLabelNode(text: "Traits: Gaming (HIGH) | Cleanliness (LOW)")
        traitsLabel.fontSize = 12
        traitsLabel.fontColor = SKColor(white: 0.9, alpha: 1.0)
        traitsLabel.fontName = "Helvetica"
        traitsLabel.horizontalAlignmentMode = .left
        traitsLabel.position = CGPoint(x: 20, y: yPos)
        addChild(traitsLabel)
    }

    // MARK: - Update

    /// Update all HUD elements based on current session state
    func update() {
        guard let session = session else { return }

        // Update satisfaction meter
        let satValue = session.satisfactionMeter.value
        let satPercent = satValue / 100.0
        satisfactionFill.xScale = CGFloat(satPercent)
        satisfactionLabel.text = "Satisfaction: \(Int(satValue))/100"

        // Change color based on level
        if satValue >= 80 {
            satisfactionFill.fillColor = SKColor(red: 0.2, green: 0.9, blue: 0.4, alpha: 1.0) // Bright green
        } else if satValue >= 65 {
            satisfactionFill.fillColor = SKColor(red: 0.4, green: 0.8, blue: 0.5, alpha: 1.0) // Green
        } else if satValue >= 50 {
            satisfactionFill.fillColor = SKColor(red: 0.9, green: 0.9, blue: 0.4, alpha: 1.0) // Yellow
        } else {
            satisfactionFill.fillColor = SKColor(red: 0.9, green: 0.4, blue: 0.3, alpha: 1.0) // Red
        }

        // Update difference meter
        let diffValue = session.differenceMeter.value
        let diffPercent = diffValue / 100.0
        differenceFill.xScale = CGFloat(diffPercent)
        let tolerance = Int(session.differenceMeter.tolerance)
        differenceLabel.text = "Difference: \(Int(diffValue))/\(tolerance)"

        // Change color based on warning level
        let warningLevel = session.differenceMeter.warningLevel
        switch warningLevel {
        case .safe:
            differenceFill.fillColor = SKColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 1.0) // Green
        case .caution:
            differenceFill.fillColor = SKColor(red: 0.9, green: 0.9, blue: 0.4, alpha: 1.0) // Yellow
        case .warning:
            differenceFill.fillColor = SKColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0) // Orange
        case .danger:
            differenceFill.fillColor = SKColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0) // Red
        }

        // Update timer
        let hours = session.remainingTimeMinutes / 60
        let minutes = session.remainingTimeMinutes % 60
        timerLabel.text = "⏰ \(hours):\(String(format: "%02d", minutes))"

        // Update budget
        budgetLabel.text = "💵 $\(session.remainingBudget)"
        if session.remainingBudget < 30 {
            budgetLabel.fontColor = SKColor(red: 1.0, green: 0.5, blue: 0.3, alpha: 1.0) // Warning color
        } else {
            budgetLabel.fontColor = .white
        }

        // Update traits
        let revealedTraits = session.man.revealedTraits
        if revealedTraits.isEmpty {
            traitsLabel.text = "Traits: None revealed yet"
        } else {
            let traitStrings = revealedTraits.map { trait in
                let name = trait.type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
                let intensity = trait.intensity.rawValue.uppercased()
                return "\(name) (\(intensity))"
            }
            traitsLabel.text = "Traits: " + traitStrings.joined(separator: " | ")
        }
    }
}
