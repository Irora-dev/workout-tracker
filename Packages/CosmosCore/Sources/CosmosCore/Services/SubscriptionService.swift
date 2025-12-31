import Foundation
import StoreKit

/// Service for managing subscriptions and premium features
@MainActor
public final class SubscriptionService: ObservableObject {
    public static let shared = SubscriptionService()

    // MARK: - Product IDs
    private static let monthlyProductID = "com.forge.premium.monthly"
    private static let annualProductID = "com.forge.premium.annual"
    private static let lifetimeProductID = "com.forge.premium.lifetime"

    // MARK: - Published State
    @Published public private(set) var currentTier: SubscriptionTier = .free
    @Published public private(set) var expirationDate: Date?
    @Published public private(set) var isLoading = false
    @Published public private(set) var products: [Product] = []
    @Published public private(set) var purchaseError: String?

    // MARK: - Computed
    public var isPremium: Bool {
        currentTier == .premium
    }

    public var monthlyProduct: Product? {
        products.first { $0.id == Self.monthlyProductID }
    }

    public var annualProduct: Product? {
        products.first { $0.id == Self.annualProductID }
    }

    public var lifetimeProduct: Product? {
        products.first { $0.id == Self.lifetimeProductID }
    }

    private var updateListenerTask: Task<Void, Error>?

    private init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await checkEntitlement()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load Products
    public func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let productIDs: Set<String> = [
                Self.monthlyProductID,
                Self.annualProductID,
                Self.lifetimeProductID
            ]
            products = try await Product.products(for: productIDs)
                .sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
            purchaseError = "Failed to load subscription options"
        }
    }

    // MARK: - Purchase
    public func purchase(_ product: Product) async throws -> Transaction? {
        isLoading = true
        purchaseError = nil
        defer { isLoading = false }

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateSubscriptionStatus(transaction)
            await transaction.finish()
            return transaction

        case .userCancelled:
            return nil

        case .pending:
            purchaseError = "Purchase is pending approval"
            return nil

        @unknown default:
            return nil
        }
    }

    // MARK: - Restore
    public func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                await updateSubscriptionStatus(transaction)
            }
        }
    }

    // MARK: - Check Entitlement
    public func checkEntitlement() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                await updateSubscriptionStatus(transaction)
            }
        }
    }

    // MARK: - Feature Gating
    public func hasAccess(to feature: PremiumFeature) -> Bool {
        guard !isPremium else { return true }
        return feature.isAvailableForFree
    }

    // MARK: - Private Helpers
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self.updateSubscriptionStatus(transaction)
                    await transaction.finish()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }

    private func updateSubscriptionStatus(_ transaction: Transaction) async {
        if transaction.revocationDate != nil {
            currentTier = .free
            expirationDate = nil
            return
        }

        if transaction.productID == Self.lifetimeProductID {
            currentTier = .premium
            expirationDate = nil
            return
        }

        if let expirationDate = transaction.expirationDate {
            if expirationDate > Date() {
                currentTier = .premium
                self.expirationDate = expirationDate
            } else {
                currentTier = .free
                self.expirationDate = nil
            }
        }
    }
}

// MARK: - Premium Features
public enum PremiumFeature: String, CaseIterable {
    // Workouts
    case unlimitedWorkoutTypes
    case customExercises
    case workoutNotes
    case restTimer

    // Plans
    case allWorkoutPlans
    case customPlans
    case planScheduling

    // Analytics
    case advancedAnalytics
    case personalRecords
    case progressCharts
    case exportData

    // Health
    case healthKitSync
    case healthInsights

    // Social
    case challenges
    case leaderboards
    case shareWorkouts

    // General
    case unlimitedHistory
    case removeAds
    case prioritySupport

    public var displayName: String {
        switch self {
        case .unlimitedWorkoutTypes: return "All Workout Types"
        case .customExercises: return "Custom Exercises"
        case .workoutNotes: return "Workout Notes"
        case .restTimer: return "Rest Timer"
        case .allWorkoutPlans: return "50+ Workout Plans"
        case .customPlans: return "Custom Plans"
        case .planScheduling: return "Plan Scheduling"
        case .advancedAnalytics: return "Advanced Analytics"
        case .personalRecords: return "Personal Records"
        case .progressCharts: return "Progress Charts"
        case .exportData: return "Export Data"
        case .healthKitSync: return "HealthKit Sync"
        case .healthInsights: return "Health Insights"
        case .challenges: return "Challenges"
        case .leaderboards: return "Leaderboards"
        case .shareWorkouts: return "Share Workouts"
        case .unlimitedHistory: return "Unlimited History"
        case .removeAds: return "No Ads"
        case .prioritySupport: return "Priority Support"
        }
    }

    public var iconName: String {
        switch self {
        case .unlimitedWorkoutTypes: return "figure.mixed.cardio"
        case .customExercises: return "plus.circle.fill"
        case .workoutNotes: return "note.text"
        case .restTimer: return "timer"
        case .allWorkoutPlans: return "list.bullet.clipboard"
        case .customPlans: return "pencil.and.list.clipboard"
        case .planScheduling: return "calendar"
        case .advancedAnalytics: return "chart.xyaxis.line"
        case .personalRecords: return "trophy.fill"
        case .progressCharts: return "chart.bar.fill"
        case .exportData: return "square.and.arrow.up"
        case .healthKitSync: return "heart.fill"
        case .healthInsights: return "waveform.path.ecg"
        case .challenges: return "flag.fill"
        case .leaderboards: return "list.number"
        case .shareWorkouts: return "square.and.arrow.up.circle.fill"
        case .unlimitedHistory: return "clock.arrow.circlepath"
        case .removeAds: return "xmark.circle.fill"
        case .prioritySupport: return "bubble.left.and.bubble.right.fill"
        }
    }

    public var isAvailableForFree: Bool {
        switch self {
        case .restTimer, .workoutNotes:
            return true
        default:
            return false
        }
    }
}

// MARK: - Feature Limits
public struct FeatureLimits {
    // Free tier limits
    public static let freeWorkoutTypes = 3
    public static let freeHistoryDays = 7
    public static let freeWorkoutPlans = 5
    public static let freeCustomExercises = 5

    // Premium has unlimited
}

// MARK: - Errors
public enum SubscriptionError: Error, LocalizedError {
    case verificationFailed
    case purchaseFailed
    case networkError

    public var errorDescription: String? {
        switch self {
        case .verificationFailed:
            return "Purchase verification failed"
        case .purchaseFailed:
            return "Purchase could not be completed"
        case .networkError:
            return "Network error. Please try again."
        }
    }
}
