//
//  Views.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/5/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

extension UIView {
	public func matchFrame(to view: Any) {
		if let view = view as? UIView {
			frame = view.frame
		} else if let rect = view as? CGRect {
			frame.origin = rect.origin
			frame.size = rect.size
		} else {
			error.regarding(self, explanation: "Could not match view's frame because the input view was not of type UIView or CGRect.")
		}
		updateShadowFrame()
	}
}

// Framework for Moving Views

public enum origins {
	case top
	case topMinusPadding
	case middle
	case bottom
	case bottomMinusPadding
	case left
	case leftMinusPadding
	case center
	case right
	case rightMinusPadding
	case totheLeftOf
	case toTheRightOf
	case aboveView
	case belowView
}

extension UIView {
	private static var associationKey_padding: UInt8 = 0
	public var paddingInsets: UIEdgeInsets? {
		get {
			return objc_getAssociatedObject(self, &UIView.associationKey_padding) as? UIEdgeInsets
		}
		set(newValue) {
			objc_setAssociatedObject(self, &UIView.associationKey_padding, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	@objc public convenience init(addTo view: UIView) {
		self.init(frame: .zero)
		view.addSubview(self)
	}
	
	public func move(x: Any?, y: Any?) {
		translator(x: x, y: y, considersSafeAreaFrom: nil)
	}
	
	public func move(x: Any?, y: Any?, considersSafeAreaFrom view: UIView) {
		translator(x: x, y: y, considersSafeAreaFrom: view)
	}
	
	public func move(addToX x: CGFloat?, addToY y: CGFloat?) {
		// translator(x: x, y: y, considersSafeAreaFrom: nil)
		var X: CGFloat = 0
		var Y: CGFloat = 0
		if let x = x { X += x }
		if let y = y { Y += y }
		
		move(x: frame.origin.x + X, y: frame.origin.y + Y)
		updateShadowFrame()
	}
	
	public func move(toMatch view: UIView) {
		frame.origin = view.frame.origin
		updateShadowFrame()
	}
	
	public func move(x: origins?, _ xView: UIView?, withXPadding xPadding: CGFloat?, y: origins?, _ yView: UIView?, withYPadding yPadding: CGFloat?) {
		var X: CGFloat = frame.origin.x
		var Y: CGFloat = frame.origin.y
		
		if let x = x {
			if let xView = xView {
				X = xView.frame.origin.x
				switch x {
				case .totheLeftOf:
					X -= frame.width
					if let xPadding = xPadding { X -= xPadding }
				case .toTheRightOf:
					X += xView.frame.width
					if let xPadding = xPadding { X += xPadding }
				default:
					error.regarding(self, explanation: "Could not move view as expected because origin parameter for x should only be origins.toTheLeftOf or origins.toTheRightOf.")
					break
				}
			}
		}
		
		if let y = y {
			if let yView = yView {
				Y = yView.frame.origin.y
				switch y {
				case .aboveView:
					Y -= frame.height
					if let yPadding = yPadding { Y -= yPadding }
				case .belowView:
					Y += yView.frame.height
					if let yPadding = yPadding { Y += yPadding }
				default:
					error.regarding(self, explanation: "Could not move view as expected because origin parameter for y should only be origins.aboveView or origins.belowView.")
					break
				}
			}
		}
		
		move(x: X, y: Y)
	}
	
	private func translator(x: Any?, y: Any?, considersSafeAreaFrom view: UIView?) {
		guard let superview = superview else { error.regarding(self, explanation: "Could not move view because there is no reference to a superview."); return }
		
		func translate(_ point: Any) -> CGFloat {
			if let point = point as? origins {
				var padding: CGFloat = 0
				var safeArea: CGFloat = 0
				
				switch point {
				case .top, .topMinusPadding:
					if point == .topMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.top
						} else { printErrorForPadding() }
					}
					if let view = view {
						if #available(iOS 11.0, *) {
							safeArea = view.safeAreaInsets.top
						}
					}
					return 0 + padding + safeArea
				
				case .middle:
					return (superview.bounds.height - bounds.height) / 2
				
				case .bottom, .bottomMinusPadding:
					if point == .bottomMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.bottom
						} else { printErrorForPadding() }
					}
					if let view = view {
						if #available(iOS 11.0, *) {
							safeArea = view.safeAreaInsets.bottom
						}
					}
					return superview.bounds.height - bounds.height - padding - safeArea
				
				case .left, .leftMinusPadding:
					if point == .leftMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.left
						} else { printErrorForPadding() }
					}
					return 0 + padding
				
				case .center:
					return (superview.bounds.width - bounds.width) / 2
				
				case .right, .rightMinusPadding:
					if point == .rightMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.right
						} else { printErrorForPadding() }
					}
					return superview.bounds.width - bounds.width - padding
				
				default:
					return 0
				}
			}
			
			else if let point = point as? CGFloat { return point }
			else if let point = point as? Double { return CGFloat(point) }
			else if let point = point as? Int { return CGFloat(point) }
			
			else {
				error.regarding(self, explanation: "Could not move view to expected point because one or more of the parameters were not of type UIView.origins, CGFloat, Double, or Int.")
				return 0
			}
		}
		
		var X = frame.origin.x
		var Y = frame.origin.y
		
		if let x = x { X = translate(x) }
		if let y = y { Y = translate(y) }
		
		frame.origin = CGPoint(x: X, y: Y)
		updateShadowFrame()
	}
}




