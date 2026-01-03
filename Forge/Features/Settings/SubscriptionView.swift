import SwiftUI
import CosmosCore
import CosmosUI

/// Subscription/paywall view
struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var isProcessing = false

    enum SubscriptionPlan {
        case monthly
        case yearly

        var price: String {
            switch self {
            case .monthly: return "$9.99"
            case .yearly: return "$59.99"
            }
        }

        var period: String {
            switch self {
            case .monthly: return "/month"
            case .yearly: return "/year"
            }
        }

        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "Save 50%"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CosmosSpacing.xl) {
                    // Hero section
                    heroSection

                    // Features
                    featuresSection

                    // Plan selection
                    planSelectionSection

                    // Subscribe button
                    subscribeButton

                    // Restore & Terms
                    footerSection
                }
                .padding(.horizontal, CosmosSpacing.screenHorizontal)
                .padding(.bottom, CosmosSpacing.screenBottom)
            }
            .cosmosBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.cosmosTextSecondary)
                    }
                }
            }
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: CosmosSpacing.lg) {
            // Premium badge
            HStack(spacing: CosmosSpacing.xs) {
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.nebulaGold)
                Text("FORGE PREMIUM")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.nebulaGold)
            }
            .padding(.horizontal, CosmosSpacing.md)
            .padding(.vertical, CosmosSpacing.xs)
            .background(
                Capsule()
                    .fill(Color.nebulaGold.opacity(0.15))
            )
            .padding(.top, CosmosSpacing.xl)

            // Title
            Text("Unlock Your\nFull Potential")
                .font(.cosmosLargeTitle)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // Subtitle
            Text("Get unlimited access to all features and take your workouts to the next level.")
                .font(.cosmosSubheadline)
                .foregroundStyle(Color.cosmosTextSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: CosmosSpacing.md) {
            featureRow(icon: "list.clipboard.fill", title: "50+ Workout Plans", description: "Access all premium workout programs")
            featureRow(icon: "chart.bar.fill", title: "Advanced Analytics", description: "Detailed progress tracking and insights")
            featureRow(icon: "figure.run", title: "Unlimited Workouts", description: "Track unlimited workout sessions")
            featureRow(icon: "brain.head.profile", title: "AI Recommendations", description: "Personalized workout suggestions")
            featureRow(icon: "trophy.fill", title: "Challenges", description: "Compete with friends and community")
            featureRow(icon: "icloud.fill", title: "Cloud Sync", description: "Sync across all your devices")
        }
        .padding(CosmosSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: CosmosRadius.lg)
                .fill(Color.cardBackground)
        )
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: CosmosSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.nebulaGold)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.cosmosBody)
                    .foregroundStyle(.white)

                Text(description)
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }

            Spacer()

            Image(systemName: "checkmark")
                .foregroundStyle(Color.cosmosSuccess)
        }
    }

    // MARK: - Plan Selection
    private var planSelectionSection: some View {
        VStack(spacing: CosmosSpacing.md) {
            Text("Choose Your Plan")
                .font(.cosmosHeadline)
                .foregroundStyle(.white)

            HStack(spacing: CosmosSpacing.md) {
                planCard(.monthly)
                planCard(.yearly)
            }
        }
    }

    private func planCard(_ plan: SubscriptionPlan) -> some View {
        let isSelected = selectedPlan == plan

        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedPlan = plan
            }
        } label: {
            VStack(spacing: CosmosSpacing.sm) {
                if let savings = plan.savings {
                    Text(savings)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, CosmosSpacing.sm)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.cosmosSuccess)
                        )
                } else {
                    Spacer()
                        .frame(height: 22)
                }

                Text(plan == .monthly ? "Monthly" : "Yearly")
                    .font(.cosmosSubheadline)
                    .foregroundStyle(isSelected ? .white : Color.cosmosTextSecondary)

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(plan.price)
                        .font(.cosmosTitle2)
                        .foregroundStyle(.white)

                    Text(plan.period)
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)
                }

                if plan == .yearly {
                    Text("$5/month")
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextTertiary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, CosmosSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: CosmosRadius.md)
                    .fill(isSelected ? Color.nebulaPurple.opacity(0.3) : Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: CosmosRadius.md)
                            .stroke(isSelected ? Color.nebulaPurple : Color.clear, lineWidth: 2)
                    )
            )
        }
    }

    // MARK: - Subscribe Button
    private var subscribeButton: some View {
        VStack(spacing: CosmosSpacing.sm) {
            Button {
                subscribe()
            } label: {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Start Free Trial")
                            .font(.cosmosHeadline)
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, CosmosSpacing.md)
                .background(
                    LinearGradient.cosmosPurple
                )
                .clipShape(RoundedRectangle(cornerRadius: CosmosRadius.md))
            }
            .disabled(isProcessing)

            Text("7-day free trial, then \(selectedPlan.price)\(selectedPlan.period)")
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextSecondary)
        }
    }

    // MARK: - Footer
    private var footerSection: some View {
        VStack(spacing: CosmosSpacing.md) {
            Button("Restore Purchases") {
                restorePurchases()
            }
            .font(.cosmosSubheadline)
            .foregroundStyle(Color.nebulaCyan)

            HStack(spacing: CosmosSpacing.lg) {
                Button("Terms of Service") {}
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)

                Button("Privacy Policy") {}
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }

            Text("Cancel anytime. Subscription automatically renews.")
                .font(.cosmosCaption)
                .foregroundStyle(Color.cosmosTextTertiary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Actions
    private func subscribe() {
        isProcessing = true
        Task {
            do {
                // In real app, would call StoreKit
                try await Task.sleep(nanoseconds: 2_000_000_000)
                dismiss()
                appState.showSuccessToast("Welcome to Premium!")
            } catch {
                appState.showErrorToast("Subscription failed")
            }
            isProcessing = false
        }
    }

    private func restorePurchases() {
        isProcessing = true
        Task {
            do {
                try await appState.subscriptionService.restorePurchases()
                if appState.subscriptionService.isPremium {
                    dismiss()
                    appState.showSuccessToast("Purchases restored!")
                } else {
                    appState.showErrorToast("No purchases to restore")
                }
            } catch {
                appState.showErrorToast("Restore failed")
            }
            isProcessing = false
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(AppState())
}
