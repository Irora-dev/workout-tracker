import SwiftUI

// MARK: - Spacing System
public enum CosmosSpacing {
    /// Extra small: 4pt
    public static let xs: CGFloat = 4

    /// Small: 8pt
    public static let sm: CGFloat = 8

    /// Medium: 12pt
    public static let md: CGFloat = 12

    /// Large: 16pt
    public static let lg: CGFloat = 16

    /// Extra large: 24pt
    public static let xl: CGFloat = 24

    /// Double extra large: 32pt
    public static let xxl: CGFloat = 32

    /// Triple extra large: 40pt
    public static let xxxl: CGFloat = 40

    /// Screen horizontal padding
    public static let screenHorizontal: CGFloat = 20

    /// Screen bottom padding (for tab bar)
    public static let screenBottom: CGFloat = 100
}

// MARK: - Corner Radius
public enum CosmosRadius {
    /// Small: 8pt (buttons, small elements)
    public static let sm: CGFloat = 8

    /// Medium: 12pt (input fields, tags)
    public static let md: CGFloat = 12

    /// Large: 16pt (cards, containers)
    public static let lg: CGFloat = 16

    /// Extra large: 20pt (large cards, sheets)
    public static let xl: CGFloat = 20

    /// Full circle
    public static let full: CGFloat = 9999
}

// MARK: - Elevation (Shadow)
public struct CosmosElevation: ViewModifier {
    public enum Level {
        case none
        case subtle
        case medium
        case high
        case glow(Color)

        var shadowColor: Color {
            switch self {
            case .none:
                return .clear
            case .subtle:
                return .black.opacity(0.15)
            case .medium:
                return .black.opacity(0.25)
            case .high:
                return .black.opacity(0.35)
            case .glow(let color):
                return color.opacity(0.4)
            }
        }

        var radius: CGFloat {
            switch self {
            case .none: return 0
            case .subtle: return 4
            case .medium: return 8
            case .high: return 16
            case .glow: return 12
            }
        }

        var y: CGFloat {
            switch self {
            case .none: return 0
            case .subtle: return 2
            case .medium: return 4
            case .high: return 8
            case .glow: return 0
            }
        }
    }

    let level: Level

    public func body(content: Content) -> some View {
        content
            .shadow(color: level.shadowColor, radius: level.radius, x: 0, y: level.y)
    }
}

public extension View {
    func cosmosElevation(_ level: CosmosElevation.Level) -> some View {
        modifier(CosmosElevation(level: level))
    }

    func cosmosGlow(_ color: Color, radius: CGFloat = 12) -> some View {
        self.shadow(color: color.opacity(0.4), radius: radius)
    }
}

// MARK: - Icon Sizes
public enum CosmosIconSize {
    /// Small: 16pt
    public static let sm: CGFloat = 16

    /// Medium: 20pt
    public static let md: CGFloat = 20

    /// Large: 24pt
    public static let lg: CGFloat = 24

    /// Extra large: 32pt
    public static let xl: CGFloat = 32

    /// Hero: 48pt
    public static let hero: CGFloat = 48
}
