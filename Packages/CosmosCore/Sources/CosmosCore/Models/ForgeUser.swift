import Foundation
import SwiftData

/// The user profile for Forge
@Model
public final class ForgeUser {
    // MARK: - Identity
    @Attribute(.unique) public var id: UUID
    public var appleUserID: String?
    public var createdAt: Date
    public var updatedAt: Date

    // MARK: - Profile
    public var displayName: String?
    public var username: String?
    public var bio: String?
    public var avatarData: Data?
    public var isPublicProfile: Bool

    // MARK: - Subscription
    public var subscriptionTier: SubscriptionTier
    public var subscriptionExpiresAt: Date?
    public var subscriptionProductID: String?
    public var hasLifetimePurchase: Bool

    // MARK: - Preferences
    public var weightUnit: WeightUnit
    public var distanceUnit: DistanceUnit
    public var preferredWorkoutTypes: [WorkoutType]
    public var weekStartsOnMonday: Bool
    public var defaultRestTime: TimeInterval  // In seconds

    // MARK: - Notifications
    public var workoutRemindersEnabled: Bool
    public var reminderTime: Date?
    public var streakRemindersEnabled: Bool
    public var socialNotificationsEnabled: Bool

    // MARK: - Stats (Denormalized for performance)
    public var totalWorkouts: Int
    public var totalDuration: TimeInterval  // In seconds
    public var totalVolume: Double
    public var currentStreak: Int
    public var longestStreak: Int
    public var personalRecords: Int

    // MARK: - Social
    public var followingCount: Int
    public var followersCount: Int

    // MARK: - Onboarding
    public var hasCompletedOnboarding: Bool
    public var hasConnectedHealthKit: Bool

    // MARK: - Computed
    public var isPremium: Bool {
        subscriptionTier == .premium || hasLifetimePurchase
    }

    public var avatarInitials: String {
        if let name = displayName, !name.isEmpty {
            let parts = name.split(separator: " ")
            if parts.count >= 2 {
                return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
            }
            return String(name.prefix(2)).uppercased()
        }
        return "FG"
    }

    public init(
        id: UUID = UUID(),
        appleUserID: String? = nil
    ) {
        self.id = id
        self.appleUserID = appleUserID
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isPublicProfile = false
        self.subscriptionTier = .free
        self.hasLifetimePurchase = false
        self.weightUnit = .pounds
        self.distanceUnit = .miles
        self.preferredWorkoutTypes = []
        self.weekStartsOnMonday = true
        self.defaultRestTime = 90
        self.workoutRemindersEnabled = false
        self.streakRemindersEnabled = true
        self.socialNotificationsEnabled = true
        self.totalWorkouts = 0
        self.totalDuration = 0
        self.totalVolume = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.personalRecords = 0
        self.followingCount = 0
        self.followersCount = 0
        self.hasCompletedOnboarding = false
        self.hasConnectedHealthKit = false
    }

    // MARK: - Methods
    public func updateStreak(workoutDate: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let workoutDay = calendar.startOfDay(for: workoutDate)

        if workoutDay == today {
            // Check if we already have a workout today
            // This should be called after incrementing totalWorkouts
            if currentStreak == 0 {
                currentStreak = 1
            }
        }

        longestStreak = max(longestStreak, currentStreak)
        updatedAt = Date()
    }
}

// MARK: - Supporting Types

public enum SubscriptionTier: String, Codable {
    case free
    case premium

    public var displayName: String {
        switch self {
        case .free: return "Free"
        case .premium: return "Premium"
        }
    }
}

public enum WeightUnit: String, Codable, CaseIterable {
    case pounds
    case kilograms

    public var displayName: String {
        switch self {
        case .pounds: return "Pounds (lbs)"
        case .kilograms: return "Kilograms (kg)"
        }
    }

    public var abbreviation: String {
        switch self {
        case .pounds: return "lbs"
        case .kilograms: return "kg"
        }
    }

    public func convert(_ value: Double, to unit: WeightUnit) -> Double {
        if self == unit { return value }
        switch (self, unit) {
        case (.pounds, .kilograms):
            return value * 0.453592
        case (.kilograms, .pounds):
            return value * 2.20462
        default:
            return value
        }
    }
}

public enum DistanceUnit: String, Codable, CaseIterable {
    case miles
    case kilometers

    public var displayName: String {
        switch self {
        case .miles: return "Miles"
        case .kilometers: return "Kilometers"
        }
    }

    public var abbreviation: String {
        switch self {
        case .miles: return "mi"
        case .kilometers: return "km"
        }
    }

    public func convert(_ meters: Double) -> Double {
        switch self {
        case .miles:
            return meters / 1609.344
        case .kilometers:
            return meters / 1000
        }
    }
}
