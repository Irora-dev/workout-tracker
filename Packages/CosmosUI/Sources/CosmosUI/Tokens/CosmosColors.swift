import SwiftUI

// MARK: - Color Extension
public extension Color {
    // MARK: - Base Colors (Backgrounds)

    /// Primary background - darkest layer (#0A0A14)
    static let cosmicBlack = Color(red: 0.04, green: 0.04, blue: 0.08)

    /// Secondary background - gradient stops (#140F24)
    static let cosmicDeep = Color(red: 0.08, green: 0.06, blue: 0.14)

    /// Cards, containers, elevated surfaces (#1F1A33)
    static let cardBackground = Color(red: 0.12, green: 0.10, blue: 0.20)

    // MARK: - Accent Colors

    /// Success, completion, highlights (#40D9F2)
    static let nebulaCyan = Color(red: 0.25, green: 0.85, blue: 0.95)

    /// Alerts, evening theme, decorative (#F259BF)
    static let nebulaMagenta = Color(red: 0.95, green: 0.35, blue: 0.75)

    /// Secondary text, muted elements (#B38CF2)
    static let nebulaLavender = Color(red: 0.70, green: 0.55, blue: 0.95)

    /// Primary buttons, main actions (#8C4DD9)
    static let nebulaPurple = Color(red: 0.55, green: 0.30, blue: 0.85)

    /// Morning theme, warnings, stars (#FFCC66)
    static let nebulaGold = Color(red: 1.0, green: 0.80, blue: 0.40)

    // MARK: - Semantic Colors

    /// Success state
    static let cosmosSuccess = nebulaCyan

    /// Warning state
    static let cosmosWarning = nebulaGold

    /// Error state
    static let cosmosError = Color(red: 1.0, green: 0.35, blue: 0.35)

    /// Primary accent
    static let cosmosPrimary = nebulaPurple

    /// Secondary accent
    static let cosmosSecondary = nebulaLavender

    // MARK: - Text Colors

    /// Primary text - white
    static let cosmosTextPrimary = Color.white

    /// Secondary text
    static let cosmosTextSecondary = nebulaLavender.opacity(0.8)

    /// Tertiary text
    static let cosmosTextTertiary = nebulaLavender.opacity(0.6)

    /// Muted text
    static let cosmosTextMuted = nebulaLavender.opacity(0.5)

    /// Disabled text
    static let cosmosTextDisabled = nebulaLavender.opacity(0.4)

    // MARK: - Border Colors

    static let cosmosBorder = nebulaLavender.opacity(0.15)
    static let cosmosBorderFocused = nebulaPurple.opacity(0.5)

    // MARK: - Workout Type Colors

    static func workoutTypeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "gym", "weightlifting", "strength":
            return nebulaPurple
        case "running", "cardio":
            return nebulaCyan
        case "swimming":
            return Color(red: 0.2, green: 0.7, blue: 0.9)
        case "cycling":
            return nebulaGold
        case "yoga", "pilates":
            return nebulaMagenta
        case "hiit":
            return Color(red: 1.0, green: 0.5, blue: 0.3)
        case "climbing", "bouldering":
            return Color(red: 0.8, green: 0.6, blue: 0.4)
        default:
            return nebulaLavender
        }
    }
}

// MARK: - Gradients
public extension LinearGradient {
    /// Main nebula gradient
    static let cosmosNebula = LinearGradient(
        colors: [.nebulaMagenta, .nebulaPurple, .nebulaCyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Background gradient
    static let cosmosBackground = LinearGradient(
        stops: [
            .init(color: .cosmicBlack, location: 0),
            .init(color: .cosmicDeep, location: 0.3),
            .init(color: .cosmicDeep, location: 0.7),
            .init(color: .cosmicBlack, location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Success gradient
    static let cosmosSuccess = LinearGradient(
        colors: [.nebulaCyan, .nebulaCyan.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Purple action gradient
    static let cosmosPurple = LinearGradient(
        colors: [.nebulaPurple, .nebulaPurple.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Gold/warning gradient
    static let cosmosGold = LinearGradient(
        colors: [.nebulaGold, .nebulaGold.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - ShapeStyle Extension
public extension ShapeStyle where Self == Color {
    static var cosmicBlack: Color { .cosmicBlack }
    static var cosmicDeep: Color { .cosmicDeep }
    static var cardBackground: Color { .cardBackground }
    static var nebulaCyan: Color { .nebulaCyan }
    static var nebulaMagenta: Color { .nebulaMagenta }
    static var nebulaLavender: Color { .nebulaLavender }
    static var nebulaPurple: Color { .nebulaPurple }
    static var nebulaGold: Color { .nebulaGold }
}
