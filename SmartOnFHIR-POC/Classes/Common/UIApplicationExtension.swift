//
//  UIApplicationExtension.swift

//
//  Created by Zain Arshad on 09/11/2018.
//  Copyright © 2018 Technosoft Solutions. All rights reserved.
//

import Foundation
import UIKit
// MARK: UIApplication version and build extension
extension UIApplication {
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}
