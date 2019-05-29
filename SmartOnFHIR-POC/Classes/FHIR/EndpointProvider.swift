//
//  EndpointProvider.swift
//
//  Created by Pascal Pfiffner on 12/3/16.
//  Copyright © 2016 SMART Platforms. All rights reserved.
//

import Foundation
import SMART
import MKProgress


public class EndpointProvider {
    
    let userDefaults = UserDefaults.standard
    var healthSource:String?
    
    public var endpoints: [Endpoint]? {
        didSet {
            if nil == activeEndpoint, endpoints?.count ?? 0 > 0 {
                activeEndpoint = endpoints![0]
            }
        }
    }
    
    public private(set) var activeEndpoint: Endpoint?
    
    public func activate(endpoint: Endpoint) {
        if let active = activeEndpoint?.client {
            active.abort()
        }
        activeEndpoint = endpoint
    }
    
    /**
     Forwards to the active endpoint's client instance's `authorize()` method. If the endpoint defines a manual patient selection block,
     takes care of executing the manual selection if `authorize()` does not come back with a patient.
     
     - parameter callback: The block to execute once authorization and patient selection have finished
     */
    func selectPatient(imageData: String, monthsData: [MonthDataModel], callback: @escaping (_ patient: Patient?, _ error: Error?) -> Void) {
        
        
        guard let endpoint = activeEndpoint, let smart = endpoint.client else {
            callback(nil, AppError.noActiveEndpoint)
            return
        }
        smart.authorize() { patient, error in
            
            if nil == error, nil == patient, let manual = endpoint.manualPatientSelect {
                
                fhir_logIfDebug("Endpoint \(endpoint) did not return a patient after authorization, executing `manualPatientSelect`")
                
                manual(smart.server, { patient, error in
                    if(patient != nil){
                        
                        var observationCount = 1
                        
                        for monthData in monthsData{
                            let observation = Observation(json: self.asCountJSON(data: String(monthData.steps), date: monthData.startDate, patient: patient as! Patient))
                            observation.create(smart.server, callback: { (error) in
                                if(error != nil){
                                    print(error ?? "Error: something wrong")
                                }else{
                                    print("Step count add")
//                                    print("Patient : \(patient)")
                                    
//                                    print("Observation : \(observation.asJSON())")
                                }
                                
                                observationCount += 1
                                if observationCount > 5{
//                                    DispatchQueue.main.async {
//                                        MKProgress.hide()
//                                    }
                                    callback(patient as? Patient, error)
                                }
                                
                            })
                        }
                        
                        
                        let observation = Observation(json: self.asImageJSON(data: imageData, startDate: (monthsData.first?.startDate)!, endDate: (monthsData.last?.startDate)!, patient: patient as! Patient))
                        observation.create(smart.server, callback: { (error) in
                            if(error != nil){
                                print(error ?? "Error: something wrong")
                            }else{
                                print("Step image added")
                                print("Patient : \(patient)")
                                
                            }
                            
                            observationCount += 1
                            if observationCount > 5{
                                callback(patient as? Patient, error)
                            }
                            
                        })
                       
                    }
                    
                    else{
                        callback(nil, error)
                    }
                })
            }
            else {
                
                if(patient != nil){
                    
                     var observationCount = 1
                    
                    for monthData in monthsData{
                        
                        let observation = Observation(json: self.asCountJSON(data: String(monthData.steps), date: monthData.startDate, patient: patient!))
                        observation.create(smart.server, callback: { (error) in
                            
                            if(error != nil){

                                print(error ?? "Error: something wrong")
                                
                            }else{
                                
                                print("Step count add")
                            }
                            
                            observationCount += 1
                            if observationCount > 5{
                                callback(patient as? Patient, error)
                            }
                        })
                    }
                    
                    let observation = Observation(json: self.asImageJSON(data: imageData, startDate: (monthsData.first?.startDate)!, endDate: (monthsData.last?.startDate)!, patient: patient as! Patient))
                    observation.create(smart.server, callback: { (error) in
                        if(error != nil){
                            print(error ?? "Error: something wrong")
                        }else{
                            print("Step image added")
                            print("Patient : \(patient)")
                        }
                        
                        observationCount += 1
                        if observationCount > 5{
                            callback(patient as? Patient, error)
                        }
                    })
                    
                }
                
                else{
                    callback(nil, error)
                }
            }
        }
    }
    
