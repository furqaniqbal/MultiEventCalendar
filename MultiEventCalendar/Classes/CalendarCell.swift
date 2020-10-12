//
//  CalendarCell.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 30/12/2017.
//  Copyright © 2017 Sports Analytics. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    @IBOutlet var dateTitle: UILabel!
    
    @IBOutlet weak var borderView: TLDesignableView!
    @IBOutlet var constraintStrap1LabelLeading: NSLayoutConstraint!
    @IBOutlet var constraintStrap2LabelLeading: NSLayoutConstraint!
    @IBOutlet var constraintStrap3LabelLeading: NSLayoutConstraint!
    
    @IBOutlet var constraintStrap1LabelTrailing: NSLayoutConstraint!
    @IBOutlet var constraintStrap2LabelTrailing: NSLayoutConstraint!
    @IBOutlet var constraintStrap3LabelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var viewStrapEvent1: EventView!
    @IBOutlet weak var viewStrapEvent2: EventView!
    @IBOutlet weak var viewStrapEvent3: EventView!
    
    var isToday: Bool = false {
        didSet {
            if isToday {
                dateTitle?.textColor = .red
            } else {
                dateTitle?.textColor = .black
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewStrapEvent1.configure(tintColor: nil)
        viewStrapEvent2.configure(tintColor: nil)
        viewStrapEvent3.configure(tintColor: nil)
    }
    
    @objc override func updateUI() {
        borderView.isHidden = !isSelected
    }
}


extension JTAppleCell {
    
    override open var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    @objc func updateUI() {
        
    }
}
