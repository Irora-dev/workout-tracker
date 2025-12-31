import SwiftUI
import CosmosCore
import CosmosUI

/// Full-screen active workout tracking view
struct ActiveWorkoutView: View {
    let workout: Workout
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: ActiveWorkoutViewModel
    @State private var showExercisePicker = false
    @State private var showDiscardAlert = false

    init(workout: Workout) {
        self.workout = workout
        _viewModel = StateObject(wrappedValue: ActiveWorkoutViewModel(workout: workout))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                ScrollView {
                    VStack(spacing: CosmosSpacing.lg) {
                        // Workout header with timer
                        workoutHeader

                        // Quick stats
                        quickStatsBar

                        // Exercise list
                        exerciseList

                        // Add exercise button
                        addExerciseButton

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, CosmosSpacing.screenHorizontal)
                    .padding(.top, CosmosSpacing.md)
                }

                // Bottom action bar
                VStack {
                    Spacer()
                    bottomActionBar
                }
            }
            .cosmosBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(workout.workoutType.displayName)
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showDiscardAlert = true
                    }
                    .foregroundStyle(Color.cosmosTextSecondary)
                }
            }
            .sheet(isPresented: $showExercisePicker) {
                ExercisePickerView(onSelect: { exercise in
                    viewModel.addExercise(exercise)
                })
                .environmentObject(appState)
            }
            .alert("Discard Workout?", isPresented: $showDiscardAlert) {
                Button("Keep Working", role: .cancel) {}
                Button("Discard", role: .destructive) {
                    appState.cancelWorkout()
                }
            } message: {
                Text("Your workout progress will be lost.")
            }
        }
    }

    // MARK: - Workout Header
    private var workoutHeader: some View {
        VStack(spacing: CosmosSpacing.md) {
            // Timer
            Text(viewModel.formattedDuration)
                .font(.cosmosLargeNumber)
                .foregroundStyle(.white)
                .monospacedDigit()

            // Workout type badge
            HStack(spacing: CosmosSpacing.xs) {
                Image(systemName: workout.workoutType.iconName)
                    .foregroundStyle(Color.workoutTypeColor(for: workout.workoutType.rawValue))

                Text(workout.workoutType.displayName)
                    .font(.cosmosSubheadline)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CosmosSpacing.lg)
    }

    // MARK: - Quick Stats Bar
    private var quickStatsBar: some View {
        HStack(spacing: CosmosSpacing.md) {
            statPill(value: "\(viewModel.completedSets)", label: "Sets")
            statPill(value: viewModel.formattedVolume, label: "Volume")
            statPill(value: "\(viewModel.exerciseCount)", label: "Exercises")
        }
    }

    private func statPill(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            Text(label)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CosmosSpacing.sm)
        .cosmosCardStyle()
    }

    // MARK: - Exercise List
    private var exerciseList: some View {
        VStack(spacing: CosmosSpacing.md) {
            if viewModel.exercises.isEmpty {
                emptyExerciseState
            } else {
                ForEach(viewModel.exercises) { workoutExercise in
                    ExerciseCardView(
                        workoutExercise: workoutExercise,
                        onAddSet: { viewModel.addSet(to: workoutExercise) },
                        onUpdateSet: { set, weight, reps in
                            viewModel.updateSet(set, weight: weight, reps: reps)
                        },
                        onCompleteSet: { set in
                            viewModel.completeSet(set)
                        },
                        onDeleteSet: { set in
                            viewModel.deleteSet(set, from: workoutExercise)
                        }
                    )
                }
            }
        }
    }

    private var emptyExerciseState: some View {
        VStack(spacing: CosmosSpacing.md) {
            Image(systemName: "dumbbell")
                .font(.system(size: 48))
                .foregroundStyle(Color.cosmosTextTertiary)

            Text("No exercises yet")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            Text("Add exercises to track your workout")
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CosmosSpacing.xxl)
        .cosmosCardStyle()
    }

    // MARK: - Add Exercise Button
    private var addExerciseButton: some View {
        Button {
            showExercisePicker = true
        } label: {
            HStack(spacing: CosmosSpacing.sm) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                Text("Add Exercise")
                    .font(.cosmosBody)
            }
            .foregroundStyle(Color.nebulaCyan)
            .frame(maxWidth: .infinity)
            .padding(.vertical, CosmosSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: CosmosCornerRadius.md)
                    .stroke(Color.nebulaCyan.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [8]))
            )
        }
    }

    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        HStack(spacing: CosmosSpacing.md) {
            // Rest timer button
            RestTimerButton(viewModel: viewModel)

            // Finish workout button
            CosmosPrimaryButton("Finish Workout") {
                finishWorkout()
            }
        }
        .padding(.horizontal, CosmosSpacing.screenHorizontal)
        .padding(.vertical, CosmosSpacing.md)
        .background(
            Rectangle()
                .fill(Color.cosmicBlack)
                .overlay(
                    Rectangle()
                        .fill(Color.cardBackground.opacity(0.5))
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func finishWorkout() {
        viewModel.stopTimer()
        workout.duration = viewModel.elapsedTime
        appState.endWorkout()
        appState.presentSheet(.workoutSummary(workout))
    }
}

// MARK: - Active Workout ViewModel
@MainActor
final class ActiveWorkoutViewModel: ObservableObject {
    let workout: Workout
    private let dataService = DataService.shared

    @Published var exercises: [WorkoutExercise] = []
    @Published var elapsedTime: TimeInterval = 0
    @Published var restTimerActive = false
    @Published var restTimeRemaining: TimeInterval = 0

    private var timer: Timer?
    private var restTimer: Timer?

    var completedSets: Int {
        exercises.flatMap { $0.sets }.filter { $0.isCompleted }.count
    }

    var exerciseCount: Int {
        exercises.count
    }

    var totalVolume: Double {
        exercises.flatMap { $0.sets }
            .filter { $0.isCompleted }
            .reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }

    var formattedVolume: String {
        if totalVolume >= 1000 {
            return String(format: "%.1fk", totalVolume / 1000)
        }
        return String(format: "%.0f", totalVolume)
    }

    var formattedDuration: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var formattedRestTime: String {
        let minutes = Int(restTimeRemaining) / 60
        let seconds = Int(restTimeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    init(workout: Workout) {
        self.workout = workout
        self.exercises = workout.exercises
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.elapsedTime += 1
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func addExercise(_ exercise: Exercise) {
        let workoutExercise = dataService.addExercise(exercise, to: workout)
        exercises.append(workoutExercise)
    }

    func addSet(to workoutExercise: WorkoutExercise) {
        let newSet = dataService.addSet(to: workoutExercise)
        if let index = exercises.firstIndex(where: { $0.id == workoutExercise.id }) {
            exercises[index] = workoutExercise
        }
    }

    func updateSet(_ set: ExerciseSet, weight: Double, reps: Int) {
        set.weight = weight
        set.reps = reps
        dataService.save()
        objectWillChange.send()
    }

    func completeSet(_ set: ExerciseSet) {
        set.isCompleted = true
        set.completedAt = Date()
        dataService.save()
        objectWillChange.send()

        // Auto-start rest timer
        startRestTimer(duration: 90)
    }

    func deleteSet(_ set: ExerciseSet, from workoutExercise: WorkoutExercise) {
        dataService.deleteSet(set, from: workoutExercise)
        if let index = exercises.firstIndex(where: { $0.id == workoutExercise.id }) {
            exercises[index] = workoutExercise
        }
        objectWillChange.send()
    }

    func startRestTimer(duration: TimeInterval) {
        restTimeRemaining = duration
        restTimerActive = true

        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self = self else {
                    timer.invalidate()
                    return
                }

                if self.restTimeRemaining > 0 {
                    self.restTimeRemaining -= 1
                } else {
                    self.restTimerActive = false
                    timer.invalidate()
                    // TODO: Add haptic feedback
                }
            }
        }
    }

    func cancelRestTimer() {
        restTimer?.invalidate()
        restTimerActive = false
        restTimeRemaining = 0
    }

    deinit {
        timer?.invalidate()
        restTimer?.invalidate()
    }
}

// MARK: - Exercise Card View
struct ExerciseCardView: View {
    let workoutExercise: WorkoutExercise
    let onAddSet: () -> Void
    let onUpdateSet: (ExerciseSet, Double, Int) -> Void
    let onCompleteSet: (ExerciseSet) -> Void
    let onDeleteSet: (ExerciseSet) -> Void

    @State private var isExpanded = true

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: CosmosSpacing.md) {
                    // Exercise icon
                    exerciseIcon

                    // Exercise name and info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(workoutExercise.exercise?.name ?? "Exercise")
                            .font(.cosmosHeadline)
                            .foregroundStyle(.white)

                        if let muscle = workoutExercise.exercise?.primaryMuscle {
                            Text(muscle.displayName)
                                .font(.cosmosCaption)
                                .foregroundStyle(Color.cosmosTextSecondary)
                        }
                    }

                    Spacer()

                    // Set count
                    Text("\(workoutExercise.sets.count) sets")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.cosmosTextTertiary)
                }
                .padding(CosmosSpacing.md)
            }

            if isExpanded {
                Divider()
                    .background(Color.cosmosTextTertiary.opacity(0.3))

                // Sets list
                VStack(spacing: CosmosSpacing.sm) {
                    // Header row
                    HStack {
                        Text("SET")
                            .frame(width: 40)
                        Text("PREV")
                            .frame(width: 60)
                        Text("LBS")
                            .frame(maxWidth: .infinity)
                        Text("REPS")
                            .frame(maxWidth: .infinity)
                        Text("")
                            .frame(width: 44)
                    }
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
                    .padding(.horizontal, CosmosSpacing.md)
                    .padding(.top, CosmosSpacing.sm)

                    // Set rows
                    ForEach(Array(workoutExercise.sets.enumerated()), id: \.element.id) { index, set in
                        SetRowView(
                            setNumber: index + 1,
                            set: set,
                            previousSet: workoutExercise.exercise?.previousSetData(at: index),
                            onUpdate: { weight, reps in onUpdateSet(set, weight, reps) },
                            onComplete: { onCompleteSet(set) },
                            onDelete: { onDeleteSet(set) }
                        )
                    }

                    // Add set button
                    Button {
                        onAddSet()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Set")
                        }
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.nebulaCyan)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, CosmosSpacing.sm)
                    }
                    .padding(.horizontal, CosmosSpacing.md)
                    .padding(.bottom, CosmosSpacing.sm)
                }
            }
        }
        .cosmosCardStyle()
    }

    private var exerciseIcon: some View {
        Circle()
            .fill(Color.nebulaPurple.opacity(0.2))
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: workoutExercise.exercise?.iconName ?? "dumbbell")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.nebulaPurple)
            )
    }
}

