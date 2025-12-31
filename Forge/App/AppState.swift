import SwiftUI
import CosmosCore

/// Global app state and navigation
@MainActor
public final class AppState: ObservableObject {
    // MARK: - Navigation
    @Published var selectedTab: Tab = .today
    @Published var navigationPath = NavigationPath()

    // MARK: - Sheets
    @Published var activeSheet: SheetType?
    @Published var activeWorkout: Workout?

    // MARK: - User State
    @Published var currentUser: ForgeUser?
    @Published var isOnboardingComplete: Bool = false

    // MARK: - Services
    let dataService: DataService
    let healthKitService: HealthKitService
    let subscriptionService: SubscriptionService

    // MARK: - Toast
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var toastType: ToastType = .success

    init(
        dataService: DataService = .shared,
        healthKitService: HealthKitService = .shared,
        subscriptionService: SubscriptionService = .shared
    ) {
        self.dataService = dataService
        self.healthKitService = healthKitService
        self.subscriptionService = subscriptionService

        loadUserState()
    }

    // MARK: - Load State
    private func loadUserState() {
        currentUser = dataService.getCurrentUser()
        isOnboardingComplete = currentUser?.hasCompletedOnboarding ?? false
    }

    // MARK: - Navigation Actions
    func switchTab(to tab: Tab) {
        selectedTab = tab
    }

    func presentSheet(_ sheet: SheetType) {
        activeSheet = sheet
    }

    func dismissSheet() {
        activeSheet = nil
    }

    // MARK: - Workout Actions
    func startWorkout(type: WorkoutType) {
        let workout = dataService.createWorkout(type: type)
        activeWorkout = workout
        activeSheet = .activeWorkout
    }

    func endWorkout() {
        if let workout = activeWorkout {
            workout.complete()
            dataService.save()

            // Update user stats
            if let user = currentUser {
                user.totalWorkouts += 1
                user.totalDuration += workout.duration
                user.totalVolume += workout.totalVolume
                dataService.save()
            }
        }
        activeWorkout = nil
        activeSheet = nil
        showSuccessToast("Workout completed!")
    }

    func cancelWorkout() {
        if let workout = activeWorkout {
            workout.cancel()
            dataService.save()
        }
        activeWorkout = nil
        activeSheet = nil
    }

    // MARK: - Toast
    func showSuccessToast(_ message: String) {
        toastMessage = message
        toastType = .success
        showToast = true
    }

    func showErrorToast(_ message: String) {
        toastMessage = message
        toastType = .error
        showToast = true
    }
}

// MARK: - Tab Enum
enum Tab: Int, CaseIterable {
    case today = 0
    case workout = 1
    case plans = 2
    case progress = 3
    case profile = 4

    var title: String {
        switch self {
        case .today: return "Today"
        case .workout: return "Workout"
        case .plans: return "Plans"
        case .progress: return "Progress"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .today: return "house"
        case .workout: return "figure.run"
        case .plans: return "list.clipboard"
        case .progress: return "chart.bar"
        case .profile: return "person"
        }
    }

    var selectedIcon: String {
        switch self {
        case .today: return "house.fill"
        case .workout: return "figure.run"
        case .plans: return "list.clipboard.fill"
        case .progress: return "chart.bar.fill"
        case .profile: return "person.fill"
        }
    }
}

// MARK: - Sheet Types
enum SheetType: Identifiable {
    case activeWorkout
    case newWorkout
    case exercisePicker
    case workoutSummary(Workout)
    case planDetail(UUID)
    case settings
    case subscription

    var id: String {
        switch self {
        case .activeWorkout: return "activeWorkout"
        case .newWorkout: return "newWorkout"
        case .exercisePicker: return "exercisePicker"
        case .workoutSummary(let workout): return "summary-\(workout.id)"
        case .planDetail(let id): return "plan-\(id)"
        case .settings: return "settings"
        case .subscription: return "subscription"
        }
    }
}

// MARK: - Toast Type (for AppState)
enum ToastType {
    case success
    case error
    case warning
    case info
}
