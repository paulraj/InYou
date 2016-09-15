//
//  GPlusAPIHandler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 8/9/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

//https://www.googleapis.com/auth/tasks

import Foundation
import Alamofire

class GPlusAPIHandler {
    
    var accessToken: String = ""
    var userEmail: String = ""
    var mail: String = ""
    var imageUrl: String = ""
    var key = "AIzaSyAyCx0UP5J6RGz6LZ6vV9lkaw72-YQ6CfM"
    
    var contact = GoogleContact()
    
    init () {
        //self.contact = loggedInUser
        self.userEmail = loggedInUser.email
        self.accessToken = loggedInUser.accessToken
    }
    
    func listPeople(){
    
    }
    
    func getPeople(){
    
    }
    func searchPeople(){
    
    }
    
    func getGPlusContact(id: String, completionHandler: (data: NSDictionary?, error: NSError?) -> ()) {
        let url = NSURL(string: "https://www.googleapis.com/plus/v1/people/\(id)")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        Alamofire.Manager.sharedInstance.request(.GET, request, parameters: [ "access_token": self.accessToken,"alt": "json"])
                .responseJSON { response in
                    completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
            }
    }
    
    func getGPlusContactImpl(contact: GoogleContact, completionHandler: (data: String, error: NSError?) -> ()){
        self.contact = contact
        var _nextPageToken: String = ""
        getGPlusContact(contact.googlePlusId) { data, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(data!)
                //print(json)
                if json["occupation"] {
                    contact.occupation = json["occupation"].string!
                }
                if json["gender"] {
                    contact.gender = json["gender"].string!
                }
                if json["name"]["familyName"]{
                    contact.familyName = json["name"]["familyName"].string!
                }
                if json["name"]["givenName"] {
                    contact.givenName = json["name"]["givenName"].string!
                }
                if json["placesLived"] {
                    contact.location = json["placesLived"]["value"].string!
                }
                if json["relationshipStatus"] {
                    contact.relationshipStatus = json["relationshipStatus"].string!
                }
                if json["aboutMe"] {
                    contact.aboutMe = json["aboutMe"].string!
                }
            }
        }
    }
    
    func getGPlusContactActivities(id: String, completionHandler: (data: NSDictionary?, error: NSError?) -> ()) {
        let url = NSURL(string: "https://www.googleapis.com/plus/v1/people/\(id)/activities")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        Alamofire.Manager.sharedInstance.request(.GET, request, parameters: [ "access_token": self.accessToken,"alt": "json"])
            .responseJSON { response in
                completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
        }
    }
    
    func getGPlusContactActivitiesImpl(contact: GoogleContact, completionHandler: (data: String, error: NSError?) -> ()){
        self.contact = contact
        var _nextPageToken: String = ""
        getGPlusContactActivities(contact.googlePlusId) { data, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(data!)
                //print(json)
            }
        }
    }
    
    
    func getAllGPlusContacts(completionHandler: (data: String, error: NSError?) -> ()){
        self.getGPlusContactsImpl("") { data, error in
            completionHandler(data: data, error: error)
        }
    }
    
    func getGPlusContacts(nextPageToken: String, completionHandler: (data: NSDictionary?, error: NSError?) -> ()) {
        let url = NSURL(string: "https://www.googleapis.com/plus/v1/people/me/people/visible")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        if (!nextPageToken.isEmpty && nextPageToken != "No") {
            //print("have page token")
            Alamofire.Manager.sharedInstance.request(.GET, request, parameters: [ "access_token": self.accessToken,"alt": "json", "pageToken": nextPageToken,"max-results": 10000])
                .responseJSON { response in
                    completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
            }
        } else if (nextPageToken == "N" || nextPageToken.isEmpty) {
            Alamofire.Manager.sharedInstance.request(.GET, request, parameters: [ "access_token": self.accessToken,"alt": "json", "max-results": 100])
                .responseJSON { response in
                    completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
            }
        }
    }
    
    func getGPlusContactsImpl(nextPageToken:String, completionHandler: (data: String, error: NSError?) -> ()){
        var _nextPageToken: String = ""
        getGPlusContacts(nextPageToken) { data, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(data!)
                    //print(json["totalItems"])
                if (json["items"].count != 0 ) {
                    //print(json["items"].count)
                    for (index, contactJson):(String, JSON) in json["items"] {
                        var objectiveType = contactJson["objectType"].string!
                        if objectiveType == "person" {
                            var gc = GoogleContact()
                            gc.googlePlusId = contactJson["id"].string!
                            gc.name = contactJson["displayName"].string!
                            gc.googlePlusImageURL = contactJson["image"]["url"].string!
                            //gc.googlePlusUser = contactJson["isPlusUser"].bool! as Bool
                            //gc.email = contactJson["emails"][1]["value"].string! as String
                            gc.googlePlusUser = true
                            gc.profileImage = UIImage(named: "default_avatar.png")
                            googleContacts.append(gc)
                            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(gc), forKey: "googleContacts[\(googleContacts.count-1)]")
                        }
                    }
                    if (json["nextPageToken"].string != nil) {
                        //print("coming to nextPageToken")
                        _nextPageToken = json["nextPageToken"].string!
                        //print(_nextPageToken)
                        self.getGPlusContactsImpl(_nextPageToken) { data, error in
                            completionHandler(data: data, error: error)
                        }
                    } else {
                        completionHandler(data: "", error: error)
                    }
                }
                //print("photo image received for all contacts.")
                print("Total contacts are "+String(googleContacts.count))
                userDefaults.setObject(true, forKey: "hasContactsLoaded")
                userDefaults.setObject(googleContacts.count, forKey: "totalContacts")
                completionHandler(data: "", error:nil)
            }
        }
    }

    func loadGooglePlusContactImage(completionHandler: (data: String?, error: NSError?) -> ()){
        //print("loadGooglePlusContactImage()")
        var total = googleContacts.count
        //print("total"+String(total))
        let group = dispatch_group_create()
        for contact in googleContacts {
            if contact.googlePlusUser {
                var contactId = contact.googlePlusId
                var url = contact.googlePlusImageURL
                var contactEmailsCount = contact.emailCount
                dispatch_group_enter(group)
                GoogleContactsAPIHandler().getPhotoForGPlusContact(contactId, url: url) { contactId, data, error in
                    //var i = 0
                    if let image = UIImage(data: data!) {
                        for var i=0; i < total; i++ {
                            if googleContacts[i].googlePlusId == contactId {
                                googleContacts[i].profileImage = image
                                Cache().updateImageInUserDefaults(i, image: image)
                                break
                            }
                        }
                    }
                    dispatch_group_leave(group)
                }
            } else {
                dispatch_group_enter(group)
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            userDefaults.setObject(true, forKey: "contactsImageLoaded")
            //print("photo image received for all contacts.")
            completionHandler(data: "", error:nil)
        }
    }
    
    
}