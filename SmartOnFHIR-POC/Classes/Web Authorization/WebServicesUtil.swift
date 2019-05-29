//
//  WebServicesUtil.swift
//
//  Created by Muhammad Luqman on 02/05/2018.
//  Copyright © 2018 Csymplicity software. All rights reserved.
//

import UIKit
import Alamofire

class WebServicesUtil: NSObject
{
    static let shared = WebServicesUtil()
    
    override init(){
        
    }
    
    let authURL = "\(BASE_URL)authorize/"
    var dataURL = "\(BASE_URL)data/"
    
    private func sendRequest(with url: String, method:HTTPMethod, parameters: Dictionary<String, Any>?, timeoutInterval: Int = 0 , parameterEncoding: ParameterEncoding?, completion: @escaping (Dictionary<String, Any>?, _ success: Bool, _ message: String?) -> ())
    {
        let pm = parameterEncoding ?? URLEncoding.default
        let manager = Alamofire.SessionManager.default
        
        if(timeoutInterval > 0){
            manager.session.configuration.timeoutIntervalForRequest = Double(timeoutInterval)
        }
        
        manager.request(url, method: method, parameters: parameters, encoding: pm, headers: nil).responseJSON {
            response in
            
            debugPrint(response)
            
            var stringMessage = ""
            
            if(response.response?.statusCode == nil){
                
                stringMessage = "The Internet connection appears to be offline."
                completion(nil, false, stringMessage)
                
            }else {
                
                if let json = response.result.value
                {
                    let dictionary = json as? Dictionary<String, Any>
                    let error = dictionary![kErrorKey]
                    
                    if error is Dictionary<String, Any> {
                        
                        print("It is a Dictionary")
                        let error = dictionary![kErrorKey] as! NSDictionary
                        let code = error[kCodeKey]
                        
                        if let messages = error[kMessagesKey] as? NSArray {
                            
                            if(messages.count > 0){
                                
                                for i in 0...messages.count-1 {
                                    let message = messages[i] as! NSDictionary
                                    stringMessage = "\(stringMessage)\n\(message[kMessageKey] ?? "")(\(code ?? ""))"
                                }
                            }
                            
                            if let e = error["exception"]{
                                #if DEBUG
                                stringMessage =  "\(stringMessage) --> Exception: \(e)"
                                #endif
                            }
                            completion(nil, false, stringMessage)
                            
                        }else if let e = error["exception"]{
                            
                            completion(dictionary, false, (e as! String))
                            
                        } else {
                            
                            completion(nil, false,"Unknown server error occurred. (888)")
                        }
                    }else{
                        
                        completion(dictionary, true, stringMessage)
                    }
                }else{
                    
                    stringMessage = "Unknown server error occurred. (\(response.response?.statusCode ?? 0))"
                    
                    completion(nil, false, stringMessage)
                }
            }
        }
    }
    
    
    func getAuthorizationData(sourceAndName: String, completion: @escaping (Dictionary<String, Any>?, _ success: Bool, _ message: String?) -> ())
    {
        let compAuthURL = "\(authURL)\(sourceAndName)"
        sendRequest(with: compAuthURL, method: .get, parameters: nil, parameterEncoding: nil, completion: { (response, success, message) in
            
            completion(response, success,message)
            
        })
    }
    
    func checkAuthConnection(sourceAndName: String, completion: @escaping (_ success: Bool) -> ())
    {
        let compAuthURL = "\(authURL)\(sourceAndName)"
        sendRequest(with: compAuthURL, method: .get, parameters: nil, parameterEncoding: nil, completion: { (response, success, message) in
            completion(success)
        })
    }
    
    private func getTotalStepsData(endPoint: String, completion: @escaping (Dictionary<String, Any>?, _ success: Bool, _ message: String?) -> ())
    {
        
        dataURL = "\(dataURL)\(endPoint)"
        sendRequest(with: dataURL, method: .get, parameters: nil, parameterEncoding: nil, completion: { (response, success, message) in
            
            completion(response, success,message)
            
        })
    }
    
}
