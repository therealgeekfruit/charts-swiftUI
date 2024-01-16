//
//  DataPoint.swift
//  ChartsExp
//
//  Created by Sudeep Rao on 16/01/24.
//

import Foundation

struct SleepDataPoint: Identifiable {
    
    var id = UUID().uuidString
    var day: String
    var hours: Int
    var type: String = "Night"
}
