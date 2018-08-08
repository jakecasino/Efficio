//
//  Buttons.swift
//  Efficio
//
//  Created by Jake Casino on 7/6/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//


@IBDesignable
open class UIAction: UIButton {
	@IBInspectable public var accentColor: UIColor = UIColor.black {
		didSet { tintColor = accentColor }
	}
	
	@IBInspectable public var baseColor: UIColor = UIColor.clear {
		didSet { backgroundColor = baseColor }
	}
	
	@IBInspectable public var cornerRadius: CGFloat = 0 {
		didSet { layer.cornerRadius = cornerRadius }
	}
	
	@IBInspectable public var glyphEdgeInsets: CGFloat = 0 {
		didSet { style(self, [.glyphEdgeInsets: glyphEdgeInsets]) }
	}
	
	@IBInspectable public var glyphIsAspectFit: Bool = true {
		didSet { imageView?.contentMode = .scaleAspectFit }
	}
}

// Initializers
extension UIAction {
	public convenience init(addTo view: UIView, glyph: UIImage?, label: String?, baseColor: UIColor) {
		if let glyph = glyph {
			if let label = label {
				self.init(view: view, base: baseColor, accent: nil, glyph: glyph, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: nil, glyph: glyph, label: nil)
			}
		} else {
			if let label = label {
				self.init(view: view, base: baseColor, accent: nil, glyph: nil, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: nil, glyph: nil, label: nil)
			}
		}
	}
	
	public convenience init(addTo view: UIView, glyph: UIImage?, label: String?, baseColor: UIColor, accentColor: UIColor) {
		if let glyph = glyph {
			if let label = label {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: glyph, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: glyph, label: nil)
			}
		} else {
			if let label = label {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: nil, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: nil, label: nil)
			}
		}
	}
	
	private convenience init(view: UIView, base: UIColor, accent: UIColor?, glyph: UIImage?, label: String?) {
		self.init(frame: CGRect.zero)
		view.addSubview(self)
		
		baseColor = base
		if let accent = accent { accentColor = accent }
		else { accentColor = UIColor.white }
		
		style(self, [.backgroundColor: baseColor, .maskContent: true])
		tintColor = accentColor
		
		if let glyph = glyph {
			setImage(glyph, for: .normal)
			adjustsImageWhenHighlighted = false
		}
		
		if let label = label {
			setTitle(label, for: .normal)
		}
	}
}

// Functionality
extension UIAction {
	open override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				if backgroundColor == UIColor.clear {
					for view in subviews {
						view.alpha = 0.6
					}
				} else {
					backgroundColor = baseColor.darken(by: 0.15)
					tintColor = accentColor.darken(by: 0.15)
				}
			} else {
				if backgroundColor == UIColor.clear {
					for view in subviews {
						view.alpha = 1.0
					}
				} else {
					backgroundColor = baseColor
					tintColor = accentColor
				}
			}
		}
	}
	
	public typealias action = () -> ()
	public func toggle(inactiveState: @escaping action, activeState: @escaping action, hasHapticFeedback: Bool) {
		DispatchQueue.main.async {
			if self.isSelected {
				if #available(iOS 10.0, *) {
					if hasHapticFeedback { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
				}
				self.isSelected = false
				inactiveState()
			} else {
				if #available(iOS 10.0, *) {
					if hasHapticFeedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
				}
				self.isSelected = true
				activeState()
			}
		}
	}
}

public class UILargeTextButton: UIAction {
	public static func estimatedHeight(constrainWidthTo width: CGFloat) -> CGFloat { return UILabel.estimateHeight(withNumberOfLines: 1, text: String.someLongGenericText, constrainWidthTo: width, font: UIFont.boldSystemFont(ofSize: 17)) + (padding.medium * 2) }
	
	public convenience init(addTo view: UIView, text: String, width: CGFloat, primaryColor: UIColor) {
		self.init(frame: .zero)
		view.addSubview(self)
		
		resize(width: width, height: UILargeTextButton.estimatedHeight(constrainWidthTo: width))
		
		style(self, [.backgroundColor: primaryColor, .tintColor: UIColor.white, .corners: corners.extraLarge])
		setTitle(text, for: .normal)
		if let titleLabel = titleLabel { titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)}
	}
}
