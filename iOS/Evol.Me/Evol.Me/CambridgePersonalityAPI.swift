//
//  CambridgePersonalityFacebookAPI.swift
//  Evol.Me
//
//  Created by Paul.Raj on 8/23/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Parse
/*
Customer ID	998
API key	kh05tq7mn6aaaife3bhj8g958t
Company name	Perficient Inc
Name	Paul Raj
Address	3700 Beacon Ave
Apt 420
Fremont 94538 US
Contact	pauldeepakraj.r@gmail.com
4046424280

http://applymagicsauce.com/documentation.html

http://api-v2.applymagicsauce.com/auth

http://api-v2.applymagicsauce.com/like_ids?uid=882299955198198

*/

class ApplyMagicSauceFBAPI {
    
    var api_key = ""
    var customer_id = ""
    var api_url = ""
    //var api_like_url = ""
    
    func auth(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        //print("getting token...")
        var query = PFQuery(className:"API_keys")
        query.whereKey("API_NAME", equalTo:"Apply Magic Sauce")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error != nil {
                print("Error: \(error!) \(error!.userInfo)")
            } else if error == nil {
                for object in objects! {
                    self.api_key = object["API_KEY"] as! String
                    self.customer_id = object["CUSTOMER_ID"] as! String
                    self.api_url = object["API_URL"] as! String
                    //self.api_like_url = object["API_URL_2"] as! String
                }
                if self.api_key != "" && self.customer_id != "" && self.api_url != "" {
                    let url = NSURL(string: self.api_url )
                    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                    request.HTTPMethod = "POST"
                    var params = [ "customer_id":self.customer_id, "api_key": self.api_key ] as Dictionary<String, String>
                    var err: NSError?
                    
                    do {
                        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                    } catch {
                        print(error)
                        request.HTTPBody = nil
                        var error = NSError(domain: "Can not serialize JSON object.", code: 100, userInfo: [:] )
                        completionHandler(responseObject: ["":""] as NSDictionary, error: error)
                    }
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    Alamofire.request(request).responseJSON { response in
                        if response.result.isFailure {
                            print("Could not complete the request in auth \(response.result.error)")
                            completionHandler(responseObject: ["":""] as NSDictionary, error: response.result.error)
                        } else {
                            var json = JSON(response.result.value!)
                            //self.token = JSON["token"]
                            completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
                        }
                    }
                } else {
                    var error = NSError(domain: "No valid API keys found", code: 100, userInfo: [:] )
                    completionHandler(responseObject: ["":""] as NSDictionary, error: error)
                }
            }
        }
    }
    
    func invokeAPI(fbLikeIds: String, id: String, token: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        //print("fbLikeIds")
        //print(fbLikeIds)
        //print("id")
        //print(id)
        //print("token")
        //print(token)

        let URL = NSURL(string: "http://api-v2.applymagicsauce.com/like_ids")
        
        let parameters: [String: AnyObject] = ["traits":"BIG5,Female,Gay,Lesbian,Satisfaction_Life,Intelligence,Age,Concentration,Politics,Religion,Relationship","uid":id]
        let encodableURLRequest = NSURLRequest(URL: URL!)
        let encodedURLRequest = ParameterEncoding.URL.encode(encodableURLRequest, parameters: parameters).0
        
        let mutableURLRequest = NSMutableURLRequest(URL: encodedURLRequest.URL!)
        mutableURLRequest.HTTPMethod = "POST"
        //mutableURLRequest.HTTPBody =
        //print(fbLikeIds)
        let params = fbLikeIds
        do {
            //mutableURLRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
            mutableURLRequest.HTTPBody = try self.stringToNSData(params)
            //print(mutableURLRequest.HTTPBody)
        } catch {
            print(error)
            mutableURLRequest.HTTPBody = nil
        }
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(token, forHTTPHeaderField: "X-Auth-Token")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
            //print(response)
            //print(response.result.value)
            //print(data)
            //print(error)
            completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func stringToNSData(string: String) -> NSData {
        let data = NSMutableData()
        let terminator = [0]
        
        var stringNew = "["+string+"]"
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