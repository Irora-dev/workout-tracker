import SwiftUI

// MARK: - Typography
public extension Font {
    // MARK: - Display
    /// Large display text (32pt Bold)
    static let cosmosLargeTitle = Font.system(size: 32, weight: .bold)

    /// Title text (28pt Bold)
    static let cosmosTitle = Font.system(size: 28, weight: .bold)

    /// Title 2 text (24pt Bold)
    static let cosmosTitle2 = Font.system(size: 24, weight: .bold)

    /// Title 3 text (20pt Semibold)
    static let cosmosTitle3 = Font.system(size: 20, weight: .semibold)

    // MARK: - Body
    /// Headline text (17pt Semibold)
    static let cosmosHeadline = Font.system(size: 17, weight: .semibold)

    /// Body text (17pt Regular)
    static let cosmosBody = Font.system(size: 17, weight: .regular)

    /// Subheadline text (15pt Regular)
    static let cosmosSubheadline = Font.system(size: 15, weight: .regular)

    /// Callout text (16pt Regular)
    static let cosmosCallout = Font.system(size: 16, weight: .regular)

    // MARK: - Small
    /// Caption text (13pt Regular)
    static let cosmosCaption = Font.system(size: 13, weight: .regular)

    /// Caption 2 text (11pt Regular)
    static let cosmosCaption2 = Font.system(size: 11, weight: .regular)

    // MARK: - Special
    /// Button text (17pt Semibold)
    static let cosmosButton = Font.system(size: 17, weight: .semibold)

    /// Tab bar text (10pt Medium)
    static let cosmosTabBar = Font.system(size: 10, weight: .medium)

    /// Large numbers (48pt Bold, monospaced)
    static let cosmosLargeNumber = Font.system(size: 48, weight: .bold, design: .rounded)

    /// Medium numbers (32pt Bold, monospaced)
    static let cosmosMediumNumber = Font.system(size: 32, weight: .bold, design: .rounded)

    /// Small numbers (24pt Semibold, monospaced)
    static let cosmosSmallNumber = Font.system(size: 24, weight: .semibold, design: .rounded)
}

// MARK: - Text Style Modifiers
public struct CosmosTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat

    public func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .lineSpacing(lineSpacing)
    }
}

public extension View {
    func cosmosTextStyle(
        _ font: Font,
        color: Color = .cosmosTextPrimary,
        lineSpacing: CGFloat = 4
    ) -> some View {
        modifier(CosmosTextStyle(font: font, color: color, lineSpacing: lineSpacing))
    }

    // Convenience methods
    func cosmosTitle() -> some View {
        cosmosTextStyle(.cosmosTitle)
    }

    func cosmosHeadline() -> some View {
        cosmosTextStyle(.cosmosHeadline)
    }

    func cosmosBody() -> some View {
        cosmosTextStyle(.cosmosBody)
    }

    func cosmosCaption() -> some View {
        cosmosTextStyle(.cosmosCaption, color: .cosmosTextSecondary)
    }

    func cosmosMuted() -> some View {
        cosmosTextStyle(.cosmosSubheadline, color: .cosmosTextMuted)
    }
}
