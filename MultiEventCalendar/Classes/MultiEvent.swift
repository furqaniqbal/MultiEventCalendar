//
//  MultiEvent.swift
//  MultiEventCalendar
//
//  Created by Zoltán Koós on 08/05/2018.
//

import Foundation
import UIKit

@objc public protocol MultiEvent : class, NSObjectProtocol {
    @objc var theStartDate: Date {get set}
    @objc var theEndDate: Date {get set}
    @objc var uiColor: UIColor {get set}
    @objc var calendarId: String {get set}
    @objc var position: NSNumber? {get set}
    
    func isSingleDayEvent() -> Bool
}