    /** JSON for step count */
    func asCountJSON(data: String, date: Date, patient: Patient) -> FHIRJSON {
        
        //DomainResource
        var json = FHIRJSON()
        let code = CodeableConcept(json: codeCountJSON(date: date))
        let category = CodeableConcept(json: categoryJSON())
        
        let effectiveDateTime = DateTime.now
        let issued = Instant.now
        let subject = Reference(json: subjectJSON(patient: patient))
        
        //        json["resourceType"] = "Observation".asJSON()   // Uncommit for time being
        //        json["text"] = textJSON()                     // Uncommit for time being
        
        json["category"] = category.asJSON()
        json["code"] = code.asJSON()
        json["effectiveDateTime"] = effectiveDateTime.asJSON()
        json["issued"] = issued.asJSON()
        json["status"] = "final".asJSON()
        json["subject"] = subject.asJSON()
        json["valueString"] = data.asJSON()   // set value to step count observation
        
        return json
    }
    
    /** codeJSON for step count, "55423-8" is step count code, may use other code for another observation type */
    func codeCountJSON(date: Date) -> FHIRJSON {
        
        var json = FHIRJSON()
        let coding = Coding(json: codingJSON(code: "55423-8", display: "Step Count \(Date().monthYearFormat(date: date))", system: "http://loinc.org"))
        json["coding"] = [coding.asJSON()]
        json["text"] = "Daily Steps".asJSON()
        return json
    }
    
    
    
    /** JSON for image */
    func asImageJSON(data: String, startDate: Date, endDate: Date, patient: Patient) -> FHIRJSON {
        
        //DomainResource
        var json = FHIRJSON()
        let code = CodeableConcept(json: codeImageJSON(startDate: startDate, endDate: endDate))
        let category = CodeableConcept(json: categoryJSON())
        
        let effectiveDateTime = DateTime.now
        let issued = Instant.now
        let subject = Reference(json: subjectJSON(patient: patient))
        
        //        json["resourceType"] = "Observation".asJSON()   // Uncommit for time being
        //        json["text"] = textJSON()                     // Uncommit for time being
        
        json["category"] = category.asJSON()
        json["code"] = code.asJSON()
        json["effectiveDateTime"] = effectiveDateTime.asJSON()
        json["issued"] = issued.asJSON()
        json["status"] = "final".asJSON()
        json["subject"] = subject.asJSON()
        
        // Attachment json to attach image with main json
        var attachmentJSON = FHIRJSON()
        attachmentJSON["title"] = category.asJSON()
        attachmentJSON["creation"] = effectiveDateTime.asJSON()
        let base64Data = Base64Binary(string: data)
        attachmentJSON["data"] = base64Data.asJSON()
        attachmentJSON["contentType"] = "image/jpeg".asJSON()
        
        // Add attachment json in main json
        json["valueAttachment"] = attachmentJSON   // set value to step count/image base64 data observation
        
        return json
    }
    
    /** codeJSON for image, "55423-8" is step count code, may use other code for another observation type */
    func codeImageJSON(startDate: Date, endDate: Date) -> FHIRJSON {
        
        var json = FHIRJSON()
        let coding = Coding(json: codingJSON(code: "55423-8", display: "Step Count \(Date().monthYearFormat(date: startDate)) - \(Date().monthYearFormat(date: endDate))", system: "http://loinc.org"))
        json["coding"] = [coding.asJSON()]
        json["text"] = "Image".asJSON()
        return json
    }
    
    /** Set category by changing "code" and "display" value */
    func categoryJSON() -> FHIRJSON {
        
        var json = FHIRJSON()
        let coding = Coding(json: codingJSON(code: "activity", display: "Activity", system: "http://terminology.hl7.org/CodeSystem/observation-category"))
        json["coding"] = [coding.asJSON()]
        return json
    }
    
    func textJSON() -> FHIRJSON {
        
        var json = FHIRJSON()
        json["status"] = "generated".asJSON()
        json["div"] = "<div>[name] : [value] [hunits] @ [date]</div>".asJSON()
        return json
    }
    
    func subjectJSON(patient: Patient) -> FHIRJSON {
        
        var json = FHIRJSON()
        json["reference"] = "Patient/\(patient.id ?? "")".asJSON()
        return json
    }
    
    func codingJSON (code:String, display:String, system:String) -> FHIRJSON {
        
        var json = FHIRJSON()
        json["code"] = code.asJSON()
        json["display"] = display.asJSON()
        json["system"] = system.asJSON()
        
        return json
    }
    
    
    public func cancelPatientSelect() {
        guard let smart = activeEndpoint?.client else {
            return
        }
        smart.abort()
    }
    
    public func availableResourceTypes(for endpoint: Endpoint) -> [Resource.Type] {
        return [
            
            Observation.self,
            AllergyIntolerance.self,
            CarePlan.self,
            Condition.self,
            DiagnosticReport.self,
            Goal.self,
            Immunization.self,
            Procedure.self,
            ReferralRequest.self
        ]
    }
}


public class Endpoint {
    
    public var client: Client?
    
    public var name: String?
    
    public var manualPatientSelect: ((FHIRServer, @escaping FHIRResourceErrorCallback) -> Void)?
    
    init(client: Client?, name: String? = nil) {
        self.client = client
        self.name = name
    }
}

