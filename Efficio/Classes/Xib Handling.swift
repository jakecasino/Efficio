//
//  Xib Handling.swift
//  Efficio
//
//  Created by Jake Casino on 7/20/18.
//

import UIKit

extension UIView {
	public func loadXib(named name: String, view: UIView) {
		Bundle.main.loadNibNamed(name, owner: self, options: nil)
		addSubview(view)
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
}
