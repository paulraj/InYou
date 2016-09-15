//
//  IBMWatsonToneAnalyzerAPIHandler.swift
//  InYou
//
//  Created by Paul.Raj on 02/07/16.
//  Copyright (c) 2016 paul-anne. All rights reserved.
//

import Foundation
import Alamofire
import Parse

class IBMWatsonToneAnalyzerAPIHandler {
    
    var responseMessage = JSON("")
    var textSummary = ""
    var bigFive = [String]()
    
    var username: String = ""
    var password: String = ""
    var authHeaderValue = ""
    var url = ""
    
    init() {
        print("init()")
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
    
    func invokeAPI(contact: GoogleContact, text: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        print(text)
        //self.getAPIKey(){ apiKey, error in
        var query = PFQuery(className:"API_keys")
        query.whereKey("API_NAME", equalTo:"IBM Watson Tone Analyzer")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                print("Error: \(error!) \(error!.userInfo)")
            } else if error == nil {
                for object in objects! {
                    self.authHeaderValue = object["API_KEY"] as! String
                    self.url = object["API_URL"] as! String
                    print(self.url)
                    print(self.authHeaderValue)
                    
                    //self.authHeaderValue = apiKey as! String
                    
                    print("IBM Watson Tone Analyzer...")
                    let url = NSURL(string: self.url)
                    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                    request.HTTPMethod = "POST"
                    //print(text)
                    var params = ["data":text] as Dictionary<String, String>
                    var err: NSError?
                    
                    do {
                        //request.HTTPBody = self.stringToNSData(text)
                        //request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
                    } catch {
                        print("catch")
                        print(error)
                        request.HTTPBody = nil
                    }
                    //print(request.HTTPBody)
                    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
                    request.addValue(self.authHeaderValue, forHTTPHeaderField: "Authorization")
                    
                    Alamofire.request(request).responseJSON { response in
                            if response.result.isFailure {
                                print(response)
                                print("Could not complete the request \(response.result.error)")
                                //contact.personalityData.personalitySummary = response.result.error!.description as String!
                                //contact.personalityData.personalitySummaryStatus = "ERROR"
                            } else {
                                let json = JSON(response.result.value!)
                                var messageToPass = ""
                                self.responseMessage = json
                                print(json)
                                //print(String(stringInterpolationSegment: json["word_count"].int)+" words")
                                var _error = NSError(domain: "", code: 0,userInfo: [:] )
                                if (json["error"] != nil) {
                                    print(json["error"])
                                    //self.showError("Error", message: json["error"].stringValue, actionTitle: "OK")
                                    _error = NSError(domain: json["error"].stringValue, code: 100,userInfo: [:] )
                                } else {
                                    //print(json)
                                    for (index,toneCategory):(String, JSON) in json["document_tone"]["tone_categories"] {
                                        if (toneCategory["category_id"].stringValue == "emotion_tone") {
                                            for (index, emotionTone):(String, JSON) in toneCategory["tones"] {
                                                print(emotionTone["tone_id"])
                                                print(emotionTone["score"])
                                                
                                                
                                            }
                                        }
                                        if (toneCategory["category_id"].stringValue == "writing_tone") {
                                            for (index, writingTone):(String, JSON) in toneCategory["tones"] {
                                                print(writingTone["tone_id"])
                                                print(writingTone["score"])
                                            }
                                        }
                                        if (toneCategory["category_id"].stringValue == "social_tone") {
                                            for (index, writingTone):(String, JSON) in toneCategory["tones"] {
                                                print(writingTone["tone_id"])
                                                print(writingTone["score"])
                                                
                                            }
                                        }
                                    }
                                }
                                completionHandler(data: self.textSummary as? NSString, error: _error)
                            }
                    }
                }
            }
        }
    }
    func stringToNSData(string: String) -> NSData {
        let data = NSMutableData()
        let terminator = [0]
        
        var stringNew = string
        if let encodedString = stringNew.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            data.appendData(encodedString)
            data.appendBytes(terminator, length: 1)
        }
        else {
            NSLog("Cannot encode string \"\(string)\"")
        }
        return data
    }
}
