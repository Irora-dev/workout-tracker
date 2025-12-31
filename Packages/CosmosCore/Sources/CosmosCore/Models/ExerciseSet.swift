import Foundation
import SwiftData

/// A single set of an exercise (e.g., 10 reps at 135 lbs)
@Model
public final class ExerciseSet {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date

    // MARK: - Set Info
    public var setNumber: Int
    public var setType: SetType

    // MARK: - Weight Training
    public var weight: Double?  // In user's preferred unit (lbs or kg)
    public var reps: Int?
    public var targetReps: Int?
    public var rpe: Double?  // Rate of Perceived Exertion (1-10)

    // MARK: - Time-Based
    public var duration: TimeInterval?  // In seconds
    public var targetDuration: TimeInterval?

    // MARK: - Distance-Based
    public var distance: Double?  // In meters
    public var targetDistance: Double?
    public var pace: Double?  // Seconds per kilometer/mile

    // MARK: - Status
    public var isCompleted: Bool
    public var completedAt: Date?
    public var isPersonalRecord: Bool

    // MARK: - Relationships
    public var workoutExercise: WorkoutExercise?

    // MARK: - Computed
    public var volume: Double {
        guard isCompleted else { return 0 }
        if let weight = weight, let reps = reps {
            return weight * Double(reps)
        }
        return 0
    }

    public var displayString: String {
        var parts: [String] = []

        if let weight = weight {
            parts.append("\(Int(weight)) lbs")
        }
        if let reps = reps {
            parts.append("\(reps) reps")
        }
        if let duration = duration {
            parts.append(formatDuration(duration))
        }
        if let distance = distance {
            parts.append(formatDistance(distance))
        }

        return parts.joined(separator: " x ")
    }

    public init(
        id: UUID = UUID(),
        setNumber: Int,
        setType: SetType = .working,
        weight: Double? = nil,
        reps: Int? = nil,
        targetReps: Int? = nil,
        duration: TimeInterval? = nil,
        targetDuration: TimeInterval? = nil,
        distance: Double? = nil,
        targetDistance: Double? = nil,
        workoutExercise: WorkoutExercise? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.setNumber = setNumber
        self.setType = setType
        self.weight = weight
        self.reps = reps
        self.targetReps = targetReps
        self.duration = duration
        self.targetDuration = targetDuration
        self.distance = distance
        self.targetDistance = targetDistance
        self.isCompleted = false
        self.isPersonalRecord = false
        self.workoutExercise = workoutExercise
    }

    // MARK: - Methods
    public func complete() {
        isCompleted = true
        completedAt = Date()
    }

    public func uncomplete() {
        isCompleted = false
        completedAt = nil
        isPersonalRecord = false
    }

    // MARK: - Helpers
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", secs))"
        }
        return "\(secs)s"
    }

    private func formatDistance(_ meters: Double) -> String {
        if meters >= 1000 {
            return String(format: "%.2f km", meters / 1000)
        }
        return "\(Int(meters))m"
    }
}

public enum SetType: String, Codable, CaseIterable {
    case warmup
    case working
    case dropSet
    case failureSet
    case restPause
    case superSet

    public var displayName: String {
        switch self {
        case .warmup: return "Warm-up"
        case .working: return "Working"
        case .dropSet: return "Drop Set"
        case .failureSet: return "To Failure"
        case .restPause: return "Rest-Pause"
        case .superSet: return "Super Set"
        }
    }

    public var colorName: String {
        switch self {
        case .warmup: return "yellow"
        case .working: return "blue"
        case .dropSet: return "orange"
        case .failureSet: return "red"
        case .restPause: return "purple"
        case .superSet: return "green"
        }
    }
}
