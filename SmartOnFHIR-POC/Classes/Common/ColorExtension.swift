//
//  ColorExtension.swift

//
//  Created by Muhammad Luqman on 30/05/2018.
//  Copyright © 2018 Technosoft Solutions. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    //    static let High: UIColor = .init(red: 92, green: 173, blue: 92)
    //    static let Medium: UIColor = .init(red: 136, green: 179, blue: 159)
    //    static let Low: UIColor = .init(red: 255, green: 51, blue: 51)
    
    static let GREEN_HIGH: UIColor = .init(red: 76, green: 217, blue: 100) //.init(red: 113, green: 174, blue: 82)   // 71AE52
    static let YELLOW_MEDIUM: UIColor = .init(red: 255, green: 204, blue: 0) //.init(red: 239, green: 192, blue: 45)  // EFC02D
    static let RED_LOW: UIColor = .init(red: 255, green: 59, blue: 48) //.init(red: 213, green: 66, blue: 49)  //D54231
    
    static let PROGRESS_BACK: UIColor = .init(red: 172, green: 184, blue: 196) //ACB8C4
    //.init(red: 198,green: 223,blue: 186)//c6dfba
    
    //.init(red: 249,green: 230,blue: 171) //f9e6ab
    
    //.init(red: 239,green: 182,blue: 176)   //efb6b0
    
    static let NAV_TEXT_COLOR: UIColor = .init(red: 26,green: 41,blue: 59) //1A293B
    
    static let CHART_NO_DATA_TEXT_COLOR: UIColor = .init(red: 112, green: 133, blue: 154) //70859A

    
    convenience init(red: Int, green: Int, blue: Int)
    {
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat)
    {
        let normalizedRed = CGFloat(red) / 255
        let normalizedGreen = CGFloat(green) / 255
        let normalizedBlue = CGFloat(blue) / 255
        
        self.init(red: normalizedRed, green: normalizedGreen, blue: normalizedBlue, alpha: alpha)
    }
}
