//
//  CommonMethods.swift

//
//  Created by Zain Arshad on 09/01/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import UIKit

/** Clear codentials username, source and auth */
func clearCodentials(){
    let defaults = UserDefaults.standard
    defaults.set(false, forKey: kAuth)
    defaults.set("", forKey: kUsername)
    defaults.set("", forKey: kSourceKey)
    defaults.synchronize()
}

