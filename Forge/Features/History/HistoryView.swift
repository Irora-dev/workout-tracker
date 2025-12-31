import SwiftUI
import CosmosCore
import CosmosUI

/// History view with calendar and workout list
struct HistoryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @State private var viewMode: ViewMode = .calendar

    enum ViewMode {
        case calendar
        case list
    }

    private var workoutsForSelectedDate: [Workout] {
        appState.dataService.workoutsForDate(selectedDate)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    // View mode toggle
                    viewModeToggle

                    if viewMode == .calendar {
                        // Calendar view
                        calendarSection

                        // Selected date workouts
                        selectedDateWorkouts
                    } else {
                        // List view
                        workoutListView
                    }
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .navigationTitle("History")
            .cosmosNavigationBar()
        }
    }

    // MARK: - View Mode Toggle
    private var viewModeToggle: some View {
        HStack(spacing: 0) {
            ForEach([ViewMode.calendar, ViewMode.list], id: \.self) { mode in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        viewMode = mode
                    }
                } label: {
                    HStack(spacing: CosmosSpacing.xs) {
                        Image(systemName: mode == .calendar ? "calendar" : "list.bullet")
                        Text(mode == .calendar ? "Calendar" : "List")
                    }
                    .font(.cosmosSubheadline)
                    .foregroundStyle(viewMode == mode ? .white : Color.cosmosTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, CosmosSpacing.sm)
                    .background(
                        viewMode == mode ? Color.nebulaPurple : Color.clear
                    )
                }
            }
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: CosmosCornerRadius.md))
    }

    // MARK: - Calendar Section
    private var calendarSection: some View {
        VStack(spacing: CosmosSpacing.md) {
            // Month navigation
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.cosmosTextSecondary)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Text(monthYearString)
                    .font(.cosmosHeadline)
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.cosmosTextSecondary)
                        .frame(width: 44, height: 44)
                }
            }

            // Day headers
            HStack(spacing: 0) {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                    Text(day.prefix(2))
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextTertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: CosmosSpacing.xs) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        CalendarDayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date),
                            hasWorkout: hasWorkout(on: date),
                            workoutCount: workoutCount(on: date)
                        ) {
                            selectedDate = date
                        }
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }
            }
        }
        .padding(CosmosSpacing.md)
        .cosmosCardStyle()
    }

    // MARK: - Selected Date Workouts
    private var selectedDateWorkouts: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            HStack {
                Text(selectedDateString)
                    .font(.cosmosHeadline)
                    .foregroundStyle(.white)

                Spacer()

                if Calendar.current.isDateInToday(selectedDate) {
                    Text("Today")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.nebulaCyan)
                }
            }

            if workoutsForSelectedDate.isEmpty {
                CosmosEmptyState(
                    icon: "figure.run",
                    title: "No workouts",
                    message: "No workouts recorded on this day"
                )
                .frame(height: 150)
            } else {
                ForEach(workoutsForSelectedDate, id: \.id) { workout in
                    HistoryWorkoutCard(workout: workout) {
                        appState.presentSheet(.workoutSummary(workout))
                    }
                }
            }
        }
    }

    // MARK: - Workout List View
    private var workoutListView: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            let allWorkouts = appState.dataService.fetchWorkouts()

            if allWorkouts.isEmpty {
                CosmosEmptyState(
                    icon: "figure.run",
                    title: "No workouts yet",
                    message: "Start your first workout to see it here"
                )
            } else {
                // Group by month
                let grouped = Dictionary(grouping: allWorkouts) { workout in
                    Calendar.current.startOfMonth(for: workout.startedAt)
                }

                ForEach(grouped.keys.sorted().reversed(), id: \.self) { month in
                    Section {
                        ForEach(grouped[month] ?? [], id: \.id) { workout in
                            HistoryWorkoutCard(workout: workout) {
                                appState.presentSheet(.workoutSummary(workout))
                            }
                        }
                    } header: {
                        Text(monthSectionHeader(month))
                            .font(.cosmosSubheadline)
                            .foregroundStyle(Color.cosmosTextSecondary)
                            .padding(.top, CosmosSpacing.md)
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }

    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }

    private func monthSectionHeader(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            withAnimation(.spring(response: 0.3)) {
                currentMonth = newMonth
            }
        }
    }

    private func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let startOfMonth = calendar.startOfMonth(for: currentMonth)

        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let leadingEmptyDays = firstWeekday - calendar.firstWeekday

        var days: [Date?] = Array(repeating: nil, count: (leadingEmptyDays + 7) % 7)

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }

        // Fill remaining cells to complete the grid
        while days.count % 7 != 0 {
            days.append(nil)
        }

        return days
    }

    private func hasWorkout(on date: Date) -> Bool {
        !appState.dataService.workoutsForDate(date).isEmpty
    }

    private func workoutCount(on date: Date) -> Int {
        appState.dataService.workoutsForDate(date).count
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasWorkout: Bool
    let workoutCount: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.cosmosBody)
                    .foregroundStyle(textColor)

                // Workout indicator
                if hasWorkout {
                    Circle()
                        .fill(Color.nebulaCyan)
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                Circle()
                    .fill(backgroundColor)
            )
        }
    }

    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return .nebulaCyan
        } else if Calendar.current.isDateInFuture(date) {
            return Color.cosmosTextTertiary
        }
        return .white
    }

    private var backgroundColor: Color {
        if isSelected {
            return .nebulaPurple
        } else if isToday {
            return Color.nebulaCyan.opacity(0.2)
        }
        return .clear
    }
}

// MARK: - History Workout Card
struct HistoryWorkoutCard: View {
    let workout: Workout
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: CosmosSpacing.md) {
                // Workout type icon
                Image(systemName: workout.workoutType.iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.workoutTypeColor(for: workout.workoutType.rawValue))
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(Color.workoutTypeColor(for: workout.workoutType.rawValue).opacity(0.15))
                    )

                // Workout info
                VStack(alignment: .leading, spacing: 2) {
                    Text(workout.name ?? workout.workoutType.displayName)
                        .font(.cosmosHeadline)
                        .foregroundStyle(.white)

                    HStack(spacing: CosmosSpacing.md) {
                        Label(formattedDuration, systemImage: "clock")
                        if workout.totalSets > 0 {
                            Label("\(workout.totalSets) sets", systemImage: "repeat")
                        }
                        if workout.totalVolume > 0 {
                            Label(formattedVolume, systemImage: "scalemass")
                        }
                    }
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
                }

                Spacer()

                // Time
                Text(formattedTime)
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
            }
            .padding(CosmosSpacing.md)
            .cosmosCardStyle()
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var formattedDuration: String {
        let minutes = Int(workout.duration / 60)
        if minutes >= 60 {
            let hours = minutes / 60
            let mins = minutes % 60
            return "\(hours)h \(mins)m"
        }
        return "\(minutes)m"
    }

    private var formattedVolume: String {
        let volume = workout.totalVolume
        if volume >= 1000 {
            return String(format: "%.1fk lbs", volume / 1000)
        }
        return String(format: "%.0f lbs", volume)
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: workout.startedAt)
    }
}

// MARK: - Calendar Extension
extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }

    func isDateInFuture(_ date: Date) -> Bool {
        return date > Date()
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppState())
}
