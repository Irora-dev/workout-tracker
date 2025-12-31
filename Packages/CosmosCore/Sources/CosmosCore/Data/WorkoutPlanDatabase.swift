import Foundation

/// Static workout plan database for preset templates
public struct WorkoutPlanDatabase {

    public struct PlanTemplate {
        public let id: String
        public let name: String
        public let description: String
        public let category: PlanCategory
        public let difficulty: PlanDifficulty
        public let durationWeeks: Int
        public let daysPerWeek: Int
        public let workoutType: WorkoutType
        public let days: [DayTemplate]
        public let isPremium: Bool

        public init(
            id: String,
            name: String,
            description: String,
            category: PlanCategory,
            difficulty: PlanDifficulty,
            durationWeeks: Int,
            daysPerWeek: Int,
            workoutType: WorkoutType,
            days: [DayTemplate],
            isPremium: Bool = false
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.category = category
            self.difficulty = difficulty
            self.durationWeeks = durationWeeks
            self.daysPerWeek = daysPerWeek
            self.workoutType = workoutType
            self.days = days
            self.isPremium = isPremium
        }
    }

    public struct DayTemplate {
        public let name: String
        public let exercises: [PlannedExerciseTemplate]

        public init(name: String, exercises: [PlannedExerciseTemplate]) {
            self.name = name
            self.exercises = exercises
        }
    }

    public struct PlannedExerciseTemplate {
        public let exerciseName: String
        public let sets: Int
        public let reps: String // "8-12" or "10" or "AMRAP"
        public let notes: String?

        public init(exerciseName: String, sets: Int, reps: String, notes: String? = nil) {
            self.exerciseName = exerciseName
            self.sets = sets
            self.reps = reps
            self.notes = notes
        }
    }

    public enum PlanCategory: String, CaseIterable {
        case strength
        case hypertrophy
        case endurance
        case weightLoss
        case running
        case swimming
        case cycling
        case hiit
        case flexibility
        case beginner

        public var displayName: String {
            switch self {
            case .strength: return "Strength"
            case .hypertrophy: return "Hypertrophy"
            case .endurance: return "Endurance"
            case .weightLoss: return "Weight Loss"
            case .running: return "Running"
            case .swimming: return "Swimming"
            case .cycling: return "Cycling"
            case .hiit: return "HIIT"
            case .flexibility: return "Flexibility"
            case .beginner: return "Beginner"
            }
        }

        public var iconName: String {
            switch self {
            case .strength: return "dumbbell.fill"
            case .hypertrophy: return "figure.strengthtraining.traditional"
            case .endurance: return "figure.run"
            case .weightLoss: return "flame.fill"
            case .running: return "figure.run"
            case .swimming: return "figure.pool.swim"
            case .cycling: return "bicycle"
            case .hiit: return "bolt.fill"
            case .flexibility: return "figure.flexibility"
            case .beginner: return "star.fill"
            }
        }
    }

    public enum PlanDifficulty: String, CaseIterable {
        case beginner
        case intermediate
        case advanced

        public var displayName: String {
            rawValue.capitalized
        }
    }

    // MARK: - All Plans (50 total)
    public static let allPlans: [PlanTemplate] =
        strengthPlans +
        hypertrophyPlans +
        runningPlans +
        swimmingPlans +
        cyclingPlans +
        hiitPlans +
        beginnerPlans +
        flexibilityPlans

