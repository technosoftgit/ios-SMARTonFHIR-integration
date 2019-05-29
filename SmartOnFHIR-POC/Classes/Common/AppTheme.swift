//
//  AppTheme.swift

//
//  Created by Zain Arshad on 06/11/2018.
//  Copyright © 2018 Technosoft Solutions. All rights reserved.
//

import Foundation
import UIKit

class AppTheme {
    
    static let shared = AppTheme()
    
    init() {
        
    }
    
    func progressForegroundColor(percentage: Float) -> UIColor {
        if percentage<0.25{
            return UIColor.RED_LOW
        }
        else if percentage>=0.25 && percentage<0.8{
            return UIColor.YELLOW_MEDIUM
        }
        else{
            return UIColor.GREEN_HIGH
        }
    }
    
    func progressBackgroundColor() -> UIColor {
        return UIColor.PROGRESS_BACK
    }
    
    /** UI background color according step counting */
    func uiBackgroundColor(currentSteps: Int, targetSteps:Int) -> UIColor{
        let percentage: Float=Float(currentSteps)/Float(targetSteps)
        
        if percentage<0.25{
            return UIColor.RED_LOW
        }
        else if percentage>=0.25 && percentage<0.8{
            return UIColor.YELLOW_MEDIUM
        }
        else{
            return UIColor.GREEN_HIGH
        }
    }
    
    func navigationTextColor() -> UIColor {
        return UIColor.NAV_TEXT_COLOR
    }
    
    func chartNoDataTextColor() -> UIColor {
        return UIColor.CHART_NO_DATA_TEXT_COLOR
    }
    
    func digitFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Comfortaa-Regular", size: size)!
    }
    
    func smallDigitFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Comfortaa-Light", size: size)!
    }
    
    func boldDigitFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Comfortaa-Bold", size: size)!
    }
    
    func textFont(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans", size: size)!
    }
    
    func smallTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
    func boldTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
    
}

extension UIColor {
    
    class func colorFrom(hexString hexStr : String, alpha: CGFloat ) -> UIColor
    {
        if let rgbValue = UInt(hexStr, radix: 16) {
            
            let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255.0
            let green =  CGFloat((rgbValue >>  8) & 0xff) / 255.0
            let blue  =  CGFloat((rgbValue      ) & 0xff) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            
        } else {
            return UIColor.black
        }
    }
    
}
