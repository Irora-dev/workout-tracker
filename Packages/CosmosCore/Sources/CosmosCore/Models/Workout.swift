import Foundation
import SwiftData

/// A completed or in-progress workout session
@Model
public final class Workout {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date
    public var updatedAt: Date

    // MARK: - Core Properties
    public var name: String?
    public var workoutType: WorkoutType
    public var notes: String?

    // MARK: - Timing
    public var startedAt: Date
    public var endedAt: Date?
    public var pausedDuration: TimeInterval  // Total time paused

    // MARK: - Status
    public var status: WorkoutStatus

    // MARK: - Location (optional)
    public var locationName: String?
    public var latitude: Double?
    public var longitude: Double?

    // MARK: - Metrics
    public var caloriesBurned: Int?
    public var averageHeartRate: Int?
    public var maxHeartRate: Int?
    public var distance: Double?  // In meters
    public var elevationGain: Double?  // In meters

    // MARK: - Mood & Rating
    public var preWorkoutMood: MoodLevel?
    public var postWorkoutMood: MoodLevel?
    public var rating: Int?  // 1-5 stars

    // MARK: - HealthKit Sync
    public var healthKitID: String?
    public var syncedToHealth: Bool

    // MARK: - Plan Reference
    public var workoutPlanID: UUID?
    public var workoutDayID: UUID?

    // MARK: - Relationships
    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.workout)
    public var exercises: [WorkoutExercise]

    // MARK: - Computed
    public var duration: TimeInterval {
        guard let endedAt = endedAt else {
            return Date().timeIntervalSince(startedAt) - pausedDuration
        }
        return endedAt.timeIntervalSince(startedAt) - pausedDuration
    }

    public var totalVolume: Double {
        exercises.reduce(0) { total, exercise in
            total + exercise.totalVolume
        }
    }

    public var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }

    public var completedSets: Int {
        exercises.reduce(0) { total, exercise in
            total + exercise.sets.filter { $0.isCompleted }.count
        }
    }

    public var isComplete: Bool {
        status == .completed
    }

    public init(
        id: UUID = UUID(),
        name: String? = nil,
        workoutType: WorkoutType,
        notes: String? = nil,
        startedAt: Date = Date(),
        status: WorkoutStatus = .inProgress,
        workoutPlanID: UUID? = nil,
        workoutDayID: UUID? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.name = name
        self.workoutType = workoutType
        self.notes = notes
        self.startedAt = startedAt
        self.endedAt = nil
        self.pausedDuration = 0
        self.status = status
        self.syncedToHealth = false
        self.workoutPlanID = workoutPlanID
        self.workoutDayID = workoutDayID
        self.exercises = []
    }

    // MARK: - Methods
    public func complete() {
        status = .completed
        endedAt = Date()
        updatedAt = Date()
    }

    public func cancel() {
        status = .cancelled
        endedAt = Date()
        updatedAt = Date()
    }

    public func addExercise(_ exercise: Exercise, order: Int? = nil) -> WorkoutExercise {
        let workoutExercise = WorkoutExercise(
            exercise: exercise,
            order: order ?? exercises.count,
            workout: self
        )
        exercises.append(workoutExercise)
        updatedAt = Date()
        return workoutExercise
    }
}

public enum WorkoutStatus: String, Codable {
    case inProgress
    case paused
    case completed
    case cancelled

    public var displayName: String {
        switch self {
        case .inProgress: return "In Progress"
        case .paused: return "Paused"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }
}

public enum MoodLevel: Int, Codable, CaseIterable {
    case veryLow = 1
    case low = 2
    case neutral = 3
    case good = 4
    case great = 5

    public var displayName: String {
        switch self {
        case .veryLow: return "Very Low"
        case .low: return "Low"
        case .neutral: return "Okay"
        case .good: return "Good"
        case .great: return "Great"
        }
    }

    public var emoji: String {
        switch self {
        case .veryLow: return "😫"
        case .low: return "😔"
        case .neutral: return "😐"
        case .good: return "😊"
        case .great: return "🔥"
        }
    }
}
