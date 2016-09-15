//
//  FacebookAPIHandler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 6/25/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

//https://developers.facebook.com/quickstarts/1626225097592571/?platform=ios

import Foundation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

var likeIds = ""
var id = ""

class FB {
    var likeIds = ""
    
    func me(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,about,bio,birthday,relationship_status,first_name,gender,last_name,location,picture.width(1600).height(1600)", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("me")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                //print("fetched user: \(result)")
                var json = JSON(result)
                //print(json)
                //print
                completionHandler(responseObject: json, error: error)
            }
        })
    }
    
    func friend_details(id : String?,completionHandler: (data: JSON?, error: NSError?) -> ()) {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/"+id!+"?fields=id,name,about,bio,birthday,relationship_status,first_name,gender,last_name,location,picture.width(1600).height(1600)", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("friend_details")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                var json = JSON(result)
                print(json)
                completionHandler(data: json, error: error)
            }
        })
    }
    
    func feed(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/feed", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("feed")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
   
    func home(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/home", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("home")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
                
            }
        })
    }
    
    func profilePicture(completionHandler: (responseObject: JSON?, error: NSError?) -> ()){
        //print("profilePicture")
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["type":"large","redirect":"true","width":"400","height":"400"], HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("home")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                var json = JSON(result)
                //print("\(json)")
                completionHandler(responseObject: json, error: error)
            }
        })
    }
    
    func likes(nextCursor : String?, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        //print("likes")
        var qry : String = "/me/likes"
        var parameters = Dictionary<String, String>() as? Dictionary
        if nextCursor == nil {
            parameters = nil
        } else {
            parameters!["after"] = nextCursor
        }
        var request = FBSDKGraphRequest(graphPath: qry, parameters: parameters)
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                var json = JSON(result)
                //print(json)
                if json["data"] != nil {
                    for (index, like):(String, JSON) in json["data"] {
                        //print(like["id"])
                        if self.likeIds == "" {
                            self.likeIds =  like["id"].stringValue
                        } else {
                            self.likeIds =  like["id"].stringValue + "," + self.likeIds
                        }
                    }
                } else {
                    //print("zero likes")
                }
                if let after = ((result.objectForKey("paging") as? NSDictionary)?.objectForKey("cursors") as? NSDictionary)?.objectForKey("after") as? String {
                    self.likes(after) { responseObject, error in
                            if error != nil {
                                print("Could not complete the request \(error)")
                                completionHandler(responseObject:  [] as JSON, error: error)
                            } else {
                                completionHandler(responseObject:  responseObject, error: error)
                            }
                    }
                } else {
                    ApplyMagicSauceFBAPI().auth() { responseObject, error in
                        if error != nil {
                            print("Could not complete the request in ApplyMagicSauceFBAPI auth \(error)")
                        } else {
                            let json = JSON(responseObject!)
                            //print(json)
                            var tokenToPass  = json["token"].stringValue
                            //print("ApplyMagicSauceFBAPI now ")
                            //print(id)
                            ApplyMagicSauceFBAPI().invokeAPI(self.likeIds, id: id, token: tokenToPass) { responseObject, error in
                                if error != nil {
                                    print("Could not complete the request in ApplyMagicSauceFBAPI invokeAPI \(error)")
                                    completionHandler(responseObject:  [] as JSON, error: error)
                                } else {
                                    var json = JSON(responseObject!)
                                    //print(json)
                                    completionHandler(responseObject:  json, error: error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func friend_likes(id:String, nextCursor : String?, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        //print("likes")
        var qry : String = "/"+id+"/likes"
        var parameters = Dictionary<String, String>() as? Dictionary
        if nextCursor == nil {
            parameters = nil
        } else {
            parameters!["after"] = nextCursor
        }
        var request = FBSDKGraphRequest(graphPath: qry, parameters: parameters)
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                var json = JSON(result)
                //print(json)
                if json["data"] != nil {
                    for (index, like):(String, JSON) in json["data"] {
                        //print(like["id"])
                        if self.likeIds == "" {
                            self.likeIds =  like["id"].stringValue
                        } else {
                            self.likeIds =  like["id"].stringValue + "," + self.likeIds
                        }
                    }
                } else {
                    print("zero likes")
                }
                if let after = ((result.objectForKey("paging") as? NSDictionary)?.objectForKey("cursors") as? NSDictionary)?.objectForKey("after") as? String {
                    self.friend_likes(id, nextCursor: after) { responseObject, error in
                        if error != nil {
                            print("Could not complete the request \(error)")
                            completionHandler(responseObject:  [] as JSON, error: error)
                        } else {
                            completionHandler(responseObject:  responseObject, error: error)
                        }
                    }
                } else {
                    ApplyMagicSauceFBAPI().auth() { responseObject, error in
                        if error != nil {
                            print("Could not complete the request in oauth response \(error)")
                        } else {
                            let json = JSON(responseObject!)
                            //print(json)
                            var tokenToPass  = json["token"].stringValue
                            ApplyMagicSauceFBAPI().invokeAPI(self.likeIds, id: id, token: tokenToPass) { responseObject, error in
                                if error != nil {
                                    print("Could not complete the request in invokeAPI response \(error)")
                                    completionHandler(responseObject:  [] as JSON, error: error)
                                } else {
                                    var json = JSON(responseObject!)
                                    //print(json)
                                    completionHandler(responseObject:  json, error: error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func photos(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/photos", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("photos")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
    func albums(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/albums", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("albums")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
    func videos(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/videos", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("videos")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
    
    func friends(){
        //print("friends")
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("taggable_friends")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                //print("\(result)")
                var json = JSON(result)
                //print(json)
                if json["data"] != nil {
                    for (index, friend):(String, JSON) in json["data"] {
                        self.friend_details(friend["id"].stringValue){ data, error in
                            let friend = GoogleContact()
                            
                            friend.facebookId = data!["id"].stringValue
                            friend.name = data!["name"].stringValue
                            friend.firstName = data!["first_name"].stringValue
                            friend.lastName = data!["last_name"].stringValue
                            friend.gender = data!["gender"].stringValue
                            friend.location = data!["location"]["name"].stringValue
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            if data!["birthday"].stringValue != "" {
                                let date = dateFormatter.dateFromString(data!["birthday"].stringValue)
                                if date != nil {
                                    friend.birthday = date!
                                    let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date!)
                                    let year = components.year
                                    friend.birthYear = String(year)
                                    friend.age = String(self.calculateAge(date!))
                                    //print("age from API")
                                    //print(friend.age)
                                }
                            }
                            
                            friend.facebookProfileImageUrl = data!["picture"]["data"]["url"].stringValue
                            //friend.profileImage = UIImage(named: "default_avatar.png")
                            facebookContacts.append(friend)
                        }
                    }
                } else {
                    print("zero likes")
                }
                
            }
        })
    }
    
    func calculateAge (birthday: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: NSDate(), options: []).year
    }
    
    func taggable_friends(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("taggable_friends")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
    
    func permissions(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/permissions", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("permissions")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
    func inbox(){
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/inbox", parameters: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            //print("inbox")
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("\(result)")
            }
        })
    }
    /*
    func getFacebookContactImage(pageNumber: Int, completionHandler: (data: String?, error: NSError?) -> ()){
        //print("getTwitterContactImage()")
        var total = facebookContacts.count
        let group = dispatch_group_create()
        var count = facebookContacts.count
        for var i = 25*(pageNumber-1); i < count; i++ {
            //print("Contact's twitter Id"+twitterContacts[i].twitterId)
            var contactId = facebookContacts[i].facebookId
            //var contactEmailsCount = contact.emailCount
            //if contactEmailsCount > 0 {
            dispatch_group_enter(group)
            self.getPhotoForFacebookContact(facebookContacts[i]) { contactId, data, error in
                //var i = 0
                if let image = UIImage(data: data!) {
                    for var i=25*(pageNumber-1); i < total; i++ {
                        if facebookContacts[i].facebookId == contactId {
                            facebookContacts[i].profileImage = image
                            //userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(googleContacts[i]), forKey: "googleContacts[\(i)]")
                            //Cache().updateImageInUserDefaults(i, image: image)
                            break
                        }
                    }
                }
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            /*userDefaults.setObject(true, forKey: "contactsImageLoaded")
            print("Inserting twitter contacts after image load into userdefaults")
            var count = twitterContacts.count
            for(var i=0; i<count;i++)  {
            print("inserting "+String(i)+"record")
            
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(twitterContacts[i]), forKey: "twitterContacts[\(i)]")
            }//print("photo image received for all Twitter contacts.")*/
            completionHandler(data: "", error:nil)
        }
    }
    */
    func getFacebookContactImage(completionHandler: (data: String?, error: NSError?) -> ()){
        //print("getFacebookContactImage()")
        var total = facebookContacts.count
        //print("total "+String(total))
        let group = dispatch_group_create()
        for contact in facebookContacts {
            //print("Contact's twitter Id"+contact.twitterId)
            var contactId = contact.twitterId
            //var contactEmailsCount = contact.emailCount
            //if contactEmailsCount > 0 {
            dispatch_group_enter(group)
            self.getPhotoForFacebookContact(contact) { contactId, data, error in
                //var i = 0
                if let image = UIImage(data: data!) {
                    for var i=0; i < total; i++ {
                        if facebookContacts[i].facebookId == contactId {
                            facebookContacts[i].profileImage = image
                            //userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(googleContacts[i]), forKey: "googleContacts[\(i)]")
                            //Cache().updateImageInUserDefaults(i, image: image)
                            break
                        }
                    }
                }
                dispatch_group_leave(group)
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            /*userDefaults.setObject(true, forKey: "contactsImageLoaded")
            print("Inserting twitter contacts after image load into userdefaults")
            var count = twitterContacts.count
            for(var i=0; i<count;i++)  {
            print("inserting "+String(i)+"record")
            
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(twitterContacts[i]), forKey: "twitterContacts[\(i)]")
            }//print("photo image received for all Twitter contacts.")*/
            completionHandler(data: "", error:nil)
        }
    }
    
    func getPhotoForFacebookContact(facebookContact: GoogleContact, completionHandler: (id: String, data: NSData?, error: NSError?) -> ()){
        var imageURLStrArr: String = (facebookContact.facebookProfileImageUrl.stringByReplacingOccurrencesOfString("\\", withString: "") as! String)
        
        if let url = NSURL(string: imageURLStrArr) {
            var request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
                completionHandler(id: facebookContact.facebookId, data: data as! NSData?, error: error)
            }
        } else {
            print("Not a NS URL")
        }
    }
}