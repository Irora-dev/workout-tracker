import SwiftUI

/// Tab item configuration
public struct CosmosTabItem: Identifiable {
    public let id: Int
    public let icon: String
    public let selectedIcon: String
    public let label: String

    public init(id: Int, icon: String, selectedIcon: String, label: String) {
        self.id = id
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.label = label
    }
}

/// Custom tab bar with cosmic styling
public struct CosmosTabBar: View {
    @Binding var selectedTab: Int
    let items: [CosmosTabItem]

    public init(selectedTab: Binding<Int>, items: [CosmosTabItem]) {
        self._selectedTab = selectedTab
        self.items = items
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                tabButton(item)
            }
        }
        .padding(.horizontal, CosmosSpacing.sm)
        .padding(.top, CosmosSpacing.sm)
        .padding(.bottom, CosmosSpacing.xl)
        .background(
            Rectangle()
                .fill(Color.cosmicBlack)
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.cardBackground.opacity(0.5), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 1),
                    alignment: .top
                )
        )
    }

    @ViewBuilder
    private func tabButton(_ item: CosmosTabItem) -> some View {
        let isSelected = selectedTab == item.id

        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = item.id
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? item.selectedIcon : item.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Color.nebulaPurple : Color.cosmosTextTertiary)
                    .symbolEffect(.bounce, value: isSelected)

                Text(item.label)
                    .font(.cosmosTabBar)
                    .foregroundStyle(isSelected ? Color.nebulaPurple : Color.cosmosTextTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/// Navigation bar styling
public struct CosmosNavigationBar: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .toolbarBackground(Color.cosmicBlack, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

public extension View {
    func cosmosNavigationBar() -> some View {
        modifier(CosmosNavigationBar())
    }
}

/// Background view with cosmic gradient
public struct CosmosBackground: View {
    let showOrbs: Bool

    public init(showOrbs: Bool = true) {
        self.showOrbs = showOrbs
    }

    public var body: some View {
        ZStack {
            LinearGradient.cosmosBackground
                .ignoresSafeArea()

            if showOrbs {
                GeometryReader { geometry in
                    // Magenta orb
                    Circle()
                        .fill(Color.nebulaMagenta.opacity(0.12))
                        .frame(width: 300, height: 300)
                        .blur(radius: 80)
                        .offset(x: -100, y: -50)

                    // Purple orb
                    Circle()
                        .fill(Color.nebulaPurple.opacity(0.10))
                        .frame(width: 250, height: 250)
                        .blur(radius: 60)
                        .offset(x: geometry.size.width - 100, y: geometry.size.height * 0.3)

                    // Cyan orb
                    Circle()
                        .fill(Color.nebulaCyan.opacity(0.06))
                        .frame(width: 200, height: 200)
                        .blur(radius: 50)
                        .offset(x: 50, y: geometry.size.height * 0.6)
                }
                .ignoresSafeArea()
            }
        }
    }
}

public extension View {
    func cosmosBackground(showOrbs: Bool = true) -> some View {
        self.background(CosmosBackground(showOrbs: showOrbs))
    }
}

// MARK: - Previews
#Preview("Tab Bar") {
    VStack {
        Spacer()

        CosmosTabBar(
            selectedTab: .constant(0),
            items: [
                CosmosTabItem(id: 0, icon: "house", selectedIcon: "house.fill", label: "Today"),
                CosmosTabItem(id: 1, icon: "figure.run", selectedIcon: "figure.run", label: "Workout"),
                CosmosTabItem(id: 2, icon: "list.clipboard", selectedIcon: "list.clipboard.fill", label: "Plans"),
                CosmosTabItem(id: 3, icon: "chart.bar", selectedIcon: "chart.bar.fill", label: "Progress"),
                CosmosTabItem(id: 4, icon: "person", selectedIcon: "person.fill", label: "Profile"),
            ]
        )
    }
    .cosmosBackground()
}

#Preview("Background") {
    CosmosBackground()
}
