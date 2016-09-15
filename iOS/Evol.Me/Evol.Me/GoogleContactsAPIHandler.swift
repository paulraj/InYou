//
//  GoogleSignInHandler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/14/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import Alamofire

class GoogleContactsAPIHandler {
    
    //https://www.googleapis.com/plus/v1/people/me?key={YOUR_API_KEY}
    var accessToken: String = ""
    var userEmail: String = ""
    var refreshToken = ""
    var mail: String = ""
    var imageUrl: String = ""
    var key = "AIzaSyAyCx0UP5J6RGz6LZ6vV9lkaw72-YQ6CfM"
    
    init () {
        self.userEmail = loggedInUser.email
        self.accessToken = loggedInUser.accessToken
    }
    
    
    /*Gmail Contact Photo API*/
    func getPhotoForGmailContact(id: String, completionHandler: (id: String, data: NSData?, error: NSError?) -> ()){
        var photoUrl = "https://www.google.com/m8/feeds/photos/media/default/\(id)"
        Alamofire.request(.GET, "https://www.google.com/m8/feeds/photos/media/default/\(id)",
            parameters: [ "access_token": self.accessToken, "v":"3.0","sz":1000 ])
            .responseJSON{ response in
                completionHandler(id: id, data: response.data as! NSData?, error: response.result.error)
        }
    }
    
    func getPhotoForGPlusContact(id: String, url:String, completionHandler: (id: String, data: NSData?, error: NSError?) -> ()){
        Alamofire.request(.GET, url,
            parameters: ["sz":200 ])
            .responseJSON { response in
                completionHandler(id: id, data: response.result.value as! NSData?, error: response.result.error)
        }
    }
    
    func _getDataForGmailContacts( id: String, email: String, name: String, emailsCount: Int, completionHandler: (id: String, email: String, name: String, emailsCount:Int, data: NSData?, error: NSError?) -> ()){
        let url = NSURL(string: "https://www.google.com/m8/feeds/contacts/default/full/\(id)")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.addValue("3.0", forHTTPHeaderField: "GData-Version")
        
        Alamofire.request(.GET, request,
            parameters: [ "access_token": self.accessToken, "v":"3.0", "alt": "json", "rel": "http://schemas.google.com/g/2005#mobile"])
            .responseJSON { response in
                //print("*************")
                //print(response.result.value)
                //print("*************")
                completionHandler(id: id, email: email , name: name, emailsCount: emailsCount, data: response.result.value as! NSData?, error: response.result.error)
        }
    }
    
