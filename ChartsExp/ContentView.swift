//
//  ContentView.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 04/12/23.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    var data = [
        SleepDataPoint(day: "Mon", hours: 4),
        SleepDataPoint(day: "Mon", hours: 2, type: "Nap"),
        SleepDataPoint(day: "Tue", hours: 6),
        SleepDataPoint(day: "Tue", hours: 1, type: "Nap"),
        SleepDataPoint(day: "Wed", hours: 8),
        SleepDataPoint(day: "Wed", hours: 1, type: "Nap"),
        SleepDataPoint(day: "Thu", hours: 3),
        SleepDataPoint(day: "Thu", hours: 1, type: "Nap"),
        SleepDataPoint(day: "Thu", hours: 2, type: "Accidental"),
        SleepDataPoint(day: "Fri", hours: 5),
        SleepDataPoint(day: "Fri", hours: 2, type: "Accidental"),
        SleepDataPoint(day: "Sat", hours: 8),
        SleepDataPoint(day: "Sun", hours: 7),
    ]
    
    var body: some View {
        Chart {
            ForEach (data) { d in
                BarMark(x: PlottableValue.value("Day", d.day), y: .value("Hours", d.hours))
                    .annotation(position: .overlay){
                        Text(String(d.hours))
                            .foregroundColor(.white)
                    }
                    .foregroundStyle(by: .value("Type", d.type))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .chartYAxis { AxisMarks(position: .leading, values: [0, 2, 4, 6, 8, 10]) } // Move Y-axis to the left side, range alteration for Y-axis
        .chartYScale(domain: 0...10)
        .padding()
    }
}

#Preview {
    ContentView()
}
