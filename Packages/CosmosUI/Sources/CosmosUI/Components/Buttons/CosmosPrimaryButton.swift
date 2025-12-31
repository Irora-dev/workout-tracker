import SwiftUI

/// Primary call-to-action button with gradient background and glow
public struct CosmosPrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    public init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: CosmosSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }

                Text(title)
                    .font(.cosmosButton)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: CosmosRadius.md)
                    .fill(LinearGradient.cosmosPurple)
            )
            .opacity(isDisabled || isLoading ? 0.5 : 1)
            .cosmosGlow(.nebulaPurple, radius: isDisabled ? 0 : 12)
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(ScaleButtonStyle())
    }
}

/// Secondary button with border or ghost styling
public struct CosmosSecondaryButton: View {
    public enum Style {
        case outlined
        case ghost
        case tinted
    }

    let title: String
    let icon: String?
    let style: Style
    let action: () -> Void

    public init(
        _ title: String,
        icon: String? = nil,
        style: Style = .outlined,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: CosmosSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }

                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(foregroundColor)
            .frame(height: 44)
            .padding(.horizontal, CosmosSpacing.lg)
            .background(background)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var foregroundColor: Color {
        switch style {
        case .outlined, .ghost:
            return .nebulaLavender
        case .tinted:
            return .nebulaPurple
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .outlined:
            RoundedRectangle(cornerRadius: CosmosRadius.sm)
                .stroke(Color.cosmosBorder, lineWidth: 1)
        case .ghost:
            Color.clear
        case .tinted:
            RoundedRectangle(cornerRadius: CosmosRadius.sm)
                .fill(Color.nebulaPurple.opacity(0.15))
        }
    }
}

/// Icon-only circular button
public struct CosmosIconButton: View {
    public enum Size {
        case small   // 32pt
        case medium  // 44pt
        case large   // 56pt

        var dimension: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 56
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            }
        }
    }

    public enum Style {
        case primary
        case secondary
        case ghost
        case destructive
    }

    let icon: String
    let size: Size
    let style: Style
    let action: () -> Void

    public init(
        icon: String,
        size: Size = .medium,
        style: Style = .secondary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundStyle(foregroundColor)
                .frame(width: size.dimension, height: size.dimension)
                .background(background)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary, .ghost:
            return .nebulaLavender
        case .destructive:
            return .cosmosError
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            Circle()
                .fill(LinearGradient.cosmosPurple)
                .cosmosGlow(.nebulaPurple, radius: 8)
        case .secondary:
            Circle()
                .fill(Color.cardBackground)
                .overlay(
                    Circle()
                        .stroke(Color.cosmosBorder, lineWidth: 1)
                )
        case .ghost:
            Color.clear
        case .destructive:
            Circle()
                .fill(Color.cosmosError.opacity(0.15))
        }
    }
}

// MARK: - Button Styles
public struct ScaleButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Previews
#Preview("Primary Button") {
    VStack(spacing: 20) {
        CosmosPrimaryButton("Get Started", icon: "arrow.right") {}
        CosmosPrimaryButton("Loading...", isLoading: true) {}
        CosmosPrimaryButton("Disabled", isDisabled: true) {}
    }
    .padding()
    .background(Color.cosmicBlack)
}

#Preview("Secondary Buttons") {
    VStack(spacing: 20) {
        CosmosSecondaryButton("Cancel", style: .outlined) {}
        CosmosSecondaryButton("Skip", style: .ghost) {}
        CosmosSecondaryButton("Add", icon: "plus", style: .tinted) {}
    }
    .padding()
    .background(Color.cosmicBlack)
}

#Preview("Icon Buttons") {
    HStack(spacing: 20) {
        CosmosIconButton(icon: "plus", size: .small, style: .primary) {}
        CosmosIconButton(icon: "heart", size: .medium, style: .secondary) {}
        CosmosIconButton(icon: "trash", size: .large, style: .destructive) {}
    }
    .padding()
    .background(Color.cosmicBlack)
}
