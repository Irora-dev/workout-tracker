import Foundation
import SwiftData

// MARK: - User Profile (Public View)

/// Public-facing user profile for social features
@Model
public final class UserProfile {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var userID: UUID  // Reference to ForgeUser
    public var createdAt: Date
    public var updatedAt: Date

    // MARK: - Profile Info
    public var displayName: String
    public var username: String
    public var bio: String?
    public var avatarData: Data?

    // MARK: - Stats (Public)
    public var totalWorkouts: Int
    public var currentStreak: Int
    public var longestStreak: Int
    public var memberSince: Date
    public var favoriteWorkoutType: WorkoutType?

    // MARK: - Privacy
    public var showWorkouts: Bool
    public var showStats: Bool
    public var allowFollows: Bool

    public init(
        id: UUID = UUID(),
        userID: UUID,
        displayName: String,
        username: String
    ) {
        self.id = id
        self.userID = userID
        self.createdAt = Date()
        self.updatedAt = Date()
        self.displayName = displayName
        self.username = username
        self.totalWorkouts = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.memberSince = Date()
        self.showWorkouts = true
        self.showStats = true
        self.allowFollows = true
    }
}

// MARK: - Follow Relationship

@Model
public final class Follow {
    @Attribute(.unique) public var id: UUID
    public var followerID: UUID
    public var followingID: UUID
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        followerID: UUID,
        followingID: UUID
    ) {
        self.id = id
        self.followerID = followerID
        self.followingID = followingID
        self.createdAt = Date()
    }
}

// MARK: - Activity Feed

@Model
public final class ActivityFeedItem {
    @Attribute(.unique) public var id: UUID
    public var userID: UUID
    public var username: String
    public var avatarData: Data?
    public var createdAt: Date

    public var activityType: ActivityType
    public var workoutID: UUID?
    public var workoutType: WorkoutType?
    public var workoutDuration: TimeInterval?
    public var workoutName: String?
    public var achievementType: AchievementType?
    public var challengeID: UUID?
    public var challengeName: String?

    // MARK: - Engagement
    public var likesCount: Int
    public var commentsCount: Int
    public var isLikedByCurrentUser: Bool

    public init(
        id: UUID = UUID(),
        userID: UUID,
        username: String,
        activityType: ActivityType
    ) {
        self.id = id
        self.userID = userID
        self.username = username
        self.createdAt = Date()
        self.activityType = activityType
        self.likesCount = 0
        self.commentsCount = 0
        self.isLikedByCurrentUser = false
    }
}

public enum ActivityType: String, Codable {
    case workoutCompleted
    case achievementUnlocked
    case streakMilestone
    case personalRecord
    case challengeJoined
    case challengeCompleted
    case startedPlan

    public var displayVerb: String {
        switch self {
        case .workoutCompleted: return "completed"
        case .achievementUnlocked: return "unlocked"
        case .streakMilestone: return "reached"
        case .personalRecord: return "set"
        case .challengeJoined: return "joined"
        case .challengeCompleted: return "completed"
        case .startedPlan: return "started"
        }
    }
}

// MARK: - Challenges

@Model
public final class Challenge {
    @Attribute(.unique) public var id: UUID
    public var createdAt: Date
    public var creatorID: UUID

    // MARK: - Core Properties
    public var title: String
    public var challengeDescription: String?
    public var iconName: String
    public var colorHex: String

    // MARK: - Timing
    public var startDate: Date
    public var endDate: Date

    // MARK: - Type & Target
    public var challengeType: ChallengeType
    public var targetValue: Double  // Workouts, minutes, volume, distance, etc.
    public var targetUnit: String   // "workouts", "minutes", "lbs", "km"

    // MARK: - Visibility
    public var isPublic: Bool
    public var maxParticipants: Int?

    // MARK: - Stats
    public var participantCount: Int
    public var completedCount: Int

