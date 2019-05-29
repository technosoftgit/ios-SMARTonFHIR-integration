//
//  Endpoints.swift
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
            "client_id": "Registered app ID",
            "client_name": "Registered app name or any other",
            "redirect": "Registered app callback, like smartapp://callback",
            "logo_uri": "Logo_url",
            ])
    smartSource.authProperties.granularity = .patientSelectNative
    smartSource.authProperties.embedded = true
    
    endpoints.append(Endpoint(client: smartSource, name: "SMART (Sandbox)"))
    
    //----------------------------
    
    return endpoints
}

