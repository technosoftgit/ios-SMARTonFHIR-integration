SMART on FHIR
=============

An **SMART on FHIR IOS App** compatible with DSTU2 and Swift 4.2.


## Installation

1. Checkout the source code:
2. Install POD using `pod install` command in project directory
3. Open the project file `SmartOnFHIR-POC.xcworkspace` in Xcode 8+.
4. Select an iPhone simulator and press **Run**.

The `master` branch also contain SMART framework 2.8.2 with Swift 4.2 and DSTU-2 support.
Swift-SMART 2.8.2 (https://github.com/smart-on-fhir/Swift-SMART/releases/tag/2.8.2)) based on Swift 3.  

	Swift-SMART 2.8.2 for Swift 4.2 available on 
	https://github.com/technosoftgit/Smart_2_8_2_Swift4.git

## What's Happening?

This app allows you to **specify to which FHIR server** you want to connect. Select Custom Server to connect with specific FHIR server at run time, callback URL must be same as set in application **info.plist**

There are some places where custom code performs interesting tasks:

### End Points

Add `EndpointProvider` instance that defines which FHIR endpoints (servers) will be available in the app.
Right now these are hardcoded.

#### Endpoints.swift
```
import Foundation
import SMART


func getConfiguredEndpoints() -> [Endpoint] {
    var endpoints = [Endpoint]()
    
    let smartSource = Client(
        baseURL: "https://r2.smarthealthit.org/",
        settings: [
            "client_id": "Registered app ID",
            "client_name": "Registered app name or any other",
            "redirect": "Registered app callback, like smartapp://callback",
            "logo_uri": "Logo_URL",
            ])
    smartSource.authProperties.granularity = .patientSelectNative
    smartSource.authProperties.embedded = true
    
    endpoints.append(Endpoint(client: smartSource, name: "SMART (Sandbox)"))
    
    //----------------------------
    
    return endpoints
}
```

Add custom endpoint source and append in endpoints array. make sure following parameters are identical provided in SMART FHIR application
1. client_id(required)
2. redirect or callback(required)
3. scope(required)

### Info Plist

Add FHIR server application callback in Info.plist custom URI scheme without ://callback

#### ProviderListViewController.swift

rename "smartapp://callback" if required
```
if self.isCustomUrlExist{
               	...
                self.callbackTextField.text = "smartapp://callback"
                self.sendButton.isHidden = false
                
            }else{
                ...
                self.callbackTextField.text = "smartapp://callback"
                self.sendButton.isHidden = true
            }
```

### Credits
  The code based on below liraries

  - smart-on-fhir / Swift-SMART 
    * Swift-SMART
    * [https://github.com/smart-on-fhir/Swift-SMART](https://github.com/smart-on-fhir/Swift-SMART)

  - smart-on-fhir/Swift-FHIR
  	* Swift-FHIR
  	* [https://github.com/smart-on-fhir/Swift-FHIR](https://github.com/smart-on-fhir/Swift-FHIR)
  	
  - smart-on-fhir/SoF-Demo
  	* SoF-Demo
  	* [https://github.com/smart-on-fhir/SoF-Demo](https://github.com/smart-on-fhir/SoF-Demo)



