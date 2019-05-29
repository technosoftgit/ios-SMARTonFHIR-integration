//
//  TimeIntervalCell.swift
//
//  Created by Zain Arshad on 30/01/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import UIKit

class StepsHistoryCell: UICollectionViewCell {
    
    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func displayContent(steps: String, date: String){
        self.steps.text=steps
        self.date.text=date
    }
}
