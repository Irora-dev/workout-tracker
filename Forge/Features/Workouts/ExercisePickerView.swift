import SwiftUI
import CosmosCore
import CosmosUI

/// Exercise picker with search and filtering
struct ExercisePickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let onSelect: (Exercise) -> Void

    @State private var searchText = ""
    @State private var selectedMuscleGroup: MuscleGroup?
    @State private var selectedCategory: ExerciseCategory?
    @State private var exercises: [Exercise] = []

    init(onSelect: @escaping (Exercise) -> Void = { _ in }) {
        self.onSelect = onSelect
    }

    var filteredExercises: [Exercise] {
        var result = exercises

        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { exercise in
                exercise.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter by muscle group
        if let muscle = selectedMuscleGroup {
            result = result.filter { $0.primaryMuscle == muscle || $0.secondaryMuscles.contains(muscle) }
        }

        // Filter by category
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        return result
    }

    var groupedExercises: [(String, [Exercise])] {
        let grouped = Dictionary(grouping: filteredExercises) { exercise in
            exercise.primaryMuscle.displayName
        }
        return grouped.sorted { $0.key < $1.key }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                searchBar

                // Filter chips
                filterChips

                // Exercise list
                if filteredExercises.isEmpty {
                    emptyState
                } else {
                    exerciseList
                }
            }
            .cosmosBackground()
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.cosmosTextSecondary)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // Navigate to create custom exercise
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.nebulaCyan)
                    }
                }
            }
        }
        .onAppear {
            loadExercises()
        }
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: CosmosSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.cosmosTextTertiary)

            TextField("Search exercises", text: $searchText)
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
            RoundedRectangle(cornerRadius: CosmosRadius.md)
                .fill(Color.cardBackground)
        )
        .padding(.horizontal, CosmosSpacing.screenHorizontal)
        .padding(.vertical, CosmosSpacing.sm)
    }

    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CosmosSpacing.sm) {
                // Muscle group filter
                Menu {
                    Button("All Muscles") {
                        selectedMuscleGroup = nil
                    }
                    ForEach(MuscleGroup.allCases, id: \.self) { muscle in
                        Button(muscle.displayName) {
                            selectedMuscleGroup = muscle
                        }
                    }
                } label: {
                    filterChip(
                        label: selectedMuscleGroup?.displayName ?? "Muscle",
                        isActive: selectedMuscleGroup != nil
                    )
                }

                // Category filter
                Menu {
                    Button("All Categories") {
                        selectedCategory = nil
                    }
                    ForEach(ExerciseCategory.allCases, id: \.self) { category in
                        Button(category.displayName) {
                            selectedCategory = category
                        }
                    }
                } label: {
                    filterChip(
                        label: selectedCategory?.displayName ?? "Category",
                        isActive: selectedCategory != nil
                    )
                }

                // Clear filters
                if selectedMuscleGroup != nil || selectedCategory != nil {
                    Button {
                        selectedMuscleGroup = nil
                        selectedCategory = nil
                    } label: {
                        Text("Clear")
                            .font(.cosmosCaption)
                            .foregroundStyle(Color.nebulaCyan)
                    }
                }
            }
            .padding(.horizontal, CosmosSpacing.screenHorizontal)
            .padding(.vertical, CosmosSpacing.xs)
        }
    }

    private func filterChip(label: String, isActive: Bool) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.cosmosCaption)

            Image(systemName: "chevron.down")
                .font(.system(size: 10))
        }
        .foregroundStyle(isActive ? .white : Color.cosmosTextSecondary)
        .padding(.horizontal, CosmosSpacing.sm)
        .padding(.vertical, CosmosSpacing.xs)
        .background(
            Capsule()
                .fill(isActive ? Color.nebulaPurple : Color.cardBackground)
        )
    }

    // MARK: - Exercise List
    private var exerciseList: some View {
        List {
            ForEach(groupedExercises, id: \.0) { group, exercises in
                Section {
                    ForEach(exercises) { exercise in
                        ExerciseRowView(exercise: exercise) {
                            onSelect(exercise)
                            dismiss()
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                } header: {
                    Text(group)
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                        .textCase(nil)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: CosmosSpacing.md) {
            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(Color.cosmosTextTertiary)

            Text("No exercises found")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            Text("Try adjusting your search or filters")
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)

            Spacer()
        }
    }

    private func loadExercises() {
        exercises = appState.dataService.fetchExercises()

        // If no exercises exist, seed with defaults
        if exercises.isEmpty {
            seedDefaultExercises()
            exercises = appState.dataService.fetchExercises()
        }
    }

    private func seedDefaultExercises() {
        // This will be called once to populate the exercise database
        // Uses the ExerciseDatabase from CosmosCore
        for exerciseData in CosmosCore.ExerciseDatabase.allExercises {
            appState.dataService.createExercise(
                name: exerciseData.name,
                primaryMuscle: exerciseData.primaryMuscle,
                secondaryMuscles: exerciseData.secondaryMuscles,
                category: exerciseData.category,
                equipment: exerciseData.equipment,
                instructions: exerciseData.instructions,
                trackingType: exerciseData.trackingType
            )
        }
    }
}

// MARK: - Exercise Row View
struct ExerciseRowView: View {
    let exercise: Exercise
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: CosmosSpacing.md) {
                // Exercise icon
                Circle()
                    .fill(muscleGroupColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: exercise.iconName)
                            .font(.system(size: 20))
                            .foregroundStyle(muscleGroupColor)
                    )

                // Exercise info
                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name)
                        .font(.cosmosBody)
                        .foregroundStyle(.white)

                    HStack(spacing: CosmosSpacing.xs) {
                        Text(exercise.primaryMuscle.displayName)
                            .font(.cosmosCaption)
                            .foregroundStyle(Color.cosmosTextSecondary)

                        if let equipment = exercise.equipment {
                            Text("•")
                                .foregroundStyle(Color.cosmosTextTertiary)
                            Text(equipment.displayName)
                                .font(.cosmosCaption)
                                .foregroundStyle(Color.cosmosTextTertiary)
                        }
                    }
                }

                Spacer()

                Image(systemName: "plus.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.nebulaCyan)
            }
            .padding(.vertical, CosmosSpacing.xs)
        }
    }

    private var muscleGroupColor: Color {
        switch exercise.primaryMuscle {
        case .chest: return .cosmosError
        case .back: return .nebulaPurple
        case .shoulders: return .nebulaGold
        case .biceps, .triceps, .forearms: return .nebulaCyan
        case .quads, .hamstrings, .glutes, .calves, .hipFlexors: return .cosmosSuccess
        case .abs, .obliques, .lowerBack: return .nebulaGold
        case .fullBody: return .nebulaMagenta
        }
    }
}

#Preview {
    ExercisePickerView()
        .environmentObject(AppState())
}
