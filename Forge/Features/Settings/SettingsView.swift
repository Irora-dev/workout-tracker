import SwiftUI
import CosmosCore
import CosmosUI

/// Settings view
struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedWeightUnit: WeightUnit = .pounds
    @State private var selectedDistanceUnit: DistanceUnit = .miles
    @State private var restTimerDuration: Double = 90
    @State private var enableHaptics: Bool = true
    @State private var enableSounds: Bool = true
    @State private var showHealthKitPrompt: Bool = false

    enum WeightUnit: String, CaseIterable {
        case pounds = "lbs"
        case kilograms = "kg"
    }

    enum DistanceUnit: String, CaseIterable {
        case miles = "mi"
        case kilometers = "km"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.lg) {
                    // Account section
                    accountSection

                    // Units section
                    unitsSection

                    // Workout settings
                    workoutSettingsSection

                    // Notifications section
                    notificationsSection

                    // Health section
                    healthSection

                    // Support section
                    supportSection

                    // Danger zone
                    dangerZoneSection
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .cosmosBackground()
            .navigationTitle("Settings")
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
    }

    // MARK: - Account Section
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Account")

            VStack(spacing: 0) {
                settingsRow(icon: "person.circle", title: "Edit Profile") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsRow(icon: "star.fill", title: "Subscription", trailing: {
                    Text(appState.subscriptionService.isPremium ? "Premium" : "Free")
                        .font(.cosmosCaption)
                        .foregroundStyle(appState.subscriptionService.isPremium ? Color.nebulaGold : Color.cosmosTextSecondary)
                }) {
                    appState.presentSheet(.subscription)
                }
            }
            .cosmosCardStyle()
        }
    }

    // MARK: - Units Section
    private var unitsSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Units")

            VStack(spacing: 0) {
                settingsPickerRow(icon: "scalemass", title: "Weight", selection: $selectedWeightUnit, options: WeightUnit.allCases)

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsPickerRow(icon: "ruler", title: "Distance", selection: $selectedDistanceUnit, options: DistanceUnit.allCases)
            }
            .cosmosCardStyle()
        }
    }

    // MARK: - Workout Settings Section
    private var workoutSettingsSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Workout")

            VStack(spacing: CosmosSpacing.md) {
                // Rest timer
                HStack {
                    Image(systemName: "timer")
                        .foregroundStyle(Color.nebulaLavender)
                        .frame(width: 24)

                    Text("Default Rest Timer")
                        .font(.cosmosBody)
                        .foregroundStyle(.white)

                    Spacer()

                    Text("\(Int(restTimerDuration))s")
                        .font(.cosmosSubheadline)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }

                Slider(value: $restTimerDuration, in: 30...300, step: 15)
                    .tint(Color.nebulaPurple)
            }
            .padding(CosmosSpacing.md)
            .cosmosCardStyle()

            VStack(spacing: 0) {
                settingsToggleRow(icon: "hand.tap", title: "Haptic Feedback", isOn: $enableHaptics)

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsToggleRow(icon: "speaker.wave.2", title: "Sound Effects", isOn: $enableSounds)
            }
            .cosmosCardStyle()
        }
    }

    // MARK: - Notifications Section
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Notifications")

            VStack(spacing: 0) {
                settingsRow(icon: "bell", title: "Notification Settings") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsRow(icon: "clock", title: "Workout Reminders") {}
            }
            .cosmosCardStyle()
        }
    }

    // MARK: - Health Section
    private var healthSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Health")

            VStack(spacing: 0) {
                settingsRow(icon: "heart.fill", title: "Apple Health", trailing: {
                    Text(appState.healthKitService.isAuthorized ? "Connected" : "Not Connected")
                        .font(.cosmosCaption)
                        .foregroundStyle(appState.healthKitService.isAuthorized ? Color.nebulaGreen : Color.cosmosTextSecondary)
                }) {
                    Task {
                        try? await appState.healthKitService.requestAuthorization()
                    }
                }

                if appState.healthKitService.isAuthorized {
                    Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                    settingsRow(icon: "arrow.triangle.2.circlepath", title: "Sync Health Data") {
                        // Trigger manual sync
                    }
                }
            }
            .cosmosCardStyle()
        }
    }

    // MARK: - Support Section
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Support")

            VStack(spacing: 0) {
                settingsRow(icon: "questionmark.circle", title: "Help Center") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsRow(icon: "envelope", title: "Contact Us") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsRow(icon: "star", title: "Rate Forge") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsRow(icon: "doc.text", title: "Privacy Policy") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                settingsRow(icon: "doc.text", title: "Terms of Service") {}
            }
            .cosmosCardStyle()
        }
    }

    // MARK: - Danger Zone Section
    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
            sectionHeader("Data")

            VStack(spacing: 0) {
                settingsRow(icon: "square.and.arrow.up", title: "Export Data") {}

                Divider().background(Color.cosmosTextTertiary.opacity(0.3))

                Button {
                    // Show delete confirmation
                } label: {
                    HStack(spacing: CosmosSpacing.md) {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.nebulaRed)
                            .frame(width: 24)

                        Text("Delete All Data")
                            .font(.cosmosBody)
                            .foregroundStyle(Color.nebulaRed)

                        Spacer()
                    }
                    .padding(CosmosSpacing.md)
                }
            }
            .cosmosCardStyle()

            // Version info
            HStack {
                Spacer()
                Text("Forge v1.0.0")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextTertiary)
                Spacer()
            }
            .padding(.top, CosmosSpacing.md)
        }
    }

    // MARK: - Helper Views
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.cosmosCaption)
            .foregroundStyle(Color.cosmosTextSecondary)
            .textCase(.uppercase)
    }

    private func settingsRow(
        icon: String,
        title: String,
        trailing: (() -> AnyView)? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: CosmosSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(Color.nebulaLavender)
                    .frame(width: 24)

                Text(title)
                    .font(.cosmosBody)
                    .foregroundStyle(.white)

                Spacer()

                if let trailing = trailing {
                    trailing()
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.cosmosTextTertiary)
            }
            .padding(CosmosSpacing.md)
        }
    }

    private func settingsRow<Content: View>(
        icon: String,
        title: String,
        @ViewBuilder trailing: () -> Content,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: CosmosSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(Color.nebulaLavender)
                    .frame(width: 24)

                Text(title)
                    .font(.cosmosBody)
                    .foregroundStyle(.white)

                Spacer()

                trailing()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.cosmosTextTertiary)
            }
            .padding(CosmosSpacing.md)
        }
    }

    private func settingsToggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: CosmosSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(Color.nebulaLavender)
                .frame(width: 24)

            Text(title)
                .font(.cosmosBody)
                .foregroundStyle(.white)

            Spacer()

            Toggle("", isOn: isOn)
                .tint(Color.nebulaPurple)
                .labelsHidden()
        }
        .padding(CosmosSpacing.md)
    }

    private func settingsPickerRow<T: RawRepresentable & Hashable & CaseIterable>(
        icon: String,
        title: String,
        selection: Binding<T>,
        options: [T]
    ) -> some View where T.RawValue == String {
        HStack(spacing: CosmosSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(Color.nebulaLavender)
                .frame(width: 24)

            Text(title)
                .font(.cosmosBody)
                .foregroundStyle(.white)

            Spacer()

            Picker("", selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 100)
        }
        .padding(CosmosSpacing.md)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