// MARK: - Set Row View
struct SetRowView: View {
    let setNumber: Int
    let set: ExerciseSet
    let previousSet: (weight: Double, reps: Int)?
    let onUpdate: (Double, Int) -> Void
    let onComplete: () -> Void
    let onDelete: () -> Void

    @State private var weightText: String = ""
    @State private var repsText: String = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case weight, reps
    }

    var body: some View {
        HStack(spacing: CosmosSpacing.sm) {
            // Set number
            Text("\(setNumber)")
                .font(.cosmosBody)
                .foregroundStyle(set.isCompleted ? Color.nebulaGreen : .white)
                .frame(width: 40)

            // Previous
            if let prev = previousSet {
                Text("\(Int(prev.weight))×\(prev.reps)")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
                    .frame(width: 60)
            } else {
                Text("-")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
                    .frame(width: 60)
            }

            // Weight input
            TextField("0", text: $weightText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.cosmosBody)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, CosmosSpacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: CosmosCornerRadius.sm)
                        .fill(Color.cardBackground)
                )
                .focused($focusedField, equals: .weight)
                .onChange(of: weightText) { _, newValue in
                    if let weight = Double(newValue) {
                        onUpdate(weight, set.reps)
                    }
                }

            // Reps input
            TextField("0", text: $repsText)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.cosmosBody)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, CosmosSpacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: CosmosCornerRadius.sm)
                        .fill(Color.cardBackground)
                )
                .focused($focusedField, equals: .reps)
                .onChange(of: repsText) { _, newValue in
                    if let reps = Int(newValue) {
                        onUpdate(set.weight, reps)
                    }
                }

            // Complete button
            Button {
                if set.isCompleted {
                    // Allow uncompleting
                } else {
                    onComplete()
                }
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundStyle(set.isCompleted ? Color.nebulaGreen : Color.cosmosTextTertiary)
            }
            .frame(width: 44)
        }
        .padding(.horizontal, CosmosSpacing.md)
        .padding(.vertical, CosmosSpacing.xs)
        .background(set.isCompleted ? Color.nebulaGreen.opacity(0.1) : Color.clear)
        .onAppear {
            weightText = set.weight > 0 ? String(format: "%.0f", set.weight) : ""
            repsText = set.reps > 0 ? "\(set.reps)" : ""
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Rest Timer Button
struct RestTimerButton: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    @State private var showTimerSheet = false

    var body: some View {
        Button {
            if viewModel.restTimerActive {
                showTimerSheet = true
            } else {
                viewModel.startRestTimer(duration: 90)
            }
        } label: {
            HStack(spacing: CosmosSpacing.xs) {
                Image(systemName: "timer")
                    .font(.system(size: 18))

                if viewModel.restTimerActive {
                    Text(viewModel.formattedRestTime)
                        .font(.cosmosBody)
                        .monospacedDigit()
                } else {
                    Text("Rest")
                        .font(.cosmosBody)
                }
            }
            .foregroundStyle(viewModel.restTimerActive ? Color.nebulaGold : .white)
            .padding(.horizontal, CosmosSpacing.md)
            .padding(.vertical, CosmosSpacing.sm)
            .background(
                Capsule()
                    .fill(viewModel.restTimerActive ? Color.nebulaGold.opacity(0.2) : Color.cardBackground)
            )
        }
        .sheet(isPresented: $showTimerSheet) {
            RestTimerSheet(viewModel: viewModel)
                .presentationDetents([.height(300)])
        }
    }
}

