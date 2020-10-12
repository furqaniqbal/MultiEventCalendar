//
//  EventView.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 08/01/18.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

import UIKit

enum CornerRadiusType {
    case right
    case left
    case both
}

class EventView: UIView {
    var cornerRadiusType:CornerRadiusType?
    var previousCornerRadiusType:CornerRadiusType?
    var bezierPathLayer : CAShapeLayer?
    
    
    func configure(tintColor: UIColor?) {
        self.tintColor = tintColor
        
        if tintColor == nil {
            alpha = 0.0
        } else {
            alpha = 1.0
        }
        
        layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        layer.sublayers = []
        //if previousCornerRadiusType != cornerRadiusType || cornerRadiusType == nil {
            var maskLayer2 : CAShapeLayer!
            
            if let cornerRadiusType = cornerRadiusType {
                
                switch cornerRadiusType {
                case .right:
                    maskLayer2 = roundCorners([.topRight, .bottomRight], radius: Const.UI.eventCornerRadius)
                case .left:
                    maskLayer2 = roundCorners([.topLeft, .bottomLeft], radius: Const.UI.eventCornerRadius)
                case .both:
                    maskLayer2 = roundCorners([.topRight, .bottomRight, .topLeft, .bottomLeft], radius: Const.UI.eventCornerRadius)
                }
                
            } else {
                maskLayer2 = roundCorners([.topRight, .bottomRight, .topLeft, .bottomLeft], radius: 0)
            }
            
            bezierPathLayer?.removeFromSuperlayer()
            bezierPathLayer = maskLayer2
            layer.insertSublayer(maskLayer2, at: 0)
            previousCornerRadiusType = cornerRadiusType
        //}
    }
    
    func setupCornerRadius(cornerRadiusType: CornerRadiusType?) {
        self.cornerRadiusType = cornerRadiusType
        layoutSubviews()
    }
}
