import Foundation
import CosmosCore

/// Intelligence engine for workout recommendations and insights
@Observable
public final class IntelligenceEngine {
    public static let shared = IntelligenceEngine()

    private init() {}

    /// Suggests workout type based on user history
    public func suggestWorkoutType(for user: ForgeUser, recentWorkouts: [Workout]) -> WorkoutType {
        // Analyze recent workouts to suggest next workout
        let workoutCounts = Dictionary(grouping: recentWorkouts.prefix(14), by: { $0.workoutType })
            .mapValues { $0.count }

        // Find least done workout type in last 2 weeks
        let allTypes: [WorkoutType] = [.gym, .running, .cycling, .swimming, .hiit, .yoga]
        let leastDone = allTypes.min { (workoutCounts[$0] ?? 0) < (workoutCounts[$1] ?? 0) }

        return leastDone ?? .gym
    }

    /// Calculates recovery score based on recent activity
    public func calculateRecoveryScore(recentWorkouts: [Workout]) -> Double {
        guard !recentWorkouts.isEmpty else { return 100 }

        let calendar = Calendar.current
        let today = Date()

        // Check last 3 days of activity
        var intensityScore = 0.0
        for i in 0..<3 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? date

            let dayWorkouts = recentWorkouts.filter { $0.startedAt >= dayStart && $0.startedAt < dayEnd }
            let dayIntensity = dayWorkouts.reduce(0.0) { $0 + ($1.duration / 3600) }

            // Weight recent days more heavily
            let weight = 1.0 / Double(i + 1)
            intensityScore += dayIntensity * weight
        }

        // Convert to recovery percentage (less recent activity = higher recovery)
        let recovery = max(0, min(100, 100 - (intensityScore * 25)))
        return recovery
    }

    /// Suggests rest day based on workout patterns
    public func shouldSuggestRestDay(recentWorkouts: [Workout]) -> Bool {
        let recoveryScore = calculateRecoveryScore(recentWorkouts: recentWorkouts)
        return recoveryScore < 50
    }

    /// Generates workout insight message
    public func generateInsight(for workouts: [Workout], user: ForgeUser) -> String {
        guard !workouts.isEmpty else {
            return "Start your fitness journey with a workout today!"
        }

        let thisWeek = workouts.filter {
            Calendar.current.isDate($0.startedAt, equalTo: Date(), toGranularity: .weekOfYear)
        }

        if thisWeek.count >= 5 {
            return "Great week! You've completed \(thisWeek.count) workouts."
        } else if thisWeek.count >= 3 {
            return "Good progress! Keep up the momentum."
        } else if user.currentStreak > 0 {
            return "You're on a \(user.currentStreak)-day streak! Don't break it."
        } else {
            return "Ready to get back on track? Your body will thank you."
        }
    }

    /// Suggests exercises based on workout type and muscle groups
    public func suggestExercises(for workoutType: WorkoutType, targetMuscles: [MuscleGroup], from exercises: [Exercise], limit: Int = 6) -> [Exercise] {
        let filtered = exercises.filter { exercise in
            // Match primary or secondary muscle groups
            targetMuscles.contains(exercise.primaryMuscle) ||
            exercise.secondaryMuscles.contains(where: { targetMuscles.contains($0) })
        }

        // Shuffle and return limited set
        return Array(filtered.shuffled().prefix(limit))
    }
}
