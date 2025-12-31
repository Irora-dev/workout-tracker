import Foundation
import SwiftData

/// A workout plan/program with multiple days
@Model
public final class WorkoutPlan {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date
    public var updatedAt: Date

    // MARK: - Core Properties
    public var name: String
    public var planDescription: String?
    public var iconName: String?
    public var colorHex: String

    // MARK: - Categorization
    public var workoutType: WorkoutType
    public var difficulty: ExerciseDifficulty
    public var durationWeeks: Int
    public var daysPerWeek: Int

    // MARK: - Plan Type
    public var isSystemPlan: Bool  // Built-in template
    public var isActive: Bool      // Currently following this plan
    public var startDate: Date?

    // MARK: - Goals
    public var goals: [PlanGoal]

    // MARK: - Relationships
    @Relationship(deleteRule: .cascade, inverse: \WorkoutDay.plan)
    public var days: [WorkoutDay]

    // MARK: - Computed
    public var totalWorkouts: Int {
        days.count
    }

    public var completedWorkouts: Int {
        days.filter { $0.isCompleted }.count
    }

    public var progressPercentage: Double {
        guard totalWorkouts > 0 else { return 0 }
        return Double(completedWorkouts) / Double(totalWorkouts)
    }

    public var currentWeek: Int {
        guard let startDate = startDate else { return 1 }
        let daysSinceStart = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return (daysSinceStart / 7) + 1
    }

    public var nextWorkout: WorkoutDay? {
        days.first { !$0.isCompleted }
    }

    public init(
        id: UUID = UUID(),
        name: String,
        description: String? = nil,
        iconName: String? = nil,
        colorHex: String = "#8C4DD9",
        workoutType: WorkoutType,
        difficulty: ExerciseDifficulty = .intermediate,
        durationWeeks: Int = 4,
        daysPerWeek: Int = 3,
        isSystemPlan: Bool = false,
        goals: [PlanGoal] = []
    ) {
        self.id = id
        self.createdAt = Date()
        self.updatedAt = Date()
        self.name = name
        self.planDescription = description
        self.iconName = iconName
        self.colorHex = colorHex
        self.workoutType = workoutType
        self.difficulty = difficulty
        self.durationWeeks = durationWeeks
        self.daysPerWeek = daysPerWeek
        self.isSystemPlan = isSystemPlan
        self.isActive = false
        self.goals = goals
        self.days = []
    }

    // MARK: - Methods
    public func startPlan() {
        isActive = true
        startDate = Date()
        updatedAt = Date()
    }

    public func endPlan() {
        isActive = false
        updatedAt = Date()
    }

    public func addDay(
        name: String,
        dayNumber: Int,
        weekNumber: Int = 1
    ) -> WorkoutDay {
        let day = WorkoutDay(
            name: name,
            dayNumber: dayNumber,
            weekNumber: weekNumber,
            plan: self
        )
        days.append(day)
        updatedAt = Date()
        return day
    }
}

public enum PlanGoal: String, Codable, CaseIterable {
    case buildMuscle
    case loseFat
    case buildStrength
    case improveEndurance
    case increaseFlexibility
    case generalFitness
    case runFaster
    case runLonger
    case swimFaster
    case climbHarder

    public var displayName: String {
        switch self {
        case .buildMuscle: return "Build Muscle"
        case .loseFat: return "Lose Fat"
        case .buildStrength: return "Build Strength"
        case .improveEndurance: return "Improve Endurance"
        case .increaseFlexibility: return "Increase Flexibility"
        case .generalFitness: return "General Fitness"
        case .runFaster: return "Run Faster"
        case .runLonger: return "Run Longer"
        case .swimFaster: return "Swim Faster"
        case .climbHarder: return "Climb Harder"
        }
    }

    public var iconName: String {
        switch self {
        case .buildMuscle: return "figure.strengthtraining.traditional"
        case .loseFat: return "flame.fill"
        case .buildStrength: return "dumbbell.fill"
        case .improveEndurance: return "heart.fill"
        case .increaseFlexibility: return "figure.flexibility"
        case .generalFitness: return "figure.mixed.cardio"
        case .runFaster, .runLonger: return "figure.run"
        case .swimFaster: return "figure.pool.swim"
        case .climbHarder: return "figure.climbing"
        }
    }
}
