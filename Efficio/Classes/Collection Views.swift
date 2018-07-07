//
//  Collection Views.swift
//  Efficio
//
//  Created by Jake Casino on 7/6/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

import Foundation

extension UICollectionViewFlowLayout {
	public func addPadding(allAround value: CGFloat) {
		sectionInset = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
	}
	
	public func addPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
		sectionInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
	}
}
