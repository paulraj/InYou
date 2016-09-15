//
//  IBMWatsonAPI_Handler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/11/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

//Features to develop:
/*
Personality Text Features:
1. Big Five, Need and value
2. Intelligence and learning style
3. Find out strength and weakness
4. Behavior predictions - how to work with these people
5. Trust/confident score? show whichever is higher strength
*/

import Foundation
import Alamofire
import Parse

class IBMWatsonAPIHandler {
    
    //https://www.ng.bluemix.net/docs/#starters/mobile/ios/ios.html
    
    @IBOutlet weak var personalityLabel: UILabel!
    
    var _personalityLabel:String = ""
    
    var responseMessage = JSON("")
    var textSummary = ""
    var bigFive = [String]()
    
    /*
    below credntials creted to using paul.raj@bluehsieldca.com
    {
    "credentials": {
    "url": "https://gateway.watsonplatform.net/personality-insights/api",
    "username": "bf2025f1-1c6b-4ef8-8ac4-3f03db3b0171",
    "password": "6INTGO9Nqrxx"
    }
    }
    */
    
    //var appKey: String = "9dfedb06-d17b-4e58-b122-563d9f8548ab"
    //var appSecret: String = "f2d37c0ecbf1210c9d62f8e271ba47102fea16b9"
    //var username: String = "7c4cca52-bf9c-4039-aa8e-418dc19390e4"
    //var password: String = "NYowTQVsWHR6"
    //var authHeaderValue = "Basic N2M0Y2NhNTItYmY5Yy00MDM5LWFhOGUtNDE4ZGMxOTM5MGU0Ok5Zb3dUUVZzV0hSNg"
    
    /*
    below credntials creted to using pauldeepakraj.2011@gmail.com
    {
    "credentials": {
    "url": "https://gateway.watsonplatform.net/personality-insights/api",
    "username": "bf2025f1-1c6b-4ef8-8ac4-3f03db3b0171",
    "password": "6INTGO9Nqrxx"
    }
    }
    */
    //var appKey: String = "9dfedb06-d17b-4e58-b122-563d9f8548ab"
    //var appSecret: String = "f2d37c0ecbf1210c9d62f8e271ba47102fea16b9"
    var username: String = "f2410eca-e663-4934-be75-fb176d4f2cfa"
    var password: String = "8eLqgCc7I71I"
    //var authHeaderValue = "Basic ZjI0MTBlY2EtZTY2My00OTM0LWJlNzUtZmIxNzZkNGYyY2ZhOjhlTHFnQ2M3STcxSQ=="
    var authHeaderValue = "12345"
    
    init() {
        //print("init()")
        //super.init()
        var query = PFQuery(className:"API_keys")
        query.whereKey("API_NAME", equalTo:"IBM Watson Personality Insight")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.authHeaderValue = object["API_KEY"] as! String
                        //print(object["keyValue"])
                        //print(self.authHeaderValue)
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    /*
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    */
    /*override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    personalityLabel.text = " hello"
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }*/
    
    func getAPIKey(completionHandler: (apiKey: NSString, error: NSError?) -> ()){
        var query = PFQuery(className:"API_keys")
        var apiKeyValue = ""
        query.whereKey("API_NAME", equalTo:"IBM Watson Personality Insight")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        apiKeyValue  = object["API_KEY"] as! String
                        self.authHeaderValue = apiKeyValue
                        //print(object["keyValue"])
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            completionHandler(apiKey: "", error: error)
        }
    }
    
