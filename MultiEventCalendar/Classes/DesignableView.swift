//
//  TLDesignableView.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 09/01/18.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

import UIKit

@IBDesignable class TLDesignableView: UIView {
    @IBInspectable var borderColor: UIColor = UIColor() {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = CGFloat() {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = CGFloat() {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
