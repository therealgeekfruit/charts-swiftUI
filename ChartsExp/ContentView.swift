//
//  ContentView.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 04/12/23.
//

import SwiftUI
import Charts

// A view for an individual category card
struct CategoryCard: View {
    var data: ScreenTimeData
    var color: Color
    
    var body: some View {
        VStack {
            HStack{
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                Text(data.category)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(data.duration) m")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    var data = [
        ScreenTimeData(category: "Social", startTime: 2, duration: 10),
        ScreenTimeData(category: "Entertainment", startTime: 2, duration: 25),
        ScreenTimeData(category: "Social", startTime: 8, duration: 15),
        ScreenTimeData(category: "Games", startTime: 8, duration: 30),
        ScreenTimeData(category: "Productivity", startTime: 9, duration: 25),
        ScreenTimeData(category: "Social", startTime: 9, duration: 20),
        ScreenTimeData(category: "Entertainment", startTime: 10, duration: 40),
        ScreenTimeData(category: "Education", startTime: 10, duration: 10),
        ScreenTimeData(category: "Health", startTime: 11, duration: 15),
        ScreenTimeData(category: "Social", startTime: 11, duration: 20),
        ScreenTimeData(category: "Games", startTime: 12, duration: 30),
        ScreenTimeData(category: "Productivity", startTime: 12, duration: 10),
        ScreenTimeData(category: "Education", startTime: 13, duration: 25),
        ScreenTimeData(category: "Entertainment", startTime: 13, duration: 20),
        ScreenTimeData(category: "Social", startTime: 14, duration: 15),
        ScreenTimeData(category: "Health", startTime: 14, duration: 20),
        ScreenTimeData(category: "Games", startTime: 15, duration: 25),
        ScreenTimeData(category: "Productivity", startTime: 15, duration: 35),
        ScreenTimeData(category: "Education", startTime: 17, duration: 45),
        ScreenTimeData(category: "Health", startTime: 18, duration: 30),
        ScreenTimeData(category: "Entertainment", startTime: 23, duration: 35)
    ]
    
    // Dictionary to map categories to colors
    let categoryColor: [String: Color] = [
        "Social": .blue,
        "Entertainment": .red,
        "Games": .orange,
        "Productivity": .purple,
        "Education": .green,
        "Health": .cyan
    ]
    
    // Define two columns for the grid
    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        Chart {
            ForEach (data) { d in
                BarMark(x: PlottableValue.value("Day", d.startTime), y: .value("Hours", d.duration))
                    .foregroundStyle(by: .value("Type", d.category))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .chartLegend(.hidden)
        .chartYAxis { AxisMarks(position: .leading, values: [0, 15, 30, 45, 60]) } // Move Y-axis to the left side, range alteration for Y-axis
        .chartXAxis {
            AxisMarks(values: .stride(by: 6)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    switch value.as(Int.self) {
                    case 0: Text("12 AM")
                    case 6: Text("06 AM")
                    case 12: Text("12 PM")
                    case 18: Text("06 PM")
                    default: Text("")
                    }
                }
            }
        }
        .chartYScale(domain: 0...60)
        .frame(height: UIScreen.main.bounds.height / 2.3)
        .padding()
        
        // Use a LazyVGrid to place the cards two in a row
        LazyVGrid(columns: columns, spacing: 10) {
            let groupedData = Dictionary(grouping: data, by: { $0.category })
            ForEach(groupedData.keys.sorted(), id: \.self) { key in
                if let color = categoryColor[key] {
                    CategoryCard(
                        data: ScreenTimeData(
                            category: key,
                            startTime: 0,
                            duration: groupedData[key]?.reduce(0) { $0 + $1.duration } ?? 0
                        ),
                        color: color
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
