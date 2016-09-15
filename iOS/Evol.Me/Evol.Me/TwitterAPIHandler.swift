//
//  TwitterAPIHandler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 9/21/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

//https://api.twitter.com/1.1/statuses/user_timeline.json?count=3200&user_id=1763261&screen_name=cwodtke

import Foundation
import Alamofire
import TwitterKit
import Fabric

class TwitterAPIHandler {
    var api_key = "5482600aed99bc01"
    //var user_id = "1763261"
    //var screen_name = "cwodtke"
    //var authHeaderValue = "OAuth realm=\"https://api.twitter.com/\",oauth_consumer_key=\"LuIM7Infby1eVfqVXvFyv3XDd\",oauth_token=\"317505059-Ex0F22YBYzNU2dICjELzpibYfXCbbPntWMzGsNei\",oauth_nonce=\"\(NSUUID().UUIDString)\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"\(String(Int(NSDate().timeIntervalSince1970)))\",oauth_version=\"1.0\",oauth_signature=\"b2%2BSk6cPI6vUDn1Eqeab0jRxVAE%3D\""
    var oauth_consumer_key = "LuIM7Infby1eVfqVXvFyv3XDd"
    var oauth_consumer_secret = "kPzqEqpNgWJfJb2K0dq98qlIGl2Z7T9JPAipV0VFCY37fTMynG"
    
    var authHeaderValue = "OAuth oauth_consumer_key=\"LuIM7Infby1eVfqVXvFyv3XDd\", oauth_nonce=\"c63a2da3f984f0b1f2cc4e4772dd5d2f\", oauth_signature=\"b2%2BSk6cPI6vUDn1Eqeab0jRxVAE%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1448854231\", oauth_token=\"317505059-Ex0F22YBYzNU2dICjELzpibYfXCbbPntWMzGsNei\", oauth_version=\"1.0\""
    
    var previousCursor = "-1"
    var nextCursor = "-1"
    
    /*
    OAuth realm="https://api.twitter.com/",oauth_consumer_key="LuIM7Infby1eVfqVXvFyv3XDd",oauth_token="317505059-Ex0F22YBYzNU2dICjELzpibYfXCbbPntWMzGsNei",oauth_nonce="4XMBC5UDMYD1PV9B",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1442996065",oauth_version="1.0",oauth_signature="OvnnD73YikNwpaQqkxWWc3Lod8Y%3D"
    */
    func getTweets(user_id: String, screen_name: String, completionHandler: (data: NSArray!, error: NSError?) -> ()){
        //print(authHeaderValue)
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        //request.HTTPMethod = "GET"
        //var err: NSError?
        //var params = ["count": 3200, "screen_name": screen_name] as Dictionary<String, AnyObject>
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(.GET, request, parameters: ["count": 3200, "screen_name": screen_name]).responseJSON { response in
            if response.result.isSuccess {
                var responseObjectJSON = JSON(response.result.value!)
                if (responseObjectJSON["errors"] != nil) {
                    //print(responseObjectJSON)
                    var _error = NSError(domain: responseObjectJSON["errors"]["message"].stringValue, code: 100,userInfo: [:] )
                    completionHandler(data: [] as! NSArray, error: _error)
                } else {
                    completionHandler(data: response.result.value as! NSArray, error: response.result.error)
                }
            }
        }
    }
    
    func getPhoto(url:String, completionHandler: (data: NSData?, error: NSError?) -> ()){
        Alamofire.request(.GET, (url as? NSURL)!)
            .responseJSON { response in
                completionHandler(data: response.result.value as! NSData?, error: response.result.error )
        }
    }
    
