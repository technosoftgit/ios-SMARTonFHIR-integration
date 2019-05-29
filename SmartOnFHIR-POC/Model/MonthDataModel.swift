//
//  MonthDaysModel.swift
//
//  Created by Zain Arshad on 04/02/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import Foundation

struct MonthDataModel {
    var steps:Int
    var startDate:Date
    var endDate:Date
    
    init(steps: Int, startDate: Date, endDate: Date) {
        self.steps=steps
        self.startDate=startDate
        self.endDate=endDate
    }
}
