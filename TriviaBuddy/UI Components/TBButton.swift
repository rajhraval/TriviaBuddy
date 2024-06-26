//
//  TBButton.swift
//  Meh
//
//  Created by Raj Raval on 31/01/24.
//

import UIKit

enum TBButtonStyle {
    case icon
    case symbol
    case label
    case text
    case navigation
    case chip

    case jumboText
    case jumboSymbol
}

final class TBButton: UIButton {

    var title: String = "Button" {
        didSet {
            setupButton()
        }
    }

    var style: TBButtonStyle = .text {
        didSet {
            setupButton()
        }
    }

    var image: UIImage = UIImage(systemName: "heart.fill")! {
        didSet {
            setupButton()
        }
    }

    var size: UIButton.Configuration.Size = .large {
        didSet {
            setupButton()
        }
    }

    var radius: UIButton.Configuration.CornerStyle = .large {
        didSet {
            setupButton()
        }
    }

    var foregroundColour: UIColor = .white {
        didSet {
            setupButton()
        }
    }

    var backgroundColour: UIColor = .systemOrange {
        didSet {
            setupButton()
        }
    }

    var chipColor: UIColor = .systemBlue {
        didSet {
            setupButton()
        }
    }

    var font: UIFont = .h3 {
        didSet {
            setupButton()
        }
    }

    override var isSelected: Bool {
        didSet {
            if style == .chip {
                setupButton()
            }
        }
    }

    init(style: TBButtonStyle) {
        super.init(frame: .zero)
        self.style = style
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    func prepareForReuse() {
        titleLabel?.text = nil
        self.configuration?.title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        var configuration: UIButton.Configuration
        switch style {
        case .symbol, .icon:
            configuration = style == .symbol ? .filled() : .plain()
            let fontConfig = UIImage.SymbolConfiguration(font: style == .symbol ? .h3 : .symbol)
            configuration.image = image.applyingSymbolConfiguration(fontConfig)
            configuration.baseForegroundColor = foregroundColour

            if style == .symbol {
                configuration.buttonSize = size
                configuration.cornerStyle = radius
                configuration.baseBackgroundColor = backgroundColour
            }
        case .text, .label, .navigation:
            configuration = style == .text ? .filled() : .plain()

            configuration.baseForegroundColor = foregroundColour
            configuration.title = title
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                let size = self.style == .navigation ? UIFont.p.pointSize : self.font.pointSize
                outgoing.font = UIFont(name: self.font.fontName, size: size)!
                return outgoing
            }

            if style == .navigation {
                configuration.titleAlignment = .trailing
                configuration.contentInsets.trailing = -1
            }

            if style == .text {
                configuration.buttonSize = size
                configuration.cornerStyle = radius
                configuration.baseBackgroundColor = backgroundColour
            }
        case .jumboText, .jumboSymbol:
            configuration = .filled()
            if style == .jumboText {
                configuration.title = title
                configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont(name: self.font.fontName, size: self.font.pointSize)!
                    return outgoing
                }
            }
            if style == .jumboSymbol {
                let fontConfig = UIImage.SymbolConfiguration(font: .h3)
                configuration.image = image.applyingSymbolConfiguration(fontConfig)
            }
            configuration.baseForegroundColor = foregroundColour
            configuration.baseBackgroundColor = style == .jumboSymbol ? backgroundColour : backgroundColour.withAlphaComponent(0.15)
            configuration.cornerStyle = .capsule
            configuration.buttonSize = .large
        case .chip:
            configuration = isSelected ? .filled() : .tinted()
            configuration.cornerStyle = .dynamic
            configuration.baseBackgroundColor = chipColor
            configuration.buttonSize = .medium
            configuration.baseForegroundColor = isSelected ? .white : chipColor
            configuration.title = title
            titleLabel?.textAlignment = .center
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                let font = UIFont.p
                outgoing.font = UIFont(name: font.fontName, size: font.pointSize)!
                return outgoing
            }
        }
        self.configuration = configuration
    }

    func setupAccessibility(
        label: String,
        hint: String
    ) {
        isAccessibilityElement = true
        accessibilityLabel = label
        accessibilityHint = hint
        accessibilityTraits = .button
    }
    
}
