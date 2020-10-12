//
//  EventMapper.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 02/01/18.
//  Copyright © 2018 Sports Analytics. All rights reserved.
//

import Foundation
import DateTools

class EventMapper {
    static let shared = EventMapper()
    
    //Mapping event
    func mapEvents(events: NSArray) -> [DayViewModel] {
        
        //Get all the dates for all events
        func getAllDatesForEvents() -> Set<Date> {
            var setAllEventDates = Set<Date>()
            let multiEvents = events as! [MultiEvent]
            for event in multiEvents {
                if event.isSingleDayEvent() {
                    setAllEventDates.insert(event.theStartDate)
                    continue
                }
                let numberOfDaysForEvent = event.theEndDate.interval(ofComponent: .day, fromDate: event.theStartDate)
                guard numberOfDaysForEvent > 0 else { continue }
                for index in 0...numberOfDaysForEvent {
                    let nextDate = event.theStartDate.addingTimeInterval(TimeInterval(60 * 60 * 24 * index))
                    setAllEventDates.insert(nextDate)
                }
            }
            return setAllEventDates
        }
        
        let setAllEventDates = getAllDatesForEvents()
        
        //Sort all the dates Earlier-Later
        let sortedAllEventDates = setAllEventDates.sorted { (date1, date2) -> Bool in
            return date1 < date2
        }

        var arrDayViewModel = [DayViewModel]()
        
        //Loop all the available dates
        for date in sortedAllEventDates {
            //Create dayViewModel with date
            let dayViewModel = DayViewModel(date: date)
            
            //Loop all the events on this date
            let events = events as! [MultiEvent]
            for event in events {
                //Check if any event is on given date
                if date.isBetween(event.theStartDate, and: event.theEndDate) {
                    
                    //Check if this event is already added and initial index set?
                    //If yes, then continue that index, else start from available index
                    if arrDayViewModel.contains(where: { (model) -> Bool in
                        return model.event1?.calendarId == event.calendarId || model.event2?.calendarId == event.calendarId || model.event3?.calendarId == event.calendarId
                    }) {
                        //There is on viewModel having same event id, so choose it's index for upcoming days for same event
                        for viewModel in arrDayViewModel {
                            if viewModel.event1?.calendarId == event.calendarId {
                                event.position = viewModel.event1?.position
                                
                                //Check if isEvent1StartDay
                                if date.isSame(date: event.theStartDate) {
                                    dayViewModel.isEvent1StartDay = true
                                }
                                //Check if isEvent1EndDay
                                if date.isSame(date: event.theEndDate) {
                                    dayViewModel.isEvent1EndDay = true
                                }
                                dayViewModel.event1 = event
                                continue
                            } else if viewModel.event2?.calendarId == event.calendarId {
                                event.position = viewModel.event2?.position
                                
                                //Check if isEvent2StartDay
                                if date.isSame(date: event.theStartDate) {
                                    dayViewModel.isEvent2StartDay = true
                                }
                                //Check if isEvent2EndDay
                                if date.isSame(date: event.theEndDate) {
                                    dayViewModel.isEvent2EndDay = true
                                }
                                dayViewModel.event2 = event
                                continue
                            } else if viewModel.event3?.calendarId == event.calendarId {
                                event.position = viewModel.event3?.position
                                
                                //Check if isEvent3StartDay
                                if date.isSame(date: event.theStartDate) {
                                    dayViewModel.isEvent3StartDay = true
                                }
                                //Check if isEvent3EndDay
                                if date.isSame(date: event.theEndDate) {
                                    dayViewModel.isEvent3EndDay = true
                                }
                                dayViewModel.event3 = event
                                continue
                            } else {

                            }
                        }
                        
                    //New event, not already added. So add to DayViewModel
                    } else {
                        if dayViewModel.event1 == nil {
                            event.position = 1
                            dayViewModel.isEvent1StartDay = true
                            //Check if single day event
                            dayViewModel.isEvent1EndDay = event.isSingleDayEvent()
                            
                            dayViewModel.event1 = event
                            continue
                        }
                        
                        if dayViewModel.event2 == nil {
                            event.position = 2
                            dayViewModel.isEvent2StartDay = true
                            //Check if single day event
                            dayViewModel.isEvent2EndDay = event.isSingleDayEvent()
                            dayViewModel.event2 = event
                            continue
                        }
                        
                        if dayViewModel.event3 == nil {
                            event.position = 3
                            dayViewModel.isEvent3StartDay = true
                            //Check if single day event
                            dayViewModel.isEvent3EndDay = event.isSingleDayEvent()
                            dayViewModel.event3 = event
                            continue
                        }
                    }
                }
            }
            
            arrDayViewModel.append(dayViewModel)
        }
        
        return arrDayViewModel
    }
}
