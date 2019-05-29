//
//  ProviderListViewController.swift

//
//  Created by Zain Arshad on 17/04/2019.
//  Copyright © 2019 Technosoft Solutions. All rights reserved.
//

import UIKit
import SMART
import iOSDropDown
import MKProgress

class ResourceType {
    let type: Resource.Type
    var resources: [Resource]?
    var error: Error?
    
    init(type: Resource.Type) {
        self.type = type
    }
}

class ProviderListViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var dropdownList: DropDown!
    
    @IBOutlet weak var clientIDTextField: UITextField!
    @IBOutlet weak var baseUrlTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scopeTextField: UITextField!
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var callbackTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var customDataView: UIView!
    
    @IBOutlet weak var customViewHeightConstraint: NSLayoutConstraint!
    
    let userDefaults = UserDefaults.standard
    var healthSource:String?
    
    var keyboardSize:CGSize?
    var activeField:UITextField?
    var imageEncodedData:String = ""    // Assign image data in base64 format
    
    /** Use month model, last index contain latest */
    var monthsData = [MonthDataModel]()    // Assign array of Five month using ModelDataModel  like, MonthDataModel(steps: MONTH_STEPS, startDate: MONTH_START_DATE, endDate: MONTH_END_DATE)
    
    
    // user default constants
    private let CUSTOM_CLIENT_ID = "CUSTOM_CLIENT_ID"
    private let CUSTOM_BASE_URL = "CUSTOM_BASE_URL"
    private let CUSTOM_APP_NAME = "CUSTOM_APP_NAME"
    private let CUSTOM_SCOPE = "CUSTOM_SCOPE"
    private let CUSTOM_SECRET = "CUSTOM_SECRET"
    private let CUSTOM_CALLBACK = "CUSTOM_CALLBACK"
    
    private let SELECTED_INDEX = "SELECTED_INDEX"
    
    let CUSTOM_VIEW_HEIGHT = CGFloat(600)
    
    var endPointProviders:EndpointProvider?
    var patient:Patient?
    var resourceTypes: [ResourceType] = []
    var isCustomUrlExist = false
    
    var onEndpointSelect: ((Endpoint?) -> Void)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Endpoint"
        print(monthsData)
        
        self.dropdownList.delegate = self
        
        // Keyboard and gesture setting
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        sendButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        
        customDataView.isHidden = true
        customViewHeightConstraint.constant = 0
        
        endPointProviders = EndpointProvider()
        endPointProviders?.endpoints = getConfiguredEndpoints()
        
        // Add providers in dropdown list
        for endpoint in (endPointProviders?.endpoints)! {
            dropdownList.optionArray.append(endpoint.name!)
        }
        
        
        // use flag to detect custom url already added in user defaults or not
        if (userDefaults.object(forKey: CUSTOM_CLIENT_ID) == nil) || ((userDefaults.value(forKey: CUSTOM_CLIENT_ID) as? String)?.count == 0) {
            // Add "Add Custom" or "Already added" source in dropdown end
            dropdownList.optionArray.append("Custom Server")
            isCustomUrlExist = false
        }
        else{
            // if CUSTOM id already exist
            dropdownList.optionArray.append("Custom Server")
            
            let customClient = Client(
                baseURL: (self.userDefaults.value(forKey: self.CUSTOM_BASE_URL) as? String) ?? "",
                settings: [
                    "client_id": (self.userDefaults.value(forKey: self.CUSTOM_CLIENT_ID) as? String) ?? "",
                    "client_name": (self.userDefaults.value(forKey: self.CUSTOM_APP_NAME) as? String) ?? "",
                    "redirect": (self.userDefaults.value(forKey: self.CUSTOM_CALLBACK) as? String) ?? "",
                    "scope" : (self.userDefaults.value(forKey: self.CUSTOM_SCOPE) as? String) ?? ""
                ])
            customClient.authProperties.granularity = .patientSelectWeb
            customClient.authProperties.embedded = true
            endPointProviders?.endpoints?.append(Endpoint(client: customClient, name: "Custom Server"))
            
            isCustomUrlExist = true
        }
        
        // Dropdown list setting
        dropdownList.text = dropdownList.optionArray.first
        dropdownList.rowHeight = 50
        dropdownList.selectedRowColor = UIColor.lightGray
        dropdownList.listHeight = 260
        dropdownList.selectedIndex = 0
        
        dropdownList.listWillAppear {
            
            self.dismissKeyboard()
//            self.customDataView.isHidden = true
            
        }
        // The the Closure returns Selected Index and String
        dropdownList.didSelect{(selectedText , index ,id) in
            
            // Save selected index
            self.userDefaults.set(index, forKey: self.SELECTED_INDEX)
            self.userDefaults.synchronize()
            
            
            print("Selected index : \(index)")
            // last index use for custom
            if index == (self.dropdownList.optionArray.count - 1){
                //  if custom url exist then populate
                if self.isCustomUrlExist{
                    self.clientIDTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_CLIENT_ID) as? String) ?? ""
                    self.baseUrlTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_BASE_URL) as? String) ?? ""
                    self.nameTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_APP_NAME) as? String) ?? ""
                    self.scopeTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_SCOPE) as? String) ?? ""
                    self.secretTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_SECRET) as? String) ?? ""
                    self.callbackTextField.text = "smartapp://callback"
                    self.sendButton.isHidden = false
                    
                }else{
                    
                    self.clientIDTextField.text = ""
                    self.baseUrlTextField.text = ""
                    self.nameTextField.text = ""
                    self.scopeTextField.text = ""
                    self.secretTextField.text = ""
                    self.callbackTextField.text = "smartapp://callback"
                    self.sendButton.isHidden = true
                }
                self.customViewHeightConstraint.constant = self.CUSTOM_VIEW_HEIGHT
                self.customDataView.isHidden = false
                self.scrollView.isScrollEnabled = true
                
            }else{
                let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
                let offset = CGPoint(x: 0, y: -(navigationBarHeight+15))
                
                self.customViewHeightConstraint.constant = 0
                self.customDataView.isHidden = true
                self.sendButton.isHidden = false
                self.scrollView.setContentOffset(offset, animated: true)
                self.scrollView.isScrollEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // use flag to detect custom url already added in user defaults or not
        if (userDefaults.object(forKey: SELECTED_INDEX) == nil){
            userDefaults.set(0, forKey: SELECTED_INDEX)
            userDefaults.synchronize()
        }
        
        dropdownList.selectedIndex = userDefaults.value(forKey: SELECTED_INDEX) as? Int
        dropdownList.text = dropdownList.optionArray[dropdownList.selectedIndex ?? 0]
    
        
        print("Selected index : \(String(describing: index))")
        
        // last index use for custom
        if dropdownList.selectedIndex == (self.dropdownList.optionArray.count - 1){
            //  if custom url exist then populate
            if self.isCustomUrlExist{
                self.clientIDTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_CLIENT_ID) as? String) ?? ""
                self.baseUrlTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_BASE_URL) as? String) ?? ""
                self.nameTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_APP_NAME) as? String) ?? ""
                self.scopeTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_SCOPE) as? String) ?? ""
                self.secretTextField.text = (self.userDefaults.value(forKey: self.CUSTOM_SECRET) as? String) ?? ""
                self.callbackTextField.text = "smartapp://callback"
                self.sendButton.isHidden = false
                
            }else{
                
                self.clientIDTextField.text = ""
                self.baseUrlTextField.text = ""
                self.nameTextField.text = ""
                self.scopeTextField.text = ""
                self.secretTextField.text = ""
                self.callbackTextField.text = "smartapp://callback"
                self.sendButton.isHidden = true
            }
            self.customViewHeightConstraint.constant = CUSTOM_VIEW_HEIGHT
            self.customDataView.isHidden = false
            self.scrollView.isScrollEnabled = true
            
        }else{
            
            self.customViewHeightConstraint.constant = 0
            self.customDataView.isHidden = true
            self.sendButton.isHidden = false
            self.scrollView.setContentOffset(.zero, animated: true)
            self.scrollView.isScrollEnabled = false
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        activeField?.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == dropdownList{
            textField.resignFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        activeField = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Call on keyboard will shown
    @objc func keyboardWillShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        self.keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.keyboardSize!.height + 50, right: 0.0) // may add self offset in height
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    
    
    // Call on keyboard will hidden
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
    }
    @IBAction func saveAction(_ sender: UIButton) {
        if clientIDTextField.text?.count != 0 && baseUrlTextField.text?.count != 0{
            userDefaults.set(clientIDTextField.text, forKey: CUSTOM_CLIENT_ID)
            userDefaults.set(baseUrlTextField.text, forKey: CUSTOM_BASE_URL)
            userDefaults.set(nameTextField.text, forKey: CUSTOM_APP_NAME)
            userDefaults.set(scopeTextField.text, forKey: CUSTOM_SCOPE)
            userDefaults.set(secretTextField.text, forKey: CUSTOM_SECRET)
//            userDefaults.set(callbackTextField.text, forKey: CUSTOM_CALLBACK)
            isCustomUrlExist = true
            userDefaults.synchronize()
            
            // Remove existing object
            endPointProviders?.endpoints?.removeLast()
        
            // Add new object
            let customClient = Client(
                baseURL: baseUrlTextField.text!,
                settings: [
                    "client_id": clientIDTextField.text!,
                    "client_name": nameTextField.text!,
                    "redirect": "smartapp://callback",
                    "scope" : scopeTextField.text!
                ])
            customClient.authProperties.granularity = .patientSelectWeb
            customClient.authProperties.embedded = true
            endPointProviders?.endpoints?.append(Endpoint(client: customClient, name: "Custom Server"))
            
            dropdownList.optionArray.removeAll()
            
            // Add providers in dropdown list
            for endpoint in (endPointProviders?.endpoints)! {
                dropdownList.optionArray.append(endpoint.name!)
            }
            
            customViewHeightConstraint.constant = 0
            customDataView.isHidden = false
            sendButton.isHidden = false
            self.scrollView.setContentOffset(.zero, animated: true)
            self.scrollView.isScrollEnabled = false
            
            let refreshAlert = UIAlertController(title: "", message: "Custom FHIR server configuration saved successfully!", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        else{
            let refreshAlert = UIAlertController(title: "", message: "Valid Client ID and base URL required", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func connectAction(_ sender: UIButton) {
        if let selectedIndex = dropdownList.selectedIndex{
            // Add selected provider as active provider
            let endpoint = endPointProviders!.endpoints![selectedIndex]
            self.endPointProviders?.activate(endpoint: endpoint)
            AppDelegate.activePoint = endpoint
            
            print("Active endpoint : \(String(describing: self.endPointProviders?.activeEndpoint?.name))")
            print("Active URL : \(String(describing: self.endPointProviders?.activeEndpoint?.client?.server.baseURL.absoluteString))")
            print("Active name : \(String(describing: self.endPointProviders?.activeEndpoint?.client?.server))")
            
            getPatient()
        }
    }
    

    func getPatient(){
        sendButton.isEnabled = false
        MKProgress.show()
        self.sendButton.isEnabled = true
        self.endPointProviders?.selectPatient( imageData: self.imageEncodedData, monthsData: self.monthsData, callback: { (patient, error) in
            
            DispatchQueue.main.async {
               MKProgress.hide()
            }
            
            DispatchQueue.main.async {
                MKProgress.show()
                if let error = error {
                    switch error {
                    case OAuth2Error.requestCancelled:   break
                    case let e where NSURLErrorDomain == e._domain && NSURLErrorCancelled == e._code:   break
                    default: self.show(error: error, title: "Not Authorized")
                    }
                    
                    let refreshAlert = UIAlertController(title: "", message: "Unable to add observations of selected patient", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel logic here")
                    }))
                    
                    MKProgress.hide()
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }
                    
                    // no error and a patient, perfect!
                else if let patient = patient {
                    self.patient = patient
                    
                    // Get Name from patient JSON
                    let jsonName = patient.asJSON()["name"]
                    let rawName = ((((jsonName as? [Any])?.first) as! [String: Any])["given"])!
                    let rawFamilyName = ((((jsonName as? [Any])?.first) as! [String: Any])["family"])!
                    
                    var fullName = ""
                    
                    if let name = (rawName as! NSArray)[0] as? String{
                        fullName = fullName + name
                        if let familyName = (rawFamilyName as! NSArray)[0] as? String{
                            fullName = fullName+" "+familyName
                        }
                    }
                    
                    if fullName.isEmpty{
                        fullName = "Patient"
                    }
                    
                    self.loadResources()
                    
                    let refreshAlert = UIAlertController(title: "", message: "\(fullName) observation(s) successfully added", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction!) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    MKProgress.hide()
                    self.present(refreshAlert, animated: true, completion: nil)
                }
                    
                else if patient == nil{
                    let refreshAlert = UIAlertController(title: "", message: "Invalid connection parameters", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    MKProgress.hide()
                    self.present(refreshAlert, animated: true, completion: nil)
                }
                    
                    // no error and no patient: cancelled\
                else{
                    
                }
            }
        })
    }
    
    // MARK: - Resource Handling
    
    func loadResources() {
        
        guard let endpoint = endPointProviders?.activeEndpoint, let smart = endpoint.client, let patientId = patient?.id else {
//            fhir_logIfDebug("No active endpoint or no valid `patient`, cannot fetch resources")
            return
        }
        
        // reset resourceTypes, including error and resources for each type
        resourceTypes = endPointProviders?.availableResourceTypes(for: endpoint).map() { return ResourceType(type: $0) } ?? []
        
        // load all resources of the desired types for our patient
        var i = 0
        for resType in resourceTypes {
            let dic  = ["patient": patientId,"code":"55423-8"]  // patient steps with code
            resType.type.search (dic) .perform(smart.server) { bundle, error in
                if nil != error {
                    
                    resType.error = error
                    
                } else {
                    
                    // TODO: for whatever mystic reason, simply passing "resType.type" into `entries(ofType:)` converts everything to `Resource`
                    // Have experimented with making `ResourceType` a protocol with associated type, to no avail
                    print("===>  Want type \(resType.type) [\(resType.type.resourceType.asJSON())]")
//                    resType.resources = bundle?.entries(ofType: resType.type, typeName: resType.type.resourceType) ?? []
                }
            }
            i += 1
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func show(error: Error, title: String) {
        let msg = (NSCocoaErrorDomain == error._domain) ? error.localizedDescription : "\(error)"
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
