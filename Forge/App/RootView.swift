import SwiftUI
import CosmosCore
import CosmosUI

/// Root view with tab navigation
struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            TabView(selection: $appState.selectedTab) {
                HomeView()
                    .tag(Tab.today)

                WorkoutView()
                    .tag(Tab.workout)

                PlansView()
                    .tag(Tab.plans)

                ProgressDashboardView()
                    .tag(Tab.progress)

                ProfileView()
                    .tag(Tab.profile)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom tab bar
            CosmosTabBar(
                selectedTab: Binding(
                    get: { appState.selectedTab.rawValue },
                    set: { appState.selectedTab = Tab(rawValue: $0) ?? .today }
                ),
                items: Tab.allCases.map { tab in
                    CosmosTabItem(
                        id: tab.rawValue,
                        icon: tab.icon,
                        selectedIcon: tab.selectedIcon,
                        label: tab.title
                    )
                }
            )
        }
        .cosmosBackground()
        .sheet(item: $appState.activeSheet) { sheet in
            sheetContent(for: sheet)
        }
        .cosmosToast(
            isPresented: $appState.showToast,
            message: appState.toastMessage,
            type: cosmosToastType
        )
    }

    private var cosmosToastType: CosmosUI.ToastType {
        switch appState.toastType {
        case .success: return .success
        case .error: return .error
        case .warning: return .warning
        case .info: return .info
        }
    }

    @ViewBuilder
    private func sheetContent(for sheet: SheetType) -> some View {
        switch sheet {
        case .activeWorkout:
            if let workout = appState.activeWorkout {
                ActiveWorkoutView(workout: workout)
                    .environmentObject(appState)
            }

        case .newWorkout:
            NewWorkoutView()
                .environmentObject(appState)

        case .exercisePicker:
            ExercisePickerView()
                .environmentObject(appState)

        case .workoutSummary(let workout):
            WorkoutSummaryView(workout: workout)
                .environmentObject(appState)

        case .planDetail(let planID):
            PlanDetailView(planID: planID)
                .environmentObject(appState)

        case .settings:
            SettingsView()
                .environmentObject(appState)

        case .subscription:
            SubscriptionView()
                .environmentObject(appState)
        }
    }
}

