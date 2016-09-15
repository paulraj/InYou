//
//  TraitifyAPIHandler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 6/26/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

/*
https://developer.traitify.com/documentation

EVOL-ME

Public Key: 4uo3h6cfk89mr32vvkiivu8och
Secret Key: vg0eogjbvi6u7k5b61jbac7qqq
*/


import Foundation
import Alamofire

class TraitifyAPIHandler {

    var authHeaderValue = "Basic 882o61d9pc4l08vp14d0cejn7t:x"
    var assessment_id = ""
    
    func listDecks(){
        print("Traitify Service...")
        let url = NSURL(string: "https://api.traitify.com/v1/decks")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { response in
                if response.result.isFailure {
                    print("Could not complete the request \(response.result.error)")
                } else {
                    let json = JSON(response.result.value!)
                    print(json)
                    self.getAssessments()
                }
        }
    }
    
    func getAssessments(){
        print("getAssessments")
        let url = NSURL(string: "https://api.traitify.com/v1/assessments")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        var params = ["deck_id":"career-deck"] as Dictionary<String, String>
        var err: NSError?
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch {
            print(error)
            request.HTTPBody = nil
        }

        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        Alamofire.request(request).responseJSON { response in
            if response.result.isFailure {
                print("Could not complete the request \(response.result.error)")
            } else {
                let json = JSON(response.result.value!)
                print(json)
                self.assessment_id = json["id"].string!
                self.listSlides()
            }
        }
    }
    
    func listSlides(){
        print("listSlides")
        let url = NSURL(string: "https://api.traitify.com/v1/assessments/\(assessment_id)/slides")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isFailure {
                print("Could not complete the request \(response.result.error)")
            } else {
                let json = JSON(response.result.value!)
                print(json)
                self.getResults()
            }
        }
    }
    
    func getResults(){
        print("getResults")
        let url = NSURL(string: "https://api.traitify.com/v1/assessments/\(assessment_id)?data=blend,types,traits,career_matches")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { response in
            if response.result.isFailure {
                print("Could not complete the request \(response.result.error)")
            } else {
                let json = JSON(response.result.value!)
                print(json)
            }
        }
    }
}
