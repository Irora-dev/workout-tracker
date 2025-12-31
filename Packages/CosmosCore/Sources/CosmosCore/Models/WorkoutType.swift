import Foundation

/// All supported workout types in Forge
public enum WorkoutType: String, Codable, CaseIterable, Identifiable {
    // Strength
    case gym
    case weightlifting
    case crossfit
    case bodyweight

    // Cardio
    case running
    case walking
    case cycling
    case swimming
    case rowing
    case elliptical
    case stairClimber

    // HIIT & Functional
    case hiit
    case circuitTraining
    case boxing
    case kickboxing
    case martialArts

    // Climbing
    case climbing
    case bouldering

    // Mind-Body
    case yoga
    case pilates
    case stretching

    // Sports
    case tennis
    case basketball
    case soccer
    case golf
    case baseball
    case volleyball

    // Other
    case hiking
    case dance
    case other

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .gym: return "Gym"
        case .weightlifting: return "Weightlifting"
        case .crossfit: return "CrossFit"
        case .bodyweight: return "Bodyweight"
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .rowing: return "Rowing"
        case .elliptical: return "Elliptical"
        case .stairClimber: return "Stair Climber"
        case .hiit: return "HIIT"
        case .circuitTraining: return "Circuit Training"
        case .boxing: return "Boxing"
        case .kickboxing: return "Kickboxing"
        case .martialArts: return "Martial Arts"
        case .climbing: return "Climbing"
        case .bouldering: return "Bouldering"
        case .yoga: return "Yoga"
        case .pilates: return "Pilates"
        case .stretching: return "Stretching"
        case .tennis: return "Tennis"
        case .basketball: return "Basketball"
        case .soccer: return "Soccer"
        case .golf: return "Golf"
        case .baseball: return "Baseball"
        case .volleyball: return "Volleyball"
        case .hiking: return "Hiking"
        case .dance: return "Dance"
        case .other: return "Other"
        }
    }

    public var iconName: String {
        switch self {
        case .gym, .weightlifting: return "dumbbell.fill"
        case .crossfit: return "figure.cross.training"
        case .bodyweight: return "figure.strengthtraining.traditional"
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "figure.outdoor.cycle"
        case .swimming: return "figure.pool.swim"
        case .rowing: return "figure.rower"
        case .elliptical: return "figure.elliptical"
        case .stairClimber: return "figure.stair.stepper"
        case .hiit: return "bolt.heart.fill"
        case .circuitTraining: return "arrow.triangle.2.circlepath"
        case .boxing, .kickboxing: return "figure.boxing"
        case .martialArts: return "figure.martial.arts"
        case .climbing, .bouldering: return "figure.climbing"
        case .yoga: return "figure.yoga"
        case .pilates: return "figure.pilates"
        case .stretching: return "figure.flexibility"
        case .tennis: return "figure.tennis"
        case .basketball: return "figure.basketball"
        case .soccer: return "soccerball"
        case .golf: return "figure.golf"
        case .baseball: return "figure.baseball"
        case .volleyball: return "volleyball.fill"
        case .hiking: return "figure.hiking"
        case .dance: return "figure.dance"
        case .other: return "figure.mixed.cardio"
        }
    }

    public var category: WorkoutCategory {
        switch self {
        case .gym, .weightlifting, .crossfit, .bodyweight:
            return .strength
        case .running, .walking, .cycling, .swimming, .rowing, .elliptical, .stairClimber:
            return .cardio
        case .hiit, .circuitTraining, .boxing, .kickboxing, .martialArts:
            return .hiitFunctional
        case .climbing, .bouldering:
            return .climbing
        case .yoga, .pilates, .stretching:
            return .mindBody
        case .tennis, .basketball, .soccer, .golf, .baseball, .volleyball:
            return .sports
        case .hiking, .dance, .other:
            return .other
        }
    }

    /// Whether this workout type tracks sets/reps/weight
    public var tracksResistance: Bool {
        switch self {
        case .gym, .weightlifting, .crossfit, .bodyweight, .climbing, .bouldering:
            return true
        default:
            return false
        }
    }

    /// Whether this workout type tracks distance
    public var tracksDistance: Bool {
        switch self {
        case .running, .walking, .cycling, .swimming, .rowing, .hiking:
            return true
        default:
            return false
        }
    }
}

public enum WorkoutCategory: String, Codable, CaseIterable {
    case strength
    case cardio
    case hiitFunctional
    case climbing
    case mindBody
    case sports
    case other

    public var displayName: String {
        switch self {
        case .strength: return "Strength"
        case .cardio: return "Cardio"
        case .hiitFunctional: return "HIIT & Functional"
        case .climbing: return "Climbing"
        case .mindBody: return "Mind & Body"
        case .sports: return "Sports"
        case .other: return "Other"
        }
    }
}
