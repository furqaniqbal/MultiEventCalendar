//
//  MultiEventCalendarViewController.swift
//  MultiEventCalendar
//
//  Created by Miroslav Kutak on 30/12/2017.
//  Copyright © 2017 Sports Analytics. All rights reserved.
//

import UIKit
import JTAppleCalendar

@objc public protocol MultiEventCalendarDateSelectionDelegate : class {
    @objc func didSelectDate(_ date: Date)
    @objc func refreshContentForDate(_ date: Date)
}

@objc public class MultiEventCalendarViewController: UIViewController {
    
    @objc public var delegate: MultiEventCalendarDateSelectionDelegate?
    @IBOutlet public weak var monthLabel: UILabel?
    
    @objc public class func instantiate(calendarView: JTAppleCalendarView, weekDaysCollectionView: UICollectionView) -> MultiEventCalendarViewController {
        let vc = MultiEventCalendarViewController()
        vc.calendarCollectionView = calendarView
        vc.weekDaysCollectionView = weekDaysCollectionView
        
        calendarView.calendarDataSource = vc
        calendarView.calendarDelegate = vc
        
        weekDaysCollectionView.delegate = vc
        weekDaysCollectionView.dataSource = vc
        
        vc.generateViewModelForMonth()
        
        return vc
    }
    
    @IBOutlet public weak var calendarCollectionView: JTAppleCalendarView!
    @IBOutlet weak var weekDaysCollectionView: UICollectionView!
    
    let formatter = DateFormatter()
    var todayDateString = String()
    var lastSelectedDate: Date?
    
    fileprivate var arrDayViewModels: [DayViewModel] = [] {
        didSet {
            print("Count: \(arrDayViewModels.count)")
        }
    }
    
    private var events : NSArray = []
    
    /**
     
     */
    @objc public func configure(events: NSArray) {
        self.events = events
        generateViewModelForMonth()
    }
    
    /**
     Take the events array
     Generate the dayViewModel array
        - define the event1,2 and 3 (positions)
        - if the event doesn't have a color, assign the color
     Configure the individual cells according to DayViewModel
     */
    @objc func generateViewModelForMonth() {
        let sortedEventsByDate = events.sorted { (aa, bb) -> Bool in
            if let a = aa as? MultiEvent, let b = bb as? MultiEvent {
                return a.theStartDate.compare(b.theStartDate) == .orderedAscending
            }
            return false
        }
        
        arrDayViewModels = EventMapper.shared.mapEvents(events: sortedEventsByDate as NSArray)
        calendarCollectionView.reloadData()
    }
    
    @objc public func setup() {
        arrDayViewModels = []
        generateViewModelForMonth()
//        updateMonthLabel()
        
        calendarCollectionView.scrollToHeaderForDate(Date())
//        self.updateMonthLabel()
        lastSelectedDate = formatter.date(from: todayDateString)
        delegate?.didSelectDate(lastSelectedDate ?? Date())
        calendarCollectionView.reloadData()
        weekDaysCollectionView.reloadData()
        
        updateMonthLabel()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension MultiEventCalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    public func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let timeZone = TimeZone(secondsFromGMT: 0)
        var calendar = Calendar.current
        calendar.timeZone = timeZone!
        
        formatter.dateFormat = Const.Strings.dateFormat
        formatter.timeZone = timeZone
        
        let now = Date()
        let startDate = now.addingTimeInterval(365 * 24 * 3600 * -10)
        let endDate = now.addingTimeInterval(365 * 24 * 3600 * 10)
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate, calendar: calendar)
        todayDateString = formatter.string(from: Date())
        
