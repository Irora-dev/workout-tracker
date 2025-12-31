import Foundation
import SwiftData

/// An exercise template/definition (e.g., "Bench Press")
@Model
public final class Exercise {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date

    // MARK: - Core Properties
    public var name: String
    public var instructions: String?
    public var videoURL: String?
    public var imageNames: [String]

    // MARK: - Categorization
    public var primaryMuscle: MuscleGroup
    public var secondaryMuscles: [MuscleGroup]
    public var workoutTypes: [WorkoutType]
    public var equipmentList: [Equipment]
    public var difficulty: ExerciseDifficulty
    public var category: ExerciseCategory?

    // Convenience property for primary equipment
    public var equipment: Equipment? {
        equipmentList.first
    }

    // MARK: - Tracking Type
    public var trackingType: ExerciseTrackingType

    // MARK: - System vs Custom
    public var isSystemExercise: Bool
    public var isFavorite: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        instructions: String? = nil,
        videoURL: String? = nil,
        imageNames: [String] = [],
        primaryMuscle: MuscleGroup,
        secondaryMuscles: [MuscleGroup] = [],
        workoutTypes: [WorkoutType] = [.gym],
        equipmentList: [Equipment] = [],
        difficulty: ExerciseDifficulty = .intermediate,
        trackingType: ExerciseTrackingType = .weightAndReps,
        isSystemExercise: Bool = false,
        isFavorite: Bool = false,
        category: ExerciseCategory? = nil
    ) {
        self.id = id
        self.createdAt = Date()
        self.name = name
        self.instructions = instructions
        self.videoURL = videoURL
        self.imageNames = imageNames
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscles = secondaryMuscles
        self.workoutTypes = workoutTypes
        self.equipmentList = equipmentList
        self.difficulty = difficulty
        self.trackingType = trackingType
        self.isSystemExercise = isSystemExercise
        self.isFavorite = isFavorite
        self.category = category
    }

    // MARK: - Helper Methods

    /// Get the icon name for this exercise based on primary muscle
    public var iconName: String {
        switch primaryMuscle {
        case .chest: return "figure.arms.open"
        case .back: return "figure.walk"
        case .shoulders: return "figure.boxing"
        case .biceps: return "figure.strengthtraining.traditional"
        case .triceps: return "figure.strengthtraining.functional"
        case .forearms: return "hand.raised.fill"
        case .quadriceps, .hamstrings, .glutes, .calves: return "figure.walk"
        case .core, .abs, .obliques: return "figure.core.training"
        case .fullBody: return "figure.highintensity.intervaltraining"
        case .cardio: return "figure.run"
        }
    }

    /// Get previous set data for a specific set index (for showing "previous" in workout tracking)
    public func previousSetData(at index: Int) -> (weight: Double, reps: Int)? {
        // TODO: Implement by querying historical workout data
        // For now, return nil
        return nil
    }
}

/// How an exercise tracks progress
public enum ExerciseTrackingType: String, Codable {
    case weightAndReps      // Bench press: 135lbs x 10 reps
    case repsOnly           // Pull-ups: 10 reps
    case timeOnly           // Plank: 60 seconds
    case distanceAndTime    // Running: 5km in 25 minutes
    case distanceOnly       // Swimming: 1000m
    case caloriesOnly       // General cardio
}

/// Exercise category for filtering
public enum ExerciseCategory: String, Codable, CaseIterable {
    case compound
    case isolation
    case cardio
    case flexibility
    case plyometric
    case calisthenics

    public var displayName: String {
        switch self {
        case .compound: return "Compound"
        case .isolation: return "Isolation"
        case .cardio: return "Cardio"
        case .flexibility: return "Flexibility"
        case .plyometric: return "Plyometric"
        case .calisthenics: return "Calisthenics"
        }
    }
}

public enum ExerciseDifficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case expert

    public var displayName: String {
        rawValue.capitalized
    }
}

public enum Equipment: String, Codable, CaseIterable, Identifiable {
    case none
    case bodyweight
    case barbell
    case dumbbell
    case kettlebell
    case cable
    case machine
    case resistanceBand
    case pullUpBar
    case bench
    case squat

    case treadmill
    case bike
    case rowingMachine
    case ellipticalMachine
    case stairMaster

    case medicineBall
    case stabilityBall
    case foamRoller
    case yogaMat
    case jumpRope

    case other

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .none: return "No Equipment"
        case .bodyweight: return "Bodyweight"
        case .barbell: return "Barbell"
        case .dumbbell: return "Dumbbell"
        case .kettlebell: return "Kettlebell"
        case .cable: return "Cable Machine"
        case .machine: return "Machine"
        case .resistanceBand: return "Resistance Band"
        case .pullUpBar: return "Pull-up Bar"
        case .bench: return "Bench"
        case .squat: return "Squat Rack"
        case .treadmill: return "Treadmill"
        case .bike: return "Stationary Bike"
        case .rowingMachine: return "Rowing Machine"
        case .ellipticalMachine: return "Elliptical"
        case .stairMaster: return "Stair Master"
        case .medicineBall: return "Medicine Ball"
        case .stabilityBall: return "Stability Ball"
        case .foamRoller: return "Foam Roller"
        case .yogaMat: return "Yoga Mat"
        case .jumpRope: return "Jump Rope"
        case .other: return "Other"
        }
    }

    public var iconName: String {
        switch self {
        case .none: return "hand.raised.fill"
        case .bodyweight: return "figure.stand"
        case .barbell: return "dumbbell.fill"
        case .dumbbell: return "dumbbell"
        case .kettlebell: return "scalemass.fill"
        case .cable: return "cable.connector"
        case .machine: return "gearshape.2.fill"
        case .resistanceBand: return "lasso"
        case .pullUpBar: return "figure.climbing"
        case .bench: return "bed.double.fill"
        case .squat: return "square.stack.3d.up.fill"
        case .treadmill: return "figure.run"
        case .bike: return "bicycle"
        case .rowingMachine: return "figure.rower"
        case .ellipticalMachine: return "figure.elliptical"
        case .stairMaster: return "figure.stair.stepper"
        case .medicineBall: return "circle.fill"
        case .stabilityBall: return "circle"
        case .foamRoller: return "cylinder.fill"
        case .yogaMat: return "rectangle.fill"
        case .jumpRope: return "lasso.and.sparkles"
        case .other: return "questionmark.circle"
        }
    }
}
