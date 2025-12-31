import SwiftUI

/// Standard card container with cosmic styling
public struct CosmosCard<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(CosmosSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: CosmosRadius.lg)
                    .fill(Color.cardBackground.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: CosmosRadius.lg)
                            .stroke(Color.cosmosBorder, lineWidth: 1)
                    )
            )
    }
}

/// Card with header
public struct CosmosCardWithHeader<Content: View>: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let iconColor: Color
    let action: (() -> Void)?
    let content: Content

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = .nebulaPurple,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.action = action
        self.content = content()
    }

    public var body: some View {
        CosmosCard {
            VStack(alignment: .leading, spacing: CosmosSpacing.md) {
                // Header
                HStack(spacing: CosmosSpacing.sm) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundStyle(iconColor)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(iconColor.opacity(0.15))
                            )
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.cosmosHeadline)
                            .foregroundStyle(.white)

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.cosmosCaption)
                                .foregroundStyle(Color.cosmosTextSecondary)
                        }
                    }

                    Spacer()

                    if let action = action {
                        Button(action: action) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.cosmosTextTertiary)
                        }
                    }
                }

                content
            }
        }
    }
}

/// Stat card for displaying a single metric
public struct CosmosStatCard: View {
    public enum Trend {
        case up(percentage: Int)
        case down(percentage: Int)
        case neutral

        var color: Color {
            switch self {
            case .up: return .nebulaCyan
            case .down: return .cosmosError
            case .neutral: return .cosmosTextSecondary
            }
        }

        var icon: String {
            switch self {
            case .up: return "arrow.up"
            case .down: return "arrow.down"
            case .neutral: return "minus"
            }
        }
    }

    let title: String
    let value: String
    let subtitle: String?
    let icon: String?
    let iconColor: Color
    let trend: Trend?

    public init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = .nebulaCyan,
        trend: Trend? = nil
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.trend = trend
    }

    public var body: some View {
        CosmosCard {
            VStack(alignment: .leading, spacing: CosmosSpacing.sm) {
                HStack {
                    Text(title)
                        .font(.cosmosCaption)
                        .foregroundStyle(Color.cosmosTextSecondary)

                    Spacer()

                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(iconColor)
                    }
                }

                HStack(alignment: .lastTextBaseline, spacing: CosmosSpacing.xs) {
                    Text(value)
                        .font(.cosmosMediumNumber)
                        .foregroundStyle(.white)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.cosmosSubheadline)
                            .foregroundStyle(Color.cosmosTextSecondary)
                    }

                    Spacer()

                    if let trend = trend {
                        trendBadge(trend)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func trendBadge(_ trend: Trend) -> some View {
        HStack(spacing: 2) {
            Image(systemName: trend.icon)
                .font(.system(size: 10, weight: .bold))

            switch trend {
            case .up(let pct), .down(let pct):
                Text("\(pct)%")
                    .font(.system(size: 12, weight: .semibold))
            case .neutral:
                EmptyView()
            }
        }
        .foregroundStyle(trend.color)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            Capsule()
                .fill(trend.color.opacity(0.15))
        )
    }
}

// MARK: - Card Modifier
public struct CosmosCardStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(CosmosSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: CosmosRadius.lg)
                    .fill(Color.cardBackground.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: CosmosRadius.lg)
                            .stroke(Color.cosmosBorder, lineWidth: 1)
                    )
            )
    }
}

public extension View {
    func cosmosCardStyle() -> some View {
        modifier(CosmosCardStyle())
    }
}

// MARK: - Previews
#Preview("Cards") {
    ScrollView {
        VStack(spacing: 16) {
            CosmosCard {
                Text("Simple Card Content")
                    .foregroundStyle(.white)
            }

            CosmosCardWithHeader(
                title: "Today's Progress",
                subtitle: "3 of 5 exercises",
                icon: "flame.fill",
                iconColor: .nebulaGold
            ) {
                Text("Card with header content")
                    .foregroundStyle(Color.cosmosTextSecondary)
            }

            HStack(spacing: 12) {
                CosmosStatCard(
                    title: "Streak",
                    value: "12",
                    subtitle: "days",
                    icon: "flame.fill",
                    iconColor: .nebulaGold,
                    trend: .up(percentage: 20)
                )

                CosmosStatCard(
                    title: "Workouts",
                    value: "48",
                    subtitle: "this month",
                    icon: "figure.run"
                )
            }
        }
        .padding()
    }
    .background(Color.cosmicBlack)
}