// MARK: - Rest Timer Sheet
struct RestTimerSheet: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    let presetTimes: [TimeInterval] = [30, 60, 90, 120, 180]

    var body: some View {
        VStack(spacing: CosmosSpacing.lg) {
            // Timer display
            Text(viewModel.formattedRestTime)
                .font(.cosmosLargeNumber)
                .foregroundStyle(.white)
                .padding(.top, CosmosSpacing.xl)

            // Progress ring
            CosmosProgressRing(
                progress: viewModel.restTimeRemaining / 90,
                lineWidth: 8,
                gradient: LinearGradient.cosmosCyan
            )
            .frame(width: 100, height: 100)

            // Preset buttons
            HStack(spacing: CosmosSpacing.sm) {
                ForEach(presetTimes, id: \.self) { time in
                    Button {
                        viewModel.startRestTimer(duration: time)
                    } label: {
                        Text(formatPresetTime(time))
                            .font(.cosmosCaption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, CosmosSpacing.sm)
                            .padding(.vertical, CosmosSpacing.xs)
                            .background(
                                Capsule()
                                    .fill(Color.cardBackground)
                            )
                    }
                }
            }

            // Cancel button
            Button {
                viewModel.cancelRestTimer()
                dismiss()
            } label: {
                Text("Skip Rest")
                    .font(.cosmosBody)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }
            .padding(.bottom, CosmosSpacing.lg)
        }
        .frame(maxWidth: .infinity)
        .cosmosBackground()
    }

    private func formatPresetTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        if seconds == 0 {
            return "\(minutes)m"
        }
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}

#Preview {
    let workout = Workout(workoutType: .gym)
    return ActiveWorkoutView(workout: workout)
        .environmentObject(AppState())
}
