//
//  Endpoints.swift
//  SoF-MedList
//
//  Created by Pascal Pfiffner on 12/5/16.
//  Copyright © 2016 SMART Platforms. All rights reserved.
//

import Foundation
import SMART


func getConfiguredEndpoints() -> [Endpoint] {
    var endpoints = [Endpoint]()
    
    let smartSource = Client(
        baseURL: "https://r2.smarthealthit.org/",
        settings: [
            "client_id": "my_mobile_app",
            "client_name": "SMART on FHIR iOS Sample App",
            "redirect": "smartapp://callback",
            "logo_uri": "https://avatars1.githubusercontent.com/u/7401080",
            ])
    smartSource.authProperties.granularity = .patientSelectNative
    smartSource.authProperties.embedded = true
    
    endpoints.append(Endpoint(client: smartSource, name: "SMART (Sandbox)"))
    
    //----------------------------
    
    return endpoints
}

