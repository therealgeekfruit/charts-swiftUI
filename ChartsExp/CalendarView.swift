//
//  CalendarView.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 03/02/24.
//

import Foundation
import SwiftUI

// MARK: - CalendarView
struct CalendarView: View {
    @State private var currentMonth = 0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        currentMonth -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(currentMonth == -2) // -2 to allow navigating 2 months back

                Spacer()
                
                Text("\(Date().monthYearString(currentMonth: currentMonth))")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentMonth += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(currentMonth >= 0) // Disable if currentMonth is this month or future
            }
            .padding()
            
            MonthView(currentMonth: $currentMonth)
        }.padding(.horizontal, 10)
    }
}

// MARK: - MonthView
struct MonthView: View {
    @Binding var currentMonth: Int
    @State private var selectedDay: Date?
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let today = Date()
    private var startDate: Date {
        Calendar.current.date(byAdding: .day, value: -30, to: today)!
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Days of the week header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let days = today.daysInMonth(currentMonth: currentMonth)
            let firstDayOffset = (today.firstDayOfWeekInMonth(currentMonth: currentMonth) + 6) % 7
            
            let totalDays = days + firstDayOffset
            let rows = totalDays / 7 + (totalDays % 7 == 0 ? 0 : 1)
            
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<7, id: \.self) { column in
                        let day = row * 7 + column - firstDayOffset + 1
                        if day > 0 && day <= days {
                            let date = self.getDate(for: day)
                            DayView(day: day, date: date, isToday: today.isSameDay(date), isSelected: .constant(self.selectedDay?.isSameDay(date) ?? false))
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    if self.isDateSelectable(date) {
                                        self.selectedDay = date
                                    }
                                }
                        } else {
                            Text("")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }.padding(16)
    }
    
    private func isDateSelectable(_ date: Date) -> Bool {
        return date >= startDate && date <= today
    }
    
    private func getDate(for day: Int) -> Date {
        let calendar = Calendar.current
        let yearMonth = calendar.dateComponents([.year, .month], from: today)
        var components = DateComponents()
        components.year = yearMonth.year
        components.month = yearMonth.month! + currentMonth
        components.day = day
        return calendar.date(from: components)!
    }
}


// MARK: - DayView with Selection Indicator and Disable Future Days
struct DayView: View {
    var day: Int
    var date: Date
    var isToday: Bool
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) { // Set the spacing to 0 to remove space between elements
            Text("\(day)")
                .font(.system(size: 14))
                .foregroundColor(isToday || isSelected ? Color.white : Color.primary)
                .frame(width: 28, height: 24) // Adjust the frame as needed
            
            Image("1_superhappyframe")
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
        .frame(width: 34, height: 60) // Adjust the overall frame size as needed
        .padding(2) // Adjust padding around the VStack as needed
        .background(isSelected ? Color.red : (isToday ? Color.blue : Color.clear))
        .cornerRadius(20) // This will give you rounded corners
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
                .opacity(isToday || isSelected ? 0 : (date > Date() ? 0.5 : 1))
        )
        .disabled(date > Date())
    }
}

// MARK: - Date Extension
extension Date {
    func monthYearString(currentMonth: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let adjustedDate = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        return formatter.string(from: adjustedDate)
    }
    
    func daysInMonth(currentMonth: Int) -> Int {
        let calendar = Calendar.current
        let adjustedDate = calendar.date(byAdding: .month, value: currentMonth, to: Date())!
        let range = calendar.range(of: .day, in: .month, for: adjustedDate)!
        return range.count
    }
    
    func firstDayOfWeekInMonth(currentMonth: Int) -> Int {
        let calendar = Calendar.current
        let adjustedDate = calendar.date(byAdding: .month, value: currentMonth, to: Date())!
        let components = calendar.dateComponents([.year, .month], from: adjustedDate)
        let firstDayOfMonth = calendar.date(from: components)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        return (firstWeekday + 6) % 7 // Adjust to make Sunday == 0
    }
    
    func isSameDay(_ date: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDate(self, inSameDayAs: date)
        }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
