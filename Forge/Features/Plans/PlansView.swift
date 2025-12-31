import SwiftUI
import CosmosCore
import CosmosUI

/// Plans tab - Browse and manage workout plans
struct PlansView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: WorkoutPlanDatabase.PlanCategory?
    @State private var searchText = ""
    @State private var showActivePlan = false

    private var filteredPlans: [WorkoutPlanDatabase.PlanTemplate] {
        var plans = WorkoutPlanDatabase.allPlans

        if let category = selectedCategory {
            plans = plans.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            plans = plans.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        return plans
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    // Active plan banner (if any)
                    if let activePlan = appState.dataService.getActivePlan() {
                        ActivePlanBanner(plan: activePlan) {
                            appState.presentSheet(.planDetail(activePlan.id))
                        }
                    }

                    // Search bar
                    searchBar

                    // Category filter
                    categoryFilter

                    // Plans grid
                    plansGrid
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .navigationTitle("Workout Plans")
            .cosmosNavigationBar()
        }
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: CosmosSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.cosmosTextTertiary)

            TextField("Search plans", text: $searchText)
                .font(.cosmosBody)
                .foregroundStyle(.white)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.cosmosTextTertiary)
                }
            }
        }
        .padding(CosmosSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                .fill(Color.cardBackground)
        )
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CosmosSpacing.sm) {
                // All categories button
                categoryButton(nil, label: "All")

                ForEach(WorkoutPlanDatabase.PlanCategory.allCases, id: \.self) { category in
                    categoryButton(category, label: category.displayName)
                }
            }
        }
    }

    private func categoryButton(_ category: WorkoutPlanDatabase.PlanCategory?, label: String) -> some View {
        let isSelected = selectedCategory == category

        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: CosmosSpacing.xs) {
                if let cat = category {
                    Image(systemName: cat.iconName)
                        .font(.system(size: 14))
                }
                Text(label)
                    .font(.cosmosCaption)
            }
            .foregroundStyle(isSelected ? .white : Color.cosmosTextSecondary)
            .padding(.horizontal, CosmosSpacing.md)
            .padding(.vertical, CosmosSpacing.sm)
            .background(
                Capsule()
                    .fill(isSelected ? Color.nebulaPurple : Color.cardBackground)
            )
        }
    }

    // MARK: - Plans Grid
    private var plansGrid: some View {
        LazyVStack(spacing: CosmosSpacing.md) {
            if filteredPlans.isEmpty {
                CosmosEmptyState(
                    icon: "list.clipboard",
                    title: "No plans found",
                    message: "Try adjusting your search or filters"
                )
            } else {
                ForEach(filteredPlans, id: \.id) { plan in
                    PlanCardView(plan: plan) {
                        appState.presentSheet(.planDetail(UUID()))
                    }
                }
            }
        }
    }
}

// MARK: - Active Plan Banner
struct ActivePlanBanner: View {
    let plan: WorkoutPlan
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: CosmosSpacing.md) {
                // Progress ring
                CosmosProgressRing(
                    progress: plan.progressPercentage,
                    lineWidth: 4,
                    gradient: LinearGradient.cosmosPurple
                )
                .frame(width: 50, height: 50)

                // Plan info
                VStack(alignment: .leading, spacing: 2) {
                    Text("Active Plan")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.nebulaPurple)

                    Text(plan.name)
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)

                    Text("Week \(plan.currentWeek) of \(plan.durationWeeks)")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.cosmosTextTertiary)
            }
            .padding(CosmosSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                    .fill(Color.nebulaPurple.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                            .stroke(Color.nebulaPurple.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Plan Card View
struct PlanCardView: View {
    let plan: WorkoutPlanDatabase.PlanTemplate
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
                // Header
                HStack {
                    // Category icon
                    Image(systemName: plan.category.iconName)
                        .font(.system(size: 24))
                        .foregroundStyle(categoryColor)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(categoryColor.opacity(0.15))
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(plan.name)
                                .font(.cosmosHeadline)
                                .foregroundStyle(.white)
                                .lineLimit(1)

                            if plan.isPremium {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.nebulaGold)
                            }
                        }

                        Text(plan.category.displayName)
                            .font(.cosmosCaption)
                            .foregroundStyle(Color.cosmosTextSecondary)
                    }

                    Spacer()

                    // Difficulty badge
                    difficultyBadge
                }

                // Description
                Text(plan.description)
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
                    .lineLimit(2)

                // Stats row
                HStack(spacing: CosmosSpacing.lg) {
                    statItem(icon: "calendar", value: "\(plan.durationWeeks) weeks")
                    statItem(icon: "clock", value: "\(plan.daysPerWeek)x/week")
                    statItem(icon: "figure.run", value: plan.workoutType.displayName)
                }
            }
            .padding(CosmosSpacing.md)
            .cosmosCardStyle()
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var categoryColor: Color {
        switch plan.category {
        case .strength: return .nebulaRed
        case .hypertrophy: return .nebulaPurple
        case .endurance: return .nebulaCyan
        case .weightLoss: return .nebulaOrange
        case .running: return .nebulaGreen
        case .swimming: return .nebulaCyan
        case .cycling: return .nebulaGold
        case .hiit: return .nebulaRed
        case .flexibility: return .nebulaLavender
        case .beginner: return .nebulaMagenta
        }
    }

    private var difficultyBadge: some View {
        Text(plan.difficulty.displayName)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(difficultyColor)
            .padding(.horizontal, CosmosSpacing.sm)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(difficultyColor.opacity(0.15))
            )
    }

    private var difficultyColor: Color {
        switch plan.difficulty {
        case .beginner: return .nebulaGreen
        case .intermediate: return .nebulaGold
        case .advanced: return .nebulaRed
        }
    }

    private func statItem(icon: String, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.cosmosTextTertiary)

            Text(value)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
    }
}