    public init(
        id: UUID = UUID(),
        creatorID: UUID,
        title: String,
        description: String? = nil,
        iconName: String = "trophy.fill",
        colorHex: String = "#40D9F2",
        startDate: Date,
        endDate: Date,
        challengeType: ChallengeType,
        targetValue: Double,
        targetUnit: String,
        isPublic: Bool = true
    ) {
        self.id = id
        self.createdAt = Date()
        self.creatorID = creatorID
        self.title = title
        self.challengeDescription = description
        self.iconName = iconName
        self.colorHex = colorHex
        self.startDate = startDate
        self.endDate = endDate
        self.challengeType = challengeType
        self.targetValue = targetValue
        self.targetUnit = targetUnit
        self.isPublic = isPublic
        self.participantCount = 0
        self.completedCount = 0
    }

    public var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }

    public var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }
}

public enum ChallengeType: String, Codable, CaseIterable {
    case totalWorkouts      // Complete X workouts
    case totalDuration      // Workout for X total minutes
    case totalVolume        // Lift X total lbs/kg
    case totalDistance      // Run/cycle X distance
    case consecutiveDays    // Workout X days in a row
    case specificType       // Complete X workouts of a specific type

    public var displayName: String {
        switch self {
        case .totalWorkouts: return "Total Workouts"
        case .totalDuration: return "Total Time"
        case .totalVolume: return "Total Volume"
        case .totalDistance: return "Total Distance"
        case .consecutiveDays: return "Consecutive Days"
        case .specificType: return "Workout Type"
        }
    }

    public var iconName: String {
        switch self {
        case .totalWorkouts: return "number"
        case .totalDuration: return "clock.fill"
        case .totalVolume: return "scalemass.fill"
        case .totalDistance: return "figure.run"
        case .consecutiveDays: return "flame.fill"
        case .specificType: return "star.fill"
        }
    }
}

// MARK: - Challenge Participation

@Model
public final class ChallengeParticipant {
    @Attribute(.unique) public var id: UUID
    public var challengeID: UUID
    public var userID: UUID
    public var username: String
    public var avatarData: Data?
    public var joinedAt: Date

    public var currentProgress: Double
    public var isCompleted: Bool
    public var completedAt: Date?
    public var rank: Int?

    public init(
        id: UUID = UUID(),
        challengeID: UUID,
        userID: UUID,
        username: String
    ) {
        self.id = id
        self.challengeID = challengeID
        self.userID = userID
        self.username = username
        self.joinedAt = Date()
        self.currentProgress = 0
        self.isCompleted = false
    }
}

// MARK: - Achievements

public enum AchievementType: String, Codable, CaseIterable {
    // Workout Count
    case firstWorkout
    case tenWorkouts
    case fiftyWorkouts
    case hundredWorkouts
    case fiveHundredWorkouts

    // Streaks
    case threeDayStreak
    case sevenDayStreak
    case fourteenDayStreak
    case thirtyDayStreak
    case sixtyDayStreak
    case ninetyDayStreak
    case yearStreak

    // Volume Milestones
    case thousandPounds
    case tenThousandPounds
    case hundredThousandPounds
    case millionPounds

    // Distance Milestones
    case firstMile
    case tenMiles
    case marathon
    case hundredMiles

    // Variety
    case triedAllTypes
    case weekendWarrior
    case earlyBird
    case nightOwl

    // Social
    case firstFollow
    case tenFollowers
    case challengeWinner
    case challengeCreator

