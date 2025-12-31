import Foundation
import SwiftData

/// An exercise instance within a workout (links Exercise template to sets performed)
@Model
public final class WorkoutExercise {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date

    // MARK: - Reference
    public var exerciseID: UUID
    public var exerciseName: String  // Denormalized for display
    public var exerciseIconName: String?
    public var trackingType: ExerciseTrackingType

    // MARK: - Order & Notes
    public var order: Int
    public var notes: String?
    public var restBetweenSets: TimeInterval?  // In seconds

    // MARK: - Relationships
    public var workout: Workout?

    @Relationship(deleteRule: .cascade, inverse: \ExerciseSet.workoutExercise)
    public var sets: [ExerciseSet]

    // MARK: - Computed
    public var totalVolume: Double {
        sets.filter { $0.isCompleted }.reduce(0) { total, set in
            total + set.volume
        }
    }

    public var completedSetsCount: Int {
        sets.filter { $0.isCompleted }.count
    }

    public var bestSet: ExerciseSet? {
        sets.filter { $0.isCompleted }.max { $0.volume < $1.volume }
    }

    public var isComplete: Bool {
        !sets.isEmpty && sets.allSatisfy { $0.isCompleted }
    }

    public init(
        id: UUID = UUID(),
        exercise: Exercise,
        order: Int,
        restBetweenSets: TimeInterval? = 90,
        workout: Workout? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.exerciseID = exercise.id
        self.exerciseName = exercise.name
        self.exerciseIconName = exercise.primaryMuscle.iconName
        self.trackingType = exercise.trackingType
        self.order = order
        self.restBetweenSets = restBetweenSets
        self.workout = workout
        self.sets = []
    }

    // MARK: - Methods
    public func addSet(
        weight: Double? = nil,
        reps: Int? = nil,
        duration: TimeInterval? = nil,
        distance: Double? = nil
    ) -> ExerciseSet {
        let set = ExerciseSet(
            setNumber: sets.count + 1,
            weight: weight,
            reps: reps,
            duration: duration,
            distance: distance,
            workoutExercise: self
        )
        sets.append(set)
        return set
    }

    /// Copy last completed set values for quick entry
    public func addSetFromPrevious() -> ExerciseSet {
        if let lastSet = sets.last(where: { $0.isCompleted }) {
            return addSet(
                weight: lastSet.weight,
                reps: lastSet.reps,
                duration: lastSet.duration,
                distance: lastSet.distance
            )
        } else {
            return addSet()
        }
    }
}
