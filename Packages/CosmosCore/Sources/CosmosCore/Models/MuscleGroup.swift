import Foundation

/// Muscle groups for exercise categorization and volume tracking
public enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    // Upper Body - Push
    case chest
    case shoulders
    case triceps

    // Upper Body - Pull
    case back
    case biceps
    case forearms

    // Core
    case abs
    case obliques
    case lowerBack

    // Lower Body
    case quads
    case hamstrings
    case glutes
    case calves
    case hipFlexors

    // Full Body
    case fullBody

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .chest: return "Chest"
        case .shoulders: return "Shoulders"
        case .triceps: return "Triceps"
        case .back: return "Back"
        case .biceps: return "Biceps"
        case .forearms: return "Forearms"
        case .abs: return "Abs"
        case .obliques: return "Obliques"
        case .lowerBack: return "Lower Back"
        case .quads: return "Quads"
        case .hamstrings: return "Hamstrings"
        case .glutes: return "Glutes"
        case .calves: return "Calves"
        case .hipFlexors: return "Hip Flexors"
        case .fullBody: return "Full Body"
        }
    }

    public var category: MuscleCategory {
        switch self {
        case .chest, .shoulders, .triceps:
            return .upperPush
        case .back, .biceps, .forearms:
            return .upperPull
        case .abs, .obliques, .lowerBack:
            return .core
        case .quads, .hamstrings, .glutes, .calves, .hipFlexors:
            return .lowerBody
        case .fullBody:
            return .fullBody
        }
    }

    public var iconName: String {
        switch self {
        case .chest: return "figure.arms.open"
        case .shoulders: return "figure.wave"
        case .triceps: return "figure.strengthtraining.functional"
        case .back: return "figure.climbing"
        case .biceps: return "figure.strengthtraining.traditional"
        case .forearms: return "hand.raised.fill"
        case .abs: return "figure.core.training"
        case .obliques: return "figure.flexibility"
        case .lowerBack: return "figure.roll"
        case .quads: return "figure.walk"
        case .hamstrings: return "figure.run"
        case .glutes: return "figure.stairs"
        case .calves: return "figure.step.training"
        case .hipFlexors: return "figure.yoga"
        case .fullBody: return "figure.mixed.cardio"
        }
    }
}

public enum MuscleCategory: String, Codable, CaseIterable {
    case upperPush
    case upperPull
    case core
    case lowerBody
    case fullBody

    public var displayName: String {
        switch self {
        case .upperPush: return "Upper Body (Push)"
        case .upperPull: return "Upper Body (Pull)"
        case .core: return "Core"
        case .lowerBody: return "Lower Body"
        case .fullBody: return "Full Body"
        }
    }

    public var muscleGroups: [MuscleGroup] {
        MuscleGroup.allCases.filter { $0.category == self }
    }
}