// MARK: - Placeholder Views (to be implemented)

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    // Header
                    headerSection

                    // Quick stats
                    quickStatsSection

                    // Today's workout
                    todayWorkoutSection

                    // Recent activity
                    recentActivitySection
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .navigationTitle("Today")
            .cosmosNavigationBar()
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            Text(greetingText)
                .font(.cosmosTitle)
                .foregroundStyle(.white)

            Text(dateText)
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, CosmosSpacing.lg)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    private var quickStatsSection: some View {
        HStack(spacing: CosmosSpacing.md) {
            CosmosStatCard(
                title: "Streak",
                value: "\(appState.currentUser?.currentStreak ?? 0)",
                subtitle: "days",
                icon: "flame.fill",
                iconColor: .nebulaGold
            )

            CosmosStatCard(
                title: "This Week",
                value: "\(appState.dataService.workoutsThisWeek())",
                subtitle: "workouts",
                icon: "figure.run",
                iconColor: .nebulaCyan
            )
        }
    }

    private var todayWorkoutSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            Text("Start Workout")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: CosmosSpacing.md) {
                workoutTypeButton(.gym)
                workoutTypeButton(.running)
                workoutTypeButton(.cycling)
                workoutTypeButton(.hiit)
            }
        }
    }

    private func workoutTypeButton(_ type: WorkoutType) -> some View {
        Button {
            appState.startWorkout(type: type)
        } label: {
            VStack(spacing: CosmosSpacing.sm) {
                Image(systemName: type.iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(Color.workoutTypeColor(for: type.rawValue))

                Text(type.displayName)
                    .font(.cosmosCaption)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, CosmosSpacing.lg)
            .cosmosCardStyle()
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            HStack {
                Text("Recent Workouts")
                    .font(.cosmosHeadline)
                    .foregroundStyle(.white)

                Spacer()

                Button("See All") {
                    appState.switchTab(to: .progress)
                }
                .font(.cosmosCaption)
                .foregroundStyle(Color.nebulaPurple)
            }

            let recentWorkouts = appState.dataService.fetchWorkouts(limit: 3)

            if recentWorkouts.isEmpty {
                CosmosEmptyState(
                    icon: "figure.run",
                    title: "No workouts yet",
                    message: "Start your first workout to see it here"
                )
            } else {
                ForEach(recentWorkouts, id: \.id) { workout in
                    WorkoutRowView(workout: workout)
                }
            }
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout

    var body: some View {
        CosmosCard {
            HStack(spacing: CosmosSpacing.md) {
                Image(systemName: workout.workoutType.iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.workoutTypeColor(for: workout.workoutType.rawValue))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.workoutTypeColor(for: workout.workoutType.rawValue).opacity(0.15))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(workout.name ?? workout.workoutType.displayName)
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)

                    Text(formattedDate)
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(formattedDuration)
                        .font(.cosmosSubheadline)
                        .foregroundStyle(.white)

                    if workout.totalSets > 0 {
                        Text("\(workout.totalSets) sets")
                            .font(.cosmosCaption)
                            .foregroundStyle(Color.cosmosTextSecondary)
                    }
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: workout.startedAt, relativeTo: Date())
    }

    private var formattedDuration: String {
        let minutes = Int(workout.duration / 60)
        if minutes >= 60 {
            let hours = minutes / 60
            let mins = minutes % 60
            return "\(hours)h \(mins)m"
        }
        return "\(minutes) min"
    }
}

struct WorkoutView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    Text("Choose a workout type")
                        .font(.cosmosSubheadline)
                        .foregroundStyle(Color.cosmosTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: CosmosSpacing.md) {
                        ForEach(WorkoutType.allCases.prefix(15), id: \.self) { type in
                            workoutTypeCard(type)
                        }
                    }
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .navigationTitle("New Workout")
            .cosmosNavigationBar()
        }
    }

    private func workoutTypeCard(_ type: WorkoutType) -> some View {
        Button {
            appState.startWorkout(type: type)
        } label: {
            VStack(spacing: CosmosSpacing.sm) {
                Image(systemName: type.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.workoutTypeColor(for: type.rawValue))

                Text(type.displayName)
                    .font(.cosmosCaption)
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, CosmosSpacing.lg)
            .cosmosCardStyle()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}


struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    // Profile header
                    profileHeader

                    // Stats
                    statsSection

                    // Settings
                    settingsSection
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .navigationTitle("Profile")
            .cosmosNavigationBar()
        }
    }

    private var profileHeader: some View {
        VStack(spacing: CosmosSpacing.md) {
            // Avatar
            Circle()
                .fill(LinearGradient.cosmosNebula)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(appState.currentUser?.avatarInitials ?? "FG")
                        .font(.cosmosTitle2)
                        .foregroundStyle(.white)
                )

            Text(appState.currentUser?.displayName ?? "Forge User")
                .font(.cosmosTitle3)
                .foregroundStyle(.white)

            if !appState.subscriptionService.isPremium {
                Button {
                    appState.presentSheet(.subscription)
                } label: {
                    Text("Upgrade to Premium")
                        .font(.cosmosCaption)
                        .foregroundStyle(.white)
                        .padding(.horizontal, CosmosSpacing.md)
                        .padding(.vertical, CosmosSpacing.xs)
                        .background(
                            Capsule()
                                .fill(LinearGradient.cosmosPurple)
                        )
                }
            }
        }
        .padding(.vertical, CosmosSpacing.lg)
    }

    private var statsSection: some View {
        VStack(spacing: CosmosSpacing.md) {
            HStack(spacing: CosmosSpacing.md) {
                statCard(value: "\(appState.currentUser?.totalWorkouts ?? 0)", label: "Workouts")
                statCard(value: "\(appState.currentUser?.currentStreak ?? 0)", label: "Streak")
                statCard(value: "\(appState.currentUser?.longestStreak ?? 0)", label: "Best")
            }
        }
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(spacing: CosmosSpacing.xs) {
            Text(value)
                .font(.cosmosMediumNumber)
                .foregroundStyle(.white)

            Text(label)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CosmosSpacing.md)
        .cosmosCardStyle()
    }

    private var settingsSection: some View {
        VStack(spacing: CosmosSpacing.sm) {
            settingsRow(icon: "gearshape", title: "Settings") {
                appState.presentSheet(.settings)
            }

            settingsRow(icon: "heart", title: "Connect Health") {
                Task {
                    try? await appState.healthKitService.requestAuthorization()
                }
            }

            settingsRow(icon: "star", title: "Rate Forge") {}

            settingsRow(icon: "questionmark.circle", title: "Help & Support") {}
        }
    }

    private func settingsRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: CosmosSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.nebulaLavender)
                    .frame(width: 32)

                Text(title)
                    .font(.cosmosBody)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.cosmosTextTertiary)
            }
            .padding(.vertical, CosmosSpacing.md)
            .padding(.horizontal, CosmosSpacing.md)
            .cosmosCardStyle()
        }
    }
}

// MARK: - Placeholder Sheet Views (remaining)
struct NewWorkoutView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            WorkoutView()
                .environmentObject(appState)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundStyle(Color.cosmosTextSecondary)
                    }
                }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