    // MARK: - Strength Plans (10)
    public static let strengthPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "starting-strength",
            name: "Starting Strength",
            description: "Classic beginner strength program focusing on compound lifts with linear progression.",
            category: .strength,
            difficulty: .beginner,
            durationWeeks: 12,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Workout A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 1, reps: "5"),
                ]),
                DayTemplate(name: "Workout B", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 3, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 3, reps: "5"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "stronglifts-5x5",
            name: "StrongLifts 5x5",
            description: "Simple and effective 5x5 program for building strength with progressive overload.",
            category: .strength,
            difficulty: .beginner,
            durationWeeks: 12,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Workout A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 5, reps: "5"),
                ]),
                DayTemplate(name: "Workout B", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 1, reps: "5"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "531-beginner",
            name: "5/3/1 for Beginners",
            description: "Jim Wendler's popular strength program adapted for beginners.",
            category: .strength,
            difficulty: .beginner,
            durationWeeks: 4,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Squat Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "5/3/1", notes: "Follow 5/3/1 progression"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5", notes: "FSL sets"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 3, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "10-15"),
                ]),
                DayTemplate(name: "Bench Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "5/3/1"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "5", notes: "FSL sets"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Row", sets: 4, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 3, reps: "12-15"),
                ]),
                DayTemplate(name: "Deadlift Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 3, reps: "5/3/1"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 5, reps: "5", notes: "FSL sets"),
                    PlannedExerciseTemplate(exerciseName: "Romanian Deadlift", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Plank", sets: 3, reps: "60s"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "gzclp",
            name: "GZCLP",
            description: "Cody Lefever's linear progression program with tiered exercise structure.",
            category: .strength,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Day 1", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "3", notes: "T1"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "10", notes: "T2"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 3, reps: "15", notes: "T3"),
                ]),
                DayTemplate(name: "Day 2", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 5, reps: "3", notes: "T1"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 3, reps: "10", notes: "T2"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Row", sets: 3, reps: "15", notes: "T3"),
                ]),
                DayTemplate(name: "Day 3", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "3", notes: "T1"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "10", notes: "T2"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 3, reps: "15", notes: "T3"),
                ]),
                DayTemplate(name: "Day 4", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 5, reps: "3", notes: "T1"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 3, reps: "10", notes: "T2"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Row", sets: 3, reps: "15", notes: "T3"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "texas-method",
            name: "Texas Method",
            description: "Intermediate strength program with volume, recovery, and intensity days.",
            category: .strength,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Volume Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 1, reps: "5"),
                ]),
                DayTemplate(name: "Recovery Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 2, reps: "5", notes: "80% of Monday"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 3, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Pull-Up", sets: 3, reps: "AMRAP"),
                ]),
                DayTemplate(name: "Intensity Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 1, reps: "5", notes: "PR attempt"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 1, reps: "5", notes: "PR attempt"),
                    PlannedExerciseTemplate(exerciseName: "Power Clean", sets: 5, reps: "3"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "madcow-5x5",
            name: "Madcow 5x5",
            description: "Weekly progression program for intermediate lifters.",
            category: .strength,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Monday", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5", notes: "Ramping sets"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "5", notes: "Ramping sets"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 5, reps: "5", notes: "Ramping sets"),
                ]),
                DayTemplate(name: "Wednesday", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 4, reps: "5", notes: "Light day"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 4, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 4, reps: "5"),
                ]),
                DayTemplate(name: "Friday", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5", notes: "New PR on top set"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "5", notes: "New PR on top set"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 5, reps: "5", notes: "New PR on top set"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "smolov-jr",
            name: "Smolov Jr",
            description: "Intense 3-week peaking program for bench press or squat.",
            category: .strength,
            difficulty: .advanced,
            durationWeeks: 3,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Day 1", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 6, reps: "6", notes: "70% 1RM"),
                ]),
                DayTemplate(name: "Day 2", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 7, reps: "5", notes: "75% 1RM"),
                ]),
                DayTemplate(name: "Day 3", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 8, reps: "4", notes: "80% 1RM"),
                ]),
                DayTemplate(name: "Day 4", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 10, reps: "3", notes: "85% 1RM"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "nsuns-5-day",
            name: "nSuns 5-Day",
            description: "High volume LP program based on 5/3/1 principles.",
            category: .strength,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 5,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Bench/OHP", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 9, reps: "Varied"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 8, reps: "Varied"),
                ]),
                DayTemplate(name: "Squat/Sumo", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 9, reps: "Varied"),
                    PlannedExerciseTemplate(exerciseName: "Sumo Deadlift", sets: 8, reps: "Varied"),
                ]),
                DayTemplate(name: "OHP/Incline", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 9, reps: "Varied"),
                    PlannedExerciseTemplate(exerciseName: "Incline Barbell Bench Press", sets: 8, reps: "Varied"),
                ]),
                DayTemplate(name: "Deadlift/Front", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 9, reps: "Varied"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Front Squat", sets: 8, reps: "Varied"),
                ]),
                DayTemplate(name: "Bench/CG", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 9, reps: "Varied"),
                    PlannedExerciseTemplate(exerciseName: "Close Grip Bench Press", sets: 8, reps: "Varied"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "candito-6-week",
            name: "Candito 6 Week",
            description: "Jonnie Candito's periodized strength program.",
            category: .strength,
            difficulty: .advanced,
            durationWeeks: 6,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Upper Hypertrophy", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Seated Dumbbell Press", sets: 3, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 3, reps: "10-15"),
                ]),
                DayTemplate(name: "Lower Hypertrophy", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Romanian Deadlift", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 3, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "10-15"),
                ]),
                DayTemplate(name: "Upper Strength", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 5, reps: "3-5"),
                ]),
                DayTemplate(name: "Lower Strength", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 3, reps: "3-5"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "greyskull-lp",
            name: "Greyskull LP",
            description: "Beginner linear progression with AMRAP final sets.",
            category: .strength,
            difficulty: .beginner,
            durationWeeks: 12,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Workout A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 3, reps: "5+", notes: "AMRAP on last set"),
                    PlannedExerciseTemplate(exerciseName: "Chin-Up", sets: 3, reps: "AMRAP"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "5+"),
                ]),
                DayTemplate(name: "Workout B", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "5+", notes: "AMRAP on last set"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 3, reps: "5+"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 1, reps: "5+"),
                ]),
            ]
        ),
    ]

    // MARK: - Hypertrophy Plans (10)
    public static let hypertrophyPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "ppl-6day",
            name: "Push Pull Legs (6-Day)",
            description: "Classic bodybuilding split hitting each muscle group twice per week.",
            category: .hypertrophy,
            difficulty: .intermediate,
            durationWeeks: 8,
            daysPerWeek: 6,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Push A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 4, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Seated Dumbbell Press", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Incline Dumbbell Press", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Lateral Raise", sets: 4, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 3, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Overhead Dumbbell Extension", sets: 3, reps: "12-15"),
                ]),
                DayTemplate(name: "Pull A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 3, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Pull-Up", sets: 4, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Seated Cable Row", sets: 4, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Face Pull", sets: 4, reps: "15-20"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Hammer Curl", sets: 3, reps: "10-12"),
                ]),
                DayTemplate(name: "Legs A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 4, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Romanian Deadlift", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 4, reps: "12-15"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "upper-lower-4day",
            name: "Upper/Lower Split",
            description: "4-day split alternating between upper and lower body workouts.",
            category: .hypertrophy,
            difficulty: .intermediate,
            durationWeeks: 8,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Upper A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 4, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 4, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Seated Dumbbell Press", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 3, reps: "10-12"),
                ]),
                DayTemplate(name: "Lower A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 4, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Romanian Deadlift", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 4, reps: "12-15"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "bro-split",
            name: "Bro Split (5-Day)",
            description: "Traditional bodybuilding split with one muscle group per day.",
            category: .hypertrophy,
            difficulty: .intermediate,
            durationWeeks: 8,
            daysPerWeek: 5,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Chest", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Incline Dumbbell Press", sets: 4, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Cable Crossover", sets: 3, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Pec Deck Machine", sets: 3, reps: "12-15"),
                ]),
                DayTemplate(name: "Back", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Seated Cable Row", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Straight Arm Pulldown", sets: 3, reps: "12-15"),
                ]),
                DayTemplate(name: "Shoulders", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Seated Dumbbell Press", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Lateral Raise", sets: 4, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Reverse Dumbbell Fly", sets: 3, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Shrug", sets: 3, reps: "10-12"),
                ]),
                DayTemplate(name: "Legs", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 4, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Leg Extension", sets: 3, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 4, reps: "15-20"),
                ]),
                DayTemplate(name: "Arms", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Skull Crusher", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Hammer Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Preacher Curl", sets: 2, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Overhead Dumbbell Extension", sets: 2, reps: "12-15"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "phul",
            name: "PHUL",
            description: "Power Hypertrophy Upper Lower - combines strength and size training.",
            category: .hypertrophy,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Upper Power", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 4, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 4, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 3, reps: "5-8"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 3, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 2, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Skull Crusher", sets: 2, reps: "6-10"),
                ]),
                DayTemplate(name: "Lower Power", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 4, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 3, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 3, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 4, reps: "6-10"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "full-body-3x",
            name: "Full Body 3x/Week",
            description: "Hit every muscle group three times per week for maximum frequency.",
            category: .hypertrophy,
            difficulty: .beginner,
            durationWeeks: 8,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Full Body A", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 2, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 2, reps: "10-12"),
                ]),
                DayTemplate(name: "Full Body B", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Conventional Deadlift", sets: 3, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Incline Dumbbell Press", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 3, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Walking Lunge", sets: 2, reps: "12 each"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 2, reps: "10-12"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "arnold-split",
            name: "Arnold Split",
            description: "Arnold Schwarzenegger's classic 6-day split.",
            category: .hypertrophy,
            difficulty: .advanced,
            durationWeeks: 8,
            daysPerWeek: 6,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Chest/Back", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 5, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Pull-Up", sets: 5, reps: "Max"),
                    PlannedExerciseTemplate(exerciseName: "Incline Dumbbell Press", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Flyes", sets: 3, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "T-Bar Row", sets: 3, reps: "10-15"),
                ]),
                DayTemplate(name: "Shoulders/Arms", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Overhead Press", sets: 5, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Lateral Raise", sets: 4, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Close Grip Bench Press", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 3, reps: "10-12"),
                ]),
                DayTemplate(name: "Legs", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Stiff Leg Deadlift", sets: 4, reps: "8-12"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 4, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 4, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 5, reps: "15-20"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "german-volume",
            name: "German Volume Training",
            description: "10x10 method for extreme muscle growth.",
            category: .hypertrophy,
            difficulty: .advanced,
            durationWeeks: 6,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Chest/Back", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Bench Press", sets: 10, reps: "10", notes: "60% 1RM, 60s rest"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 10, reps: "10", notes: "60% 1RM, 60s rest"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Flyes", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Row", sets: 3, reps: "10-12"),
                ]),
                DayTemplate(name: "Legs", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 10, reps: "10", notes: "60% 1RM, 60s rest"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 10, reps: "10", notes: "60% 1RM, 60s rest"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 3, reps: "15-20"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "phat",
            name: "PHAT",
            description: "Power Hypertrophy Adaptive Training by Layne Norton.",
            category: .hypertrophy,
            difficulty: .advanced,
            durationWeeks: 12,
            daysPerWeek: 5,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Upper Power", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bent Over Row", sets: 3, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 2, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Seated Dumbbell Press", sets: 3, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 2, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Skull Crusher", sets: 2, reps: "6-10"),
                ]),
                DayTemplate(name: "Lower Power", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "3-5"),
                    PlannedExerciseTemplate(exerciseName: "Hack Squat", sets: 2, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Stiff Leg Deadlift", sets: 3, reps: "5-8"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 2, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 3, reps: "6-10"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "jeff-nippard-ppl",
            name: "Science-Based PPL",
            description: "Evidence-based push pull legs split optimized for muscle growth.",
            category: .hypertrophy,
            difficulty: .intermediate,
            durationWeeks: 10,
            daysPerWeek: 6,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Push", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Bench Press", sets: 3, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Machine Shoulder Press", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Incline Dumbbell Press", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Lateral Raise", sets: 3, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 2, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Overhead Cable Extension", sets: 2, reps: "10-12"),
                ]),
                DayTemplate(name: "Pull", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Pull-Up", sets: 3, reps: "6-10"),
                    PlannedExerciseTemplate(exerciseName: "Seated Cable Row", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Face Pull", sets: 3, reps: "15-20"),
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 2, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Incline Dumbbell Curl", sets: 2, reps: "10-12"),
                ]),
                DayTemplate(name: "Legs", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 3, reps: "6-8"),
                    PlannedExerciseTemplate(exerciseName: "Romanian Deadlift", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 3, reps: "10-15"),
                    PlannedExerciseTemplate(exerciseName: "Lying Leg Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Standing Calf Raise", sets: 4, reps: "10-12"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "chest-arm-blaster",
            name: "Arm Blaster",
            description: "Specialized program for building bigger arms.",
            category: .hypertrophy,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Arms Focus", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Curl", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Close Grip Bench Press", sets: 4, reps: "8-10"),
                    PlannedExerciseTemplate(exerciseName: "Hammer Curl", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Skull Crusher", sets: 3, reps: "10-12"),
                    PlannedExerciseTemplate(exerciseName: "Preacher Curl", sets: 3, reps: "12-15"),
                    PlannedExerciseTemplate(exerciseName: "Cable Tricep Pushdown", sets: 3, reps: "12-15"),
                ]),
            ],
            isPremium: true
        ),
    ]

    // MARK: - Running Plans (8)
    public static let runningPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "couch-to-5k",
            name: "Couch to 5K",
            description: "9-week program to go from sedentary to running 5K.",
            category: .running,
            difficulty: .beginner,
            durationWeeks: 9,
            daysPerWeek: 3,
            workoutType: .running,
            days: [
                DayTemplate(name: "Run Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Walk", sets: 1, reps: "5 min", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 8, reps: "60 sec", notes: "Alternate with walking"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Walk", sets: 1, reps: "5 min", notes: "Cooldown"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "5k-to-10k",
            name: "5K to 10K",
            description: "6-week bridge program from 5K to 10K distance.",
            category: .running,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 4,
            workoutType: .running,
            days: [
                DayTemplate(name: "Easy Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "30-40 min", notes: "Conversational pace"),
                ]),
                DayTemplate(name: "Tempo Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "20 min", notes: "Tempo pace"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Cooldown"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "half-marathon",
            name: "Half Marathon Training",
            description: "12-week program to prepare for a half marathon.",
            category: .running,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 4,
            workoutType: .running,
            days: [
                DayTemplate(name: "Easy Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "5-6 miles", notes: "Easy pace"),
                ]),
                DayTemplate(name: "Speed Work", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 6, reps: "800m", notes: "Fast with 400m recovery"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Cooldown"),
                ]),
                DayTemplate(name: "Long Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10-13 miles", notes: "Easy pace"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "marathon-training",
            name: "Marathon Training",
            description: "16-week program for your first marathon.",
            category: .running,
            difficulty: .advanced,
            durationWeeks: 16,
            daysPerWeek: 5,
            workoutType: .running,
            days: [
                DayTemplate(name: "Easy Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "6-8 miles", notes: "Easy pace"),
                ]),
                DayTemplate(name: "Intervals", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "2 miles", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 8, reps: "800m", notes: "5K pace"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "2 miles", notes: "Cooldown"),
                ]),
                DayTemplate(name: "Tempo", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "8-10 miles", notes: "Marathon pace middle miles"),
                ]),
                DayTemplate(name: "Long Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "16-22 miles", notes: "Progressive pace"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "interval-training",
            name: "Interval Training",
            description: "6-week program to improve speed through intervals.",
            category: .running,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 3,
            workoutType: .running,
            days: [
                DayTemplate(name: "Track Workout", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 6, reps: "400m", notes: "90% effort, 90s rest"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Cooldown"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "hill-sprints",
            name: "Hill Sprint Program",
            description: "Build power and speed with hill repeats.",
            category: .running,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 2,
            workoutType: .running,
            days: [
                DayTemplate(name: "Hill Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "15 min", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 8, reps: "30 sec", notes: "Hill sprints, walk down recovery"),
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "10 min", notes: "Cooldown"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "recovery-run",
            name: "Recovery Run Program",
            description: "Easy running program for active recovery.",
            category: .running,
            difficulty: .beginner,
            durationWeeks: 4,
            daysPerWeek: 3,
            workoutType: .running,
            days: [
                DayTemplate(name: "Recovery Run", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 1, reps: "20-30 min", notes: "Very easy, conversational pace"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "speed-work",
            name: "Speed Work Program",
            description: "Dedicated program to increase running speed.",
            category: .running,
            difficulty: .advanced,
            durationWeeks: 8,
            daysPerWeek: 4,
            workoutType: .running,
            days: [
                DayTemplate(name: "Short Intervals", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 12, reps: "200m", notes: "Near max effort, 200m jog recovery"),
                ]),
                DayTemplate(name: "Long Intervals", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Run", sets: 4, reps: "1000m", notes: "5K pace, 400m jog recovery"),
                ]),
            ],
            isPremium: true
        ),
    ]

    // MARK: - Swimming Plans (5)
    public static let swimmingPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "learn-to-swim",
            name: "Learn to Swim",
            description: "Beginner program for new swimmers.",
            category: .swimming,
            difficulty: .beginner,
            durationWeeks: 8,
            daysPerWeek: 3,
            workoutType: .swimming,
            days: [
                DayTemplate(name: "Swim Practice", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 4, reps: "25m", notes: "Focus on form"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Breaststroke", sets: 4, reps: "25m"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "swim-endurance",
            name: "Swim Endurance Builder",
            description: "Build endurance for longer swims.",
            category: .swimming,
            difficulty: .intermediate,
            durationWeeks: 8,
            daysPerWeek: 4,
            workoutType: .swimming,
            days: [
                DayTemplate(name: "Endurance Swim", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "500m", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 10, reps: "100m", notes: "20s rest between"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "200m", notes: "Cooldown"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "swim-sprint",
            name: "Sprint Training",
            description: "Improve swim speed with sprint workouts.",
            category: .swimming,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 3,
            workoutType: .swimming,
            days: [
                DayTemplate(name: "Sprint Day", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "400m", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 8, reps: "50m", notes: "Sprint, 30s rest"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "200m", notes: "Cooldown"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "open-water-prep",
            name: "Open Water Prep",
            description: "Prepare for open water swimming.",
            category: .swimming,
            difficulty: .advanced,
            durationWeeks: 8,
            daysPerWeek: 4,
            workoutType: .swimming,
            days: [
                DayTemplate(name: "Distance Swim", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "2000-3000m", notes: "Continuous, sighting practice"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "triathlon-swim",
            name: "Triathlon Swim",
            description: "Swim training for triathlon preparation.",
            category: .swimming,
            difficulty: .intermediate,
            durationWeeks: 12,
            daysPerWeek: 3,
            workoutType: .swimming,
            days: [
                DayTemplate(name: "Tri Swim", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "300m", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 5, reps: "200m", notes: "Race pace, 30s rest"),
                    PlannedExerciseTemplate(exerciseName: "Swimming Freestyle", sets: 1, reps: "200m", notes: "Cooldown"),
                ]),
            ],
            isPremium: true
        ),
    ]

    // MARK: - Cycling Plans (5)
    public static let cyclingPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "beginner-cycling",
            name: "Beginner Cycling",
            description: "Introduction to cycling fitness.",
            category: .cycling,
            difficulty: .beginner,
            durationWeeks: 8,
            daysPerWeek: 3,
            workoutType: .cycling,
            days: [
                DayTemplate(name: "Easy Ride", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Stationary Bike", sets: 1, reps: "30-45 min", notes: "Low resistance, steady pace"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "cycling-fitness",
            name: "Cycling for Fitness",
            description: "Build cardiovascular fitness through cycling.",
            category: .cycling,
            difficulty: .intermediate,
            durationWeeks: 8,
            daysPerWeek: 4,
            workoutType: .cycling,
            days: [
                DayTemplate(name: "Steady Ride", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Cycling", sets: 1, reps: "45-60 min", notes: "Zone 2 heart rate"),
                ]),
                DayTemplate(name: "Interval Ride", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Stationary Bike", sets: 1, reps: "10 min", notes: "Warmup"),
                    PlannedExerciseTemplate(exerciseName: "Stationary Bike", sets: 6, reps: "3 min", notes: "Hard effort, 2 min easy"),
                    PlannedExerciseTemplate(exerciseName: "Stationary Bike", sets: 1, reps: "10 min", notes: "Cooldown"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "mtb-training",
            name: "Mountain Bike Training",
            description: "Build skills and fitness for mountain biking.",
            category: .cycling,
            difficulty: .intermediate,
            durationWeeks: 8,
            daysPerWeek: 3,
            workoutType: .cycling,
            days: [
                DayTemplate(name: "Trail Ride", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Cycling", sets: 1, reps: "60-90 min", notes: "Technical terrain"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "road-race-prep",
            name: "Road Race Prep",
            description: "Prepare for road cycling races.",
            category: .cycling,
            difficulty: .advanced,
            durationWeeks: 12,
            daysPerWeek: 5,
            workoutType: .cycling,
            days: [
                DayTemplate(name: "Long Ride", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Cycling", sets: 1, reps: "3-4 hours", notes: "Endurance pace"),
                ]),
                DayTemplate(name: "Threshold", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Cycling", sets: 2, reps: "20 min", notes: "FTP effort, 5 min rest"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "spin-class",
            name: "Spin Class Program",
            description: "High-energy indoor cycling workouts.",
            category: .cycling,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 3,
            workoutType: .cycling,
            days: [
                DayTemplate(name: "Spin Session", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Spin Class", sets: 1, reps: "45 min", notes: "Follow instructor cues"),
                ]),
            ]
        ),
    ]

    // MARK: - HIIT Plans (7)
    public static let hiitPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "7-minute-workout",
            name: "7-Minute Workout",
            description: "Quick, effective full-body HIIT workout.",
            category: .hiit,
            difficulty: .beginner,
            durationWeeks: 4,
            daysPerWeek: 5,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "7-Minute Circuit", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Jumping Jacks", sets: 1, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "Push-Up", sets: 1, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "Crunch", sets: 1, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "Squat Jump", sets: 1, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "Tricep Dip", sets: 1, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "Plank", sets: 1, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "High Knees", sets: 1, reps: "30 sec"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "tabata",
            name: "Tabata Training",
            description: "Classic 20/10 interval protocol for maximum intensity.",
            category: .hiit,
            difficulty: .intermediate,
            durationWeeks: 4,
            daysPerWeek: 4,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "Tabata Session", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Burpee", sets: 8, reps: "20 sec", notes: "10 sec rest between"),
                    PlannedExerciseTemplate(exerciseName: "Mountain Climber", sets: 8, reps: "20 sec", notes: "10 sec rest between"),
                    PlannedExerciseTemplate(exerciseName: "Squat Jump", sets: 8, reps: "20 sec", notes: "10 sec rest between"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "30-day-hiit",
            name: "30-Day HIIT Challenge",
            description: "Progressive HIIT program over 30 days.",
            category: .hiit,
            difficulty: .intermediate,
            durationWeeks: 4,
            daysPerWeek: 5,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "HIIT Circuit", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Burpee", sets: 3, reps: "45 sec", notes: "15 sec rest"),
                    PlannedExerciseTemplate(exerciseName: "Mountain Climber", sets: 3, reps: "45 sec"),
                    PlannedExerciseTemplate(exerciseName: "Jump Rope", sets: 3, reps: "45 sec"),
                    PlannedExerciseTemplate(exerciseName: "Tuck Jump", sets: 3, reps: "45 sec"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "metcon",
            name: "Metabolic Conditioning",
            description: "High-intensity circuits for fat loss and conditioning.",
            category: .hiit,
            difficulty: .advanced,
            durationWeeks: 6,
            daysPerWeek: 4,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "MetCon", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Kettlebell Swing", sets: 5, reps: "20"),
                    PlannedExerciseTemplate(exerciseName: "Box Jump", sets: 5, reps: "15"),
                    PlannedExerciseTemplate(exerciseName: "Battle Ropes", sets: 5, reps: "30 sec"),
                    PlannedExerciseTemplate(exerciseName: "Burpee", sets: 5, reps: "10"),
                ]),
            ],
            isPremium: true
        ),
        PlanTemplate(
            id: "emom",
            name: "EMOM Workouts",
            description: "Every Minute On the Minute training.",
            category: .hiit,
            difficulty: .intermediate,
            durationWeeks: 4,
            daysPerWeek: 3,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "EMOM 20", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Burpee", sets: 1, reps: "10", notes: "Odd minutes"),
                    PlannedExerciseTemplate(exerciseName: "Push-Up", sets: 1, reps: "15", notes: "Even minutes"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "amrap",
            name: "AMRAP Training",
            description: "As Many Rounds As Possible workouts.",
            category: .hiit,
            difficulty: .intermediate,
            durationWeeks: 4,
            daysPerWeek: 3,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "20min AMRAP", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Burpee", sets: 1, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Push-Up", sets: 1, reps: "10"),
                    PlannedExerciseTemplate(exerciseName: "Squat Jump", sets: 1, reps: "15"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "crossfit-style",
            name: "CrossFit-Style WODs",
            description: "Varied functional fitness workouts.",
            category: .hiit,
            difficulty: .advanced,
            durationWeeks: 8,
            daysPerWeek: 5,
            workoutType: .hiit,
            days: [
                DayTemplate(name: "WOD", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Barbell Back Squat", sets: 5, reps: "5"),
                    PlannedExerciseTemplate(exerciseName: "Pull-Up", sets: 1, reps: "21-15-9", notes: "For time"),
                    PlannedExerciseTemplate(exerciseName: "Burpee", sets: 1, reps: "21-15-9"),
                ]),
            ],
            isPremium: true
        ),
    ]

    // MARK: - Beginner Plans (3)
    public static let beginnerPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "first-gym-month",
            name: "Your First Month",
            description: "Introduction to gym training for complete beginners.",
            category: .beginner,
            difficulty: .beginner,
            durationWeeks: 4,
            daysPerWeek: 3,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Full Body", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Machine Chest Press", sets: 2, reps: "12"),
                    PlannedExerciseTemplate(exerciseName: "Lat Pulldown", sets: 2, reps: "12"),
                    PlannedExerciseTemplate(exerciseName: "Leg Press", sets: 2, reps: "12"),
                    PlannedExerciseTemplate(exerciseName: "Machine Shoulder Press", sets: 2, reps: "12"),
                    PlannedExerciseTemplate(exerciseName: "Plank", sets: 2, reps: "30 sec"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "10k-steps",
            name: "10,000 Steps Challenge",
            description: "Build a daily walking habit.",
            category: .beginner,
            difficulty: .beginner,
            durationWeeks: 4,
            daysPerWeek: 7,
            workoutType: .walking,
            days: [
                DayTemplate(name: "Daily Walk", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Outdoor Walk", sets: 1, reps: "10000 steps", notes: "Break into multiple walks if needed"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "fitness-foundation",
            name: "Fitness Foundation",
            description: "Build a solid fitness base with varied training.",
            category: .beginner,
            difficulty: .beginner,
            durationWeeks: 8,
            daysPerWeek: 4,
            workoutType: .gym,
            days: [
                DayTemplate(name: "Strength", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Goblet Squat", sets: 3, reps: "10"),
                    PlannedExerciseTemplate(exerciseName: "Push-Up", sets: 3, reps: "AMRAP"),
                    PlannedExerciseTemplate(exerciseName: "Dumbbell Row", sets: 3, reps: "10 each"),
                    PlannedExerciseTemplate(exerciseName: "Plank", sets: 3, reps: "30 sec"),
                ]),
                DayTemplate(name: "Cardio", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Treadmill Walk", sets: 1, reps: "30 min", notes: "Brisk pace or incline"),
                ]),
            ]
        ),
    ]

    // MARK: - Flexibility Plans (2)
    public static let flexibilityPlans: [PlanTemplate] = [
        PlanTemplate(
            id: "daily-stretch",
            name: "Daily Stretch Routine",
            description: "10-minute daily stretching for flexibility.",
            category: .flexibility,
            difficulty: .beginner,
            durationWeeks: 4,
            daysPerWeek: 7,
            workoutType: .yoga,
            days: [
                DayTemplate(name: "Stretch", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Cat-Cow Stretch", sets: 1, reps: "60 sec"),
                    PlannedExerciseTemplate(exerciseName: "Downward Dog", sets: 1, reps: "60 sec"),
                    PlannedExerciseTemplate(exerciseName: "Hip Flexor Stretch", sets: 1, reps: "30 sec each"),
                    PlannedExerciseTemplate(exerciseName: "Seated Forward Fold", sets: 1, reps: "60 sec"),
                    PlannedExerciseTemplate(exerciseName: "Child's Pose", sets: 1, reps: "60 sec"),
                ]),
            ]
        ),
        PlanTemplate(
            id: "mobility-work",
            name: "Mobility Work",
            description: "Improve joint mobility and movement quality.",
            category: .flexibility,
            difficulty: .intermediate,
            durationWeeks: 6,
            daysPerWeek: 4,
            workoutType: .yoga,
            days: [
                DayTemplate(name: "Mobility Session", exercises: [
                    PlannedExerciseTemplate(exerciseName: "Foam Roll Quads", sets: 1, reps: "2 min"),
                    PlannedExerciseTemplate(exerciseName: "Foam Roll IT Band", sets: 1, reps: "2 min"),
                    PlannedExerciseTemplate(exerciseName: "Foam Roll Back", sets: 1, reps: "2 min"),
                    PlannedExerciseTemplate(exerciseName: "World's Greatest Stretch", sets: 2, reps: "5 each side"),
                    PlannedExerciseTemplate(exerciseName: "Shoulder Dislocates", sets: 2, reps: "10"),
                    PlannedExerciseTemplate(exerciseName: "Hip Flexor Stretch", sets: 2, reps: "60 sec each"),
                ]),
            ],
            isPremium: true
        ),
    ]
}