// MARK: - Plan Detail View
struct PlanDetailView: View {
    let planID: UUID
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDayIndex = 0

    // For demo, use a template plan
    private var plan: WorkoutPlanDatabase.PlanTemplate? {
        WorkoutPlanDatabase.allPlans.first
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let plan = plan {
                    VStack(spacing: CosmosSpacing.lg) {
                        // Plan header
                        planHeader(plan)

                        // Day selector
                        daySelector(plan)

                        // Selected day exercises
                        if selectedDayIndex < plan.days.count {
                            dayExercises(plan.days[selectedDayIndex])
                        }

                        // Start button
                        startButton(plan)
                    }
                    .padding(.horizontal, CosmosSpacing.screenHorizontal)
                    .padding(.bottom, CosmosSpacing.screenBottom)
                }
            }
            .cosmosBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(Color.cosmosTextSecondary)
                }
            }
        }
    }

    private func planHeader(_ plan: WorkoutPlanDatabase.PlanTemplate) -> some View {
        VStack(spacing: CosmosSpacing.md) {
            // Icon
            Image(systemName: plan.category.iconName)
                .font(.system(size: 48))
                .foregroundStyle(Color.nebulaPurple)
                .frame(width: 80, height: 80)
                .background(
                    Circle()
                        .fill(Color.nebulaPurple.opacity(0.15))
                )

            // Name
            Text(plan.name)
                .font(.cosmosTitle2)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // Description
            Text(plan.description)
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)
                .multilineTextAlignment(.center)

            // Stats
            HStack(spacing: CosmosSpacing.xl) {
                VStack(spacing: 4) {
                    Text("\(plan.durationWeeks)")
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)
                    Text("Weeks")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }

                VStack(spacing: 4) {
                    Text("\(plan.daysPerWeek)")
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)
                    Text("Days/Week")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }

                VStack(spacing: 4) {
                    Text(plan.difficulty.displayName)
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)
                    Text("Difficulty")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }
            }
            .padding(.vertical, CosmosSpacing.md)
        }
        .padding(.top, CosmosSpacing.lg)
    }

    private func daySelector(_ plan: WorkoutPlanDatabase.PlanTemplate) -> some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            Text("Workout Days")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: CosmosSpacing.sm) {
                    ForEach(Array(plan.days.enumerated()), id: \.offset) { index, day in
                        Button {
                            selectedDayIndex = index
                        } label: {
                            VStack(spacing: 4) {
                                Text("Day \(index + 1)")
                                    .font(.cosmosCaption)
                                    .foregroundStyle(selectedDayIndex == index ? .white : Color.cosmosTextTertiary)

                                Text(day.name)
                                    .font(.cosmosSubheadline)
                                    .foregroundStyle(selectedDayIndex == index ? .white : Color.cosmosTextSecondary)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, CosmosSpacing.md)
                            .padding(.vertical, CosmosSpacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                                    .fill(selectedDayIndex == index ? Color.nebulaPurple : Color.cardBackground)
                            )
                        }
                    }
                }
            }
        }
    }

    private func dayExercises(_ day: WorkoutPlanDatabase.DayTemplate) -> some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            Text(day.name)
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            ForEach(Array(day.exercises.enumerated()), id: \.offset) { index, exercise in
                HStack(spacing: CosmosSpacing.md) {
                    // Number
                    Text("\(index + 1)")
                        .font(.cosmosCaption)
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(Color.nebulaPurple.opacity(0.3))
                        )

                    // Exercise info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(exercise.exerciseName)
                            .font(.cosmosBody)
                            .foregroundStyle(.white)

                        HStack(spacing: CosmosSpacing.sm) {
                            Text("\(exercise.sets) sets × \(exercise.reps)")
                                .font(.cosmosCaption)
                                .foregroundStyle(Color.cosmosTextSecondary)

                            if let notes = exercise.notes {
                                Text("• \(notes)")
                                    .font(.cosmosCaption)
                                    .foregroundStyle(Color.cosmosTextTertiary)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(CosmosSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                        .fill(Color.cardBackground)
                )
            }
        }
    }

    private func startButton(_ plan: WorkoutPlanDatabase.PlanTemplate) -> some View {
        VStack(spacing: CosmosSpacing.sm) {
            if plan.isPremium && !appState.subscriptionService.isPremium {
                // Premium badge
                HStack(spacing: CosmosSpacing.xs) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.nebulaGold)
                    Text("Premium Plan")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.nebulaGold)
                }

                CosmosPrimaryButton("Upgrade to Start") {
                    appState.presentSheet(.subscription)
                }
            } else {
                CosmosPrimaryButton("Start This Plan") {
                    // Start the plan
                    dismiss()
                    appState.showSuccessToast("Plan started!")
                }
            }
        }
        .padding(.top, CosmosSpacing.lg)
    }
}

#Preview {
    PlansView()
        .environmentObject(AppState())
}
