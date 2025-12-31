import SwiftUI
import CosmosCore
import CosmosUI

/// Post-workout summary with stats and celebration
struct WorkoutSummaryView: View {
    let workout: Workout
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    @State private var animateStats = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.xl) {
                    // Celebration header
                    celebrationHeader

                    // Main stats
                    mainStatsGrid

                    // Exercise breakdown
                    exerciseBreakdown

                    // Personal records (if any)
                    if !personalRecords.isEmpty {
                        personalRecordsSection
                    }

                    // Action buttons
                    actionButtons
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .cosmosBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.nebulaCyan)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                animateStats = true
            }
        }
    }

    // MARK: - Celebration Header
    private var celebrationHeader: some View {
        VStack(spacing: CosmosSpacing.md) {
            // Celebration icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.nebulaGreen.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateStats ? 1 : 0.5)
                    .opacity(animateStats ? 1 : 0)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.nebulaGreen)
                    .scaleEffect(animateStats ? 1 : 0)
            }

            Text("Workout Complete!")
                .font(.cosmosTitle)
                .foregroundStyle(.white)
                .opacity(animateStats ? 1 : 0)
                .offset(y: animateStats ? 0 : 20)

            Text(formattedDate)
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .padding(.top, CosmosSpacing.xl)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d 'at' h:mm a"
        return formatter.string(from: workout.startedAt)
    }

    // MARK: - Main Stats Grid
    private var mainStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: CosmosSpacing.md) {
            // Duration
            summaryStatCard(
                icon: "clock.fill",
                iconColor: .nebulaCyan,
                value: formattedDuration,
                label: "Duration"
            )

            // Exercises
            summaryStatCard(
                icon: "dumbbell.fill",
                iconColor: .nebulaPurple,
                value: "\(workout.exercises.count)",
                label: "Exercises"
            )

            // Sets
            summaryStatCard(
                icon: "repeat",
                iconColor: .nebulaOrange,
                value: "\(workout.totalSets)",
                label: "Sets"
            )

            // Volume
            summaryStatCard(
                icon: "scalemass.fill",
                iconColor: .nebulaGreen,
                value: formattedVolume,
                label: "Volume (lbs)"
            )
        }
        .opacity(animateStats ? 1 : 0)
        .offset(y: animateStats ? 0 : 30)
    }

    private func summaryStatCard(icon: String, iconColor: Color, value: String, label: String) -> some View {
        VStack(spacing: CosmosSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(iconColor)

            Text(value)
                .font(.cosmosMediumNumber)
                .foregroundStyle(.white)

            Text(label)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CosmosSpacing.lg)
        .cosmosCardStyle()
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

    private var formattedVolume: String {
        let volume = workout.totalVolume
        if volume >= 1000 {
            return String(format: "%.1fk", volume / 1000)
        }
        return String(format: "%.0f", volume)
    }

    // MARK: - Exercise Breakdown
    private var exerciseBreakdown: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            Text("Exercise Breakdown")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            ForEach(workout.exercises) { workoutExercise in
                exerciseBreakdownRow(workoutExercise)
            }
        }
        .opacity(animateStats ? 1 : 0)
    }

    private func exerciseBreakdownRow(_ workoutExercise: WorkoutExercise) -> some View {
        HStack(spacing: CosmosSpacing.md) {
            // Exercise icon
            Circle()
                .fill(Color.nebulaPurple.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: workoutExercise.exercise?.iconName ?? "dumbbell")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.nebulaPurple)
                )

            // Exercise name
            VStack(alignment: .leading, spacing: 2) {
                Text(workoutExercise.exercise?.name ?? "Exercise")
                    .font(.cosmosBody)
                    .foregroundStyle(.white)

                Text(setsDescription(for: workoutExercise))
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }

            Spacer()

            // Best set
            VStack(alignment: .trailing, spacing: 2) {
                Text(bestSetDescription(for: workoutExercise))
                    .font(.cosmosBody)
                    .foregroundStyle(.white)

                Text("Best Set")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
            }
        }
        .padding(CosmosSpacing.md)
        .cosmosCardStyle()
    }

    private func setsDescription(for workoutExercise: WorkoutExercise) -> String {
        let completedSets = workoutExercise.sets.filter { $0.isCompleted }.count
        return "\(completedSets) sets completed"
    }

    private func bestSetDescription(for workoutExercise: WorkoutExercise) -> String {
        let completedSets = workoutExercise.sets.filter { $0.isCompleted }
        guard let bestSet = completedSets.max(by: { ($0.weight * Double($0.reps)) < ($1.weight * Double($1.reps)) }) else {
            return "-"
        }
        return "\(Int(bestSet.weight)) lbs × \(bestSet.reps)"
    }

    // MARK: - Personal Records
    private var personalRecords: [PersonalRecord] {
        // TODO: Calculate actual PRs by comparing with historical data
        return []
    }

    private var personalRecordsSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(Color.nebulaGold)
                Text("Personal Records")
                    .font(.cosmosHeadline)
                    .foregroundStyle(.white)
            }

            ForEach(personalRecords) { record in
                HStack {
                    Text(record.exerciseName)
                        .font(.cosmosBody)
                        .foregroundStyle(.white)

                    Spacer()

                    Text(record.description)
                        .font(.cosmosBody)
                        .foregroundStyle(Color.nebulaGold)
                }
                .padding(CosmosSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                        .fill(Color.nebulaGold.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                                .stroke(Color.nebulaGold.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: CosmosSpacing.md) {
            // Share button
            Button {
                showShareSheet = true
            } label: {
                HStack(spacing: CosmosSpacing.sm) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Workout")
                }
                .font(.cosmosBody)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, CosmosSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                        .fill(Color.cardBackground)
                )
            }

            // Save to Health button
            Button {
                saveToHealth()
            } label: {
                HStack(spacing: CosmosSpacing.sm) {
                    Image(systemName: "heart.fill")
                    Text("Save to Apple Health")
                }
                .font(.cosmosBody)
                .foregroundStyle(Color.nebulaRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, CosmosSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                        .stroke(Color.nebulaRed.opacity(0.5), lineWidth: 1)
                )
            }
        }
        .opacity(animateStats ? 1 : 0)
        .padding(.top, CosmosSpacing.md)
    }

    private func saveToHealth() {
        Task {
            do {
                try await appState.healthKitService.saveWorkout(workout)
                appState.showSuccessToast("Saved to Apple Health")
            } catch {
                appState.showErrorToast("Failed to save to Health")
            }
        }
    }
}

