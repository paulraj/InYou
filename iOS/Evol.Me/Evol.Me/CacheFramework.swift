//
//  CacheFramework.swift
//  InYou
//
//  Created by Paul.Raj on 12/3/15.
//  Copyright © 2015 paul-anne. All rights reserved.
//

import Foundation

class Cache {
    
    func updateLoggedInUserImageInUserDefaults(image: UIImage  ){
        var imageData = UIImagePNGRepresentation(image)
        if let data = userDefaults.objectForKey("loggedInUser") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let loggedInUser = unarc.decodeObjectForKey("root") as! GoogleContact
            loggedInUser.profileImage = UIImage(data: imageData!)
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
        }
    }
    
    func _updateLoggedInUserImageInUserDefaults(image: UIImage  ){
        var imageData = UIImagePNGRepresentation(image)
        if let data = userDefaults.objectForKey("loggedInUser") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let loggedInUser = unarc.decodeObjectForKey("root") as! GoogleContact
            loggedInUser.profileImage = UIImage(data: imageData!)
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
        }
    }
    
    func updatePersonalitySumaryInUserDefaults(i: Int, personalityText: String  ){
        if let data = userDefaults.objectForKey("googleContacts[\(i)]") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let contact = unarc.decodeObjectForKey("root") as! GoogleContact
            contact.personalityData.personalitySummary = personalityText
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "googleContacts[\(i)]")
        }
    }
    
    func updateTwitterImageInUserDefaults(){
        //print("updateImageInUserDefaults")
        var count = twitterContacts.count
        for(var i=0; i<count;i++)  {
            if let data = userDefaults.objectForKey("twitterContacts[\(i)]") as? NSData {
                //print("twitter contact retrieved from userDefaults")
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let contact = unarc.decodeObjectForKey("root") as! GoogleContact
                contact.profileImage = twitterContacts[i].profileImage
                
                userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "twitterContacts[\(i)]")
            }
        }
    }
    
    func updateImageInUserDefaults(i: Int,image: UIImage  ){
        var imageData = UIImagePNGRepresentation(image)
        if let data = userDefaults.objectForKey("googleContacts[\(i)]") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let contact = unarc.decodeObjectForKey("root") as! GoogleContact
            contact.profileImage = UIImage(data: imageData!)
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "googleContacts[\(i)]")
        }
    }
    
    func updateEmailsCountInUserDefaults(i: Int, count: Int){
        if let data = userDefaults.objectForKey("googleContacts[\(i)]") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let contact = unarc.decodeObjectForKey("root") as! GoogleContact
            contact.emailCount = count
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "googleContacts[\(i)]")
        }
    }
    func updateGoogleImageInUserDefaults(i: Int,image: UIImage  ){
        var imageData = UIImagePNGRepresentation(image)
        if let data = userDefaults.objectForKey("googleContacts[\(i)]") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let contact = unarc.decodeObjectForKey("root") as! GoogleContact
            contact.profileImage = UIImage(data: imageData!)
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "googleContacts[\(i)]")
        }
    }
    
    func updateTwitterImageInUserDefaults(i: Int,image: UIImage  ){
        var imageData = UIImagePNGRepresentation(image)
        if let data = userDefaults.objectForKey("twitterContacts[\(i)]") as? NSData {
            //print("it is a twitter contact")
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let contact = unarc.decodeObjectForKey("root") as! GoogleContact
            contact.profileImage = UIImage(data: imageData!)
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(contact), forKey: "twitterContacts[\(i)]")
        }
    }
    
}