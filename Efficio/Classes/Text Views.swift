//
//  Text Views.swift
//  Efficio
//
//  Created by Jake Casino on 8/3/18.
//

@IBDesignable open class UITextViewElement: UITextView {
	@IBInspectable public var cornerRadius: CGFloat = 0 {
		didSet { layer.cornerRadius = cornerRadius }
	}
	
	@IBInspectable public var borderWidth: CGFloat = 0 {
		didSet { layer.borderWidth = borderWidth }
	}
	
	@IBInspectable public var borderColor: UIColor = UIColor.clear {
		didSet { layer.borderColor = borderColor.cgColor }
	}
	
	@IBInspectable public var contentInsets: String = "0, 0, 0, 0" {
		didSet {
			var values = [CGFloat]()
			for value in contentInsets.components(separatedBy: ", ") {
				values.append(CGFloat(Double(value)!))
			}
			
			textContainerInset = UIEdgeInsets(top: values[0], left: values[1], bottom: values[2], right: values[3])
		}
	}
}
