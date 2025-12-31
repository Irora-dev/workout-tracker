import Foundation
import HealthKit

/// Service for HealthKit data integration
@MainActor
public final class HealthKitService: ObservableObject {
    public static let shared = HealthKitService()

    private let healthStore = HKHealthStore()

    @Published public private(set) var isAuthorized: Bool = false
    @Published public private(set) var isHealthKitAvailable: Bool = false

    // MARK: - Types to Read
    private let readTypes: Set<HKObjectType> = {
        var types = Set<HKObjectType>()

        // Activity
        if let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepCount)
        }
        if let activeEnergy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(activeEnergy)
        }
        if let exerciseTime = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) {
            types.insert(exerciseTime)
        }
        if let standTime = HKQuantityType.quantityType(forIdentifier: .appleStandTime) {
            types.insert(standTime)
        }

        // Heart Rate
        if let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate) {
            types.insert(heartRate)
        }
        if let restingHR = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) {
            types.insert(restingHR)
        }
        if let hrv = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
            types.insert(hrv)
        }

        // Distance
        if let walkRunDistance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            types.insert(walkRunDistance)
        }
        if let cyclingDistance = HKQuantityType.quantityType(forIdentifier: .distanceCycling) {
            types.insert(cyclingDistance)
        }
        if let swimDistance = HKQuantityType.quantityType(forIdentifier: .distanceSwimming) {
            types.insert(swimDistance)
        }

        // Sleep
        if let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) {
            types.insert(sleep)
        }

        // Body
        if let weight = HKQuantityType.quantityType(forIdentifier: .bodyMass) {
            types.insert(weight)
        }
        if let bodyFat = HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage) {
            types.insert(bodyFat)
        }

        // Workouts
        types.insert(HKObjectType.workoutType())

        return types
    }()

    // MARK: - Types to Write
    private let writeTypes: Set<HKSampleType> = {
        var types = Set<HKSampleType>()

        if let activeEnergy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(activeEnergy)
        }

        types.insert(HKObjectType.workoutType())

        return types
    }()

    private init() {
        isHealthKitAvailable = HKHealthStore.isHealthDataAvailable()
    }

    // MARK: - Authorization
    public func requestAuthorization() async throws {
        guard isHealthKitAvailable else {
            throw HealthKitError.notAvailable
        }

        try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
        isAuthorized = true
    }

    public func checkAuthorizationStatus() -> HKAuthorizationStatus {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return .notDetermined
        }
        return healthStore.authorizationStatus(for: stepType)
    }

    // MARK: - Read Data
    public func fetchSteps(for date: Date) async throws -> Int {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthKitError.typeNotAvailable
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )

        let statistics = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let stats = stats {
                    continuation.resume(returning: stats)
                } else {
                    continuation.resume(throwing: HealthKitError.noData)
                }
            }
            healthStore.execute(query)
        }

        let steps = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
        return Int(steps)
    }

    public func fetchActiveCalories(for date: Date) async throws -> Double {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            throw HealthKitError.typeNotAvailable
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )

        let statistics = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
            let query = HKStatisticsQuery(
                quantityType: energyType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let stats = stats {
                    continuation.resume(returning: stats)
                } else {
                    continuation.resume(throwing: HealthKitError.noData)
                }
            }
            healthStore.execute(query)
        }

        return statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
    }

    public func fetchHeartRate(for date: Date) async throws -> (average: Int?, max: Int?, resting: Int?) {
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.typeNotAvailable
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )

        let statistics = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
            let query = HKStatisticsQuery(
                quantityType: hrType,
                quantitySamplePredicate: predicate,
                options: [.discreteAverage, .discreteMax]
            ) { _, stats, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let stats = stats {
                    continuation.resume(returning: stats)
                } else {
                    continuation.resume(throwing: HealthKitError.noData)
                }
            }
            healthStore.execute(query)
        }

        let unit = HKUnit.count().unitDivided(by: .minute())
        let average = statistics.averageQuantity()?.doubleValue(for: unit).map { Int($0) }
        let max = statistics.maximumQuantity()?.doubleValue(for: unit).map { Int($0) }

        // Fetch resting heart rate separately
        var resting: Int?
        if let restingType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) {
            let restingStats = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HKStatistics, Error>) in
                let query = HKStatisticsQuery(
                    quantityType: restingType,
                    quantitySamplePredicate: predicate,
                    options: .mostRecent
                ) { _, stats, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let stats = stats {
                        continuation.resume(returning: stats)
                    } else {
                        continuation.resume(throwing: HealthKitError.noData)
                    }
                }
                healthStore.execute(query)
            }
            resting = restingStats?.mostRecentQuantity()?.doubleValue(for: unit).map { Int($0) }
        }

        return (average, max, resting)
    }

    public func fetchDistance(for date: Date) async throws -> (walking: Double, cycling: Double, swimming: Double) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: endOfDay,
            options: .strictStartDate
        )

        var walking: Double = 0
        var cycling: Double = 0
        var swimming: Double = 0

        // Walking/Running Distance
        if let walkType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
            let stats = try? await fetchStatistics(for: walkType, predicate: predicate)
            walking = stats?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
        }

        // Cycling Distance
        if let cycleType = HKQuantityType.quantityType(forIdentifier: .distanceCycling) {
            let stats = try? await fetchStatistics(for: cycleType, predicate: predicate)
            cycling = stats?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
        }

        // Swimming Distance
        if let swimType = HKQuantityType.quantityType(forIdentifier: .distanceSwimming) {
            let stats = try? await fetchStatistics(for: swimType, predicate: predicate)
            swimming = stats?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
        }

        return (walking, cycling, swimming)
    }

    private func fetchStatistics(for type: HKQuantityType, predicate: NSPredicate) async throws -> HKStatistics {
        try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let stats = stats {
                    continuation.resume(returning: stats)
                } else {
                    continuation.resume(throwing: HealthKitError.noData)
                }
            }
            healthStore.execute(query)
        }
    }

    // MARK: - Write Workout
    public func saveWorkout(_ workout: Workout) async throws {
        guard workout.isComplete else {
            throw HealthKitError.workoutNotComplete
        }

        let workoutType = workout.workoutType.healthKitActivityType
        let startDate = workout.startedAt
        let endDate = workout.endedAt ?? Date()

        var metadata: [String: Any] = [:]
        if let notes = workout.notes {
            metadata[HKMetadataKeyWorkoutBrandName] = "Forge"
        }

        let hkWorkout = HKWorkout(
            activityType: workoutType,
            start: startDate,
            end: endDate,
            workoutEvents: nil,
            totalEnergyBurned: workout.caloriesBurned.map { HKQuantity(unit: .kilocalorie(), doubleValue: Double($0)) },
            totalDistance: workout.distance.map { HKQuantity(unit: .meter(), doubleValue: $0) },
            metadata: metadata
        )

        try await healthStore.save(hkWorkout)
    }

    // MARK: - Sync All Data for Date
    public func syncHealthData(for date: Date, metric: HealthMetric) async {
        // Steps
        if let steps = try? await fetchSteps(for: date) {
            metric.steps = steps
        }

        // Active Calories
        if let calories = try? await fetchActiveCalories(for: date) {
            metric.activeCalories = calories
        }

        // Heart Rate
        if let hr = try? await fetchHeartRate(for: date) {
            metric.averageHeartRate = hr.average
            metric.maxHeartRate = hr.max
            metric.restingHeartRate = hr.resting
        }

        // Distance
        if let distance = try? await fetchDistance(for: date) {
            metric.walkingRunningDistance = distance.walking
            metric.cyclingDistance = distance.cycling
            metric.swimmingDistance = distance.swimming
        }

        metric.fetchedAt = Date()
    }
}

