import Foundation
import SwiftData

/// A single day within a workout plan
@Model
public final class WorkoutDay {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date

    // MARK: - Core Properties
    public var name: String  // e.g., "Push Day", "Leg Day", "Long Run"
    public var dayDescription: String?
    public var dayNumber: Int   // Day within the plan (1-indexed)
    public var weekNumber: Int  // Week within the plan (1-indexed)
    public var estimatedDuration: TimeInterval?  // In minutes

    // MARK: - Target Day of Week (optional)
    public var targetDayOfWeek: Int?  // 1 = Sunday, 7 = Saturday

    // MARK: - Status
    public var isCompleted: Bool
    public var completedAt: Date?
    public var completedWorkoutID: UUID?

    // MARK: - Focus
    public var primaryMuscles: [MuscleGroup]
    public var secondaryMuscles: [MuscleGroup]

    // MARK: - Relationships
    public var plan: WorkoutPlan?

    @Relationship(deleteRule: .cascade, inverse: \PlannedExercise.workoutDay)
    public var exercises: [PlannedExercise]

    // MARK: - Computed
    public var totalExercises: Int {
        exercises.count
    }

    public var totalSets: Int {
        exercises.reduce(0) { $0 + $1.targetSets }
    }

    public var displayTitle: String {
        if weekNumber > 1 {
            return "Week \(weekNumber) - \(name)"
        }
        return name
    }

    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        dayNumber: Int,
        weekNumber: Int = 1,
        estimatedDuration: TimeInterval? = nil,
        targetDayOfWeek: Int? = nil,
        primaryMuscles: [MuscleGroup] = [],
        secondaryMuscles: [MuscleGroup] = [],
        plan: WorkoutPlan? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.name = name
        self.dayDescription = description
        self.dayNumber = dayNumber
        self.weekNumber = weekNumber
        self.estimatedDuration = estimatedDuration
        self.targetDayOfWeek = targetDayOfWeek
        self.isCompleted = false
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.plan = plan
        self.exercises = []
    }

    // MARK: - Methods
    public func markCompleted(workoutID: UUID) {
        isCompleted = true
        completedAt = Date()
        completedWorkoutID = workoutID
    }

    public func addExercise(
        exercise: Exercise,
        order: Int? = nil,
        targetSets: Int = 3,
        targetReps: Int? = nil,
        targetWeight: Double? = nil,
        targetDuration: TimeInterval? = nil,
        targetDistance: Double? = nil
    ) -> PlannedExercise {
        let planned = PlannedExercise(
            exercise: exercise,
            order: order ?? exercises.count,
            targetSets: targetSets,
            targetReps: targetReps,
            targetWeight: targetWeight,
            targetDuration: targetDuration,
            targetDistance: targetDistance,
            workoutDay: self
        )
        exercises.append(planned)
        return planned
    }
}

/// An exercise planned for a workout day (template for what to do)
@Model
public final class PlannedExercise {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date

    // MARK: - Reference
    public var exerciseID: UUID
    public var exerciseName: String
    public var trackingType: ExerciseTrackingType

    // MARK: - Order & Notes
    public var order: Int
    public var notes: String?
    public var restBetweenSets: TimeInterval?

    // MARK: - Targets
    public var targetSets: Int
    public var targetReps: Int?
    public var targetRepsRange: String?  // e.g., "8-12"
    public var targetWeight: Double?
    public var targetRPE: Double?
    public var targetDuration: TimeInterval?
    public var targetDistance: Double?
    public var targetPace: Double?

    // MARK: - Relationships
    public var workoutDay: WorkoutDay?

    public init(
        id: UUID = UUID(),
        exercise: Exercise,
        order: Int,
        targetSets: Int = 3,
        targetReps: Int? = nil,
        targetRepsRange: String? = nil,
        targetWeight: Double? = nil,
        targetRPE: Double? = nil,
        targetDuration: TimeInterval? = nil,
        targetDistance: Double? = nil,
        restBetweenSets: TimeInterval? = 90,
        notes: String? = nil,
        workoutDay: WorkoutDay? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.exerciseID = exercise.id
        self.exerciseName = exercise.name
        self.trackingType = exercise.trackingType
        self.order = order
        self.targetSets = targetSets
        self.targetReps = targetReps
        self.targetRepsRange = targetRepsRange
        self.targetWeight = targetWeight
        self.targetRPE = targetRPE
        self.targetDuration = targetDuration
        self.targetDistance = targetDistance
        self.restBetweenSets = restBetweenSets
        self.notes = notes
        self.workoutDay = workoutDay
    }

    // MARK: - Display Helpers
    public var targetDisplay: String {
        var parts: [String] = ["\(targetSets) sets"]

        if let range = targetRepsRange {
            parts.append("\(range) reps")
        } else if let reps = targetReps {
            parts.append("\(reps) reps")
        }

        if let weight = targetWeight {
            parts.append("\(Int(weight)) lbs")
        }

        if let duration = targetDuration {
            let minutes = Int(duration) / 60
            parts.append("\(minutes) min")
        }

        if let distance = targetDistance {
            if distance >= 1000 {
                parts.append(String(format: "%.1f km", distance / 1000))
            } else {
                parts.append("\(Int(distance))m")
            }
        }

        return parts.joined(separator: " x ")
    }
}
