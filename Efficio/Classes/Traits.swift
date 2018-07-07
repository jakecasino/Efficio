//
//  Traits.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

import UIKit

public enum corners {
	case extraSmall
	case small
	case medium
	case large
	case extraLarge
	case roundByWidth
	case roundByHeight
}

extension UIView {
	public enum Traits {
		case backgroundColor
		case corners
		case maskContent
		case opacity
	}
	
	public func style(_ view: UIView,_ traits: [Traits: Any]) {
		func error(for TRAIT: Traits) {
			let trait: String
			let expectedType: String
			
			switch TRAIT {
			case .backgroundColor:
				trait = "background color"
				expectedType = "UIColor"
				break
			case .corners:
				trait = "corner radius"
				expectedType = "Int"
				break
			case .maskContent:
				trait = "mask"
				expectedType = "Bool"
			case .opacity:
				trait = "opacity"
				expectedType = "CGFloat"
			}
			
			Error(for: view, if: { () -> (Bool) in true }, explanation: "Could not set \(trait) because provided value was not of type \(expectedType).")
		}
		
		for trait in traits {
			switch trait.key {
				
			case .backgroundColor:
				guard let color = (trait.value as? UIColor) else { error(for: trait.key); break }
				view.backgroundColor = color
				
			case .corners:
				func error(for value: corners) {
					Error(for: view, if: { () -> (Bool) in true }, explanation: "Corners could not \(value) because value was less than zero.")
				}
				if let value = trait.value as? corners {
					switch value {
					case .extraSmall:
						view.layer.cornerRadius = 2
						break
					case .small:
						view.layer.cornerRadius = 4
						break
					case .medium:
						view.layer.cornerRadius = 8
						break
					case .large:
						view.layer.cornerRadius = 12
						break
					case .extraLarge:
						view.layer.cornerRadius = 18
						break
					case .roundByWidth:
						guard view.frame.width > 0 else { error(for: value); break }
						view.layer.cornerRadius = (view.bounds.width / 2)
						break
					case .roundByHeight:
						guard view.frame.height > 0 else { error(for: value); break }
						view.layer.cornerRadius = (view.bounds.height / 2)
						break
					}
				}
				
				else if let value = trait.value as? CGFloat { view.layer.cornerRadius = value }
				else if let value = trait.value as? Double { view.layer.cornerRadius = CGFloat(value) }
				else if let value = trait.value as? Int { view.layer.cornerRadius = CGFloat(value) }
				else { error(for: trait.key) }
				
			case .maskContent:
				guard let value = (trait.value as? Bool) else { error(for: trait.key); break }
				view.layer.masksToBounds = value
				
			case .opacity:
				guard let value = (trait.value as? Double) else { error(for: trait.key); break }
				view.alpha = CGFloat(value)
			}
		}
	}
}

extension UIViewController {
	private static var traitsApplicator: UIView { return UIView() }
	public func style(_ view: UIView,_ traits: [UIView.Traits: Any]) {
		UIViewController.traitsApplicator.style(view, traits)
	}
}

extension UIView {
	private static var associationKey_shadow: UInt8 = 1
	private var shadow: Shadow? {
		get {
			return objc_getAssociatedObject(self, &UIView.associationKey_shadow) as? Shadow
		}
		set(newValue) {
			objc_setAssociatedObject(self, &UIView.associationKey_shadow, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	public func dropShadow(opacity: Float, x: CGFloat, y: CGFloat, spread: CGFloat) {
		guard let superview = superview else {
			Error(for: self, if: { () -> (Bool) in true }, explanation: "Could not resize view because there was no reference to a superview.")
			return
		}
		
		shadow = Shadow(linkTo: self, addTo: superview, opacity: opacity, x: x, y: y, spread: spread)
		shadow!.layer.cornerRadius = layer.cornerRadius
	}
	
	func updateShadowFrame() {
		if let shadow = shadow { shadow.matchFrame(to: self) }
	}
	
	private class Shadow: UIView {
		fileprivate convenience init(linkTo linkedView: UIView, addTo superview: UIView, opacity: Float, x: CGFloat, y: CGFloat, spread: CGFloat) {
			self.init(frame: CGRect.zero)
			superview.insertSubview(self, belowSubview: linkedView)
			matchFrame(to: linkedView)
			
			style(self, [.backgroundColor: UIColor.white, .maskContent: false])
			layer.shadowColor = UIColor.black.cgColor
			layer.shadowRadius = spread
			layer.shadowOffset = CGSize(width: x, height: y)
			layer.shadowOpacity = opacity
		}
	}
}
