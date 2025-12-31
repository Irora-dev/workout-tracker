import SwiftUI

/// Styled text input with cosmic theme
public struct CosmosTextField: View {
    @Binding var text: String
    let placeholder: String
    let label: String?
    let icon: String?
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: String,
        label: String? = nil,
        icon: String? = nil,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.icon = icon
        self.keyboardType = keyboardType
        self.isSecure = isSecure
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: CosmosSpacing.xs) {
            if let label = label {
                Text(label)
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }

            HStack(spacing: CosmosSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(isFocused ? Color.nebulaPurple : Color.cosmosTextTertiary)
                }

                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .focused($isFocused)
                }
            }
            .font(.cosmosBody)
            .foregroundStyle(.white)
            .padding(.horizontal, CosmosSpacing.md)
            .padding(.vertical, CosmosSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: CosmosRadius.md)
                    .fill(Color.cardBackground.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: CosmosRadius.md)
                            .stroke(
                                isFocused ? Color.nebulaPurple.opacity(0.5) : Color.cosmosBorder,
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

/// Numeric stepper input for reps, weight, etc.
public struct CosmosNumberStepper: View {
    @Binding var value: Double
    let label: String?
    let unit: String?
    let range: ClosedRange<Double>
    let step: Double
    let format: String

    public init(
        value: Binding<Double>,
        label: String? = nil,
        unit: String? = nil,
        range: ClosedRange<Double> = 0...999,
        step: Double = 1,
        format: String = "%.0f"
    ) {
        self._value = value
        self.label = label
        self.unit = unit
        self.range = range
        self.step = step
        self.format = format
    }

    public var body: some View {
        VStack(spacing: CosmosSpacing.xs) {
            if let label = label {
                Text(label)
                    .font(.cosmosCaption)
                    .foregroundStyle(Color.cosmosTextSecondary)
            }

            HStack(spacing: CosmosSpacing.sm) {
                // Decrement
                Button {
                    if value > range.lowerBound {
                        value = max(range.lowerBound, value - step)
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(value > range.lowerBound ? Color.white : Color.cosmosTextDisabled)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.cardBackground)
                                .overlay(
                                    Circle()
                                        .stroke(Color.cosmosBorder, lineWidth: 1)
                                )
                        )
                }
                .disabled(value <= range.lowerBound)

                // Value display
                VStack(spacing: 0) {
                    Text(String(format: format, value))
                        .font(.cosmosMediumNumber)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())

                    if let unit = unit {
                        Text(unit)
                            .font(.cosmosCaption)
                            .foregroundStyle(Color.cosmosTextSecondary)
                    }
                }
                .frame(minWidth: 60)

                // Increment
                Button {
                    if value < range.upperBound {
                        value = min(range.upperBound, value + step)
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(value < range.upperBound ? Color.white : Color.cosmosTextDisabled)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.cardBackground)
                                .overlay(
                                    Circle()
                                        .stroke(Color.cosmosBorder, lineWidth: 1)
                                )
                        )
                }
                .disabled(value >= range.upperBound)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}

/// Segmented picker with cosmic styling
public struct CosmosPicker<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let label: (T) -> String

    public init(
        selection: Binding<T>,
        options: [T],
        label: @escaping (T) -> String
    ) {
        self._selection = selection
        self.options = options
        self.label = label
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = option
                    }
                } label: {
                    Text(label(option))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(selection == option ? .white : Color.cosmosTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, CosmosSpacing.sm)
                        .background {
                            if selection == option {
                                RoundedRectangle(cornerRadius: CosmosRadius.sm)
                                    .fill(Color.nebulaPurple)
                            }
                        }
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: CosmosRadius.md)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: CosmosRadius.md)
                        .stroke(Color.cosmosBorder, lineWidth: 1)
                )
        )
    }
}

// MARK: - Previews
#Preview("Text Fields") {
    VStack(spacing: 20) {
        CosmosTextField(
            text: .constant(""),
            placeholder: "Enter exercise name",
            label: "Exercise Name",
            icon: "pencil"
        )

        CosmosTextField(
            text: .constant("john@example.com"),
            placeholder: "Email",
            icon: "envelope",
            keyboardType: .emailAddress
        )
    }
    .padding()
    .background(Color.cosmicBlack)
}

#Preview("Number Steppers") {
    HStack(spacing: 32) {
        CosmosNumberStepper(
            value: .constant(10),
            label: "Reps",
            range: 1...50
        )

        CosmosNumberStepper(
            value: .constant(135),
            label: "Weight",
            unit: "lbs",
            range: 0...500,
            step: 5
        )
    }
    .padding()
    .background(Color.cosmicBlack)
}

#Preview("Picker") {
    CosmosPicker(
        selection: .constant("Push"),
        options: ["Push", "Pull", "Legs"],
        label: { $0 }
    )
    .padding()
    .background(Color.cosmicBlack)
}
