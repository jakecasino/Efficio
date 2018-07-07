//
//  Views.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/5/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

import UIKit

extension UIView {
	public func matchFrame(to view: Any) {
		if let view = view as? UIView {
			frame = view.frame
		} else if let rect = view as? CGRect {
			frame.origin = rect.origin
			frame.size = rect.size
		} else {
			Error(for: self, if: { () -> (Bool) in
				true
			}, explanation: "Could not match view's frame because the input view was not of type UIView or CGRect.")
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
}

extension UIView {
	private static var associationKey_padding: UInt8 = 0
	private var paddingInsets: UIEdgeInsets? {
		get {
			return objc_getAssociatedObject(self, &UIView.associationKey_padding) as? UIEdgeInsets
		}
		set(newValue) {
			objc_setAssociatedObject(self, &UIView.associationKey_padding, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	public convenience init(addTo view: UIView) {
		self.init(frame: CGRect.zero)
		view.addSubview(self)
	}
	
	public func move(x: Any?, y: Any?) {
		translator(x: x, y: y, considersSafeAreaFrom: nil)
	}
	
	public func move(x: Any?, y: Any?, considersSafeAreaFrom view: UIView) {
		translator(x: x, y: y, considersSafeAreaFrom: view)
	}
	
	public func move(toMatch view: UIView) {
		frame.origin = view.frame.origin
		updateShadowFrame()
	}
	
	private func translator(x: Any?, y: Any?, considersSafeAreaFrom view: UIView?) {
		guard let superview = superview else { Error(for: self, if: { () -> (Bool) in true }, explanation: "Could not move view because there is no reference to a superview."); return }
		
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
					if let view = view { safeArea = view.safeAreaInsets.top }
					return 0 + padding + safeArea
				
				case .middle:
					return (superview.bounds.height - bounds.height) / 2
				
				case .bottom, .bottomMinusPadding:
					if point == .bottomMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.bottom
						} else { printErrorForPadding() }
					}
					if let view = view { safeArea = view.safeAreaInsets.bottom }
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
				}
			}
			
			else if let point = point as? CGFloat { return point }
			else if let point = point as? Double { return CGFloat(point) }
			else if let point = point as? Int { return CGFloat(point) }
			
			else {
				Error(for: self, if: { () -> (Bool) in true }, explanation: "Could not move view to expected point because one or more of the parameters were not of type UIView.origins, CGFloat, Double, or Int.")
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

extension UIView {
	public func resize(width: Any?, height: Any?) {
		resizer(width: width, height: height, considersSafeAreaFrom: nil)
	}
	
	public func resize(width: Any?, height: Any?, considersSafeAreaFrom view: UIView) {
		resizer(width: width, height: height, considersSafeAreaFrom: view)
	}
	
	public func resize(toFit view: UIView) {
		frame.size = view.frame.size
		updateShadowFrame()
	}
	
	private func resizer(width: Any?, height: Any?, considersSafeAreaFrom view: UIView?) {
		guard let superview = superview else { Error(for: self, if: { () -> (Bool) in true }, explanation: "Could not resize view because there was no reference to a superview."); return }
		
		func transform(_ length: Any) -> CGFloat {
			if let length = length as? boundingAreas {
				var padding: CGFloat = 0
				var safeArea: CGFloat = 0
				
				switch length {
				case .width, .widthMinusPadding:
					if length == .widthMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.left + paddingInsets.right
						} else { printErrorForPadding() }
					}
					
					if let view = view { safeArea = view.safeAreaInsets.left + view.safeAreaInsets.right }
					return superview.bounds.width - padding - safeArea
				
				case .height, .heightMinusPadding:
					if length == .heightMinusPadding {
						if let paddingInsets = superview.paddingInsets {
							padding = paddingInsets.top + paddingInsets.bottom
						} else { printErrorForPadding() }
					}
					
					if let view = view { safeArea = view.safeAreaInsets.top + view.safeAreaInsets.bottom }
					return superview.bounds.height - padding - safeArea
				}
			}
			
			else if let length = length as? CGFloat { return length }
			else if let length = length as? Double { return CGFloat(length) }
			else if let length = length as? Int { return CGFloat(length) }
			
			else {
				Error(for: self, if: { () -> (Bool) in true }, explanation: "Could not resize view to expected size because one or more of the parameters were not of type UIView.boundingAreas, CGFloat, Double, or Int.")
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
	public func padding(allAround value: CGFloat) {
		paddingInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
	}
	
	public func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
		paddingInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
	
	private func printErrorForPadding() {
		Error(for: self, if: { () -> (Bool) in true }, explanation: "Could not resize view to expected size because the referenced superview did not have any set padding insets.")
	}
}