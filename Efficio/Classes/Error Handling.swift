//
//  Error Handling.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//

public protocol ErrorHandling { }
extension ErrorHandling {
	public func Error(regarding item: Any, if problematicSituationOccurs: () -> (Bool), explanation: String) {
		if problematicSituationOccurs() {
			print("ERROR regarding \(Unmanaged.passUnretained(item as AnyObject).toOpaque()) of type '\(type(of: item))' [\(explanation)]")
		}
	}
}
