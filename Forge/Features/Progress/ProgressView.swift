import SwiftUI
import Charts
import CosmosCore
import CosmosUI

/// Progress view with stats and charts
struct ProgressDashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedMetric: ProgressMetric = .workouts

    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }

    enum ProgressMetric: String, CaseIterable {
        case workouts = "Workouts"
        case volume = "Volume"
        case duration = "Duration"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    // Overview stats
                    overviewStats

                    // Time range selector
                    timeRangeSelector

                    // Main chart
                    chartSection

                    // Workout breakdown
                    workoutBreakdown

                    // Personal records
                    personalRecordsSection

                    // Streak info
                    streakSection
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .navigationTitle("Progress")
            .cosmosNavigationBar()
        }
    }

    // MARK: - Overview Stats
    private var overviewStats: some View {
        HStack(spacing: CosmosSpacing.md) {
            overviewStatCard(
                title: "Total Workouts",
                value: "\(appState.currentUser?.totalWorkouts ?? 0)",
                icon: "figure.run",
                color: .nebulaCyan
            )

            overviewStatCard(
                title: "This Week",
                value: "\(appState.dataService.workoutsThisWeek())",
                icon: "calendar",
                color: .nebulaPurple
            )
        }
    }

    private func overviewStatCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
            }

            Text(value)
                .font(.cosmosMediumNumber)
                .foregroundStyle(.white)

            Text(title)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(CosmosSpacing.md)
        .cosmosCardStyle()
    }

    // MARK: - Time Range Selector
    private var timeRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTimeRange = range
                    }
                } label: {
                    Text(range.rawValue)
                        .font(.cosmosSubheadline)
                        .foregroundStyle(selectedTimeRange == range ? .white : Color.cosmosTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, CosmosSpacing.sm)
                        .background(
                            selectedTimeRange == range ? Color.nebulaPurple : Color.clear
                        )
                }
            }
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: CosmosCornerRadius.md))
    }

    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            // Metric selector
            HStack(spacing: CosmosSpacing.sm) {
                ForEach(ProgressMetric.allCases, id: \.self) { metric in
                    Button {
                        selectedMetric = metric
                    } label: {
                        Text(metric.rawValue)
                            .font(.cosmosCaption)
                            .foregroundStyle(selectedMetric == metric ? .white : Color.cosmosTextSecondary)
                            .padding(.horizontal, CosmosSpacing.sm)
                            .padding(.vertical, CosmosSpacing.xs)
                            .background(
                                Capsule()
                                    .fill(selectedMetric == metric ? Color.nebulaPurple : Color.clear)
                            )
                    }
                }
            }

            // Chart
            Chart {
                ForEach(chartData, id: \.date) { dataPoint in
                    BarMark(
                        x: .value("Date", dataPoint.date, unit: chartUnit),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.nebulaPurple, Color.nebulaCyan],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(4)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel()
                        .foregroundStyle(Color.cosmosTextSecondary)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.cosmosTextTertiary.opacity(0.3))
                    AxisValueLabel()
                        .foregroundStyle(Color.cosmosTextSecondary)
                }
            }
            .frame(height: 200)
            .padding(CosmosSpacing.md)
            .cosmosCardStyle()
        }
    }

    private var chartUnit: Calendar.Component {
        switch selectedTimeRange {
        case .week: return .day
        case .month: return .weekOfMonth
        case .year: return .month
        }
    }

    private var chartData: [ChartDataPoint] {
        // Generate sample data based on time range
        let calendar = Calendar.current
        var data: [ChartDataPoint] = []

        switch selectedTimeRange {
        case .week:
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: -6 + i, to: Date()) {
                    let workouts = appState.dataService.workoutsForDate(date)
                    let value: Double
                    switch selectedMetric {
                    case .workouts:
                        value = Double(workouts.count)
                    case .volume:
                        value = workouts.reduce(0) { $0 + $1.totalVolume }
                    case .duration:
                        value = workouts.reduce(0) { $0 + $1.duration } / 60
                    }
                    data.append(ChartDataPoint(date: date, value: value))
                }
            }
        case .month:
            for i in 0..<4 {
                if let date = calendar.date(byAdding: .weekOfMonth, value: -3 + i, to: Date()) {
                    // Get all workouts in this week
                    let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
                    let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!

                    let workouts = appState.dataService.fetchWorkouts().filter {
                        $0.startedAt >= weekStart && $0.startedAt < weekEnd
                    }

                    let value: Double
                    switch selectedMetric {
                    case .workouts:
                        value = Double(workouts.count)
                    case .volume:
                        value = workouts.reduce(0) { $0 + $1.totalVolume }
                    case .duration:
                        value = workouts.reduce(0) { $0 + $1.duration } / 60
                    }
                    data.append(ChartDataPoint(date: date, value: value))
                }
            }
        case .year:
            for i in 0..<12 {
                if let date = calendar.date(byAdding: .month, value: -11 + i, to: Date()) {
                    // Get all workouts in this month
                    let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
                    let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!

                    let workouts = appState.dataService.fetchWorkouts().filter {
                        $0.startedAt >= monthStart && $0.startedAt < monthEnd
                    }

                    let value: Double
                    switch selectedMetric {
                    case .workouts:
                        value = Double(workouts.count)
                    case .volume:
                        value = workouts.reduce(0) { $0 + $1.totalVolume }
                    case .duration:
                        value = workouts.reduce(0) { $0 + $1.duration } / 60
                    }
                    data.append(ChartDataPoint(date: date, value: value))
                }
            }
        }

        return data
    }

    // MARK: - Workout Breakdown
    private var workoutBreakdown: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            Text("Workout Types")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            let workouts = appState.dataService.fetchWorkouts()
            let grouped = Dictionary(grouping: workouts) { $0.workoutType }

            if grouped.isEmpty {
                Text("No workout data yet")
                    .font(.cosmosSubheadline)
                    .foregroundStyle(Color.cosmosTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, CosmosSpacing.lg)
            } else {
                ForEach(grouped.sorted(by: { $0.value.count > $1.value.count }).prefix(5), id: \.key) { type, typeWorkouts in
                    workoutTypeRow(type: type, count: typeWorkouts.count, total: workouts.count)
                }
            }
        }
        .padding(CosmosSpacing.md)
        .cosmosCardStyle()
    }

    private func workoutTypeRow(type: WorkoutType, count: Int, total: Int) -> some View {
        let percentage = total > 0 ? Double(count) / Double(total) : 0

        return HStack(spacing: CosmosSpacing.md) {
            Image(systemName: type.iconName)
                .font(.system(size: 18))
                .foregroundStyle(Color.workoutTypeColor(for: type.rawValue))
                .frame(width: 32)

            Text(type.displayName)
                .font(.cosmosBody)
                .foregroundStyle(.white)

            Spacer()

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.cosmosTextTertiary.opacity(0.3))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.workoutTypeColor(for: type.rawValue))
                        .frame(width: geo.size.width * percentage, height: 4)
                }
            }
            .frame(width: 80, height: 4)

            Text("\(count)")
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)
                .frame(width: 30, alignment: .trailing)
        }
    }

    // MARK: - Personal Records Section
    private var personalRecordsSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.md) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(Color.nebulaGold)
                Text("Personal Records")
                    .font(.cosmosHeadline)
                    .foregroundStyle(.white)
            }

            let records = appState.dataService.fetchPersonalRecords(limit: 5)

            if records.isEmpty {
                Text("Complete workouts to set personal records")
                    .font(.cosmosSubheadline)
                    .foregroundStyle(Color.cosmosTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, CosmosSpacing.lg)
            } else {
                ForEach(records, id: \.id) { record in
                    HStack {
                        Text(record.exerciseName)
                            .font(.cosmosBody)
                            .foregroundStyle(.white)

                        Spacer()

                        Text(record.formattedValue)
                            .font(.cosmosSubheadline)
                            .foregroundStyle(Color.nebulaGold)
                    }
                    .padding(.vertical, CosmosSpacing.xs)
                }
            }
        }
        .padding(CosmosSpacing.md)
        .cosmosCardStyle()
    }

    // MARK: - Streak Section
    private var streakSection: some View {
        HStack(spacing: CosmosSpacing.md) {
            // Current streak
            streakCard(
                title: "Current Streak",
                value: "\(appState.currentUser?.currentStreak ?? 0)",
                subtitle: "days",
                icon: "flame.fill",
                color: .nebulaGold
            )

            // Longest streak
            streakCard(
                title: "Longest Streak",
                value: "\(appState.currentUser?.longestStreak ?? 0)",
                subtitle: "days",
                icon: "crown.fill",
                color: .nebulaPurple
            )
        }
    }

    private func streakCard(title: String, value: String, subtitle: String, icon: String, color: Color) -> some View {
        VStack(spacing: CosmosSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(color)

            Text(value)
                .font(.cosmosMediumNumber)
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextTertiary)

            Text(title)
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, CosmosSpacing.lg)
        .cosmosCardStyle()
    }
}

// MARK: - Chart Data Point
struct ChartDataPoint {
    let date: Date
    let value: Double
}

// MARK: - PersonalRecord Extension
extension CosmosCore.PersonalRecord {
    var formattedValue: String {
        switch recordType {
        case .maxWeight:
            return "\(Int(value)) lbs"
        case .maxReps:
            return "\(Int(value)) reps"
        case .maxVolume:
            return "\(Int(value)) lbs vol"
        case .fastestTime:
            return String(format: "%.1f min", value / 60)
        case .longestDistance:
            return String(format: "%.1f mi", value)
        }
    }
}

#Preview {
    ProgressDashboardView()
        .environmentObject(AppState())
}