    func invokeAPI(contact: GoogleContact, mail: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        //print(mail)
        //self.getAPIKey(){ apiKey, error in
            var query = PFQuery(className:"API_keys")
            var apiKeyValue = ""
            query.whereKey("API_NAME", equalTo:"IBM Watson Personality Insight")
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error != nil {
                    print("Error: \(error!) \(error!.userInfo)")
                } else if error == nil {
                    for object in objects! {
                        apiKeyValue  = object["API_KEY"] as! String
                        self.authHeaderValue = apiKeyValue
                        //print(object["keyValue"])
                        //self.authHeaderValue = apiKey as! String
                     
                        print("IBM Watson Service...")
                        let url = NSURL(string: "https://gateway.watsonplatform.net/personality-insights/api/v2/profile")
                        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                        request.HTTPMethod = "POST"
                        print(mail)
                        var params = [mail:""] as Dictionary<String, String>
                        var err: NSError?
                        
                        do {
                            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                        } catch {
                            print(error)
                            request.HTTPBody = nil
                        }
                        
                        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
                        request.addValue(self.authHeaderValue, forHTTPHeaderField: "Authorization")
                        
                        Alamofire.request(request)
                            .responseJSON { response in
                                if response.result.isFailure {
                                    //print(response)
                                    print("Could not complete the request \(response.result.error)")
                                    contact.personalityData.personalitySummary = response.result.error!.description as String!
                                    contact.personalityData.personalitySummaryStatus = "ERROR"
                                } else {
                                    let json = JSON(response.result.value!)
                                    var messageToPass = ""
                                    self.responseMessage = json
                                    //print(json)
                                    //print(String(stringInterpolationSegment: json["word_count"].int)+" words")
                                    var _error = NSError(domain: "", code: 0,userInfo: [:] )
                                    if (json["error"] != nil) {
                                        //print(json["error"])
                                        //self.showError("Error", message: json["error"].stringValue, actionTitle: "OK")
                                        _error = NSError(domain: json["error"].stringValue, code: 100,userInfo: [:] )
                                    } else {
                                        //print(json)
                                        for (index,jsonTreeChildren):(String, JSON) in json["tree"]["children"] {
                                            if (jsonTreeChildren["name"].stringValue == "Big 5") {
                                                for (index, jsonTreeChildrenChildren):(String, JSON) in jsonTreeChildren["children"] {
                                                    /*if !(self.commonPercentile(jsonTreeChildrenChildren["percentage"].string!)) {
                                                    //do something
                                                    //textSummary
                                                    } else {
                                                    //nothing
                                                    }*/
                                                    messageToPass = messageToPass + "Big 5: ["
                                                    //messageToPass = messageToPass + jsonTreeChildrenChildren["name"].stringValue
                                                    //messageToPass = messageToPass + ", id: " + jsonTreeChildrenChildren["id"].stringValue
                                                    //messageToPass = messageToPass + ": " + jsonTreeChildrenChildren["percentage"].stringValue
                                                    //messageToPass = messageToPass + "]"
                                                    self.textSummary += ""
                                                    
                                                    //print(jsonTreeChildrenChildren["category"])
                                                    for (index, jsonTreeChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildren["children"] {
                                                        //for (index,jsonTreeChildrenChildrenChildren):(String,JSON) in jsonTreeChildrenChildren["children"] {
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Agreeableness") {
                                                            
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.traits!.agreeableness!.agreeablenessKey = "Agreeableness"
                                                            
                                                            var percentageDouble = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            contact.personalityData.traits!.agreeableness!.agreeablenessValue = percentageDouble
                                                            
                                                            if percentageDouble < 0.32 {
                                                                self.bigFive.append("L")
                                                            } else if percentageDouble > 0.68 {
                                                                self.bigFive.append("H")
                                                            }
                                                            
                                                            for (index, jsonTreeChildrenChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildrenChildren["children"]{
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Altruism"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    
                                                                    contact.personalityData.traits!.agreeableness!.altruism = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are more concerned with taking care of yourself than taking time for others. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You feel fulfilled when helping others and will go out of your way to do so. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Cooperation"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.agreeableness!.cooperation = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You do not shy away from contradicting others. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are easy to please and try to avoid confrontation. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Modesty"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.agreeableness!.modesty = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You hold yourself in high regard and are satisfied with who you are. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are uncomfortable being the center of attention. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Uncompromising"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    
                                                                    contact.personalityData.traits!.agreeableness!.morality = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are comfortable using every trick in the book to get what you want. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You think it is wrong to take advantage of others to get ahead. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Sympathy"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.agreeableness!.sympathy = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You think people should generally rely more on themselves than on others. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You feel what others feel and are compassionate toward them. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Trust"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.agreeableness!.trust = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are wary of other people's intentions and do not trust easily. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You believe the best of others and trust people easily. "
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Conscientiousness") {
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //var percentageNSString: NSNumber = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            contact.personalityData.traits!.conscientiousness!.conscientiousnessKey = "Conscientiousness"
                                                            //print(percentage)
                                                            var percentageDouble = Double(NSString(string: percentage).doubleValue*100)
                                                            contact.personalityData.traits!.conscientiousness!.conscientiousnessValue = percentageDouble
                                                            
                                                            if percentageDouble < 0.32 {
                                                                self.bigFive.append("L")
                                                            } else if percentageDouble > 0.68 {
                                                                self.bigFive.append("H")
                                                            }
                                                            
                                                            for (index, jsonTreeChildrenChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildrenChildren["children"]{
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Achievement striving"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.conscientiousness!.achievementStriving = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are content with your level of accomplishment and do not feel the need to set ambitious goals. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You set high goals for yourself and work hard to achieve them. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Cautiousness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.conscientiousness!.cautiousness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You would rather take action immediately than spend time deliberating making a decision. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You carefully think through decisions before making them. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Dutifulness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.conscientiousness!.dutifulness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You do what you want, disregarding rules and obligations. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You take rules and obligations seriously, even when they are inconvenient. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Orderliness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    
                                                                    contact.personalityData.traits!.conscientiousness!.orderliness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You do not make a lot of time for organization in your daily life. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You feel a strong need for structure in your life. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Self-discipline"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.conscientiousness!.selfDiscipline = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You have a hard time sticking with difficult tasks for a long period of time. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You can tackle and stick with tough tasks. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Self-efficacy"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.conscientiousness!.selfEfficacy = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You frequently doubt your ability to achieve your goals. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You feel you have the ability to succeed in the tasks you set out to do. "
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Extraversion") {
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //var percentageNSString: NSNumber = Double(NSString(string: percentage).doubleValue*100).doubleValue
                                                            
                                                            contact.personalityData.traits!.extraversion!.extraversionKey = "Extraversion"
                                                            var  percentageDouble = Double(NSString(string: percentage).doubleValue*100)
                                                            contact.personalityData.traits!.extraversion!.extraversionValue = percentageDouble
                                                            
                                                            if percentageDouble < 0.32 {
                                                                self.bigFive.append("L")
                                                            } else if percentageDouble > 0.68 {
                                                                self.bigFive.append("H")
                                                            }
                                                            
                                                            for (index, jsonTreeChildrenChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildrenChildren["children"]{
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Activity level"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.extraversion!.activityLevel = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You appreciate a relaxed pace in life. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You enjoy a fast-paced, busy schedule with many activities. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Assertiveness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.extraversion!.assertiveness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You prefer to listen than to talk, especially in group settings. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You tend to speak up and take charge of situations, and you are comfortable leading groups. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Cheerfulness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    ////print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.extraversion!.cheerfulness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are generally serious and do not joke much. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are a joyful person and share that joy with the world. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Excitement-seeking"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.extraversion!.excitementSeeking = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You prefer activities that are quiet, calm, and safe. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are excited by taking risks and feel bored without lots of action going on. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Outgoing"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.extraversion!.friendliness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are a private person and do not let many people in. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You make friends easily and feel comfortable around other people. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Gregariousness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.extraversion!.gregariousness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You have a strong desire to have time to yourself. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You enjoy being in the company of others. "
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Emotional range") {
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //var percentageNSString: NSNumber = Double(NSString(string: percentage).doubleValue*100).doubleValue
                                                            
                                                            contact.personalityData.traits!.neuroticism!.neuroticismKey = "EmotionalRange"
                                                            //print(percentage)
                                                            var percentageDouble = Double(NSString(string: percentage).doubleValue*100)
                                                            contact.personalityData.traits!.neuroticism!.neuroticismValue = percentageDouble
                                                            
                                                            if percentageDouble < 0.32 {
                                                                self.bigFive.append("L")
                                                            } else if percentageDouble > 0.68 {
                                                                self.bigFive.append("H")
                                                            }
                                                            for (index, jsonTreeChildrenChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildrenChildren["children"]{
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Fiery"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.neuroticism!.anger = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "It takes a lot to get you angry. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You have a fiery temper, especially when things do not go your way. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Prone to worry"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.neuroticism!.anxiety = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You tend to feel calm and self-assured. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You tend to worry about things that might happen. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Melancholy"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.neuroticism!.depression = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are generally comfortable with yourself as you are. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You think quite often about the things you are unhappy about. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Immoderation"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.neuroticism!.immoderation = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You have control over your desires, which are not particularly intense. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You feel your desires strongly and are easily tempted by them. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Self-consciousness"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.neuroticism!.selfConsciousness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are hard to embarrass and are self-confident most of the time. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are sensitive about what others might be thinking of you. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Susceptible to stress"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    messageToPass = messageToPass + "]"
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.neuroticism!.vulnerability = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You handle unexpected events calmly and effectively. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are easily overwhelmed in stressful situations. "
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Openness") {
                                                            
                                                            //if (0.5-(jsonTreeChildrenChildrenChildren["percentage"] as? NSString)!.DoubleValue > 0.18) {
                                                            // } else { }
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //var percentageNSString: NSNumber = Double(NSString(string: percentage).doubleValue*100).doubleValue
                                                            
                                                            contact.personalityData.traits!.openness!.opennessKey = "Openness"
                                                            //print(percentage)
                                                            
                                                            var percentageDouble = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            contact.personalityData.traits!.openness!.opennessValue = percentageDouble
                                                            
                                                            if percentageDouble < 0.32 {
                                                                self.bigFive.append("L")
                                                            } else if percentageDouble > 0.68 {
                                                                self.bigFive.append("H")
                                                            }
                                                            
                                                            for (index, jsonTreeChildrenChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildrenChildren["children"]{
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Adventurousness"){
                                                                    messageToPass = messageToPass + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.openness!.adventurousness = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You enjoy familiar routines and prefer not to deviate from them. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are eager to experience new things. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Artistic interests"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.openness!.artisticInterests = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You are less concerned with artistic or creative activities than most people. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You enjoy beauty and seek out creative experiences. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Emotionality"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.openness!.emotionality = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You do not frequently think about or openly express your emotions. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are aware of your feelings and how to express them. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Imagination"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.openness!.imagination = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You prefer facts over fantasy. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You have a wild imagination. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Intellect"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.openness!.intellect = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You prefer dealing with the world as it is, rarely considering abstract ideas. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You are open to and intrigued by new ideas and love to explore them. "
                                                                        }
                                                                    }
                                                                }
                                                                if (jsonTreeChildrenChildrenChildrenChildren["name"] == "Authority-challenging"){
                                                                    messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildrenChildren["name"].stringValue + ": " +
                                                                        (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    //print(jsonTreeChildrenChildrenChildrenChildren["sampling_error"])
                                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                                    
                                                                    contact.personalityData.traits!.openness!.liberalism = Double(NSString(string: percentage).doubleValue*100)
                                                                    
                                                                    if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                        var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                        if percentageNSString < 0.32 {
                                                                            self.textSummary += "You prefer following with tradition to maintain a sense of stability. "
                                                                        } else if percentageNSString > 0.68 {
                                                                            self.textSummary += "You prefer to challenge authority and traditional values to help bring about change. "
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            if (jsonTreeChildren["name"].stringValue == "Needs") {
                                                for (index, jsonTreeChildrenChildren):(String, JSON) in jsonTreeChildren["children"] {
                                                    /*if !(self.commonPercentile(jsonTreeChildrenChildren["percentage"].string!)) {
                                                    //do something
                                                    //textSummary
                                                    } else {
                                                    //nothing
                                                    }*/
                                                    
                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                    
                                                    contact.personalityData.needs?.needValue = Double(NSString(string: percentage).doubleValue*100)
                                                    
                                                    contact.personalityData.needs?.needKey = jsonTreeChildrenChildren["name"].stringValue
                                                    
                                                    //print(jsonTreeChildrenChildren["name"])
                                                    //print(jsonTreeChildrenChildren["id"])
                                                    //print(jsonTreeChildrenChildren["percentage"])
                                                    //print(jsonTreeChildrenChildren["category"])
                                                    messageToPass = messageToPass + ", Needs: ["
                                                    //messageToPass = messageToPass + jsonTreeChildrenChildren["name"].stringValue
                                                    //messageToPass = messageToPass + ", id: " + jsonTreeChildrenChildren["id"].stringValue
                                                    //messageToPass = messageToPass + ": " + jsonTreeChildrenChildren["percentage"].stringValue
                                                    //messageToPass = messageToPass + "] "
                                                    self.textSummary += "\n\nNeeds:\n"
                                                    for (index, jsonTreeChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildren["children"] {
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Challenge"){
                                                            messageToPass = messageToPass + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.challenge = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You have an urge to achieve, to succeed, and to take on challenges. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Closeness"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.closeness = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You relish being connected to family and setting up a home. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Curiosity"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.curiosity = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You have a desire to discover, find out, and grow. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Excitement"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.excitement = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You want to get out there and live life, have upbeat emotions, and want to have fun. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Harmony"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.harmony = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You appreciate other people, their viewpoints, and their feelings. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Ideal"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.ideal = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You desire perfection and a sense of community. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Liberty"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.liberty = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You have a desire for fashion and new things, as well as the need for escape. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Love"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.love = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You enjoy social contact, whether one-to-one or one-to-many. Any brand involved in bringing people together taps this need."
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Practicality"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.practicality = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You have a desire to get the job done, a desire for skill and efficiency, which can include physical expression and experience. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Self-expression"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.selfExpression = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You enjoy discovering and asserting their own identities. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Stability"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.stability = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You seek equivalence in the physical world. They favor the sensible, the tried and tested. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Structure"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4)) + "]"
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.needs!.structure = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You exhibit groundedness and a desire to hold things together. They need things to be well organized and under control. "
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            if (jsonTreeChildren["name"].stringValue == "Values") {
                                                for (index, jsonTreeChildrenChildren):(String, JSON) in jsonTreeChildren["children"] {
                                                    /*if !(self.commonPercentile(jsonTreeChildrenChildren["percentage"].string!)) {
                                                    //do something
                                                    //textSummary
                                                    } else {
                                                    //nothing
                                                    }*/
                                                    var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                    
                                                    contact.personalityData.values?.valueValue = Double(NSString(string: percentage).doubleValue*100)
                                                    
                                                    contact.personalityData.values?.valueKey = jsonTreeChildrenChildren["name"].stringValue
                                                    
                                                    //print(jsonTreeChildrenChildren["name"])
                                                    //print(jsonTreeChildrenChildren["id"])
                                                    //print(jsonTreeChildrenChildren["percentage"])
                                                    //print(jsonTreeChildrenChildren["category"])
                                                    messageToPass = messageToPass + ", Values: ["
                                                    //messageToPass = messageToPass + jsonTreeChildrenChildren["name"].stringValue
                                                    //messageToPass = messageToPass + ", id: " + jsonTreeChildrenChildren["id"].stringValue
                                                    //messageToPass = messageToPass + ": " + jsonTreeChildrenChildren["percentage"].stringValue
                                                    //messageToPass = messageToPass + "]"
                                                    self.textSummary += "\n\nValues:\n"
                                                    var valueSummary = ""
                                                    for (index, jsonTreeChildrenChildrenChildren):(String, JSON) in jsonTreeChildrenChildren["children"] {
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Conservation"){
                                                            messageToPass = messageToPass + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.values!.conservation = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You emphasize self-restriction, order, and resistance to change. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Openness to change"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.values!.opennessToChange = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You emphasize independent action, thought, and feeling, as well as a readiness for new experiences. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Hedonism"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.values!.hedonism = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You seek pleasure and sensuous gratification for themselves. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Self-enhancement"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.values!.selfEnhancement = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You seek personal success for yourselves. "
                                                                }
                                                            }
                                                        }
                                                        if (jsonTreeChildrenChildrenChildren["name"] == "Self-transcendence"){
                                                            messageToPass = messageToPass + ", " + jsonTreeChildrenChildrenChildren["name"].stringValue + ": " +
                                                                (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4)) + "]"
                                                            //print(jsonTreeChildrenChildrenChildren["sampling_error"])
                                                            var percentage: String = (self.addTrailingChars(jsonTreeChildrenChildrenChildren["percentage"].stringValue) as NSString).substringWithRange(NSRange(location: 0, length: 4))
                                                            
                                                            contact.personalityData.values!.selfTranscendence = Double(NSString(string: percentage).doubleValue*100)
                                                            
                                                            if (self.considerPercentage(percentage, samplingError: jsonTreeChildrenChildrenChildren["sampling_error"].stringValue)) {
                                                                var percentageNSString: NSNumber = (percentage as NSString).doubleValue
                                                                if percentageNSString < 0.32 {
                                                                    self.textSummary += ""
                                                                } else if percentageNSString > 0.68 {
                                                                    self.textSummary += "You show concern for the welfare and interests of others. "
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        //print(json.stringValue)
                                        //self.textSummary += "\n\nTwo Dimension:\n"
                                        let traitsValue: String = self.twoDimension()
                                        contact.personalityData.personalityTraits = traitsValue
                                    }
                                    
                                    //self.message = self.responseDict
                                    //HomeViewController().moveNow()
                                    //self.showError("OK", message: "OK", actionTitle: "ok")
                                    contact.personalityData.personalitySummary = self.textSummary as String
                                    if self.textSummary.isEmpty {
                                        contact.personalityData.personalitySummary = _error.domain as String!
                                        contact.personalityData.personalitySummaryStatus = "ERROR"
                                    } else {
                                        contact.personalityData.personalitySummaryStatus = "SUCCESS"
                                    }
                                    
                                    completionHandler(data: self.textSummary as? NSString, error: _error)
                                }
                        }
                    }
                }
            }
        //}
        }
        
        /*
        func commonPercentile(percentile: String) -> Bool {
        return (0.5 - (percentile as? NSString)!.DoubleValue > 0.18)
        }
        */
        /*func showError(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title,
        message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        }*/
        
        func addTrailingChars(trait: String) -> String {
            var addedString: String = ""
            if (trait.characters.count < 4) {
                addedString = trait + ".0000"
            } else {
                addedString = trait
            }
            return addedString
        }
        
        func considerPercentage(percentage: String, samplingError: String) -> Bool {
            var percentageNSString: NSNumber = (percentage as NSString).doubleValue
            var _samplingError: NSNumber = (samplingError as NSString).doubleValue
            if (_samplingError<0.2) {
                return (percentageNSString > 0.68 || percentageNSString < 0.32) ? true : false
            } else{
                return false
            }
        }
        
        func twoDimension() -> String {
            //Agreeableness
            var personalityTopTraits = ""
            switch self.bigFive[0] {
            case "H":
                switch self.bigFive[1] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Helpful, Considerate"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Unpretentious, Self-effacing"
                default:
                    print("nothing")
                }
                switch self.bigFive[2] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Happy, Friendly"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Soft-hearted, agreeable"
                default:
                    print("nothing")
                }
                switch self.bigFive[3] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Sensitive, Passionate"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Generous, Pleasant, Tolerant"
                default:
                    print("nothing")
                }
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Diplomatic, Idealistic"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Dependent, Simple"
                default:
                    print("nothing")
                }
            case "L":
                switch self.bigFive[1] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Strict, Rigid, Stern"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Distrustful, Uncooperative"
                default:
                    print("nothing")
                }
                switch self.bigFive[2] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Combative, Rough"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Cynical, Detached"
                default:
                    print("nothing")
                }
                switch self.bigFive[3] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Critical, selfish"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Insensitive, Unaffectionate"
                default:
                    print("nothing")
                }
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Eccentric, Individualistic"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Narrow-minded, Callous"
                default:
                    print("nothing")
                }
            default:
                print("nothing")
            }
            //Conscientiousness
            switch self.bigFive[1] {
            case "H":
                switch self.bigFive[2] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Ambitious, Competitive"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Cautious, Punctual"
                default:
                    print("nothing")
                }
                switch self.bigFive[3] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Particular, High-strung"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Consistent, Logical"
                default:
                    print("nothing")
                }
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Sophisticated, Perfectionistic"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Traditional, Conventional"
                default:
                    print("nothing")
                }
            case "L":
                switch self.bigFive[2] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Unruly, Reckless"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Indecisive, Unambitious"
                default:
                    print("nothing")
                }
                switch self.bigFive[3] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Forgetful, Impulsive"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Informal, Low-key"
                default:
                    print("nothing")
                }
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Unconventional, Quirky"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "llogical, Immature"
                default:
                    print("nothing")
                }
            default:
                print("nothing")
            }
            //Extraversion
            switch self.bigFive[2] {
            case "H":
                switch self.bigFive[3] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Explosive, Wordy"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Courageous"
                default:
                    print("nothing")}
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Expressive, Witty"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Verbose"
                default:
                    print("nothing")
                }
            case "L":
                switch self.bigFive[3] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Pessimistic, Cowardly"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Peaceful, Modest"
                default:
                    print("nothing")
                }
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Introspective, Contemplating"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Unadventurous, Passive"
                default:
                    print("nothing")
                }
            default:
                print("nothing")
            }
            //Emotional Range
            switch self.bigFive[3] {
            case "H":
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Excitable, Passionate"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Apprehensive"
                default:
                    print("nothing")
                }
            case "L":
                switch self.bigFive[4] {
                case "H":
                    personalityTopTraits = personalityTopTraits + " , " + "Creative, Intellectual"
                case "L":
                    personalityTopTraits = personalityTopTraits + " , " + "Insensitive"
                default:
                    print("nothing")
                }
            default:
                print("nothing")
            }
            return String(personalityTopTraits.characters.dropFirst(3))+"."
        }
        
        /*
        for (bigFiveName: String, percentage: String) in self.bigFive {
        switch bigFiveName {
        case "Agreeableness ":
        print()
        case "Openness":
        print()
        case "Conscientiousness":
        print()
        case "Extraversion":
        print()
        case "Neuroticism":
        print()
        default:
        print()
        }
        if () {
        
        } else {
        
        }
        }
        
        
        //}
        */
        /*func GetTextSummary(){
        var local = self.responseMessage
        //self.responseMessage.map({
        //   (0.5-($0["tree"]["children"]["children"]["children"]["percentage"] as? NSString)!.DoubleValue > 0.18)
        //})
        
        for (name: String, valueJson: JSON) in self.responseMessage["tree"]["children"]["children"]["children"] {
        if (0.5-(valueJson["percentage"] as? NSString)!.DoubleValue > 0.18) {
        self.textSummary += ""
        
        } else{
        
        }
        }
        }*/
        /*
        func dsds(json: JSON){
        for (index: String, jsonTreeChildren: JSON) in json["tree"]["children"] {
        if (jsonTreeChildren["name"].stringValue == "Big 5 ") {
        for (index: String, jsonTreeChildrenChildren: JSON) in jsonTreeChildren["children"] {
        if(self.commonPercentile){
        self.responseMessage["tree"]["children"][]
        }
        print(jsonTreeChildrenChildren["name"])
        print(jsonTreeChildrenChildren["id"])
        print(jsonTreeChildrenChildren["percentage"])
        print(jsonTreeChildrenChildren["category"])
        
        }
        }
        
        if (jsonTreeChildren["name"].stringValue == "Needs") {
        for (index: String, jsonTreeChildrenChildren: JSON) in jsonTreeChildren["children"] {
        print(jsonTreeChildrenChildren["name"])
        print(jsonTreeChildrenChildren["id"])
        print(jsonTreeChildrenChildren["percentage"])
        print(jsonTreeChildrenChildren["category"])
        
        }
        }
        if (jsonTreeChildren["name"].stringValue == "Values") {
        for (index: String, jsonTreeChildrenChildren: JSON) in jsonTreeChildren["children"] {
        print(jsonTreeChildrenChildren["name"])
        print(jsonTreeChildrenChildren["id"])
        print(jsonTreeChildrenChildren["percentage"])
        print(jsonTreeChildrenChildren["category"])
        
        }
        }
        }
        
        }
        */
}
