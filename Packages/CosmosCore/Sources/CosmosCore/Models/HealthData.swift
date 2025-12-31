import Foundation
import SwiftData

/// Health data synced from HealthKit
@Model
public final class HealthMetric {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var date: Date  // The day this metric is for
    public var fetchedAt: Date

    // MARK: - Steps
    public var steps: Int?
    public var stepsGoal: Int?

    // MARK: - Activity
    public var activeCalories: Double?
    public var activeCaloriesGoal: Double?
    public var exerciseMinutes: Int?
    public var exerciseMinutesGoal: Int?
    public var standHours: Int?
    public var standHoursGoal: Int?

    // MARK: - Heart Rate
    public var restingHeartRate: Int?
    public var averageHeartRate: Int?
    public var maxHeartRate: Int?
    public var heartRateVariability: Double?  // ms

    // MARK: - Distance
    public var walkingRunningDistance: Double?  // meters
    public var cyclingDistance: Double?  // meters
    public var swimmingDistance: Double?  // meters

    // MARK: - Sleep
    public var sleepDuration: TimeInterval?  // seconds
    public var sleepQuality: SleepQuality?

    // MARK: - Body
    public var weight: Double?  // kg
    public var bodyFatPercentage: Double?

    public init(
        id: UUID = UUID(),
        date: Date
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.fetchedAt = Date()
    }

    // MARK: - Computed
    public var stepsProgress: Double {
        guard let steps = steps, let goal = stepsGoal, goal > 0 else { return 0 }
        return min(1.0, Double(steps) / Double(goal))
    }

    public var activeCaloriesProgress: Double {
        guard let calories = activeCalories, let goal = activeCaloriesGoal, goal > 0 else { return 0 }
        return min(1.0, calories / goal)
    }

    public var exerciseProgress: Double {
        guard let minutes = exerciseMinutes, let goal = exerciseMinutesGoal, goal > 0 else { return 0 }
        return min(1.0, Double(minutes) / Double(goal))
    }

    public var totalDistance: Double {
        (walkingRunningDistance ?? 0) + (cyclingDistance ?? 0) + (swimmingDistance ?? 0)
    }
}

public enum SleepQuality: String, Codable {
    case poor
    case fair
    case good
    case excellent

    public var displayName: String {
        rawValue.capitalized
    }

    public var iconName: String {
        switch self {
        case .poor: return "moon.zzz"
        case .fair: return "moon"
        case .good: return "moon.fill"
        case .excellent: return "moon.stars.fill"
        }
    }
}

/// Weekly health summary for progress tracking
public struct WeeklyHealthSummary: Codable {
    public var weekStartDate: Date
    public var weekEndDate: Date

    public var totalSteps: Int
    public var averageDailySteps: Int
    public var totalActiveCalories: Double
    public var totalExerciseMinutes: Int
    public var totalDistance: Double

    public var averageRestingHeartRate: Int?
    public var averageSleepDuration: TimeInterval?

    public var workoutCount: Int
    public var workoutDays: Int  // Days with at least one workout

    public init(weekStartDate: Date) {
        self.weekStartDate = weekStartDate
        self.weekEndDate = Calendar.current.date(byAdding: .day, value: 6, to: weekStartDate) ?? weekStartDate
        self.totalSteps = 0
        self.averageDailySteps = 0
        self.totalActiveCalories = 0
        self.totalExerciseMinutes = 0
        self.totalDistance = 0
        self.workoutCount = 0
        self.workoutDays = 0
    }
}

/// Personal record for an exercise
@Model
public final class PersonalRecord {
    @Attribute(.unique) public var id: UUID
    public var exerciseID: UUID
    public var exerciseName: String
    public var recordType: RecordType
    public var value: Double
    public var previousValue: Double?
    public var achievedAt: Date
    public var workoutID: UUID?

    public init(
        id: UUID = UUID(),
        exerciseID: UUID,
        exerciseName: String,
        recordType: RecordType,
        value: Double,
        previousValue: Double? = nil,
        workoutID: UUID? = nil
    ) {
        self.id = id
        self.exerciseID = exerciseID
        self.exerciseName = exerciseName
        self.recordType = recordType
        self.value = value
        self.previousValue = previousValue
        self.achievedAt = Date()
        self.workoutID = workoutID
    }

    public var improvement: Double? {
        guard let previous = previousValue else { return nil }
        return value - previous
    }

    public var improvementPercentage: Double? {
        guard let previous = previousValue, previous > 0 else { return nil }
        return ((value - previous) / previous) * 100
    }
}

public enum RecordType: String, Codable {
    case maxWeight      // Heaviest weight lifted (1RM)
    case maxReps        // Most reps at any weight
    case maxVolume      // Highest single-set volume (weight x reps)
    case fastestTime    // Fastest time for distance
    case longestTime    // Longest duration
    case longestDistance // Longest distance

    public var displayName: String {
        switch self {
        case .maxWeight: return "Max Weight"
        case .maxReps: return "Max Reps"
        case .maxVolume: return "Max Volume"
        case .fastestTime: return "Fastest Time"
        case .longestTime: return "Longest Time"
        case .longestDistance: return "Longest Distance"
        }
    }

    public var iconName: String {
        switch self {
        case .maxWeight: return "scalemass.fill"
        case .maxReps: return "number"
        case .maxVolume: return "chart.bar.fill"
        case .fastestTime: return "bolt.fill"
        case .longestTime: return "clock.fill"
        case .longestDistance: return "arrow.right"
        }
    }
}
