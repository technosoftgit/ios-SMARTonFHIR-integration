//
//  DateExtension.swift

//
//  Created by Muhammad Luqman on 30/05/2018.
//  Copyright © 2018 Technosoft Solutions. All rights reserved.
//

import Foundation

extension Calendar {
    
    static let gregorian = Calendar(identifier: .iso8601)
}

extension Date {
    
    /** Return advance date by adding hours in given date */
    func add(date: Date, hours: Int) -> Date {
        return Calendar.gregorian.date(byAdding: .hour, value: hours, to: date)!
    }
    
    /** Return advance date by adding minutes in given date */
    func add(date: Date, minutes: Int) -> Date {
        return Calendar.gregorian.date(byAdding: .minute, value: minutes, to: date)!
    }
    
    /** Return advance date by adding seconds in given date */
    func add(date: Date, seconds: Int) -> Date {
        return Calendar.gregorian.date(byAdding: .second, value: seconds, to: date)!
    }
    
    
    var noon: Date {
        return Calendar.gregorian.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var startOfDay: Date {
        
        return Calendar.gregorian.startOfDay(for: self)
    }
    
    var current: Date{
        return Date().startOfDay
    }
    
    var yesterday: Date {
        //Original
        //        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
        return Calendar.gregorian.date(byAdding: .day, value: 0, to: Date().current)!
    }
    
    var tomorrow: Date {
        return Calendar.gregorian.date(byAdding: .day, value: 1, to: Date().current)!
    }
    
    
    var startOfWeek: Date? {
        
        guard let sunday = Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return Calendar.gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Date? {
        
        guard let sunday = Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return Calendar.gregorian.date(byAdding: .day, value: 6, to: sunday)?.endOfDay
    }
    
    
    var endOfDay: Date? {
        
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.gregorian.date(byAdding: components, to: startOfDay)
    }
    
    func getDaysInMonth() -> Int{
        
        let calendar = Calendar.gregorian
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    func startOfMonth() -> Date {
        let date=Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.month, .year], from: Calendar.gregorian.startOfDay(for: self.startOfDay)))!
        return Calendar.gregorian.date(byAdding: .day, value: 0, to: date)!     // Change value 1 to 0
    }
    