    func getUserTimelineWithUserId(screenName: NSString, userId: NSString, completionHandler: (data: String?, count: Int?, error: NSError?) -> ()){
        let client = TWTRAPIClient(userID: userId as String)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["count": "10000","screen_name":String(screenName),"include_rts":String(true)]
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        var allTweets = ""
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            var count = 0
            if (connectionError == nil) {
                do {
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    if let dict = json as? [AnyObject] {
                        for tweet in dict {
                            let text = String(tweet["text"])
                            count++
                            allTweets = allTweets + "\n" + text
                        }
                        
                        completionHandler(data: allTweets, count: count, error:  connectionError)
                    }
                } catch {
                    completionHandler(data: allTweets, count: count, error:  connectionError)
                    print("error")
                }
            } else {
                completionHandler(data: allTweets, count: count, error:  connectionError)
                print("Error: \(connectionError)")
            }
        }
    }
    
    func getFriendslistWithUserId(cursor: String, completionHandler: (data: String?, error: NSError?) -> ()){
        print("getFriendslistWithUserId")
        let client = TWTRAPIClient(userID: loggedInUser.id as String)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/friends/list.json"
        let params = ["count": "25", "screen_name":String(loggedInUser.twitterScreenName), "cursor":cursor, "skip_status":String(true),
            "include_user_entities":String(false)]
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                do {
                    let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! AnyObject
                    loggedInUser.twitterFriendsListCursor = String(response["next_cursor"])
                    //print(response["next_cursor"])
                    //print(response["previous_cursor"])
                    
                    if let friends = response["users"] as? NSArray {
                        for friend in friends {
                            let contact = GoogleContact()
                            contact.name = String(friend["name"]!)
                            contact.twitterId = String(friend["id_str"]!)
                            contact.twitterName = String(friend["name"]!)
                            contact.twitterScreenName = String(friend["screen_name"]!)
                            contact.twitterFriendsCount = friend["friends_count"]! as! Int
                            contact.twitterFollowersCount = friend["followers_count"]! as! Int
                            contact.twitterLocation = String(friend["location"]!)
                            contact.twitterDescription = String(friend["description"]!)
                            contact.twitterProfileImageUrlHttps = String(friend["profile_image_url_https"]!)
                            contact.twitterProfileBackgroundImageUrlHttps = String(friend["profile_background_image_url_https"]!)
                            
                            contact.profileImage = UIImage(named: "defaultTwitterProfileImage.png")
                            twitterContacts.append(contact)
                        }
                        //print(twitterContacts.count)
                        loggedInUser.twitterFriendsCount = friends.count
                        userDefaults.setObject(true, forKey: "hasContactsLoaded")
                        userDefaults.setObject(friends.count, forKey: "totalContacts")
                    }
                } catch {
                    print("error")
                }
            } else {
                print("Error: \(connectionError)")
            }
            completionHandler(data: "", error: connectionError)
        }
    }
    
    func getFollowerslistWithUserId(cursor: String, completionHandler: (data: String?, error: NSError?) -> ()){
        print("getFollowerslistWithUserId")
        let client = TWTRAPIClient(userID: loggedInUser.id as String)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/followers/list.json"
        let params = ["count": "25", "screen_name":String(loggedInUser.twitterScreenName), "cursor":cursor, "skip_status":String(true),
            "include_user_entities":String(false)]
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                do {
                    let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! AnyObject
                    loggedInUser.twitterFollowersListCursor = String(response["next_cursor"])
                    //print(response["next_cursor"])
                    //print(response["previous_cursor"])
                    //print(response)
                    print("response for follower")
                    if let followers = response["users"] as? NSArray {
                        for follower in followers {
                            let contact = GoogleContact()
                            contact.name = String(follower["name"]!)
                            contact.twitterId = String(follower["id_str"]!)
                            contact.twitterName = String(follower["name"]!)
                            contact.twitterScreenName = String(follower["screen_name"]!)
                            contact.twitterFriendsCount = follower["friends_count"]! as! Int
                            contact.twitterFollowersCount = follower["followers_count"]! as! Int
                            contact.twitterLocation = String(follower["location"]!)
                            contact.twitterDescription = String(follower["description"]!)
                            contact.twitterProfileImageUrlHttps = String(follower["profile_image_url_https"]!)
                            contact.twitterProfileBackgroundImageUrlHttps = String(follower["profile_background_image_url_https"]!)
                            
                            contact.profileImage = UIImage(named: "defaultTwitterProfileImage.png")
                            twitterFollowerContacts.append(contact)
                        }
                        print(twitterFollowerContacts.count)
                        loggedInUser.twitterFollowersCount = followers.count
                        //userDefaults.setObject(true, forKey: "hasContactsLoaded")
                        //userDefaults.setObject(followers.count, forKey: "totalContacts")
                    }
                } catch {
                    print("error")
                }
            } else {
                print("Error: \(connectionError)")
            }
            completionHandler(data: "", error: connectionError)
        }
    }
    
    func getUsersShow( completionHandler: (data: String?, error: NSError?) -> ()){
        print("getUsersShow")
        let client = TWTRAPIClient(userID: loggedInUser.id as String)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
        let params = ["screen_name":String(loggedInUser.twitterScreenName), "include_user_entities":String(false)]
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if (connectionError == nil) {
                do {
                    let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! AnyObject
                    print(response)
                    print("response for follower")
                    var myInfo = response
                    loggedInUser.twitterFriendsCount = myInfo["friends_count"] as! Int
                    loggedInUser.twitterLocation = myInfo["location"] as! String
                    loggedInUser.twitterDescription = myInfo["description"] as! String
                    loggedInUser.twitterName = myInfo["name"] as! String
                    loggedInUser.twitterStatusesCount = myInfo["statuses_count"] as! Int
                    loggedInUser.twitterId = myInfo["id_str"] as! String
                    loggedInUser.twitterProfileImageUrl = myInfo["profile_image_url"] as! String
                    loggedInUser.twitterProfileImageUrlHttps = myInfo["profile_image_url_https"] as! String
                    loggedInUser.twitterProfileBackgroundImageUrl = myInfo["profile_background_image_url"] as! String
                    loggedInUser.twitterProfileBackgroundImageUrlHttps = myInfo["profile_background_image_url_https"] as! String
                    loggedInUser.twitterScreenName = myInfo["screen_name"] as! String
                    loggedInUser.twitterFollowersCount = myInfo["followers_count"] as! Int
                } catch {
                    print("error")
                }
            } else {
                print("Error: \(connectionError)")
            }
            completionHandler(data: "", error: connectionError)
        }
    }
    
    /*func getFollowingUsers(completionHandler: (data: String?, error: NSError?) -> ()){
        //swifter.getFriendsIDsWithID
        swifter.getFollowersIDsWithID(loggedInUser.twitterUserId, cursor: "-1", stringifyIDs: true, count: 100, success: { (ids: [JSONValue]?, previousCursor: String?, nextCursor: String?) in
            let group = dispatch_group_create()
            
            for id in ids! {
                //var followingId: String = id["text"].string
                print("getFollowersIDsWithID")
                print(id)
                if let followingId = id.string {
                    dispatch_group_enter(group)
                    
                    swifter.getUsersShowWithUserID(followingId, includeEntities: false, success: { (user) in
                        print("user from getFollowersIDsWithID")
                        print(user)
                        let contact = GoogleContact()
                        //print(user)
                        contact.name = user!["name"]!.string!
                        contact.twitterId = user!["id_str"]!.string!
                        contact.twitterName = user!["name"]!.string!
                        contact.twitterScreenName = user!["screen_name"]!.string!
                        contact.twitterFriendsCount = user!["friends_count"]!.integer!
                        contact.twitterFollowersCount = user!["followers_count"]!.integer!
                        contact.twitterLocation = user!["location"]!.string!
                        contact.twitterProfileImageUrlHttps = user!["profile_image_url_https"]!.string!
                        contact.twitterProfileBackgroundImageUrlHttps = user!["profile_background_image_url_https"]!.string!
                        
                        contact.profileImage = UIImage(named: "defaultTwitterProfileImage.png")
                        twitterFollowingContacts.append(contact)
                        //userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "twitterContacts[\(index)]")
                        
                        dispatch_group_leave(group)
                        
                        }, failure: {
                            (error: NSError) in
                            dispatch_group_leave(group)
                            print(error)
                    })
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue()) {
                completionHandler(data: "", error:nil)
            }
            }, failure: {
                (error: NSError) in
                print(error)
        })
    }
    
    func getTwitterFriends(completionHandler: (data: String?, error: NSError?) -> ()){
        swifter.getFriendsIDsWithID(loggedInUser.twitterUserId, cursor: self.nextCursor, stringifyIDs: true, count: 100, success: { (ids: [JSONValue]?,
            previousCursor: String?, nextCursor: String?) in
            print("got response from getFriendsIDsWithID  with cursor "+self.nextCursor)
            print("PreviousCursor: "+previousCursor!)
            print("NextCursor: "+nextCursor!)
            self.nextCursor = nextCursor!
            self.previousCursor = previousCursor!
            var remainingCount = 180
            var index = 0
            let group = dispatch_group_create()
            for id in ids! {
                index++
                //var followingId: String = id["text"].string
                let followingId = id.string
                if  remainingCount > 5 {
                    dispatch_group_enter(group)
                    swifter.getUsersShowWithUserID(followingId!, includeEntities: false, success: { (user) in
                        let contact = GoogleContact()
                        //print(user)
                        contact.name = user!["name"]!.string!
                        contact.twitterId = user!["id_str"]!.string!
                        contact.twitterName = user!["name"]!.string!
                        contact.twitterScreenName = user!["screen_name"]!.string!
                        contact.twitterFriendsCount = user!["friends_count"]!.integer!
                        contact.twitterFollowersCount = user!["followers_count"]!.integer!
                        contact.twitterLocation = user!["location"]!.string!
                        contact.twitterProfileImageUrlHttps = user!["profile_image_url_https"]!.string!
                        contact.twitterProfileBackgroundImageUrlHttps = user!["profile_background_image_url_https"]!.string!
                        
                        contact.profileImage = UIImage(named: "defaultTwitterProfileImage.png")
                        twitterContacts.append(contact)
                        //userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "twitterContacts[\(index)]")
                        
                        dispatch_group_leave(group)
                        
                        }, failure: {
                            (error: NSError) in
                            print("Error Occured here.")
                            if error.code == 429 {
                                print(error)
                                var responseHeader = error.userInfo["Response-Headers"]
                                //print()
                                remainingCount = Int(responseHeader!["x-rate-limit-remaining"] as! String)!
                            }
                            dispatch_group_leave(group)
                    })
                } else if remainingCount <= 5 {
                    print("it is about to exceed now...")
                }
            }
            userDefaults.setObject(true, forKey: "hasContactsLoaded")
            userDefaults.setObject(ids!.count, forKey: "totalContacts")
            dispatch_group_notify(group, dispatch_get_main_queue()) {
                /*print("Inserting twitter contacts into userdefaults")
                var count = twitterContacts.count
                for(var i=0; i<count;i++)  {
                print("inserting "+String(i)+"record")
                userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(twitterContacts[i]), forKey: "twitterContacts[\(i)]")
                }*/
                completionHandler(data: "", error:nil)
            }
            }, failure: {
                (error: NSError) in
                print(error)
        })
    }*/
    
    func getTwitterContactImage(twitterContactsLocal: [GoogleContact], completionHandler: (data: String?, error: NSError?) -> ()){
        print("getTwitterContactImage()"+String(twitterContactsLocal.count))
        var total = twitterContactsLocal.count
        //print("total "+String(total))
        let group = dispatch_group_create()
        for contact in twitterContactsLocal {
            //print("Contact's twitter Id"+contact.twitterId)
            var contactId = contact.twitterId
            //var contactEmailsCount = contact.emailCount
            //if contactEmailsCount > 0 {
            dispatch_group_enter(group)
            TwitterAPIHandler().getPhotoForTwitterContact(contact) { contactId, data, error in
                //var i = 0
                if let image = UIImage(data: data!) {
                    for var i=0; i < total; i++ {
                        if twitterContactsLocal[i].twitterId == contactId {
                            twitterContactsLocal[i].profileImage = image
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
    
    func getTwitterContactImage(twitterContactsLocal: [GoogleContact], pageNumber: Int, completionHandler: (data: String?, error: NSError?) -> ()){
        //print("getTwitterContactImage()")
        var total = twitterContactsLocal.count
        let group = dispatch_group_create()
        var count = twitterContactsLocal.count
        for var i = 25*(pageNumber-1); i < count; i++ {
            //print("Contact's twitter Id"+twitterContacts[i].twitterId)
            var contactId = twitterContactsLocal[i].twitterId
            //var contactEmailsCount = contact.emailCount
            //if contactEmailsCount > 0 {
            dispatch_group_enter(group)
            TwitterAPIHandler().getPhotoForTwitterContact(twitterContactsLocal[i]) { contactId, data, error in
                //var i = 0
                if let image = UIImage(data: data!) {
                    for var i=25*(pageNumber-1); i < total; i++ {
                        if twitterContactsLocal[i].twitterId == contactId {
                            twitterContactsLocal[i].profileImage = image
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
    
    func getPhotoForTwitterContact(twitterContact: GoogleContact, completionHandler: (id: String, data: NSData?, error: NSError?) -> ()){
        var imageURLStrArr = twitterContact.twitterProfileImageUrlHttps.componentsSeparatedByString("_normal")
        var imageURLStr = (imageURLStrArr[0] as! String)+(imageURLStrArr[1] as! String)
        
        if let url = NSURL(string: imageURLStr) {
            var request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                
                completionHandler(id: twitterContact.twitterId, data: data as! NSData?, error: error)
                //userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(twitterContact), forKey: "loggedInUser")
            }
        }
    }
    
    func getFollowingUsersThroughAPI(completionHandler: (data: NSDictionary?, error: NSError?) -> ()) {
        let url = NSURL(string: "https://api.twitter.com/1.1/friends/ids.json")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        //request.addValue(self.authHeaderValue, forHTTPHeaderField: "Authorization")
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //request.addValue(self.oauth_consumer_key, forHTTPHeaderField: "oauth_consumer_key")
        //request.addValue(self.oauth_consumer_secret, forHTTPHeaderField: "oauth_consumer_secret")
        
        //request.addValue(loggedInUser.twitterOauthTokenKey, forHTTPHeaderField: "oauth_token")
        //request.addValue(loggedInUser.twitterOauthTokenSecret, forHTTPHeaderField: "oauth_token_secret")
        
        //print(loggedInUser.twitterUserId)
        //print("user id")
        //print(authHeaderValue)
        
        //print(loggedInUser.twitterScreenName)
        Alamofire.Manager.sharedInstance.request(.GET, request,
            parameters: [ "screen_name": loggedInUser.twitterScreenName,"cursor": "-1", "stringify_ids":true,"count": 200,
                "oauth_consumer_key":self.oauth_consumer_key, "oauth_consumer_secret": self.oauth_consumer_secret,
                "oauth_token": loggedInUser.twitterOauthTokenKey, "oauth_token_secret": loggedInUser.twitterOauthTokenSecret])
            .responseJSON { response in
                //print("response from API")
                //print(response)
                completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
        }
    }
    
    
}
