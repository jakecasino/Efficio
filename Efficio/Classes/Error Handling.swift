//
//  Error Handling.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

extension Error {
	public static func error(for item: Any, explanation: String) {
		error(when: { () -> (Bool) in
			true
		}, for: item, explanation: explanation)
	}
	
	public static func error(when problematicSituationOccurs: () -> (Bool), for item: Any, explanation: String) {
		if problematicSituationOccurs() {
			print("ERROR regarding \(Unmanaged.passUnretained(item as AnyObject).toOpaque()) of type '\(type(of: item))' [\(explanation)]")
		}
	}
}

extension UIViewController: Error { }
extension UIView: Error { }
extension UIColor: Error { }
