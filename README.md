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


## What's Happening?

This app allows you to **specify to which FHIR server** you want to connect. Select Custom Server to connect with specific FHIR server at run time, callback URL must be same as set in application **info.plist**

There are some places where custom code performs interesting tasks:

### End Points

Add `EndpointProvider` instance that defines which FHIR endpoints (servers) will be available in the app.
Right now these are hardcoded, starting at line 16 to line 25 in `Endpoints.swift`.

Add custom endpoint source and append in endpoints array. make sure following parameters are identical provided in SMART FHIR application
	1. client_id(required)
	2. redirect or callback(required)
	3. scope(required)

### Info Plist

Add FHIR server application callback callback url in Info.plist without ://callback

### ProviderListViewController

rename "smartapp://callback" on line 160 and 170 with our FHIR server callback if required
