//
//  ReceptivitiAPIHandler.swift
//  InYou
//
//  Created by Paul.Raj on 12/21/15.
//  Copyright © 2015 paul-anne. All rights reserved.
//

import Foundation
import Alamofire
import Parse

class ReceptivitiAPIHandler{
    var apiKey = "5670524246769a04b09a1861"
    var apiSecretKey = "QvZFdgf661PjM5ECAyQoj7iPTdrgs7xxUbDgL3YhVDk"
    
    func invokeAPI(contact: GoogleContact, text: String, completionHandler: (data: NSString?, error: NSError?) -> ()){
            var query = PFQuery(className:"API_keys")
            var apiKeyValue = ""
            var apiSecretKeyValue = ""
            query.whereKey("API_NAME", equalTo:"Receptiviti")
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error != nil {
                    print("Error: \(error!) \(error!.userInfo)")
                } else if error == nil {
                    for object in objects! {
                        //print(object["keyValue"] as! String)
                        apiKeyValue  = object["API_KEY"] as! String
                        apiSecretKeyValue = object["SECRET_KEY"] as! String
                        self.apiKey = apiKeyValue
                        self.apiSecretKey = apiSecretKeyValue
                        var personId = ""
                        let diceRoll = Int(arc4random_uniform(UInt32(999999999)))
                        
                        print("Receptiviti Writing Samples API...")
                        let url = NSURL(string: "https://api.receptiviti.com/api/person")
                        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                        request.HTTPMethod = "POST"
                        var params = ["gender": "1", "client_reference_id": String(diceRoll), "name": contact.name] as Dictionary<String, String>
                        var err: NSError?
                        //print(params)
                        do {
                            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                        } catch {
                            print(error)
                            request.HTTPBody = nil
                        }
                        
                        request.addValue(self.apiKey, forHTTPHeaderField: "X-API-KEY")
                        request.addValue(self.apiSecretKey, forHTTPHeaderField: "X-API-SECRET-KEY")
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.addValue("application/json", forHTTPHeaderField: "Accept")
                        
                        Alamofire.request(request).responseJSON { response in
                            if response.result.error != nil {
                                print("Could not complete the request. Error: \(error)")
                                completionHandler(data: "" as? NSString, error: response.result.error)
                            } else {
                                print("Receptiviti Writing Samples API...")
                                let json = JSON(response.result.value!)
                                //print(json)
                                personId = json["_id"].stringValue
                                //print("personId")
                                //print(personId)
                                if personId == "" {
                                    completionHandler(data: "" as? NSString, error: response.result.error)
                                } else {
                                    let url = NSURL(string: "https://api.receptiviti.com/api/person/"+personId+"/writing_samples")
                                    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                                    request.HTTPMethod = "POST"
                                    var params = ["content": text, "client_reference_id": String(diceRoll), "content_source": "1","sample_date":"2015-12-23T13:43:33.062929"] as Dictionary<String, String>
                                    var err: NSError?
                                    
                                    do {
                                        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                                    } catch {
                                        print(error)
                                        request.HTTPBody = nil
                                    }
                                    
                                    request.addValue(self.apiKey, forHTTPHeaderField: "X-API-KEY")
                                    request.addValue(self.apiSecretKey, forHTTPHeaderField: "X-API-SECRET-KEY")
                                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                                    
                                    Alamofire.request(request).responseJSON { response in
                                        if response.result.error != nil {
                                            print("Could not complete the request. Error: \(error)")
                                            completionHandler(data: "" as? NSString, error: response.result.error)
                                        } else {
                                            let json = JSON(response.result.value!)
                                            print(json)
                                            //print(json["receptiviti_scores"]["percentiles"]["independent"].stringValue)
                                            var thinkingStyle:NSString = json["receptiviti_scores"]["percentiles"]["thinking_style"].stringValue
                                            
                                            //print(json["receptiviti_scores"]["percentiles"]["type_a"].stringValue)
                                            if json["receptiviti_scores"]["percentiles"]["type_a"] > 50 {
                                                contact.personalityData.personalityType = "Type A"
                                            } else {
                                                contact.personalityData.personalityType = "Type B"
                                            }
                                            
                                            contact.personalityData.workhorse = json["receptiviti_scores"]["percentiles"]["workhorse"].stringValue
                                            contact.personalityData.thinkingStyleDegree = thinkingStyle.substringWithRange(NSRange(location: 0, length: 2))
                                            contact.personalityData.marketingIq = json["receptiviti_scores"]["percentiles"]["marketing_iq"].stringValue
                                            contact.personalityData.insecure = json["receptiviti_scores"]["percentiles"]["insecure"].stringValue
                                            //contact.personalityData.conscientous = responseDict["receptiviti_scores"]["percentiles"]["conscientious"].stringValue
                                            contact.personalityData.rewardBias = json["receptiviti_scores"]["percentiles"]["reward_bias"].stringValue
                                            contact.personalityData.impulsive = json["receptiviti_scores"]["percentiles"]["impulsive"].stringValue
                                            contact.personalityData.familyOrientedScore = json["receptiviti_scores"]["percentiles"]["family_oriented"].stringValue
                                            contact.personalityData.achievementDriven = json["receptiviti_scores"]["percentiles"]["achievment_driven"].stringValue
                                            contact.personalityData.happiness = json["receptiviti_scores"]["percentiles"]["happiness"].stringValue
                                            contact.personalityData.socialSkills = json["receptiviti_scores"]["percentiles"]["social_skills"].stringValue
                                            contact.personalityData.independentScore = json["receptiviti_scores"]["percentiles"]["independent"].stringValue
                                            contact.personalityData.powerDriven = json["receptiviti_scores"]["percentiles"]["power_driven"].stringValue
                                            contact.personalityData.cold = json["receptiviti_scores"]["percentiles"]["cold"].stringValue
                                            contact.personalityData.adjustment = json["receptiviti_scores"]["percentiles"]["adjustment"].stringValue
                                            //contact.personalityData.openness = responseDict["receptiviti_scores"]["percentiles"]["openness"].stringValue
                                            //contact.personalityData.agreeable = responseDict["receptiviti_scores"]["percentiles"]["agreeable"].stringValue
                                            contact.personalityData.depression = json["receptiviti_scores"]["percentiles"]["depression"].stringValue
                                            completionHandler(data: "" as? NSString, error: response.result.error)
                                            var count = 0
                                            for (index, snapshot):(String, JSON) in json["personality_snapshot"] {
                                                contact.personalityData.receptivitiSummary.append(snapshot["summary"].stringValue)
                                                contact.personalityData.receptivitiDescription.append(snapshot["description"].stringValue)
                                                //count++
                                            }
                                            
                                            contact.personalityData.personalitySummary = contact.personalityData.receptivitiSummary[0] + ":\n" +
                                                                contact.personalityData.receptivitiDescription[0] + "\n\n" +
                                                                contact.personalityData.receptivitiSummary[1] + ":\n" +
                                                                contact.personalityData.receptivitiDescription[1] + "\n\n" +
                                                                contact.personalityData.receptivitiSummary[2] + ":\n" +
                                                                contact.personalityData.receptivitiDescription[2]
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
}