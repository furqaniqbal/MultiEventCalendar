//
//  UIView.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 08/01/18.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = path.cgPath
        
        maskLayer2.shadowRadius = 5
        maskLayer2.shadowOpacity = 0.5
        maskLayer2.shadowColor = tintColor?.cgColor
        maskLayer2.fillColor = tintColor?.cgColor
        maskLayer2.shadowOffset = CGSize(width: 0, height: 1)
        
        return maskLayer2
    }
}