// MARK: - Errors
public enum HealthKitError: Error, LocalizedError {
    case notAvailable
    case typeNotAvailable
    case notAuthorized
    case noData
    case workoutNotComplete

    public var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .typeNotAvailable:
            return "This data type is not available"
        case .notAuthorized:
            return "HealthKit access not authorized"
        case .noData:
            return "No data available"
        case .workoutNotComplete:
            return "Workout must be completed before saving"
        }
    }
}

// MARK: - WorkoutType Extension
extension WorkoutType {
    public var healthKitActivityType: HKWorkoutActivityType {
        switch self {
        case .gym, .weightlifting, .bodyweight:
            return .traditionalStrengthTraining
        case .crossfit:
            return .crossTraining
        case .running:
            return .running
        case .walking:
            return .walking
        case .cycling:
            return .cycling
        case .swimming:
            return .swimming
        case .rowing:
            return .rowing
        case .elliptical:
            return .elliptical
        case .stairClimber:
            return .stairClimbing
        case .hiit:
            return .highIntensityIntervalTraining
        case .circuitTraining:
            return .functionalStrengthTraining
        case .boxing, .kickboxing:
            return .boxing
        case .martialArts:
            return .martialArts
        case .climbing, .bouldering:
            return .climbing
        case .yoga:
            return .yoga
        case .pilates:
            return .pilates
        case .stretching:
            return .flexibility
        case .tennis:
            return .tennis
        case .basketball:
            return .basketball
        case .soccer:
            return .soccer
        case .golf:
            return .golf
        case .baseball:
            return .baseball
        case .volleyball:
            return .volleyball
        case .hiking:
            return .hiking
        case .dance:
            return .dance
        case .other:
            return .other
        }
    }
}
