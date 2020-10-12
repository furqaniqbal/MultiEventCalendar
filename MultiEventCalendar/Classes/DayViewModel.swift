//
//  DayViewModel.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 02/01/18.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

import Foundation

class DayViewModel {
    /**
     Positions in the Day View
     */
    var event1: MultiEvent?
    var event2: MultiEvent?
    var event3: MultiEvent?
    
    var isEvent1StartDay = false
    var isEvent1EndDay = false
    
    var isEvent2StartDay = false
    var isEvent2EndDay = false
    
    var isEvent3StartDay = false
    var isEvent3EndDay = false
    
    var date: Date
    
    /**
     Sorted array of Events
     */
    var events = [MultiEvent]()
    
    init(date: Date) {
        self.date = date
    }
}
