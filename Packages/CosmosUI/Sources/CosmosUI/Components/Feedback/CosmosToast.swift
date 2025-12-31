import SwiftUI

/// Toast notification type
public enum ToastType {
    case success
    case error
    case warning
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .nebulaCyan
        case .error: return .cosmosError
        case .warning: return .nebulaGold
        case .info: return .nebulaLavender
        }
    }
}

/// Toast notification view
public struct CosmosToast: View {
    let message: String
    let type: ToastType

    public init(message: String, type: ToastType) {
        self.message = message
        self.type = type
    }

    public var body: some View {
        HStack(spacing: CosmosSpacing.sm) {
            Image(systemName: type.icon)
                .font(.system(size: 20))
                .foregroundStyle(type.color)

            Text(message)
                .font(.cosmosSubheadline)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, CosmosSpacing.lg)
        .padding(.vertical, CosmosSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: CosmosRadius.md)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: CosmosRadius.md)
                        .stroke(type.color.opacity(0.3), lineWidth: 1)
                )
        )
        .cosmosElevation(.medium)
        .padding(.horizontal, CosmosSpacing.lg)
    }
}

/// Toast presentation modifier
public struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: ToastType
    let duration: TimeInterval

    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if isPresented {
                CosmosToast(message: message, type: type)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(100)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPresented = false
                            }
                        }
                    }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
    }
}

public extension View {
    func cosmosToast(
        isPresented: Binding<Bool>,
        message: String,
        type: ToastType = .success,
        duration: TimeInterval = 3
    ) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, type: type, duration: duration))
    }
}

/// Loading indicator
public struct CosmosLoadingIndicator: View {
    let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: CosmosSpacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .nebulaPurple))
                .scaleEffect(1.2)

            if let message = message {
                Text(message)
                    .font(.cosmosSubheadline)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }
        }
        .padding(CosmosSpacing.xl)
    }
}

/// Empty state placeholder
public struct CosmosEmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    public init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: CosmosSpacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(Color.cosmosTextTertiary)

            VStack(spacing: CosmosSpacing.sm) {
                Text(title)
                    .font(.cosmosTitle3)
                    .foregroundStyle(.white)

                Text(message)
                    .font(.cosmosSubheadline)
                    .foregroundStyle(Color.cosmosTextSecondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle = actionTitle, let action = action {
                CosmosPrimaryButton(actionTitle, icon: "plus", action: action)
                    .frame(maxWidth: 200)
            }
        }
        .padding(CosmosSpacing.xl)
    }
}

// MARK: - Previews
#Preview("Toasts") {
    VStack(spacing: 16) {
        CosmosToast(message: "Workout completed!", type: .success)
        CosmosToast(message: "Network error", type: .error)
        CosmosToast(message: "Streak at risk", type: .warning)
        CosmosToast(message: "New feature available", type: .info)
    }
    .background(Color.cosmicBlack)
}

#Preview("Loading") {
    CosmosLoadingIndicator(message: "Loading workouts...")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cosmicBlack)
}

#Preview("Empty State") {
    CosmosEmptyState(
        icon: "figure.run",
        title: "No Workouts Yet",
        message: "Start your fitness journey by logging your first workout.",
        actionTitle: "Start Workout"
    ) {}
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.cosmicBlack)
}
