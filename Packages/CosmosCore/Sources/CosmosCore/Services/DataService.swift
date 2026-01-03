import Foundation
import SwiftData

/// Central service for all data operations
@MainActor
public final class DataService: ObservableObject {
    public static let shared = DataService()

    // MARK: - Container
    public let container: ModelContainer

    public var modelContext: ModelContext {
        container.mainContext
    }

    // MARK: - Init
    private init() {
        let schema = Schema([
            // Core Models
            ForgeUser.self,
            Exercise.self,
            Workout.self,
            WorkoutExercise.self,
            ExerciseSet.self,
            WorkoutPlan.self,
            WorkoutDay.self,
            PlannedExercise.self,
            HealthMetric.self,
            PersonalRecord.self,

            // Social Models
            UserProfile.self,
            Follow.self,
            ActivityFeedItem.self,
            Challenge.self,
            ChallengeParticipant.self,
            UnlockedAchievement.self,
        ])

        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // MARK: - User
    public func getCurrentUser() -> ForgeUser {
        let descriptor = FetchDescriptor<ForgeUser>()
        if let user = try? modelContext.fetch(descriptor).first {
            return user
        }
        // Create new user if none exists
        let newUser = ForgeUser()
        modelContext.insert(newUser)
        try? modelContext.save()
        return newUser
    }

    // MARK: - Exercises
    public func fetchExercises(
        searchText: String? = nil,
        muscleGroup: MuscleGroup? = nil,
        workoutType: WorkoutType? = nil,
        equipment: Equipment? = nil
    ) -> [Exercise] {
        var predicates: [Predicate<Exercise>] = []

        if let search = searchText, !search.isEmpty {
            predicates.append(#Predicate<Exercise> { exercise in
                exercise.name.localizedStandardContains(search)
            })
        }

        if let muscle = muscleGroup {
            predicates.append(#Predicate<Exercise> { exercise in
                exercise.primaryMuscle == muscle
            })
        }

        let descriptor = FetchDescriptor<Exercise>(
            sortBy: [SortDescriptor(\.name)]
        )

