//
//  ViewController.swift
//  MultiEventCalendar
//
//  Created by Quang Truong Tuan on 10/12/2020.
//  Copyright (c) 2020 Quang Truong Tuan. All rights reserved.
//

import UIKit
import MultiEventCalendar
import JTAppleCalendar

class DemoEvent: NSObject, MultiEvent {
    var theStartDate: Date = Date()
    var theEndDate: Date = Date()
    var uiColor: UIColor = .blue
    var calendarId: String = "1"
    var position: NSNumber? = nil

    init(calendarId: String, uiColor: UIColor, position: NSNumber, theStartDate: Date = Date(), thEndDate: Date = Date()) {
        self.uiColor = uiColor
        self.calendarId = calendarId
        self.position = position
        self.theStartDate = theStartDate
        self.theEndDate = thEndDate
    }

    func isSingleDayEvent() -> Bool {
        return false
    }
}

class ViewController: UIViewController {

    // MARK: - IBOulets

    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    @IBOutlet private weak var weekDaysCollectionView: UICollectionView!
    @IBOutlet private weak var currentMonthLabel: UILabel!

    private var multiEventCalendarVC: MultiEventCalendarViewController?
    
    // MARK: - Properties
    
    private var allEvents = [DemoEvent]()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        multiEventCalendarVC?.updateMonthLabel()
    }

    // MARK: - Methods

    private func configViews() {
        multiEventCalendarVC = MultiEventCalendarViewController.instantiate(
            calendarView: calendarView,
            weekDaysCollectionView: weekDaysCollectionView)
        multiEventCalendarVC?.delegate = self
        multiEventCalendarVC?.monthLabel = currentMonthLabel
        multiEventCalendarVC?.setup()
    }

    // Demo Data
    private func configData() {
        let currentDate = Date()
        allEvents = [
            DemoEvent(calendarId: "1", uiColor: .red, position: NSNumber(value: 1), theStartDate: currentDate, thEndDate: currentDate.add(days: 3)),
            DemoEvent(calendarId: "2", uiColor: .green, position: NSNumber(value: 2), theStartDate: currentDate, thEndDate: currentDate.add(days: 6)),
            DemoEvent(calendarId: "3", uiColor: .blue, position: NSNumber(value: 3), theStartDate: currentDate.add(days: 8), thEndDate: currentDate.add(days: 30)),
        ]
        multiEventCalendarVC?.configure(events: NSArray(array: allEvents))
    }

    // MARK: - IBActions

    @IBAction private func nextMonthClicked(_ sender: AnyObject) {
        calendarView.scrollToNextMonth(completion: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.multiEventCalendarVC?.updateMonthLabel()
            strongSelf.refreshContentForDate(strongSelf.calendarView.someDateThisMonth() ?? Date())
        })
    }

    @IBAction private func previousMonthClicked(_ sender: AnyObject) {
        calendarView.scrollToPreviousMonth(completion: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.multiEventCalendarVC?.updateMonthLabel()
            strongSelf.refreshContentForDate(strongSelf.calendarView.someDateThisMonth() ?? Date())
        })
    }
}

// MARK: - MultiEventCalendarDateSelectionDelegate
extension ViewController: MultiEventCalendarDateSelectionDelegate {
    func didSelectDate(_ date: Date) {
        print("didSelectDate: \(date.toString())")
    }

    func refreshContentForDate(_ date: Date) {
        print("refreshContentForDate: \(date.toString())")
    }
}
