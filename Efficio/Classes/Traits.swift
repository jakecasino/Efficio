//
//  Traits.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

import UIKit

// Add Error Handling Protocol
extension UIView: ErrorHandling { }

// Traits Library
extension UIView {
	public enum traits {
		case backgroundColor
		case cornerRadius
		case masksToBounds
		case opacity
	}
	
	public enum roundedCorners {
		case width
		case height
	}
	
	public func style(_ view: UIView,_ traits: [traits: Any]) {
		func ErrorFor(_ TRAIT: traits) {
			let trait: String
			let expectedType: String
			
			switch TRAIT {
			case .backgroundColor:
				trait = "background color"
				expectedType = "UIColor"
				break
			case .cornerRadius:
				trait = "corner radius"
				expectedType = "Int"
				break
			case .masksToBounds:
				trait = "mask"
				expectedType = "Bool"
			case .opacity:
				trait = "opacity"
				expectedType = "CGFloat"
			}
			
			let errorMessage = "Could not set \(trait) because provided value was not of type \(expectedType)."
			Error(regarding: view, if: { () -> (Bool) in
				true
			}, explanation: errorMessage)
		}
		
		for trait in traits {
			switch trait.key {
			
			case .backgroundColor:
				if let color = trait.value as? UIColor {
					view.backgroundColor = color
				} else { ErrorFor(trait.key) }
			
			case .cornerRadius:
				func ErrorFor(_ value: roundedCorners) {
					Error(regarding: view, if: { () -> (Bool) in
						true
					}, explanation: "Could not round corners based on \(value) because \(value) is less than zero.")
				}
				if let value = trait.value as? roundedCorners {
					var radius: CGFloat = 0
					switch value {
					case .width:
						if view.frame.width > 0 {
							radius = view.frame.width
						} else { ErrorFor(value) }
						break
					case .height:
						if view.frame.height > 0 {
							radius = view.frame.height
						} else { ErrorFor(value) }
						break
					}
					view.layer.cornerRadius = radius
				} else if let value = trait.value as? (() -> (CGFloat)) {
					view.layer.cornerRadius = value()
				} else if let value = trait.value as? CGFloat {
					view.layer.cornerRadius = value
				} else if let value = trait.value as? Int {
					view.layer.cornerRadius = CGFloat(value)
				} else { ErrorFor(trait.key) }
			
			case .masksToBounds:
				if let value = trait.value as? Bool {
					view.layer.masksToBounds = value
				} else {
					ErrorFor(trait.key)
				}
			
			case .opacity:
				if let value = trait.value as? Double {
					view.alpha = CGFloat(value)
				} else {
					ErrorFor(trait.key)
				}
			}
		}
	}
}
