//
//  FullContactAPIHandler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 9/16/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import Alamofire
import Parse

class FullContactAPI {
    
    //var api_key = "5f86438e00205f11"
    var api_key = ""
    
    // var contact = GoogleContact()
    
    init(){
        
    }
    
    func getByEmail(email: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()){
        Alamofire.request(.GET, "https://api.fullcontact.com/v2/person.json",
            parameters: ["email": email, "apiKey": api_key])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
   
    func getByFacebook(facebookId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()){
        Alamofire.request(.GET, "https://api.fullcontact.com/v2/person.json",
            parameters: ["facebookId": facebookId, "apiKey": api_key])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getByTwitter(twitterHandle: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()){
        Alamofire.request(.GET, "https://api.fullcontact.com/v2/person.json",
            parameters: ["twitter": twitterHandle, "apiKey": api_key])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getPhoto(url:String, completionHandler: (data: NSData?, error: NSError?) -> Void){
        Alamofire.request(.GET, url)
            .responseJSON { response in
                completionHandler(data: response.data as! NSData?, error: response.result.error)
        }
    }
    
    func getAllDetails(contact: GoogleContact, completionHandler: (data: NSString?, error: NSString?) -> ()){
        //print("calling Full Contact API")
        var query = PFQuery(className:"API_keys")
        query.whereKey("API_NAME", equalTo:"Full Contact")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.api_key = object["API_KEY"] as! String
                        
                        if !contact.email.isEmpty {
                            self.getByEmail(contact.email) { data, error in
                                //print(data)
                                if error != nil {
                                    print(error)
                                } else {
                                    let json = JSON(data!)
                                    self.populateDetails(json, contact: contact) { data, error in
                                        completionHandler(data: "Done" as NSString?, error: error)
                                    }
                                }
                            }
                        } else if !contact.twitterScreenName.isEmpty {
                            self.getByTwitter(contact.twitterScreenName) { data, error in
                                //print(data)
                                if error != nil {
                                    print(error)
                                } else {
                                    let json = JSON(data!)
                                    self.populateDetails(json, contact: contact) { data, error in
                                        completionHandler(data: "Done" as NSString?, error: error)
                                    }
                                }
                            }
                        } else if !contact.facebookId.isEmpty {
                            //print("contact.facebookId not empty")
                            //print(contact.facebookId)
                            self.getByFacebook(contact.facebookId) { data, error in
                                //print(data)
                                if error != nil {
                                    print(error)
                                } else {
                                    let json = JSON(data!)
                                    self.populateDetails(json, contact: contact) { data, error in
                                        completionHandler(data: "Done" as NSString?, error: error)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func populateDetails(json: JSON, contact: GoogleContact, completionHandler: (data: NSString?, error: NSString?) -> Void){
        if (json["contactInfo"].count != 0){
            //print("in contactInfo")
            contact.familyName = json["contactInfo"]["familyName"].stringValue
            contact.lastName = json["contactInfo"]["familyName"].stringValue
            contact.firstName = json["contactInfo"]["givenName"].stringValue
            contact.givenName = json["contactInfo"]["givenName"].stringValue
            contact.name = json["contactInfo"]["fullName"].stringValue
            for (index, website):(String, JSON) in json["websites"] {
                contact.website = website["url"].stringValue
                break
            }
        }
        if (json["demographics"].count != 0 ){
            contact.gender = json["demographics"]["gender"].stringValue
            if (json["demographics"]["locationDeduced"].count != 0) {
                contact.location = json["demographics"]["locationDeduced"]["deducedLocation"].stringValue
            }
        }
        if (json["digitalFootprint"].count != 0 ){
            contact.popularityScore  = json["digitalFootprint"]["scores"]["value"].stringValue
        }
        if (json["socialProfiles"].count != 0 ){
            for (index, profile):(String, JSON) in json["socialProfiles"] {
                var account = SocialProfile()
                account.bio = profile["bio"].stringValue
                account.type = profile["type"].stringValue
                account.username = profile["username"].stringValue
                account.id = profile["id"].stringValue
                account.url = profile["url"].stringValue
                account.followers = profile["followers"].intValue
                account.following = profile["following"].intValue
                contact.socialProfiles.append(account)
            }
        }
        if (json["organizations"].count != 0 ) {
            for (index, organization):(String, JSON) in json["organizations"] {
                contact.organization = organization["name"].stringValue
            }
        }
        if (json["photos"].count != 0 ) {
            let group = dispatch_group_create()
            for  (index, photo):(String, JSON)  in json["photos"] {
                //print(index)
                var url = photo["url"].stringValue
                dispatch_group_enter(group)
                self.getPhoto(url) { data, error in
                    if let image = UIImage(data: data!) {
                        //print("image loaded now.")
                        contact.images.append(image)
                    }
                    dispatch_group_leave(group)
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue()) {
                completionHandler(data: "Done" as NSString?, error: "")
            }
        } else {
            completionHandler(data: "Done" as NSString?, error: "")
        }
    }
}