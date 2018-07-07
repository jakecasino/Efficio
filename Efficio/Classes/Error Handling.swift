//
//  Error Handling.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

public protocol ErrorHandling { }
extension ErrorHandling {
	public func Error(for item: Any, if problematicSituationOccurs: () -> (Bool), explanation: String) {
		if problematicSituationOccurs() {
			print("ERROR regarding \(Unmanaged.passUnretained(item as AnyObject).toOpaque()) of type '\(type(of: item))' [\(explanation)]")
		}
	}
}

extension UIViewController: ErrorHandling { }
extension UIView: ErrorHandling { }
extension UIColor: ErrorHandling { }