        return (try? modelContext.fetch(descriptor)) ?? []
    }

    @discardableResult
    public func createExercise(
        name: String,
        primaryMuscle: MuscleGroup,
        secondaryMuscles: [MuscleGroup] = [],
        category: ExerciseCategory? = nil,
        equipment: Equipment? = nil,
        instructions: String? = nil,
        trackingType: ExerciseTrackingType = .weightAndReps
    ) -> Exercise {
        let equipmentList = equipment.map { [$0] } ?? []
        let exercise = Exercise(
            name: name,
            primaryMuscle: primaryMuscle,
            secondaryMuscles: secondaryMuscles,
            equipmentList: equipmentList,
            trackingType: trackingType,
            isSystemExercise: true,
            category: category
        )
        exercise.instructions = instructions
        modelContext.insert(exercise)
        try? modelContext.save()
        return exercise
    }

    // MARK: - Workout Exercises
    public func addExercise(_ exercise: Exercise, to workout: Workout) -> WorkoutExercise {
        let workoutExercise = WorkoutExercise(
            exercise: exercise,
            order: workout.exercises.count,
            workout: workout
        )
        workout.exercises.append(workoutExercise)
        modelContext.insert(workoutExercise)

        // Add initial set
        let initialSet = ExerciseSet(setNumber: 1, workoutExercise: workoutExercise)
        workoutExercise.sets.append(initialSet)
        modelContext.insert(initialSet)

        try? modelContext.save()
        return workoutExercise
    }

    public func addSet(to workoutExercise: WorkoutExercise) -> ExerciseSet {
        let setNumber = workoutExercise.sets.count + 1
        let exerciseSet = ExerciseSet(setNumber: setNumber, workoutExercise: workoutExercise)
        workoutExercise.sets.append(exerciseSet)
        modelContext.insert(exerciseSet)
        try? modelContext.save()
        return exerciseSet
    }

    public func deleteSet(_ set: ExerciseSet, from workoutExercise: WorkoutExercise) {
        workoutExercise.sets.removeAll { $0.id == set.id }
        modelContext.delete(set)

        // Renumber remaining sets
        for (index, remainingSet) in workoutExercise.sets.enumerated() {
            remainingSet.setNumber = index + 1
        }

        try? modelContext.save()
    }

    // MARK: - Workouts
    public func fetchWorkouts(
        dateRange: ClosedRange<Date>? = nil,
        workoutType: WorkoutType? = nil,
        limit: Int? = nil
    ) -> [Workout] {
        var descriptor = FetchDescriptor<Workout>(
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )

        // Fetch more than limit since we filter in memory
        if let limit = limit {
            descriptor.fetchLimit = limit * 2
        }

        var workouts = (try? modelContext.fetch(descriptor)) ?? []

        // Filter completed workouts in memory (SwiftData predicate has issues with enum rawValue)
        workouts = workouts.filter { $0.status == .completed }

        if let limit = limit {
            workouts = Array(workouts.prefix(limit))
        }

        return workouts
    }

    public func fetchWorkout(byID id: UUID) -> Workout? {
        let descriptor = FetchDescriptor<Workout>(
            predicate: #Predicate { $0.id == id }
        )
        return try? modelContext.fetch(descriptor).first
    }

    public func createWorkout(type: WorkoutType, name: String? = nil) -> Workout {
        let workout = Workout(name: name, workoutType: type)
        modelContext.insert(workout)
        try? modelContext.save()
        return workout
    }

    public func deleteWorkout(_ workout: Workout) {
        modelContext.delete(workout)
        try? modelContext.save()
    }

    public func workoutsForDate(_ date: Date) -> [Workout] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<Workout>(
            predicate: #Predicate { workout in
                workout.startedAt >= startOfDay && workout.startedAt < endOfDay
            },
            sortBy: [SortDescriptor(\.startedAt)]
        )

        let workouts = (try? modelContext.fetch(descriptor)) ?? []
        // Filter completed workouts in memory (SwiftData predicate has issues with enum rawValue)
        return workouts.filter { $0.status == .completed }
    }

    // MARK: - Workout Plans
    public func fetchWorkoutPlans(
        isActive: Bool? = nil,
        isSystemPlan: Bool? = nil
    ) -> [WorkoutPlan] {
        let descriptor = FetchDescriptor<WorkoutPlan>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )

        var plans = (try? modelContext.fetch(descriptor)) ?? []

        if let isActive = isActive {
            plans = plans.filter { $0.isActive == isActive }
        }

        if let isSystem = isSystemPlan {
            plans = plans.filter { $0.isSystemPlan == isSystem }
        }

        return plans
    }

    public func getActivePlan() -> WorkoutPlan? {
        fetchWorkoutPlans(isActive: true).first
    }

    // MARK: - Health Metrics
    public func fetchHealthMetric(for date: Date) -> HealthMetric? {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let descriptor = FetchDescriptor<HealthMetric>(
            predicate: #Predicate { $0.date == startOfDay }
        )
        return try? modelContext.fetch(descriptor).first
    }

    public func getOrCreateHealthMetric(for date: Date) -> HealthMetric {
        if let existing = fetchHealthMetric(for: date) {
            return existing
        }
        let metric = HealthMetric(date: date)
        modelContext.insert(metric)
        try? modelContext.save()
        return metric
    }

    // MARK: - Personal Records
    public func fetchPersonalRecords(
        exerciseID: UUID? = nil,
        limit: Int? = nil
    ) -> [PersonalRecord] {
        var descriptor = FetchDescriptor<PersonalRecord>(
            sortBy: [SortDescriptor(\.achievedAt, order: .reverse)]
        )

        if let limit = limit {
            descriptor.fetchLimit = limit
        }

        var records = (try? modelContext.fetch(descriptor)) ?? []

        if let exerciseID = exerciseID {
            records = records.filter { $0.exerciseID == exerciseID }
        }

        return records
    }

    // MARK: - Stats
    public func totalWorkoutsCount() -> Int {
        let descriptor = FetchDescriptor<Workout>()
        let workouts = (try? modelContext.fetch(descriptor)) ?? []
        // Filter completed workouts in memory (SwiftData predicate has issues with enum rawValue)
        return workouts.filter { $0.status == .completed }.count
    }

    public func workoutsThisWeek() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!

        let descriptor = FetchDescriptor<Workout>(
            predicate: #Predicate { workout in
                workout.startedAt >= weekStart
            }
        )
        let workouts = (try? modelContext.fetch(descriptor)) ?? []
        // Filter completed workouts in memory (SwiftData predicate has issues with enum rawValue)
        return workouts.filter { $0.status == .completed }.count
    }

    // MARK: - Save
    public func save() {
        try? modelContext.save()
    }
}