// Framework for Resizing Views

public enum boundingAreas {
	case width
	case widthMinusPadding
	case height
	case heightMinusPadding
}

extension CGSize {
	public static var aspect: CGSize { return CGSize() }
	public enum aspectRatios {
		case standard
		case wide
		case square
		case tall
	}
	public func height(_ aspectRatio: aspectRatios, fromWidth value: CGFloat) -> CGFloat {
		let width: CGFloat
		let height: CGFloat
		switch aspectRatio {
		case .standard:
			width = 4
			height = 3
			break
		case .wide:
			width = 16
			height = 9
			break
		case .square:
			width = 1
			height = 1
			break
		case .tall:
			width = 7
			height = 5
			break
		}
		return (value * height) / width
	}
}

extension UIView {
	
	public func resize(width: Any?, height: Any?) {
		resizer(width: width, height: height, considersSafeAreaFrom: nil)
	}
	
	public func resize(width: Any?, height: Any?, considersSafeAreaFrom view: UIView) {
		resizer(width: width, height: height, considersSafeAreaFrom: view)
	}
	
	public func resize(addToWidth width: CGFloat?, addToHeight height: CGFloat?) {
		var WIDTH: CGFloat = 0
		var HEIGHT: CGFloat = 0
		if let width = width { WIDTH += width }
		if let height = height { HEIGHT += height }
		
		resize(width: frame.width + WIDTH, height: frame.height + HEIGHT)
		updateShadowFrame()
	}
	
	public func resize(toFit view: UIView) {
		frame.size = view.frame.size
		updateShadowFrame()
	}
	
	private func resizer(width: Any?, height: Any?, considersSafeAreaFrom view: UIView?) {
		
		func transform(_ length: Any) -> CGFloat {
			if let length = length as? boundingAreas {
				guard let superview = superview else { error.regarding(self, explanation: "Could not resize view because there was no reference to a superview."); return 0 }
				
				var padding: CGFloat = 0
				var safeArea: CGFloat = 0
				
				switch length {
				case .width, .widthMinusPadding:
					if length == .widthMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.left + paddingInsets.right
						} else { printErrorForPadding() }
					}
					
					if let view = view { if #available(iOS 11.0, *) { safeArea = view.safeAreaInsets.left + view.safeAreaInsets.right } }
					return superview.bounds.width - padding - safeArea
				
				case .height, .heightMinusPadding:
					if length == .heightMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.top + paddingInsets.bottom
						} else { printErrorForPadding() }
					}
					
					if let view = view { if #available(iOS 11.0, *) { safeArea = view.safeAreaInsets.top + view.safeAreaInsets.bottom } }
					return superview.bounds.height - padding - safeArea
				}
			}
			
			else if let length = length as? CGFloat { return length }
			else if let length = length as? Double { return CGFloat(length) }
			else if let length = length as? Int { return CGFloat(length) }
			
			else {
				error.regarding(self, explanation: "Could not resize view to expected size because one or more of the parameters were not of type UIView.boundingAreas, CGFloat, Double, or Int.")
				return 0
			}
		}
		
		var WIDTH = frame.size.width
		var HEIGHT = frame.size.height
		
		if let width = width { WIDTH = transform(width) }
		if let height = height { HEIGHT = transform(height) }
		
		frame.size = CGSize(width: WIDTH, height: HEIGHT)
		updateShadowFrame()
	}
}




// Framework for Padding Views

public struct padding {
	public static var extraSmall: CGFloat { return 4 }
	public static var small: CGFloat { return 8 }
	public static var medium: CGFloat { return 16 }
	public static var large: CGFloat { return 24 }
	public static var extraLarge: CGFloat { return 34 }
}

extension UIView {
	public func addPadding(allAround value: CGFloat) {
		paddingInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
	}
	
	public func addPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
		paddingInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
	
	public func boundingArea(_ length: boundingAreas) -> CGFloat {
		switch length {
		case .width:
			return frame.width
		case .widthMinusPadding:
			var padding: CGFloat = 0
			if let paddingInsets = paddingInsets { padding += paddingInsets.left + paddingInsets.right }
			return frame.width - padding
		case .height:
			return frame.height
		case .heightMinusPadding:
			var padding: CGFloat = 0
			if let paddingInsets = paddingInsets { padding += paddingInsets.left + paddingInsets.right }
			return frame.height - padding
		}
	}
	
	private func printErrorForPadding() {
		error.regarding(self, explanation: "Could not resize view to expected size because the referenced superview did not have any set padding insets.")
	}
}

extension UIView {
	public static func updateConstraints(in delegate: UIView, _ performUpdate: () -> ()) {
		delegate.layoutIfNeeded()
		performUpdate()
		delegate.layoutIfNeeded()
	}
	
	public static func updateConstraints(in delegate: UIView, _ performUpdate: () -> (), animatedWithDuration duration: TimeInterval, delay: TimeInterval, usingSpringWithDamping: CGFloat, initialSpringVelocity: CGFloat, options: UIViewAnimationOptions, completion: (() -> ())?) {
		
		delegate.layoutIfNeeded()
		performUpdate()
		
		UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: {
			delegate.layoutIfNeeded()
		}) { (_) in
			if let completion = completion {
				completion()
			}
		}
	}
}
