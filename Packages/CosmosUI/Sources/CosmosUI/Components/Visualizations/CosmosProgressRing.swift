import SwiftUI

/// Circular progress ring with animated fill
public struct CosmosProgressRing: View {
    public enum Size {
        case small   // 44pt
        case medium  // 64pt
        case large   // 120pt

        var dimension: CGFloat {
            switch self {
            case .small: return 44
            case .medium: return 64
            case .large: return 120
            }
        }

        var lineWidth: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 6
            case .large: return 10
            }
        }

        var fontSize: Font {
            switch self {
            case .small: return .system(size: 12, weight: .bold)
            case .medium: return .system(size: 16, weight: .bold)
            case .large: return .system(size: 28, weight: .bold)
            }
        }
    }

    public enum Style {
        case gradient
        case solid(Color)
        case success

        var colors: [Color] {
            switch self {
            case .gradient:
                return [.nebulaMagenta, .nebulaPurple, .nebulaCyan]
            case .solid(let color):
                return [color]
            case .success:
                return [.nebulaCyan]
            }
        }
    }

    let progress: Double
    let size: Size
    let style: Style
    let showPercentage: Bool
    let label: String?
    let icon: String?

    @State private var animatedProgress: Double = 0

    public init(
        progress: Double,
        size: Size = .medium,
        style: Style = .gradient,
        showPercentage: Bool = true,
        label: String? = nil,
        icon: String? = nil
    ) {
        self.progress = min(max(progress, 0), 1)
        self.size = size
        self.style = style
        self.showPercentage = showPercentage
        self.label = label
        self.icon = icon
    }

    public var body: some View {
        VStack(spacing: CosmosSpacing.xs) {
            ZStack {
                // Background track
                Circle()
                    .stroke(
                        Color.cosmosBorder,
                        style: StrokeStyle(lineWidth: size.lineWidth, lineCap: .round)
                    )

                // Progress arc
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        progressGradient,
                        style: StrokeStyle(lineWidth: size.lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animatedProgress)

                // Center content
                centerContent
            }
            .frame(width: size.dimension, height: size.dimension)

            if let label = label {
                Text(label)
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { _, newValue in
            animatedProgress = newValue
        }
    }

    @ViewBuilder
    private var centerContent: some View {
        if let icon = icon {
            Image(systemName: icon)
                .font(.system(size: size.dimension * 0.3))
                .foregroundStyle(style.colors.first ?? .nebulaCyan)
        } else if showPercentage {
            Text("\(Int(animatedProgress * 100))")
                .font(size.fontSize)
                .foregroundStyle(.white)
                .contentTransition(.numericText())
        }
    }

    private var progressGradient: some ShapeStyle {
        if style.colors.count > 1 {
            return AnyShapeStyle(
                AngularGradient(
                    colors: style.colors,
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360 * animatedProgress)
                )
            )
        } else {
            return AnyShapeStyle(style.colors.first ?? .nebulaCyan)
        }
    }
}

/// Streak indicator with flame icon
public struct CosmosStreakIndicator: View {
    public enum Size {
        case compact    // Just number + flame
        case standard   // Number + flame + "day streak"
        case featured   // Large with glow

        var flameSize: CGFloat {
            switch self {
            case .compact: return 16
            case .standard: return 20
            case .featured: return 32
            }
        }

        var numberFont: Font {
            switch self {
            case .compact: return .system(size: 16, weight: .bold)
            case .standard: return .system(size: 20, weight: .bold)
            case .featured: return .system(size: 32, weight: .bold)
            }
        }
    }

    let count: Int
    let isActive: Bool
    let size: Size

    public init(count: Int, isActive: Bool = true, size: Size = .standard) {
        self.count = count
        self.isActive = isActive
        self.size = size
    }

    public var body: some View {
        HStack(spacing: CosmosSpacing.xs) {
            Image(systemName: isActive ? "flame.fill" : "flame")
                .font(.system(size: size.flameSize))
                .foregroundStyle(isActive ? Color.nebulaGold : Color.cosmosTextMuted)
                .symbolEffect(.bounce, value: isActive)

            Text("\(count)")
                .font(size.numberFont)
                .foregroundStyle(isActive ? .white : Color.cosmosTextMuted)
                .contentTransition(.numericText())

            if size == .standard || size == .featured {
                Text(count == 1 ? "day" : "days")
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }
        }
        .padding(.horizontal, size == .featured ? CosmosSpacing.lg : CosmosSpacing.sm)
        .padding(.vertical, size == .featured ? CosmosSpacing.md : CosmosSpacing.xs)
        .background {
            if size == .featured {
                Capsule()
                    .fill(Color.nebulaGold.opacity(0.15))
                    .overlay(
                        Capsule()
                            .stroke(Color.nebulaGold.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .cosmosGlow(isActive && size == .featured ? .nebulaGold : .clear, radius: 8)
    }
}

/// Mini progress bar (horizontal)
public struct CosmosProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat

    @State private var animatedProgress: Double = 0

    public init(progress: Double, color: Color = .nebulaCyan, height: CGFloat = 6) {
        self.progress = min(max(progress, 0), 1)
        self.color = color
        self.height = height
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Capsule()
                    .fill(Color.cosmosBorder)

                // Progress
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width * animatedProgress)
            }
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Previews
#Preview("Progress Rings") {
    VStack(spacing: 32) {
        HStack(spacing: 24) {
            CosmosProgressRing(progress: 0.75, size: .small)
            CosmosProgressRing(progress: 0.5, size: .medium, style: .solid(.nebulaCyan))
            CosmosProgressRing(progress: 1.0, size: .large, style: .success, label: "Complete")
        }

        CosmosProgressRing(progress: 0.6, size: .large, showPercentage: false, icon: "flame.fill")
    }
    .padding()
    .background(Color.cosmicBlack)
}

#Preview("Streak Indicators") {
    VStack(spacing: 24) {
        CosmosStreakIndicator(count: 7, isActive: true, size: .compact)
        CosmosStreakIndicator(count: 14, isActive: true, size: .standard)
        CosmosStreakIndicator(count: 30, isActive: true, size: .featured)
        CosmosStreakIndicator(count: 5, isActive: false, size: .standard)
    }
    .padding()
    .background(Color.cosmicBlack)
}

#Preview("Progress Bars") {
    VStack(spacing: 16) {
        CosmosProgressBar(progress: 0.3, color: .nebulaCyan)
        CosmosProgressBar(progress: 0.7, color: .nebulaPurple)
        CosmosProgressBar(progress: 1.0, color: .nebulaGold)
    }
    .padding()
    .background(Color.cosmicBlack)
}