        return parameters
    }
    
    
    func configureVisibleCell(myCustomCell: CalendarCell, cellState: CellState, date: Date) {
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.isHidden = false
        } else {
            myCustomCell.isHidden = true
            return
        }
        /* // Bring back the out of this month dates if needed
        switch cellState.dateBelongsTo {
        case .thisMonth:
            myCustomCell.dateTitle.textColor = .black
        default:
            myCustomCell.dateTitle.textColor = UIColor(white: 0.0, alpha: 0.5)
        }*/
        
        //print("Count: \(arrDayViewModels.count)")
        myCustomCell.dateTitle.text = cellState.text
        
        myCustomCell.isToday = (formatter.string(from: date) == todayDateString)
        myCustomCell.isSelected = calendarCollectionView.selectedDates.contains(date)
        
        let dateString = "\(date.year)/\(date.month)/\(date.day)"
        let currentDayViewModel = arrDayViewModels.filter { (dayViewModel) -> Bool in
            let dayViewModelDateString = "\(dayViewModel.date.year)/\(dayViewModel.date.month)/\(dayViewModel.date.day)"
            //print("ViewModelDate: \(dayViewModelDateString)\tCurrentDate:\(dateString)")
            return dayViewModelDateString == dateString
        }
        
        guard let currentDayViewModelObj = currentDayViewModel.first else {
            return
        }
        
        myCustomCell.viewStrapEvent1.configure(tintColor: currentDayViewModelObj.event1?.uiColor)
        myCustomCell.viewStrapEvent2.configure(tintColor: currentDayViewModelObj.event2?.uiColor)
        myCustomCell.viewStrapEvent3.configure(tintColor: currentDayViewModelObj.event3?.uiColor)
        
        myCustomCell.constraintStrap1LabelLeading.isActive = currentDayViewModelObj.isEvent1StartDay
        myCustomCell.constraintStrap1LabelTrailing.isActive = currentDayViewModelObj.isEvent1EndDay

        myCustomCell.constraintStrap2LabelLeading.isActive = currentDayViewModelObj.isEvent2StartDay
        myCustomCell.constraintStrap2LabelTrailing.isActive = currentDayViewModelObj.isEvent2EndDay

        myCustomCell.constraintStrap3LabelLeading.isActive = currentDayViewModelObj.isEvent3StartDay
        myCustomCell.constraintStrap3LabelTrailing.isActive = currentDayViewModelObj.isEvent3EndDay
        
        //If single day event -> set both corner radius
        if currentDayViewModelObj.event1?.isSingleDayEvent() ?? false {
            myCustomCell.viewStrapEvent1.setupCornerRadius(cornerRadiusType: .both)
        
        //Else multi days event -> set single corner radius
        } else {
            if currentDayViewModelObj.isEvent1StartDay {
                myCustomCell.viewStrapEvent1.setupCornerRadius(cornerRadiusType: .left)
            } else if currentDayViewModelObj.isEvent1EndDay {
                myCustomCell.viewStrapEvent1.setupCornerRadius(cornerRadiusType: .right)
            } else {
                myCustomCell.viewStrapEvent1.setupCornerRadius(cornerRadiusType: nil)
            }
        }
        
        if currentDayViewModelObj.event2?.isSingleDayEvent() ?? false {
            myCustomCell.viewStrapEvent2.setupCornerRadius(cornerRadiusType: .both)
        } else {
            if currentDayViewModelObj.isEvent2StartDay {
                myCustomCell.viewStrapEvent2.setupCornerRadius(cornerRadiusType: .left)
            } else if currentDayViewModelObj.isEvent2EndDay {
                myCustomCell.viewStrapEvent2.setupCornerRadius(cornerRadiusType: .right)
            } else {
                myCustomCell.viewStrapEvent2.setupCornerRadius(cornerRadiusType: nil)
            }
        }
        
        if currentDayViewModelObj.event3?.isSingleDayEvent() ?? false {
            myCustomCell.viewStrapEvent3.setupCornerRadius(cornerRadiusType: .both)
        } else {
            if currentDayViewModelObj.isEvent3StartDay {
                myCustomCell.viewStrapEvent3.setupCornerRadius(cornerRadiusType: .left)
            } else if currentDayViewModelObj.isEvent3EndDay {
                myCustomCell.viewStrapEvent3.setupCornerRadius(cornerRadiusType: .right)
            } else {
                myCustomCell.viewStrapEvent3.setupCornerRadius(cornerRadiusType: nil)
            }
        }
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let lastSelectedDateObj = lastSelectedDate {
            calendar.deselect(dates: [lastSelectedDateObj])
        }
        
        lastSelectedDate = date
        
        delegate?.didSelectDate(date)
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateMonthLabel()
        
        if let someDateThisMonth = calendar.someDateThisMonth() {
            delegate?.refreshContentForDate(someDateThisMonth)
        }
    }
    
    @objc public func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        let dates = calendarCollectionView.visibleDates().monthDates
        if dates.count > 0 {
            let index = dates.count / 2
            let date = calendarCollectionView.visibleDates().monthDates[index].date
            monthLabel?.text = formatter.string(from: date)
        } else {
            monthLabel?.text = nil
        }
    }

    public func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 1.0)
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        calendar.register(JTAppleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "JTAppleCollectionReusableView")
        let view =  calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "JTAppleCollectionReusableView", for: indexPath)
        return view
    }
}

