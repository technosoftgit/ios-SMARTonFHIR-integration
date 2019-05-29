//
//  AppConstant.swift

//
//  Created by Zain Arshad on 09/01/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import UIKit

var maxPatientsCapturedImages = 5
var maxPatientsSelectedImages = 2

//var FontNameDemi = "FoundrySterling-demi"
//var FontNameMedium = "FoundrySterling-medium"
//var FontNameThin = "FoundrySterling-thin"

var kOthervalue = "Other"
var kAllvalue = "All"

let NUMBER_OF_ROWS=3


// MARK: - Alert Messages..........
let kMaxLimitReachedMsg = "You have reached maximum limit \(maxPatientsCapturedImages)  of photos."

// Add ?? for replace encounter name...
let kMesssageOnBackAlert = "You will lose your ?? information, if any. Do you want to continue?"

let kAuthorizationTokenKey = "Authorization"
let kAppVersionKey = "app_version"
let kDeviceTypeKey = "device_type"
let kTimeZoneKey = "Timezone"
let kIsDayLightSaving = "isDayLightSaving"

let kMessageKey = "message"
let kMessagesKey = "messages"
let kErrorKey = "error"
let kCodeKey = "code"
let kDataKey = "data"

//Representative Key
let kPhoneNoKey = "phoneNo"
let kFullNameKey = "FullName"

//Current login User keys
let kUserFullNameKey = "fullname"
let kIdKey = "id"
let kNameKey = "name"
let kUserRoleKey = "role"
let partialText  = "Partial"
let fullText  = "Full"

let kApplicationDate = "ApplicationDate";
let kLastName = "LastName";

let kSet="Set"

let kIsFirstTime="isFirstTime"
let kAuth="isAuthorized"
let kSourceKey="shim-Key"
let kDailyGoals="dailyGoal"
let kFirstTimeSetting="firstTimeSetting"

let kUsername="username"

let UndefinedSteps = -999

let ENTITY_NAME = "SourceDB"

let SYNC_START = "syncStart"
let SYNC_END = "syncEnd"
let NOTIF_SYNC_TIME = "syncTimeForNotification"
let IS_FIRST_SYNC = "isFirstSync"
let TODAY_STEPS = "todaySteps"
let CURRENT_DATE = "current date"

let DAY_COUNT=6
let WEEK_COUNT=4
let MONTH_COUNT=4

let DAYS_IN_WEEK = 7
let DAYS_IN_MONTH = 30

let INVALID_SOURCE=""


#if DEBUG
let BASE_URL = "http://10.10.10.162:8084/"   //  "http://10.10.10.162:8084/"  //  "http://localhost:8084/"
#else
let BASE_URL = "http://10.10.10.162:8084/"   //  "http://10.10.10.162:8084/"  //  "http://localhost:8084/"
#endif


let SESSION_EXPIRE_MSG = "Session expired, please re-login"
let NO_CONNECTION_MSG = "No internet connection or server not responding"

/** If only Health-Kit is available source. No Shimmer integration */
let ONLY_HEALTH_KIT_AVAILABLE = true