    func endOfMonth() -> Date {
        
        return (Calendar.gregorian.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())?.endOfDay)!
    }
    
    
    /**
     Provide next day Date.
     dayBackwardCount decide how much back from current day,
     1, 2, 3 ... day
     */
    func nextDaysDate(date: Date, dayNextCount: Int) -> Date {
        let secondsInDay=86400
        return date.addingTimeInterval(TimeInterval((dayNextCount*secondsInDay)))
    }
    
    /**
     Provide previous day from current Date.
     dayBackwardCount decide how much back from current day,
     1, 2, 3 ... day
     */
    func previousDaysDate(dayBackwardCount: Int) -> Date {
        let secondsInDay=86400
        // Multiply by -1 to move backward
        return Date().addingTimeInterval(TimeInterval(-(dayBackwardCount*secondsInDay)))
    }
    
    /**
     Provide previous day from given Date.
     dayBackwardCount decide how much back from given day,
     1, 2, 3 ... day
     */
    func previousDaysDate(date: Date, dayBackwardCount: Int) -> Date {
        let secondsInDay=86400
        // Multiply by -1 to move backward
        return date.addingTimeInterval(TimeInterval(-(dayBackwardCount*secondsInDay)))
    }
    
    /**
     Provide previous week Start from current Date.
     weekBackwardCount decide how much back from current week,
     1, 2, 3 ... weeks
     */
    func previousWeeksStartDate(weekBackwardCount: Int) -> Date {
        let daysInWeek = 7
        let secondsInWeek=86400*daysInWeek
        
        // Multiply by -1 to move backward
        let previousWeekDate : Date = Date().addingTimeInterval(TimeInterval(-(weekBackwardCount*secondsInWeek)))
        let previousWeekStartDate = (previousWeekDate.startOfWeek?.startOfDay)!
        return previousWeekStartDate
    }
    
    /**
     Provide previous week Start from given Date.
     weekBackwardCount decide how much back from given week,
     1, 2, 3 ... weeks
     */
    func previousWeeksStartDate(date: Date, weekBackwardCount: Int) -> Date {
        let daysInWeek = 7
        let secondsInWeek=86400*daysInWeek
        
        // Multiply by -1 to move backward
        let previousWeekDate : Date = date.addingTimeInterval(TimeInterval(-(weekBackwardCount*secondsInWeek)))
        let previousWeekStartDate = (previousWeekDate.startOfWeek?.startOfDay)!
        return previousWeekStartDate
    }
    
    /**
     Provide previous week End from current Date.
     weekBackwardCount decide how much back from current week,
     1, 2, 3 ... weeks
     */
    func previousWeeksEndDate(weekBackwardCount: Int) -> Date {
        let daysInWeek = 7
        let secondsInWeek=86400*daysInWeek
        
        // Multiply by -1 to move backward
        let previousWeekDate : Date = Date().addingTimeInterval(TimeInterval(-(weekBackwardCount*secondsInWeek)))
        let previousWeekEndDate = (previousWeekDate.endOfWeek?.endOfDay)!
        return previousWeekEndDate
    }
    
    /**
     Provide previous week End from given Date.
     weekBackwardCount decide how much back from current week,
     1, 2, 3 ... weeks
     */
    func previousWeeksEndDate(date: Date, weekBackwardCount: Int) -> Date {
        let daysInWeek = 7
        let secondsInWeek=86400*daysInWeek
        
        // Multiply by -1 to move backward
        let previousWeekDate : Date = date.addingTimeInterval(TimeInterval(-(weekBackwardCount*secondsInWeek)))
        let previousWeekEndDate = (previousWeekDate.endOfWeek?.endOfDay)!
        return previousWeekEndDate
    }
    
    /**
     Provide previous month Start Date.
     monthBackwardCount decide how much back from current month,
     1, 2, 3 ... Months
     */
    func previousMonthsStartDate(monthBackwardCount: Int) -> Date {
        // Multiply by -1 to move backward
        let PREVIOUS_MONTH_COUNT = monthBackwardCount * -1
        let previousMonthsDate=Calendar.gregorian.date(byAdding: .month, value: PREVIOUS_MONTH_COUNT, to: Date().current)
        return (previousMonthsDate?.startOfMonth().startOfDay)!
    }
    
    /**
     Provide given month previous month Start Date.
     monthBackwardCount decide how much back from current month,
     1, 2, 3 ... Months
     */
    func previousMonthsStartDate(date: Date, monthBackwardCount: Int) -> Date {
        // Multiply by -1 to move backward
        let PREVIOUS_MONTH_COUNT = monthBackwardCount * -1
        let previousMonthsDate=Calendar.gregorian.date(byAdding: .month, value: PREVIOUS_MONTH_COUNT, to: date.startOfDay)
        return (previousMonthsDate?.startOfMonth().startOfDay)!
    }
    
    
    /**
     Provide previous month End Date.
     monthBackwardCount decide how much back from current month,
     1, 2, 3 ... Months
     */
    func previousMonthsEndDate(monthBackwardCount: Int) -> Date {
        // Multiply by -1 to move backward
        let PREVIOUS_MONTH_COUNT = monthBackwardCount * -1
        let previousMonthsDate=Calendar.gregorian.date(byAdding: .month, value: PREVIOUS_MONTH_COUNT, to: Date().current)
        return (previousMonthsDate?.endOfMonth().endOfDay)!   // May change into (previousMonthsDate?.endOfMonth().startOfDay)! in future
    }
    
    /**
     Provide given month previous month End Date.
     monthBackwardCount decide how much back from current month,
     1, 2, 3 ... Months
     */
    func previousMonthsEndDate(date: Date, monthBackwardCount: Int) -> Date {
        // Multiply by -1 to move backward
        let PREVIOUS_MONTH_COUNT = monthBackwardCount * -1
        let previousMonthsDate=Calendar.gregorian.date(byAdding: .month, value: PREVIOUS_MONTH_COUNT, to: date.startOfDay)
        return (previousMonthsDate?.endOfMonth().endOfDay)!   // May change into (previousMonthsDate?.endOfMonth().startOfDay)! in future
    }
    
    // Formatters
    /** Return name of day, return like MON-17 */
    func dayDateFormat(forDate: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE-dd"
        let dayName = formatter.string(from: forDate)
        return dayName
    }
    
    /** Return name of day, date and month name year like 07-NOV 2018 */
    func dateMonthYearFormat(forDate: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM yyyy"
        let dayName = formatter.string(from: forDate)
        return dayName
    }
    
    /** Return name of day, Return like 11-17 NOV */
    func dateDateMonthFormat(fromDate: Date, toDate: Date) -> String{
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = "dd"
        let fromDateName = fromFormatter.string(from: fromDate)
        
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = "dd"
        let toDateName = toFormatter.string(from: toDate)
        
        let monthNameFormatter = DateFormatter()
        monthNameFormatter.dateFormat = "LLL"
        let monthName = monthNameFormatter.string(from: toDate)
        
        let dateDateMonthStr=fromDateName+"-"+toDateName+" "+monthName
        return dateDateMonthStr
    }
    
    /** Return name of day, Return like 11 NOV-17 NOV */
    func dateMonthDateMonthFormat(fromDate: Date, toDate: Date) -> String{
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = "dd"
        let fromDateName = fromFormatter.string(from: fromDate)
        
        let fromMonthNameFormatter = DateFormatter()
        fromMonthNameFormatter.dateFormat = "LLL"
        let fromMonthName = fromMonthNameFormatter.string(from: fromDate)
        
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = "dd"
        let toDateName = toFormatter.string(from: toDate)
        
        let toMonthNameFormatter = DateFormatter()
        toMonthNameFormatter.dateFormat = "LLL"
        let toMonthName = toMonthNameFormatter.string(from: toDate)
        
        let dateDateMonthStr=fromDateName+" "+fromMonthName+"-"+toDateName+" "+toMonthName
        return dateDateMonthStr
    }
    
    
    /** Return day-month year day-month year, Return like 01-NOV 2018 - 07-NOV 2018 Format */
    func dateMonthYearDateMonthYearFormat(fromDate: Date, toDate: Date) -> String{
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = "dd"
        let fromDateName = fromFormatter.string(from: fromDate)
        
        let fromMonthNameFormatter = DateFormatter()
        fromMonthNameFormatter.dateFormat = "LLL"
        let fromMonthName = fromMonthNameFormatter.string(from: fromDate)
        
        let fromYearNameFormatter = DateFormatter()
        fromYearNameFormatter.dateFormat = "yyyy"
        let fromYearName = fromYearNameFormatter.string(from: fromDate)
        
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = "dd"
        let toDateName = toFormatter.string(from: toDate)
        
        let toMonthNameFormatter = DateFormatter()
        toMonthNameFormatter.dateFormat = "LLL"
        let toMonthName = toMonthNameFormatter.string(from: toDate)
        
        let toYearNameFormatter = DateFormatter()
        toYearNameFormatter.dateFormat = "yyyy"
        let toYearName = toYearNameFormatter.string(from: toDate)
        
        let formattedDate=fromDateName+"-"+fromMonthName+" "+fromYearName+" - "+toDateName+"-"+toMonthName+" "+toYearName
        return formattedDate
    }
    
    /** Return name of month and year like NOV-18 */
    func monthYearFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL-yy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    /** Return name of month and full year like NOV-2018 */
    func monthFullYearFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    
    /** Return name of month, return like NOV */
    func monthFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    /** Return string date in yyyy-MM-dd, return like 2018-12-30 */
    func yearMonthDayFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    /** Return days difference between start and end date*/
    func daysDifference(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day!
    }
    
    /** Return yyyy-MM-dd'T'HH:mm:ssZ Date from ISO8601 date string */
    func dateFromString(dateStr: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateFormatter.date(from: dateStr)!
        
        return date
    }
    
    /** Return date in MM-dd-yyyy HH:mm, return like 12-30-2018 12:20 */
    func monthDayYearHourMinFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    /** Get day number of month  */
    func currentDayOfMonth(date: Date)->Int {
        return Calendar.current.ordinality(of: .day, in: .month, for: date)!
    }
    
    /** Get day number year */
    func currentDayOfYear(date: Date)->Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: date)!
    }
    
    /** Get name of date, like Mon, Tue, ... , or Sun */
    func dayName(forDate date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }

    /** Check date greater or not */
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        
        var isGreater = false
        
        if self.compare(dateToCompare) == .orderedDescending{
            isGreater=true
        }
        
        return isGreater
    }
    
    /** Check date less or not */
    func isLessThanDate(dateToCompare: Date) -> Bool {
        
        var isLess = false
        
        if self.compare(dateToCompare) == .orderedAscending{
            isLess=true
        }
        
        return isLess
    }
    
    /** Check dates equal or not */
    func isEqualToDate(dateToCompare: Date) -> Bool {
        
        var isEqualTo = false
        
        if self.compare(dateToCompare) == .orderedSame{
            isEqualTo=true
        }
        
        return isEqualTo
    }
    
    /** Current time in Second */
    func toSeconds() -> Int64! {
        return Int64(self.timeIntervalSince1970)
    }
    
    /** Second to Date */
    func secondsToDate(seconds: Int64) -> Date {
        let date = Date(timeIntervalSince1970: (Double(seconds)))
        return date
    }
    
    /** Current time in millisecond */
    func toMilliseconds() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    /** Millisecond to Date */
    func millisecondsToDate(milliseconds: Int64) -> Date {
        let date = Date(timeIntervalSince1970: (Double(milliseconds) / 1000.0))
        return date
    }
    
    /** Return date in yyyy-MM-dd, return like 2018-12-30 */
    func yearMonthDayFormat(str: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateFormatter.date(from: str)!
        
        return date
    }
}