extension MultiEventCalendarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let weekDaysCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cells.weekDaysCell, for: indexPath) as! WeekDaysCell
        var components = DateComponents()
        let calendar = Calendar.current
        components.year = 2006
        components.day = indexPath.row + calendar.firstWeekday
        
        let f = DateFormatter()
        f.dateFormat = "EEE" // short day style, "Sun", there are more available
        let d = calendar.date(from: components)
        let dayName = f.string(from: d!)
        
        
        weekDaysCell.dayLabel.text = dayName.uppercased()
        return weekDaysCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        return CGSize(width: collectionViewSize.width/7, height: collectionViewSize.height)
    }
}

//MARK: - Actions
extension MultiEventCalendarViewController {
    
    @IBAction func previousMonthTapped (_ sender: UIButton) {
        calendarCollectionView.scrollToPreviousMonth {
            if let date = self.calendarCollectionView.someDateThisMonth() {
                self.delegate?.refreshContentForDate(date)
            }
        }
    }
    
    @IBAction func nextMonthTapped (_ sender: UIButton) {
        calendarCollectionView.scrollToNextMonth {
            
            if let date = self.calendarCollectionView.someDateThisMonth() {
                self.delegate?.refreshContentForDate(date)
            }
        }
    }
}

public extension JTAppleCalendarView {
    
    @objc public func firstDayOfTheCurrentMonth() -> Date? {
        if let firstDateOfTheVisibleMonth = visibleDates().monthDates.first?.date {
            return firstDateOfTheVisibleMonth
        }
        return nil
    }
    
    @objc public func someDateThisMonth() -> Date? {
        return firstDayOfTheCurrentMonth()?.addingTimeInterval(24 * 3600 * 15)
    }
    
    @objc public func scrollToPreviousMonth(completion: (()->Void)? = nil) {
        if let firstDateOfTheVisibleMonth = visibleDates().monthDates.first?.date {
            let someDatePreviousMonth = firstDateOfTheVisibleMonth.addingTimeInterval(-24 * 3600 * 15)
            scrollToHeaderForDate(someDatePreviousMonth, withAnimation: true, completionHandler: {
                completion?()
            })
        } else {
            completion?()
        }
    }
    
    @objc public func scrollToNextMonth(completion: (()->Void)? = nil) {
        if let lastDateOfTheVisibleMonth = visibleDates().monthDates.last?.date {
            let someDateNextMonth = lastDateOfTheVisibleMonth.addingTimeInterval(24 * 3600 * 15)
            scrollToHeaderForDate(someDateNextMonth, withAnimation: true, completionHandler: {
                completion?()
            })
        } else {
            completion?()
        }
    }
    
}