    public var displayName: String {
        switch self {
        case .firstWorkout: return "First Step"
        case .tenWorkouts: return "Getting Started"
        case .fiftyWorkouts: return "Dedicated"
        case .hundredWorkouts: return "Century Club"
        case .fiveHundredWorkouts: return "Iron Will"
        case .threeDayStreak: return "Three-peat"
        case .sevenDayStreak: return "Week Warrior"
        case .fourteenDayStreak: return "Fortnight Force"
        case .thirtyDayStreak: return "Monthly Master"
        case .sixtyDayStreak: return "Two Month Titan"
        case .ninetyDayStreak: return "Quarter Champion"
        case .yearStreak: return "Year of Steel"
        case .thousandPounds: return "Ton of Fun"
        case .tenThousandPounds: return "Heavy Lifter"
        case .hundredThousandPounds: return "Volume King"
        case .millionPounds: return "Millionaire"
        case .firstMile: return "Mile Marker"
        case .tenMiles: return "Distance Runner"
        case .marathon: return "Marathoner"
        case .hundredMiles: return "Ultra Runner"
        case .triedAllTypes: return "Jack of All Trades"
        case .weekendWarrior: return "Weekend Warrior"
        case .earlyBird: return "Early Bird"
        case .nightOwl: return "Night Owl"
        case .firstFollow: return "Social Butterfly"
        case .tenFollowers: return "Influencer"
        case .challengeWinner: return "Champion"
        case .challengeCreator: return "Challenge Master"
        }
    }

    public var description: String {
        switch self {
        case .firstWorkout: return "Complete your first workout"
        case .tenWorkouts: return "Complete 10 workouts"
        case .fiftyWorkouts: return "Complete 50 workouts"
        case .hundredWorkouts: return "Complete 100 workouts"
        case .fiveHundredWorkouts: return "Complete 500 workouts"
        case .threeDayStreak: return "Work out 3 days in a row"
        case .sevenDayStreak: return "Work out 7 days in a row"
        case .fourteenDayStreak: return "Work out 14 days in a row"
        case .thirtyDayStreak: return "Work out 30 days in a row"
        case .sixtyDayStreak: return "Work out 60 days in a row"
        case .ninetyDayStreak: return "Work out 90 days in a row"
        case .yearStreak: return "Work out 365 days in a row"
        case .thousandPounds: return "Lift 1,000 lbs total volume"
        case .tenThousandPounds: return "Lift 10,000 lbs total volume"
        case .hundredThousandPounds: return "Lift 100,000 lbs total volume"
        case .millionPounds: return "Lift 1,000,000 lbs total volume"
        case .firstMile: return "Run your first mile"
        case .tenMiles: return "Run 10 miles total"
        case .marathon: return "Run 26.2 miles total"
        case .hundredMiles: return "Run 100 miles total"
        case .triedAllTypes: return "Try 5 different workout types"
        case .weekendWarrior: return "Work out both Saturday and Sunday"
        case .earlyBird: return "Complete a workout before 7 AM"
        case .nightOwl: return "Complete a workout after 10 PM"
        case .firstFollow: return "Follow your first user"
        case .tenFollowers: return "Get 10 followers"
        case .challengeWinner: return "Win a challenge"
        case .challengeCreator: return "Create a challenge"
        }
    }

    public var iconName: String {
        switch self {
        case .firstWorkout: return "star.fill"
        case .tenWorkouts, .fiftyWorkouts, .hundredWorkouts, .fiveHundredWorkouts: return "flame.fill"
        case .threeDayStreak, .sevenDayStreak, .fourteenDayStreak, .thirtyDayStreak,
             .sixtyDayStreak, .ninetyDayStreak, .yearStreak: return "bolt.fill"
        case .thousandPounds, .tenThousandPounds, .hundredThousandPounds, .millionPounds: return "scalemass.fill"
        case .firstMile, .tenMiles, .marathon, .hundredMiles: return "figure.run"
        case .triedAllTypes: return "sparkles"
        case .weekendWarrior: return "sun.max.fill"
        case .earlyBird: return "sunrise.fill"
        case .nightOwl: return "moon.fill"
        case .firstFollow, .tenFollowers: return "person.2.fill"
        case .challengeWinner, .challengeCreator: return "trophy.fill"
        }
    }
}

@Model
public final class UnlockedAchievement {
    @Attribute(.unique) public var id: UUID
    public var userID: UUID
    public var achievementType: AchievementType
    public var unlockedAt: Date

    public init(
        id: UUID = UUID(),
        userID: UUID,
        achievementType: AchievementType
    ) {
        self.id = id
        self.userID = userID
        self.achievementType = achievementType
        self.unlockedAt = Date()
    }
}
