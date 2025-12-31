import Foundation

/// Static exercise database for seeding the app with default exercises
public struct ExerciseDatabase {
    public struct ExerciseData {
        public let name: String
        public let primaryMuscle: MuscleGroup
        public let secondaryMuscles: [MuscleGroup]
        public let category: ExerciseCategory
        public let equipment: Equipment?
        public let instructions: String?
        public let trackingType: ExerciseTrackingType

        public init(
            name: String,
            primaryMuscle: MuscleGroup,
            secondaryMuscles: [MuscleGroup] = [],
            category: ExerciseCategory,
            equipment: Equipment? = nil,
            instructions: String? = nil,
            trackingType: ExerciseTrackingType = .weightAndReps
        ) {
            self.name = name
            self.primaryMuscle = primaryMuscle
            self.secondaryMuscles = secondaryMuscles
            self.category = category
            self.equipment = equipment
            self.instructions = instructions
            self.trackingType = trackingType
        }
    }

    public static let allExercises: [ExerciseData] =
        chestExercises +
        backExercises +
        shoulderExercises +
        bicepsExercises +
        tricepsExercises +
        legExercises +
        coreExercises +
        cardioExercises +
        plyometricExercises +
        flexibilityExercises

    // MARK: - Chest Exercises (20)
    public static let chestExercises: [ExerciseData] = [
        ExerciseData(name: "Barbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .compound, equipment: .barbell, instructions: "Lie on bench, grip barbell slightly wider than shoulder width, lower to chest, press up."),
        ExerciseData(name: "Incline Barbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .compound, equipment: .barbell),
        ExerciseData(name: "Decline Barbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Dumbbell Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Incline Dumbbell Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Decline Dumbbell Press", primaryMuscle: .chest, secondaryMuscles: [.triceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Dumbbell Flyes", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Incline Dumbbell Flyes", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Cable Crossover", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "High Cable Crossover", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Low Cable Crossover", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Push-Up", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .calisthenics, equipment: .bodyweight),
        ExerciseData(name: "Wide Push-Up", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .calisthenics, equipment: .bodyweight),
        ExerciseData(name: "Decline Push-Up", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .calisthenics, equipment: .bodyweight),
        ExerciseData(name: "Chest Dip", primaryMuscle: .chest, secondaryMuscles: [.triceps], category: .compound, equipment: .bodyweight),
        ExerciseData(name: "Machine Chest Press", primaryMuscle: .chest, secondaryMuscles: [.triceps], category: .compound, equipment: .machine),
        ExerciseData(name: "Smith Machine Bench Press", primaryMuscle: .chest, secondaryMuscles: [.triceps, .shoulders], category: .compound, equipment: .machine),
        ExerciseData(name: "Pec Deck Machine", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Svend Press", primaryMuscle: .chest, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Landmine Press", primaryMuscle: .chest, secondaryMuscles: [.shoulders], category: .compound, equipment: .barbell),
    ]

    // MARK: - Back Exercises (25)
    public static let backExercises: [ExerciseData] = [
        ExerciseData(name: "Conventional Deadlift", primaryMuscle: .back, secondaryMuscles: [.hamstrings, .glutes, .core], category: .compound, equipment: .barbell),
        ExerciseData(name: "Sumo Deadlift", primaryMuscle: .back, secondaryMuscles: [.hamstrings, .glutes, .quadriceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Pull-Up", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Chin-Up", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Wide Grip Pull-Up", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Neutral Grip Pull-Up", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Lat Pulldown", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .cable),
        ExerciseData(name: "Close Grip Lat Pulldown", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .cable),
        ExerciseData(name: "Behind Neck Lat Pulldown", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .cable),
        ExerciseData(name: "Barbell Bent Over Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Pendlay Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Dumbbell Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Kroc Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Seated Cable Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .cable),
        ExerciseData(name: "T-Bar Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Chest Supported Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Face Pull", primaryMuscle: .back, secondaryMuscles: [.shoulders], category: .isolation, equipment: .cable),
        ExerciseData(name: "Straight Arm Pulldown", primaryMuscle: .back, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Machine Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .machine),
        ExerciseData(name: "Inverted Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Meadows Row", primaryMuscle: .back, secondaryMuscles: [.biceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Rack Pull", primaryMuscle: .back, secondaryMuscles: [.glutes, .hamstrings], category: .compound, equipment: .barbell),
        ExerciseData(name: "Snatch Grip Deadlift", primaryMuscle: .back, secondaryMuscles: [.glutes, .hamstrings], category: .compound, equipment: .barbell),
        ExerciseData(name: "Hyperextension", primaryMuscle: .back, secondaryMuscles: [.glutes], category: .isolation, equipment: .machine),
        ExerciseData(name: "Reverse Hyperextension", primaryMuscle: .back, secondaryMuscles: [.glutes], category: .isolation, equipment: .machine),
    ]

    // MARK: - Shoulder Exercises (20)
    public static let shoulderExercises: [ExerciseData] = [
        ExerciseData(name: "Barbell Overhead Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Push Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps, .quadriceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Seated Dumbbell Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Standing Dumbbell Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Arnold Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Dumbbell Lateral Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Cable Lateral Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Machine Lateral Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Dumbbell Front Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Plate Front Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .other),
        ExerciseData(name: "Cable Front Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Reverse Dumbbell Fly", primaryMuscle: .shoulders, secondaryMuscles: [.back], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Reverse Pec Deck", primaryMuscle: .shoulders, secondaryMuscles: [.back], category: .isolation, equipment: .machine),
        ExerciseData(name: "Barbell Upright Row", primaryMuscle: .shoulders, secondaryMuscles: [.biceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Dumbbell Upright Row", primaryMuscle: .shoulders, secondaryMuscles: [.biceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Barbell Shrug", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .barbell),
        ExerciseData(name: "Dumbbell Shrug", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Machine Shoulder Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], category: .compound, equipment: .machine),
        ExerciseData(name: "Behind Neck Press", primaryMuscle: .shoulders, secondaryMuscles: [.triceps], category: .compound, equipment: .barbell),
        ExerciseData(name: "Lu Raise", primaryMuscle: .shoulders, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
    ]

    // MARK: - Biceps Exercises (15)
    public static let bicepsExercises: [ExerciseData] = [
        ExerciseData(name: "Barbell Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .barbell),
        ExerciseData(name: "EZ Bar Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .barbell),
        ExerciseData(name: "Dumbbell Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Alternating Dumbbell Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Hammer Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Preacher Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .barbell),
        ExerciseData(name: "Dumbbell Preacher Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Incline Dumbbell Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Cable Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Cable Rope Hammer Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .cable),
        ExerciseData(name: "Concentration Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Spider Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Zottman Curl", primaryMuscle: .biceps, secondaryMuscles: [.forearms], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Drag Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .barbell),
        ExerciseData(name: "Machine Bicep Curl", primaryMuscle: .biceps, secondaryMuscles: [], category: .isolation, equipment: .machine),
    ]

    // MARK: - Triceps Exercises (15)
    public static let tricepsExercises: [ExerciseData] = [
        ExerciseData(name: "Close Grip Bench Press", primaryMuscle: .triceps, secondaryMuscles: [.chest], category: .compound, equipment: .barbell),
        ExerciseData(name: "Cable Tricep Pushdown", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Rope Tricep Pushdown", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Skull Crusher", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .barbell),
        ExerciseData(name: "Dumbbell Skull Crusher", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Overhead Dumbbell Extension", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Overhead Cable Extension", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Tricep Dip", primaryMuscle: .triceps, secondaryMuscles: [.chest], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Bench Dip", primaryMuscle: .triceps, secondaryMuscles: [], category: .compound, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Diamond Push-Up", primaryMuscle: .triceps, secondaryMuscles: [.chest], category: .calisthenics, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Tricep Kickback", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Cable Kickback", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "JM Press", primaryMuscle: .triceps, secondaryMuscles: [.chest], category: .compound, equipment: .barbell),
        ExerciseData(name: "Tate Press", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .dumbbell),
        ExerciseData(name: "Machine Tricep Extension", primaryMuscle: .triceps, secondaryMuscles: [], category: .isolation, equipment: .machine),
    ]

    // MARK: - Leg Exercises (40)
    public static let legExercises: [ExerciseData] = [
        // Quadriceps
        ExerciseData(name: "Barbell Back Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], category: .compound, equipment: .barbell),
        ExerciseData(name: "Barbell Front Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .core], category: .compound, equipment: .barbell),
        ExerciseData(name: "Goblet Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Leg Press", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], category: .compound, equipment: .machine),
        ExerciseData(name: "Hack Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .compound, equipment: .machine),
        ExerciseData(name: "V-Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .compound, equipment: .machine),
        ExerciseData(name: "Smith Machine Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], category: .compound, equipment: .machine),
        ExerciseData(name: "Leg Extension", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Sissy Squat", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .isolation, equipment: .bodyweight),
        ExerciseData(name: "Walking Lunge", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .hamstrings], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Reverse Lunge", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Bulgarian Split Squat", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Step-Up", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Cyclist Squat", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .compound, equipment: .dumbbell),

        // Hamstrings
        ExerciseData(name: "Romanian Deadlift", primaryMuscle: .hamstrings, secondaryMuscles: [.glutes, .back], category: .compound, equipment: .barbell),
        ExerciseData(name: "Dumbbell Romanian Deadlift", primaryMuscle: .hamstrings, secondaryMuscles: [.glutes, .back], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Single Leg Romanian Deadlift", primaryMuscle: .hamstrings, secondaryMuscles: [.glutes, .back], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Lying Leg Curl", primaryMuscle: .hamstrings, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Seated Leg Curl", primaryMuscle: .hamstrings, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Nordic Hamstring Curl", primaryMuscle: .hamstrings, secondaryMuscles: [], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Stiff Leg Deadlift", primaryMuscle: .hamstrings, secondaryMuscles: [.glutes, .back], category: .compound, equipment: .barbell),
        ExerciseData(name: "Good Morning", primaryMuscle: .hamstrings, secondaryMuscles: [.glutes, .back], category: .compound, equipment: .barbell),

        // Glutes
        ExerciseData(name: "Barbell Hip Thrust", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings], category: .compound, equipment: .barbell),
        ExerciseData(name: "Dumbbell Hip Thrust", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Glute Bridge", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings], category: .isolation, equipment: .bodyweight),
        ExerciseData(name: "Single Leg Glute Bridge", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings], category: .isolation, equipment: .bodyweight),
        ExerciseData(name: "Cable Pull Through", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings], category: .isolation, equipment: .cable),
        ExerciseData(name: "Kickback Machine", primaryMuscle: .glutes, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Frog Pump", primaryMuscle: .glutes, secondaryMuscles: [], category: .isolation, equipment: .bodyweight),
        ExerciseData(name: "Sumo Squat", primaryMuscle: .glutes, secondaryMuscles: [.quadriceps], category: .compound, equipment: .dumbbell),
        ExerciseData(name: "Cable Hip Abduction", primaryMuscle: .glutes, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Hip Abduction Machine", primaryMuscle: .glutes, secondaryMuscles: [], category: .isolation, equipment: .machine),

        // Calves
        ExerciseData(name: "Standing Calf Raise", primaryMuscle: .calves, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Seated Calf Raise", primaryMuscle: .calves, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Donkey Calf Raise", primaryMuscle: .calves, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Leg Press Calf Raise", primaryMuscle: .calves, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Single Leg Calf Raise", primaryMuscle: .calves, secondaryMuscles: [], category: .isolation, equipment: .bodyweight),
        ExerciseData(name: "Smith Machine Calf Raise", primaryMuscle: .calves, secondaryMuscles: [], category: .isolation, equipment: .machine),

        // Adductors
        ExerciseData(name: "Hip Adduction Machine", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Cable Hip Adduction", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .isolation, equipment: .cable),
    ]

    // MARK: - Core Exercises (20)
    public static let coreExercises: [ExerciseData] = [
        ExerciseData(name: "Plank", primaryMuscle: .core, secondaryMuscles: [.abs], category: .calisthenics, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Side Plank", primaryMuscle: .obliques, secondaryMuscles: [.core], category: .calisthenics, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Crunch", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Bicycle Crunch", primaryMuscle: .abs, secondaryMuscles: [.obliques], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Reverse Crunch", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Sit-Up", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "V-Up", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Hanging Leg Raise", primaryMuscle: .abs, secondaryMuscles: [], category: .compound, equipment: .pullUpBar, trackingType: .repsOnly),
        ExerciseData(name: "Hanging Knee Raise", primaryMuscle: .abs, secondaryMuscles: [], category: .compound, equipment: .pullUpBar, trackingType: .repsOnly),
        ExerciseData(name: "Captain's Chair Leg Raise", primaryMuscle: .abs, secondaryMuscles: [], category: .compound, equipment: .machine, trackingType: .repsOnly),
        ExerciseData(name: "Russian Twist", primaryMuscle: .obliques, secondaryMuscles: [.abs], category: .isolation, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Cable Woodchop", primaryMuscle: .obliques, secondaryMuscles: [.core], category: .compound, equipment: .cable),
        ExerciseData(name: "Ab Wheel Rollout", primaryMuscle: .abs, secondaryMuscles: [.core], category: .compound, equipment: .other, trackingType: .repsOnly),
        ExerciseData(name: "Dead Bug", primaryMuscle: .core, secondaryMuscles: [.abs], category: .calisthenics, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Bird Dog", primaryMuscle: .core, secondaryMuscles: [.back], category: .calisthenics, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Pallof Press", primaryMuscle: .core, secondaryMuscles: [.obliques], category: .isolation, equipment: .cable, trackingType: .repsOnly),
        ExerciseData(name: "Cable Crunch", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .cable),
        ExerciseData(name: "Machine Crunch", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .machine),
        ExerciseData(name: "Decline Sit-Up", primaryMuscle: .abs, secondaryMuscles: [], category: .isolation, equipment: .bench, trackingType: .repsOnly),
        ExerciseData(name: "Dragon Flag", primaryMuscle: .abs, secondaryMuscles: [.core], category: .calisthenics, equipment: .bench, trackingType: .repsOnly),
    ]

    // MARK: - Cardio Exercises (25)
    public static let cardioExercises: [ExerciseData] = [
        ExerciseData(name: "Treadmill Run", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .hamstrings], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Treadmill Walk", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Treadmill Incline Walk", primaryMuscle: .cardio, secondaryMuscles: [.glutes, .calves], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Outdoor Run", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .hamstrings], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Outdoor Walk", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Hiking", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .glutes], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Stationary Bike", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Spin Class", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps], category: .cardio, equipment: .machine, trackingType: .timeOnly),
        ExerciseData(name: "Outdoor Cycling", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Rowing Machine", primaryMuscle: .cardio, secondaryMuscles: [.back, .biceps], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Elliptical", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .glutes], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Stair Climber", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .glutes], category: .cardio, equipment: .machine, trackingType: .timeOnly),
        ExerciseData(name: "Swimming Freestyle", primaryMuscle: .cardio, secondaryMuscles: [.back, .shoulders], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Swimming Breaststroke", primaryMuscle: .cardio, secondaryMuscles: [.chest, .shoulders], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Swimming Backstroke", primaryMuscle: .cardio, secondaryMuscles: [.back, .shoulders], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Swimming Butterfly", primaryMuscle: .cardio, secondaryMuscles: [.shoulders, .core], category: .cardio, equipment: .none, trackingType: .distanceAndTime),
        ExerciseData(name: "Jump Rope", primaryMuscle: .cardio, secondaryMuscles: [.calves], category: .cardio, equipment: .other, trackingType: .timeOnly),
        ExerciseData(name: "Battle Ropes", primaryMuscle: .cardio, secondaryMuscles: [.shoulders, .core], category: .cardio, equipment: .other, trackingType: .timeOnly),
        ExerciseData(name: "Assault Bike", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .shoulders], category: .cardio, equipment: .machine, trackingType: .caloriesOnly),
        ExerciseData(name: "Ski Erg", primaryMuscle: .cardio, secondaryMuscles: [.back, .triceps], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "VersaClimber", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps, .glutes], category: .cardio, equipment: .machine, trackingType: .distanceAndTime),
        ExerciseData(name: "Mountain Climber", primaryMuscle: .cardio, secondaryMuscles: [.core, .shoulders], category: .cardio, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Jumping Jacks", primaryMuscle: .cardio, secondaryMuscles: [], category: .cardio, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "High Knees", primaryMuscle: .cardio, secondaryMuscles: [.quadriceps], category: .cardio, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Butt Kicks", primaryMuscle: .cardio, secondaryMuscles: [.hamstrings], category: .cardio, equipment: .bodyweight, trackingType: .timeOnly),
    ]

    // MARK: - Plyometric Exercises (15)
    public static let plyometricExercises: [ExerciseData] = [
        ExerciseData(name: "Burpee", primaryMuscle: .fullBody, secondaryMuscles: [.cardio], category: .plyometric, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Box Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes, .calves], category: .plyometric, equipment: .other, trackingType: .repsOnly),
        ExerciseData(name: "Broad Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .plyometric, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Tuck Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.core], category: .plyometric, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Squat Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .plyometric, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Split Squat Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .plyometric, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Lateral Box Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .plyometric, equipment: .other, trackingType: .repsOnly),
        ExerciseData(name: "Depth Jump", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .plyometric, equipment: .other, trackingType: .repsOnly),
        ExerciseData(name: "Clapping Push-Up", primaryMuscle: .chest, secondaryMuscles: [.triceps], category: .plyometric, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Medicine Ball Slam", primaryMuscle: .fullBody, secondaryMuscles: [.core], category: .plyometric, equipment: .medicineBall, trackingType: .repsOnly),
        ExerciseData(name: "Medicine Ball Throw", primaryMuscle: .fullBody, secondaryMuscles: [.core], category: .plyometric, equipment: .medicineBall, trackingType: .repsOnly),
        ExerciseData(name: "Kettlebell Swing", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings, .core], category: .plyometric, equipment: .kettlebell),
        ExerciseData(name: "Kettlebell Snatch", primaryMuscle: .fullBody, secondaryMuscles: [.shoulders, .core], category: .plyometric, equipment: .kettlebell),
        ExerciseData(name: "Kettlebell Clean", primaryMuscle: .fullBody, secondaryMuscles: [.biceps, .core], category: .plyometric, equipment: .kettlebell),
        ExerciseData(name: "Power Clean", primaryMuscle: .fullBody, secondaryMuscles: [.back, .quadriceps], category: .plyometric, equipment: .barbell),
    ]

    // MARK: - Flexibility/Mobility Exercises (15)
    public static let flexibilityExercises: [ExerciseData] = [
        ExerciseData(name: "Downward Dog", primaryMuscle: .fullBody, secondaryMuscles: [.hamstrings, .calves], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Cat-Cow Stretch", primaryMuscle: .back, secondaryMuscles: [.core], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Child's Pose", primaryMuscle: .back, secondaryMuscles: [.shoulders], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Pigeon Pose", primaryMuscle: .glutes, secondaryMuscles: [.hamstrings], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Seated Forward Fold", primaryMuscle: .hamstrings, secondaryMuscles: [.back], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Standing Quad Stretch", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Hip Flexor Stretch", primaryMuscle: .quadriceps, secondaryMuscles: [.glutes], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "World's Greatest Stretch", primaryMuscle: .fullBody, secondaryMuscles: [], category: .flexibility, equipment: .bodyweight, trackingType: .timeOnly),
        ExerciseData(name: "Foam Roll IT Band", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .flexibility, equipment: .foamRoller, trackingType: .timeOnly),
        ExerciseData(name: "Foam Roll Quads", primaryMuscle: .quadriceps, secondaryMuscles: [], category: .flexibility, equipment: .foamRoller, trackingType: .timeOnly),
        ExerciseData(name: "Foam Roll Back", primaryMuscle: .back, secondaryMuscles: [], category: .flexibility, equipment: .foamRoller, trackingType: .timeOnly),
        ExerciseData(name: "Foam Roll Calves", primaryMuscle: .calves, secondaryMuscles: [], category: .flexibility, equipment: .foamRoller, trackingType: .timeOnly),
        ExerciseData(name: "Shoulder Dislocates", primaryMuscle: .shoulders, secondaryMuscles: [], category: .flexibility, equipment: .resistanceBand, trackingType: .repsOnly),
        ExerciseData(name: "Wall Angels", primaryMuscle: .shoulders, secondaryMuscles: [.back], category: .flexibility, equipment: .bodyweight, trackingType: .repsOnly),
        ExerciseData(name: "Thoracic Spine Rotation", primaryMuscle: .back, secondaryMuscles: [.core], category: .flexibility, equipment: .bodyweight, trackingType: .repsOnly),
    ]
}
