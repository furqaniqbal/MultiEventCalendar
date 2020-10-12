//
//  Event.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 30/12/2017.
//  Copyright © 2017 Sports Analytics. All rights reserved.
//

import Foundation
import UIKit

class Event {
    let id: String
    let fromDate: Date
    let toDate: Date
    let isSingleDayEvent: Bool
    
    var color: UIColor?
    var position: Int?
    init(id:String, fromDate: String, toDate: String) {
        self.id = id
        let formatter = DateFormatter()
        formatter.dateFormat = Const.Strings.dateFormat
        formatter.timeZone = TimeZone(abbreviation: Const.Strings.timeZone)
        
        self.fromDate = formatter.date(from: fromDate)!
        self.toDate = formatter.date(from: toDate)!
        
        isSingleDayEvent = (fromDate == toDate)
    }
    
    func contains(date: Date) -> Bool {
        return (fromDate.compare(date) == .orderedAscending
        || fromDate.compare(date) == .orderedSame) &&
            (toDate.compare(date) == .orderedDescending
            || toDate.compare(date) == .orderedSame)
    }
}