    func convertToBase64URLDecoding(data: String) -> String {
        var _data = data
        if !data.isEmpty {
            _data = data.stringByReplacingOccurrencesOfString("-", withString: "+")
            _data = _data.stringByReplacingOccurrencesOfString("_", withString: "/")
            let dataUTF8 = (_data as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
            let dataUTF8DecodedData = NSData(base64EncodedData: dataUTF8, options: NSDataBase64DecodingOptions(rawValue: 0))
            var decodedString = NSString()
            if(dataUTF8DecodedData != nil ){
                decodedString = NSString(data: dataUTF8DecodedData!, encoding: NSUTF8StringEncoding)!
            }
            return decodedString as String
        } else {
            return ""
        }
    }
    
    /*Gmail Contacts API*/
    func getAllGmailContacts(completionHandler: (data: String, error: NSError?) -> ()){
        self.getGMailContactsImpl() { data, error in
            completionHandler(data: data, error: error)
        }
    }
    
    func getGMailContacts(completionHandler: (data: NSDictionary?, error: NSError?) -> ()) {
        let url = NSURL(string: "https://www.google.com/m8/feeds/contacts/\(self.userEmail)/full")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.addValue("3.0", forHTTPHeaderField: "GData-Version")
        
        Alamofire.Manager.sharedInstance.request(.GET, request, parameters: [ "access_token": self.accessToken,"alt": "json", "v":"3.0","max-results": 1000000])
            .responseJSON { response in
                completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
        }
    }
    
    func getGMailContactsImpl( completionHandler: (data: String, error: NSError?) -> ()){
        getGMailContacts {  data, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(data!)
                if (json["feed"]["entry"].count != 0 ) {
                    //let group = dispatch_group_create()
                    for (index, contactJson):(String, JSON) in json["feed"]["entry"] {
                        let _name = contactJson["title"]["$t"].string! as String
                        if let email = contactJson["gd$email"][0]["address"].string {
                            
                            //let name = _name.isEmpty ? email : self.camelCaseString(_name)
                            let name = _name.isEmpty ? email : _name
                            
                            //let name = _name.isEmpty ? self.extractNameFromEmailId(email) : self.camelCaseString(_name)
                            let id = self.extractContactId(contactJson["id"]["$t"].string! as String)
                            let gc = GoogleContact()
                            gc.id = id
                            gc.name = name
                            gc.email = email
                            gc.profileImage = UIImage(named: "default_avatar.png")
                            googleContacts.append(gc)
                            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(gc), forKey: "googleContacts[\(index)]")
                            
                            //to be modified....
                            /*dispatch_group_enter(group)
                            FullContactAPI().callFullContactAPI(gc) { data, error in
                                print("contact details updated now.")
                                //dispatch_group_leave(group)
                            }*/
                        }
                    }
                    /*dispatch_group_notify(group, dispatch_get_main_queue()) {
                        //userDefaults.setObject(true, forKey: "contactsImageLoaded")
                        print("Full Contact API is called for all contacts.")
                        //completionHandler(data: "", error:nil)
                    }*/
                }
                
                //print("Total contacts are "+String(googleContacts.count))
                userDefaults.setObject(true, forKey: "hasContactsLoaded")
                userDefaults.setObject(googleContacts.count, forKey: "totalContacts")
                completionHandler(data: "", error: error)
            }
        }
    }
    
    /*Gmail Contacts API*/
    func getAllGmailContactGroups(completionHandler: (data: String, error: NSError?) -> ()){
        self.getGMailContactGroupsImpl() { data, error in
            completionHandler(data: data, error: error)
        }
    }
    
    func getGMailContactGroups(completionHandler: (data: NSDictionary?, error: NSError?) -> ()) {
        let url = NSURL(string: "https://www.google.com/m8/feeds/groups/\(self.userEmail)/full")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.addValue("3.0", forHTTPHeaderField: "GData-Version")
        
        Alamofire.Manager.sharedInstance.request(.GET, request, parameters: [ "access_token": self.accessToken,"alt": "json", "v":"3.0","max-results": 1000000])
            .responseJSON { response in
                completionHandler(data: response.result.value as! NSDictionary?, error: response.result.error)
        }
    }
    
    func getGMailContactGroupsImpl( completionHandler: (data: String, error: NSError?) -> ()){
        getGMailContactGroups {  data, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(data!)
                //print(json)
                completionHandler(data: "", error: error)
            }
        }
    }
    

    
    /*Gmail Contacts API*/
    
    
    
    func extractContactId(id: String) -> String {
        var idArr = id.componentsSeparatedByString("/")  //split(id) {$0 == "/"}
        return idArr[idArr.count-1]
    }
    
    func extractNameFromEmailId(id: String) -> String {
        var nameInEmail = id.componentsSeparatedByString("@") //split(id) {$0 == "@"}
        let nameSpiltByDot = nameInEmail[0].componentsSeparatedByString(".") //split(nameInEmail[0]) {$0 == "."}
        let nameSpiltByDash =  nameInEmail[0].componentsSeparatedByString("_") //split(nameInEmail[0]) {$0 == "_"}
        var name: String = ""
        if nameSpiltByDot.count > 0 {
            for name_seg in nameSpiltByDot {
                if name.isEmpty {
                    name = name_seg
                } else {
                    name = name + " " + name_seg
                }
            }
        } else if nameSpiltByDash.count > 0 {
            for name_seg in nameSpiltByDot {
                if name.isEmpty {
                    name = name_seg
                } else {
                    name = name + " " + name_seg
                }
            }
        }
        return camelCaseString(name)
    }
    
    func camelCaseString(source: String) -> String {
        if source.containsString(" ") {
            let camel = NSString(format: "%@", (source as NSString).capitalizedString) as String
            return "\(camel)"
        } else {
            //let first = (source as NSString).lowercaseString.substringToIndex(source.startIndex.advancedBy(1)).capitalizedString
            let first = source.characters.first
            let rest = source.characters.dropFirst() //dropFirst(source)
            return "\(first)\(rest)"
        }
    }
    
    
    func loadContactImage(completionHandler: (data: String?, error: NSError?) -> ()){
        //print("loadContactImage()")
        var total = googleContacts.count
        //print("total "+String(total))
        let group = dispatch_group_create()
        for contact in googleContacts {
            if !contact.googlePlusUser {
                var contactId = contact.id
                //var contactEmailsCount = contact.emailCount
                //if contactEmailsCount > 0 {
                dispatch_group_enter(group)
                GoogleContactsAPIHandler().getPhotoForGmailContact(contactId) { contactId, data, error in
                    var i = 0
                    if let image = UIImage(data: data!) {
                        for i=0; i < total; i++ {
                            if googleContacts[i].id == contactId {
                                googleContacts[i].profileImage = image
                                //userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(googleContacts[i]), forKey: "googleContacts[\(i)]")
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
    
    
    func getMailCount(completionHandler: (data: String?, error: NSError?) -> ()){
        //print("getMailCount() - \(googleContacts.count)")
        var total = googleContacts.count
        let group = dispatch_group_create()
        for contact in googleContacts {
            var contactId = contact.id
            var contactEmail = contact.email
            if contactEmail.isEmpty {
                dispatch_group_enter(group)
                dispatch_group_leave(group)
            } else {
                dispatch_group_enter(group)
                GMailAPIHandler().getMailCount("from:"+contactEmail, contactId: contactId){id, count, error in
                    if error != nil{
                        print(error)
                    } else {
                        //var i = 0
                        var total = googleContacts.count
                        for var i=0; i < total; i++ {
                            if googleContacts[i].id as String == id {
                                googleContacts[i].emailCount = count
                                userDefaults.setObject(true, forKey: "contactsEmailCountLoaded")
                                userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(googleContacts[i]), forKey: "googleContacts[\(i)]")
                                //self.updateEmailsCountInUserDefaults(i, count: count)
                                break
                            }
                        }
                    }
                    dispatch_group_leave(group)
                }
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            //print("mail count received for all contacts.")
            completionHandler(data: "", error:nil)
        }
    }
    
    func filterContacts(){
        googleContacts = googleContacts.filter({
            if $0.emailCount > 0{
                return true
            } else {
                return false
            }
        })
        //print("new count:"+String(googleContacts.count))
    }
    
    
    
    func sortContacts(){
        googleContacts.sort {
            item1, item2 in
            let count1 = item1.emailCount
            let count2 = item2.emailCount
            return count1 > count2
        }
    }
    
    /*
    func addContact(email:String, id: String, name: String){
    var contact: Dictionary<String, Any> =
    ["id":id, "name": name ,"email": email, "emailsCount": 0, "image": UIImage(named: "default_avatar.png")]
    globalGoogleContacts.append(contact)
    }*/
}