// MARK: - Personal Record Model
struct PersonalRecord: Identifiable {
    let id = UUID()
    let exerciseName: String
    let type: RecordType
    let value: Double

    enum RecordType {
        case weight
        case reps
        case volume
    }

    var description: String {
        switch type {
        case .weight:
            return "\(Int(value)) lbs PR!"
        case .reps:
            return "\(Int(value)) reps PR!"
        case .volume:
            return "\(Int(value)) lbs volume PR!"
        }
    }
}

// MARK: - Share Card View (for generating share image)
struct WorkoutShareCard: View {
    let workout: Workout

    var body: some View {
        VStack(spacing: CosmosSpacing.lg) {
            // Header
            HStack {
                Image(systemName: workout.workoutType.iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.workoutTypeColor(for: workout.workoutType.rawValue))

                Text(workout.workoutType.displayName)
                    .font(.cosmosTitle3)
                    .foregroundStyle(.white)

                Spacer()

                Text("FORGE")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
            }

            // Stats row
            HStack(spacing: CosmosSpacing.lg) {
                statItem(value: formattedDuration, label: "Duration")
                statItem(value: "\(workout.exercises.count)", label: "Exercises")
                statItem(value: "\(workout.totalSets)", label: "Sets")
            }

            // Date
            Text(formattedDate)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .padding(CosmosSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CosmosCornerRadius.lg)
                .fill(LinearGradient.cosmosBackground)
        )
        .frame(width: 320)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.cosmosHeadline)
                .foregroundStyle(.white)
            Text(label)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
    }

    private var formattedDuration: String {
        let minutes = Int(workout.duration / 60)
        return "\(minutes) min"
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: workout.startedAt)
    }
}

#Preview {
    let workout = Workout(workoutType: .gym)
    workout.duration = 3600
    return WorkoutSummaryView(workout: workout)
        .environmentObject(AppState())
}
