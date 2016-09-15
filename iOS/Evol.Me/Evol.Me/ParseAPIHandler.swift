//
//  ParseAPIHandler.swift
//  InYou
//
//  Created by Paul.Raj on 11/26/15.
//  Copyright © 2015 paul-anne. All rights reserved.
//

import Foundation
import Parse

class ParseAPIHandler {
    func saveUserInCloud(){
        print("saveUserInCloud")
        var query = PFQuery(className:"Contact")
        query.whereKey("signedInWith", equalTo:loggedInUser.signedInWith)
        
        if loggedInUser.signedInWith == "Twitter" {
            query.whereKey("name", equalTo:loggedInUser.twitterScreenName)
            
            /*var twitterQuery = PFQuery(className:"TwitterProfile")
            twitterQuery.whereKey("id", equalTo:loggedInUser.twitterId)
            twitterQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if objects!.count == 0 {
                    
                    }
                }
            }
            //query.whereKey("twitterProfile", matchesQuery:twitterQuery)
            
            
            let twitterProfile = PFObject(className: "TwitterProfile")
            twitterProfile["id"] = loggedInUser.twitterId
            */
            //query.whereKey("twitterProfile", equalTo: twitterProfile)
        } else if loggedInUser.signedInWith == "Facebook" {
            //var facebookQuery = PFQuery(className:"FacebookProfile")
            //facebookQuery.whereKey("id", equalTo:loggedInUser.facebookId)
            query.whereKey("name", equalTo:loggedInUser.name)
            //query.whereKey("facebookProfile", matchesQuery:facebookQuery)
            let facebookProfile = PFObject(className: "FacebookProfile")
            facebookProfile["id"] = loggedInUser.facebookId
            
            query.whereKey("facebookProfile", equalTo:facebookProfile)
        } else {
            query.whereKey("email", equalTo:loggedInUser.email)
        }
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    print("count = 0 ")
                    let personalityData = PFObject(className: "PersonalityData")
                    personalityData["personalitySummary"] = loggedInUser.personalityData.personalitySummary
                    personalityData["personalitySummaryStatus"] = loggedInUser.personalityData.personalitySummaryStatus
                    personalityData["feelingLike"] = loggedInUser.personalityData.feelByAge
                    
                    personalityData["personalityTraits"] = loggedInUser.personalityData.personalityTraits
                    personalityData["lifeSatisfaction"] = loggedInUser.personalityData.lifeSatisfaction
                    personalityData["intelligenceQuotient"] = loggedInUser.personalityData.intelligenceQuotient
                    personalityData["emotionalQuotient"] = loggedInUser.personalityData.emotionalQuotient
                    personalityData["friendlinessScore"] = loggedInUser.personalityData.friendlinessScore
                    personalityData["trustScore"] = loggedInUser.personalityData.trustScore
                    personalityData["creativity"] = loggedInUser.personalityData.creativity
                    personalityData["innovation"] = loggedInUser.personalityData.innovation
                    personalityData["imagination"] = loggedInUser.personalityData.imagination
                    personalityData["learningStyle"] = loggedInUser.personalityData.learningStyle
                    personalityData["imagination"] = loggedInUser.personalityData.imagination
                    personalityData["thinkingStyle"] = loggedInUser.personalityData.thinkingStyle
                    personalityData["academicPerformance"] = loggedInUser.personalityData.academicPerformance
                    personalityData["carreerPerformance"] = loggedInUser.personalityData.carreerPerformance
                    personalityData["careerInterest"] = loggedInUser.personalityData.careerArea
                    personalityData["strengths"] = loggedInUser.personalityData.strengths
                    personalityData["personalRelationship"] = loggedInUser.personalityData.personalRelationship
                    
                    let personalityTraits = PFObject(className: "PersonalityTraits")
                    personalityTraits["personalityTraitKey"] = loggedInUser.personalityData.traits!.personalityTraitKey
                    personalityTraits["personalityTraitValue"] = loggedInUser.personalityData.traits!.personalityTraitValue
                    
                    //open
                    personalityTraits["opennessKey"] = loggedInUser.personalityData.traits!.openness!.opennessKey
                    personalityTraits["opennessValue"] = loggedInUser.personalityData.traits!.openness!.opennessValue
                    
                    personalityTraits["openAdventurous"] = loggedInUser.personalityData.traits!.openness!.adventurousness
                    personalityTraits["openArtisticInterests"] = loggedInUser.personalityData.traits!.openness!.artisticInterests
                    personalityTraits["openEmotionality"] = loggedInUser.personalityData.traits!.openness!.emotionality
                    personalityTraits["openImagination"] = loggedInUser.personalityData.traits!.openness!.imagination
                    personalityTraits["openIntellect"] = loggedInUser.personalityData.traits!.openness!.intellect
                    personalityTraits["openLiberalism"] = loggedInUser.personalityData.traits!.openness!.liberalism
                    
                    //cons
                    personalityTraits["conscientiousnessKey"] = loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessKey
                    personalityTraits["conscientiousnessValue"] = loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessValue
                    
                    personalityTraits["conscientiousAchievementStriving"] = loggedInUser.personalityData.traits!.conscientiousness!.achievementStriving
                    personalityTraits["conscientiousCautiousness"] = loggedInUser.personalityData.traits!.conscientiousness!.cautiousness
                    personalityTraits["conscientiousDutifulness"] = loggedInUser.personalityData.traits!.conscientiousness!.dutifulness
                    personalityTraits["conscientiousOrderliness"] = loggedInUser.personalityData.traits!.conscientiousness!.orderliness
                    personalityTraits["conscientiousSelfDiscipline"] = loggedInUser.personalityData.traits!.conscientiousness!.selfDiscipline
                    personalityTraits["conscientiousSelfEfficacy"] = loggedInUser.personalityData.traits!.conscientiousness!.selfEfficacy
                    
                    //agreeable
                    personalityTraits["agreeablenessKey"] = loggedInUser.personalityData.traits!.agreeableness!.agreeablenessKey
                    personalityTraits["agreeablenessValue"] = loggedInUser.personalityData.traits!.agreeableness!.agreeablenessValue
                    
                    personalityTraits["agreeableAltruism"] = loggedInUser.personalityData.traits!.agreeableness!.altruism
                    personalityTraits["agreeableCooperation"] = loggedInUser.personalityData.traits!.agreeableness!.cooperation
                    personalityTraits["agreeableModesty"] = loggedInUser.personalityData.traits!.agreeableness!.modesty
                    personalityTraits["agreeableMorality"] = loggedInUser.personalityData.traits!.agreeableness!.morality
                    personalityTraits["agreeableSympathy"] = loggedInUser.personalityData.traits!.agreeableness!.sympathy
                    personalityTraits["agreeableTrust"] = loggedInUser.personalityData.traits!.agreeableness!.trust
                    
                    //neuroticism
                    personalityTraits["neuroticismKey"] = loggedInUser.personalityData.traits!.neuroticism!.neuroticismKey
                    personalityTraits["neuroticismValue"] = loggedInUser.personalityData.traits!.neuroticism!.neuroticismValue
                    
                    personalityTraits["neuroticismAnger"] = loggedInUser.personalityData.traits!.neuroticism!.anger
                    personalityTraits["neuroticismAnxiety"] = loggedInUser.personalityData.traits!.neuroticism!.anxiety
                    personalityTraits["neuroticismDepression"] = loggedInUser.personalityData.traits!.neuroticism!.depression
                    personalityTraits["neuroticismImmoderation"] = loggedInUser.personalityData.traits!.neuroticism!.immoderation
                    personalityTraits["neuroticismSelfConsciousness"] = loggedInUser.personalityData.traits!.neuroticism!.selfConsciousness
                    personalityTraits["neuroticismVulnerability"] = loggedInUser.personalityData.traits!.neuroticism!.vulnerability
                    
                    //agreeable
                    personalityTraits["extraversionKey"] = loggedInUser.personalityData.traits!.extraversion!.extraversionKey
                    personalityTraits["extraversionValue"] = loggedInUser.personalityData.traits!.extraversion!.extraversionValue
                    
                    personalityTraits["extraversionActivityLevel"] = loggedInUser.personalityData.traits!.extraversion!.activityLevel
                    personalityTraits["extraversionAssertiveness"] = loggedInUser.personalityData.traits!.extraversion!.assertiveness
                    personalityTraits["extraversionCheerfulness"] = loggedInUser.personalityData.traits!.extraversion!.cheerfulness
                    personalityTraits["extraversionExcitementSeeking"] = loggedInUser.personalityData.traits!.extraversion!.excitementSeeking
                    personalityTraits["extraversionFriendliness"] = loggedInUser.personalityData.traits!.extraversion!.friendliness
                    personalityTraits["extraversionGregariousness"] = loggedInUser.personalityData.traits!.extraversion!.gregariousness
                    
                    personalityData["traits"] = personalityTraits
                    
                    
                    //print("Creating a new contact now...")
                    let contact = PFObject(className: "Contact")
                    contact["email"] = loggedInUser.email
                    contact["firstName"] = loggedInUser.firstName
                    contact["lastName"] = loggedInUser.lastName
                    contact["address"] = loggedInUser.address
                    contact["location"] = loggedInUser.location
                    contact["locality"] = loggedInUser.locality
                    contact["postCode"] = loggedInUser.postCode
                    contact["administrativeArea"] = loggedInUser.administrativeArea
                    contact["country"] = loggedInUser.country
                    
                    contact["location"] = loggedInUser.location
                    contact["signedInWith"] = loggedInUser.signedInWith
                    if loggedInUser.images.count > 0 {
                        let images0Data = UIImagePNGRepresentation(loggedInUser.images[0])
                        let images0File = PFFile(name:"image0.png", data:images0Data!)
                        
                        //let images1Data = UIImagePNGRepresentation(loggedInUser.images[1])
                        //let images1File = PFFile(name:"image[1].png", data:images1Data!)
                        
                        //let images2Data = UIImagePNGRepresentation(loggedInUser.images[2])
                        //let images2File = PFFile(name:"image[2].png", data:images2Data!)
                        
                        //var relation = contact.relationForKey("images")
                        //relation.addFile(images0File)
                        //relation.addFile(images1File)
                        //relation.addFile(images2File)
                        
                        contact["imagesFileArray"] = images0File //, images1File, images2File]
                    }
                    
                    let profileImageData = UIImagePNGRepresentation(loggedInUser.profileImage)
                    let profileImageFile = PFFile(name:"profileImage.png", data:profileImageData!)
                    contact["profileImage"] = profileImageFile
                    
                    contact["personalityData"] = personalityData
                    
                    switch loggedInUser.signedInWith {
                    case "Google":
                        let googleProfile = PFObject(className: "GoogleProfile")
                        //googleProfile["id"] = loggedInUser.googleId
                        googleProfile["name"] = loggedInUser.name
                        googleProfile["firstName"] = loggedInUser.firstName
                        googleProfile["lastName"] = loggedInUser.lastName
                        
                        googleProfile["gender"] = loggedInUser.googleGender
                        googleProfile["id"] = loggedInUser.googleId
                        googleProfile["name"] = loggedInUser.googleName
                        googleProfile["familyName"] = loggedInUser.googleFamilyName
                        googleProfile["lastName"] = loggedInUser.googleLastName
                        googleProfile["circledByCount"] = loggedInUser.googleCircledByCount
                        googleProfile["objectType"] = loggedInUser.googleObjectType
                        googleProfile["isPlusUser"] = loggedInUser.googleIsPlusUser
                    case "Facebook":
                        let facebookProfile = PFObject(className: "FacebookProfile")
                        facebookProfile["id"] = loggedInUser.id
                        facebookProfile["name"] = loggedInUser.name
                        facebookProfile["firstName"] = loggedInUser.firstName
                        facebookProfile["lastName"] = loggedInUser.lastName
                        facebookProfile["gender"] = loggedInUser.gender
                        facebookProfile["birthday"] = loggedInUser.birthday
                        
                        contact["name"] = loggedInUser.name
                        contact["facebookProfile"] = facebookProfile
                    case "Twitter":
                        contact["name"] = loggedInUser.twitterScreenName
                        let twitterProfile = PFObject(className: "TwitterProfile")
                        twitterProfile["id"] = loggedInUser.id
                        twitterProfile["userId"] = loggedInUser.twitterUserId
                        twitterProfile["screenName"] = loggedInUser.twitterScreenName
                        twitterProfile["name"] = loggedInUser.twitterName
                        twitterProfile["friendsCount"] = loggedInUser.twitterFriendsCount
                        twitterProfile["followersCount"] = loggedInUser.twitterFollowersCount
                        twitterProfile["location"] = loggedInUser.twitterLocation
                        twitterProfile["profileImageUrl"] = loggedInUser.twitterProfileImageUrlHttps
                        twitterProfile["profileBackgroundImageUrl"] = loggedInUser.twitterProfileBackgroundImageUrlHttps
                        twitterProfile["description"] = loggedInUser.twitterDescription
                        contact["twitterProfile"] = twitterProfile
                    default:
                        print("")
                    }
                    
                    contact.saveInBackgroundWithBlock { (successContact: Bool, errorContact: NSError?) -> Void in
                        if successContact == true {
                            //print("Contact has been saved.")
                        } else {
                            print(errorContact)
                        }
                    }
                    //} else {
                    //    print(error)
                    //}
                    //}
                } else {
                    print("there are many")
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func retrieveUserFromCloud(completionHandler: (data: Bool, error: NSError?) -> ()){
        var query = PFQuery(className:"Contact")
        query.whereKey("signedInWith", equalTo:loggedInUser.signedInWith)
        
        if loggedInUser.signedInWith == "Twitter" {
            query.whereKey("name", equalTo:loggedInUser.twitterScreenName)
        } else if loggedInUser.signedInWith == "Facebook" {
            query.whereKey("name", equalTo:loggedInUser.name)
        } else {
            query.whereKey("email", equalTo:loggedInUser.email)
        }
        
        query.findObjectsInBackgroundWithBlock { (contactObjects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if contactObjects!.count == 1 {
                    for contact in contactObjects! {
                        
                        loggedInUser.email = contact["email"] as! String
                        loggedInUser.firstName = contact["firstName"]  as! String
                        loggedInUser.lastName = contact["lastName"]  as! String
                        loggedInUser.address = contact["address"]  as! String
                        
                        loggedInUser.location = contact["location"]  as! String
                        loggedInUser.signedInWith = contact["signedInWith"]  as! String
                        
                        if let contactProfileImage = contact["profileImage"] as? PFFile {
                            contactProfileImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error:NSError?) -> Void in
                                if (error == nil) {
                                    
                                    let image = UIImage(data:imageData!)
                                    loggedInUser.profileImage = image
                                }
                            })
                        }
                        
                        switch contact["signedInWith"] as! String{
                        case "Google":
                            var googleProfile = contact["googleProfile"] as! PFObject
                            //loggedInUser.googleId = googleProfile["id"]  as! String
                            
                            loggedInUser.name = googleProfile["name"]  as! String
                            loggedInUser.firstName = googleProfile["firstName"]  as! String
                            loggedInUser.lastName = googleProfile["lastName"]  as! String
                            loggedInUser.gender = googleProfile["gender"]  as! String
                            loggedInUser.googleId = googleProfile["id"] as! String
                            loggedInUser.googleName = googleProfile["name"] as! String
                            loggedInUser.googleFamilyName = googleProfile["familyName"] as! String
                            loggedInUser.googleLastName = googleProfile["lastName"] as! String
                            loggedInUser.googleCircledByCount = googleProfile["circledByCount"] as! String
                            loggedInUser.googleObjectType = googleProfile["objectType"] as! String
                            loggedInUser.googleIsPlusUser = googleProfile["isPlusUser"] as! String
                            
                        case "Facebook":
                            var facebookProfile = contact["facebookProfile"] as! PFObject
                            loggedInUser.facebookId = facebookProfile["id"]  as! String
                            loggedInUser.name = facebookProfile["name"]  as! String
                            loggedInUser.firstName = facebookProfile["firstName"]  as! String
                            loggedInUser.lastName = facebookProfile["lastName"]  as! String
                            loggedInUser.gender = facebookProfile["gender"]  as! String
                            
                        case "Twitter":
                            var twitterProfile = contact["twitterProfile"] as! PFObject
                            loggedInUser.twitterId = twitterProfile["id"]  as! String
                            loggedInUser.twitterUserId = twitterProfile["userId"]  as! String
                            loggedInUser.twitterScreenName = twitterProfile["screenName"]  as! String
                            loggedInUser.twitterName = twitterProfile["name"]  as! String
                            loggedInUser.twitterFriendsCount = twitterProfile["friendsCount"]  as! Int
                            loggedInUser.twitterFollowersCount = twitterProfile["followersCount"]  as! Int
                            loggedInUser.twitterLocation = twitterProfile["location"]  as! String
                            loggedInUser.twitterProfileImageUrl = twitterProfile["profileImageUrl"]  as! String
                            loggedInUser.twitterProfileBackgroundImageUrl = twitterProfile["profileBackgroundImageUrl"]  as! String
                            loggedInUser.twitterDescription = twitterProfile["description"]  as! String
                            
                        default:
                            print("")
                        }
                        
                        if let personalityData = contact["personalityData"] as? PFObject {
                            loggedInUser.personalityData.personalitySummary =  personalityData["personalitySummary"]  as! String
                            loggedInUser.personalityData.personalitySummaryStatus = personalityData["personalitySummaryStatus"]  as! String
                            loggedInUser.personalityData.personalityTraits = personalityData["personalityTraits"]  as! String
                            loggedInUser.personalityData.lifeSatisfaction = personalityData["lifeSatisfaction"] as! String
                            loggedInUser.personalityData.intelligenceQuotient = personalityData["intelligenceQuotient"] as! String
                            loggedInUser.personalityData.emotionalQuotient = personalityData["emotionalQuotient"] as! String
                            loggedInUser.personalityData.friendlinessScore = personalityData["friendlinessScore"] as! String
                            loggedInUser.personalityData.trustScore = personalityData["trustScore"] as! String
                            loggedInUser.personalityData.creativity = personalityData["creativity"] as! String
                            loggedInUser.personalityData.innovation = personalityData["innovation"] as! String
                            loggedInUser.personalityData.imagination = personalityData["imagination"] as! String
                            loggedInUser.personalityData.learningStyle = personalityData["learningStyle"] as! String
                            loggedInUser.personalityData.imagination = personalityData["imagination"] as! String
                            loggedInUser.personalityData.thinkingStyle = personalityData["thinkingStyle"] as! String
                            loggedInUser.personalityData.academicPerformance = personalityData["academicPerformance"] as! String
                            loggedInUser.personalityData.carreerPerformance = personalityData["carreerPerformance"] as! String
                            loggedInUser.personalityData.strengths = personalityData["strengths"] as! [String]
                            loggedInUser.personalityData.personalRelationship = personalityData["personalRelationship"] as! String
                            
                            if let personalityTraits = personalityData["traits"] as? PFObject  {
                                //let personalityTraits = PFObject(className: "PersonalityTraits")
                                loggedInUser.personalityData.traits!.personalityTraitKey = personalityTraits["personalityTraitKey"] as! String
                                loggedInUser.personalityData.traits!.personalityTraitValue = personalityTraits["personalityTraitValue"] as! String
                                
                                //open
                                loggedInUser.personalityData.traits!.openness!.opennessKey = personalityTraits["opennessKey"] as! String
                                loggedInUser.personalityData.traits!.openness!.opennessValue = personalityTraits["opennessValue"]  as! Double
                                loggedInUser.personalityData.traits!.openness!.adventurousness = personalityTraits["openAdventurous"] as! Double
                                loggedInUser.personalityData.traits!.openness!.artisticInterests = personalityTraits["openArtisticInterests"] as! Double
                                loggedInUser.personalityData.traits!.openness!.emotionality = personalityTraits["openEmotionality"] as! Double
                                loggedInUser.personalityData.traits!.openness!.imagination = personalityTraits["openImagination"] as! Double
                                loggedInUser.personalityData.traits!.openness!.intellect = personalityTraits["openIntellect"] as! Double
                                loggedInUser.personalityData.traits!.openness!.liberalism = personalityTraits["openLiberalism"] as! Double
                                
                                //cons
                                loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessKey = personalityTraits["conscientiousnessKey"] as! String
                                loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessValue = personalityTraits["conscientiousnessValue"] as! Double
                                loggedInUser.personalityData.traits!.conscientiousness!.achievementStriving = personalityTraits["conscientiousAchievementStriving"] as! Double
                                loggedInUser.personalityData.traits!.conscientiousness!.cautiousness = personalityTraits["conscientiousCautiousness"] as! Double
                                loggedInUser.personalityData.traits!.conscientiousness!.dutifulness = personalityTraits["conscientiousDutifulness"] as! Double
                                loggedInUser.personalityData.traits!.conscientiousness!.orderliness = personalityTraits["conscientiousOrderliness"] as! Double
                                loggedInUser.personalityData.traits!.conscientiousness!.selfDiscipline = personalityTraits["conscientiousSelfDiscipline"]  as! Double
                                loggedInUser.personalityData.traits!.conscientiousness!.selfEfficacy = personalityTraits["conscientiousSelfEfficacy"]  as! Double
                                
                                //agreeable
                                loggedInUser.personalityData.traits!.agreeableness!.agreeablenessKey = personalityTraits["agreeablenessKey"] as! String
                                loggedInUser.personalityData.traits!.agreeableness!.agreeablenessValue = personalityTraits["agreeablenessValue"] as! Double
                                loggedInUser.personalityData.traits!.agreeableness!.altruism = personalityTraits["agreeableAltruism"] as! Double
                                loggedInUser.personalityData.traits!.agreeableness!.cooperation = personalityTraits["agreeableCooperation"] as! Double
                                loggedInUser.personalityData.traits!.agreeableness!.modesty = personalityTraits["agreeableModesty"] as! Double
                                loggedInUser.personalityData.traits!.agreeableness!.morality = personalityTraits["agreeableMorality"] as! Double
                                loggedInUser.personalityData.traits!.agreeableness!.sympathy = personalityTraits["agreeableSympathy"] as! Double
                                loggedInUser.personalityData.traits!.agreeableness!.trust = personalityTraits["agreeableTrust"]  as! Double
                                
                                //neuroticism
                                loggedInUser.personalityData.traits!.neuroticism!.neuroticismKey = personalityTraits["neuroticismKey"] as! String
                                loggedInUser.personalityData.traits!.neuroticism!.neuroticismValue = personalityTraits["neuroticismValue"] as! Double
                                loggedInUser.personalityData.traits!.neuroticism!.anger = personalityTraits["neuroticismAnger"] as! Double
                                loggedInUser.personalityData.traits!.neuroticism!.anxiety = personalityTraits["neuroticismAnxiety"] as! Double
                                loggedInUser.personalityData.traits!.neuroticism!.depression = personalityTraits["neuroticismDepression"] as! Double
                                loggedInUser.personalityData.traits!.neuroticism!.immoderation = personalityTraits["neuroticismImmoderation"] as! Double
                                loggedInUser.personalityData.traits!.neuroticism!.selfConsciousness = personalityTraits["neuroticismSelfConsciousness"] as! Double
                                loggedInUser.personalityData.traits!.neuroticism!.vulnerability = personalityTraits["neuroticismVulnerability"] as! Double
                                
                                //agreeable
                                loggedInUser.personalityData.traits!.extraversion!.extraversionKey = personalityTraits["extraversionKey"] as! String
                                loggedInUser.personalityData.traits!.extraversion!.extraversionValue = personalityTraits["extraversionValue"] as! Double
                                loggedInUser.personalityData.traits!.extraversion!.activityLevel = personalityTraits["extraversionActivityLevel"]  as! Double
                                loggedInUser.personalityData.traits!.extraversion!.assertiveness = personalityTraits["extraversionAssertiveness"] as! Double
                                loggedInUser.personalityData.traits!.extraversion!.cheerfulness = personalityTraits["extraversionCheerfulness"] as! Double
                                loggedInUser.personalityData.traits!.extraversion!.excitementSeeking = personalityTraits["extraversionExcitementSeeking"] as! Double
                                loggedInUser.personalityData.traits!.extraversion!.friendliness = personalityTraits["extraversionFriendliness"] as! Double
                                loggedInUser.personalityData.traits!.extraversion!.gregariousness = personalityTraits["extraversionGregariousness"] as! Double
                            }
                        }
                    }
                    completionHandler(data: true, error: error)
                } else {
                    completionHandler(data: false, error: error)
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func retrieveMatchingProfilesFromCloud(completionHandler: (data: Bool, error: NSError?) -> ()){
        //print("retrieveMatchingProfilesFromCloud")
        var query = PFQuery(className:"Contact")
        //query.whereKey("signedInWith", equalTo:loggedInUser.signedInWith)
        /*
        if loggedInUser.signedInWith == "Twitter" {
        query.whereKey("name", equalTo:loggedInUser.twitterScreenName)
        } else if loggedInUser.signedInWith == "Facebook" {
        query.whereKey("name", equalTo:loggedInUser.name)
        } else {
        query.whereKey("email", equalTo:loggedInUser.email)
        }*/
        matchingProfiles.removeAll()
        
        query.findObjectsInBackgroundWithBlock { (contactObjects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //if contactObjects!.count == 1 {
                var index = 0
                for contact in contactObjects! {
                    let tempContact = GoogleContact()
                    
                    tempContact.email = contact["email"] as! String
                    tempContact.firstName = contact["firstName"]  as! String
                    tempContact.lastName = contact["lastName"]  as! String
                    tempContact.address = contact["address"]  as! String
                    
                    tempContact.location = contact["location"]  as! String
                    tempContact.signedInWith = contact["signedInWith"]  as! String
                    
                    if let contactProfileImage = contact["profileImage"] as? PFFile {
                        contactProfileImage.getDataInBackgroundWithBlock({ (imageData: NSData?, error:NSError?) -> Void in
                            if (error == nil) {
                                
                                let image = UIImage(data:imageData!)
                               tempContact.profileImage = image
                            }
                        })
                    }
                    
                    switch contact["signedInWith"] as! String{
                    case "Google":
                        var googleProfile = contact["googleProfile"] as! PFObject
                        //matchingProfiles[index].googleId = googleProfile["id"]  as! String
                        
                       tempContact.name = googleProfile["name"]  as! String
                       tempContact.firstName = googleProfile["firstName"]  as! String
                       tempContact.lastName = googleProfile["lastName"]  as! String
                       tempContact.gender = googleProfile["gender"]  as! String
                       tempContact.googleId = googleProfile["id"] as! String
                       tempContact.googleName = googleProfile["name"] as! String
                       tempContact.googleFamilyName = googleProfile["familyName"] as! String
                       tempContact.googleLastName = googleProfile["lastName"] as! String
                       tempContact.googleCircledByCount = googleProfile["circledByCount"] as! String
                       tempContact.googleObjectType = googleProfile["objectType"] as! String
                       tempContact.googleIsPlusUser = googleProfile["isPlusUser"] as! String
                        
                    case "Facebook":
                        var facebookProfile = contact["facebookProfile"] as! PFObject
                       tempContact.facebookId = facebookProfile["id"]  as! String
                       tempContact.name = facebookProfile["name"]  as! String
                       tempContact.firstName = facebookProfile["firstName"]  as! String
                       tempContact.lastName = facebookProfile["lastName"]  as! String
                       tempContact.gender = facebookProfile["gender"]  as! String
                       tempContact.birthday = facebookProfile["birthday"] as! NSDate
                        
                    case "Twitter":
                        var twitterProfile = contact["twitterProfile"] as! PFObject
                       tempContact.twitterId = twitterProfile["id"]  as! String
                       tempContact.twitterUserId = twitterProfile["userId"]  as! String
                       tempContact.twitterScreenName = twitterProfile["screenName"]  as! String
                       tempContact.twitterName = twitterProfile["name"]  as! String
                       tempContact.twitterFriendsCount = twitterProfile["friendsCount"]  as! Int
                       tempContact.twitterFollowersCount = twitterProfile["followersCount"]  as! Int
                       tempContact.twitterLocation = twitterProfile["location"]  as! String
                       tempContact.twitterProfileImageUrl = twitterProfile["profileImageUrl"]  as! String
                       tempContact.twitterProfileBackgroundImageUrl = twitterProfile["profileBackgroundImageUrl"]  as! String
                       tempContact.twitterDescription = twitterProfile["description"]  as! String
                        
                    default:
                        print("")
                    }
                    
                    if let personalityData = contact["personalityData"] as? PFObject {
                       tempContact.personalityData.personalitySummary =  personalityData["personalitySummary"]  as! String
                       tempContact.personalityData.personalitySummaryStatus = personalityData["personalitySummaryStatus"]  as! String
                       tempContact.personalityData.personalityTraits = personalityData["personalityTraits"]  as! String
                       tempContact.personalityData.lifeSatisfaction = personalityData["lifeSatisfaction"] as! String
                       tempContact.personalityData.intelligenceQuotient = personalityData["intelligenceQuotient"] as! String
                       tempContact.personalityData.emotionalQuotient = personalityData["emotionalQuotient"] as! String
                       tempContact.personalityData.friendlinessScore = personalityData["friendlinessScore"] as! String
                       tempContact.personalityData.trustScore = personalityData["trustScore"] as! String
                       tempContact.personalityData.creativity = personalityData["creativity"] as! String
                       tempContact.personalityData.innovation = personalityData["innovation"] as! String
                       tempContact.personalityData.imagination = personalityData["imagination"] as! String
                       tempContact.personalityData.learningStyle = personalityData["learningStyle"] as! String
                       tempContact.personalityData.imagination = personalityData["imagination"] as! String
                       tempContact.personalityData.thinkingStyle = personalityData["thinkingStyle"] as! String
                       tempContact.personalityData.academicPerformance = personalityData["academicPerformance"] as! String
                       tempContact.personalityData.carreerPerformance = personalityData["carreerPerformance"] as! String
                       tempContact.personalityData.strengths = personalityData["strengths"] as! [String]
                       tempContact.personalityData.personalRelationship = personalityData["personalRelationship"] as! String
                        
                        if let personalityTraits = personalityData["traits"] as? PFObject  {
                            //let personalityTraits = PFObject(className: "PersonalityTraits")
                           tempContact.personalityData.traits!.personalityTraitKey = personalityTraits["personalityTraitKey"] as! String
                           tempContact.personalityData.traits!.personalityTraitValue = personalityTraits["personalityTraitValue"] as! String
                            
                            //open
                           tempContact.personalityData.traits!.openness!.opennessKey = personalityTraits["opennessKey"] as! String
                           tempContact.personalityData.traits!.openness!.opennessValue = personalityTraits["opennessValue"]  as! Double
                           tempContact.personalityData.traits!.openness!.adventurousness = personalityTraits["openAdventurous"] as! Double
                           tempContact.personalityData.traits!.openness!.artisticInterests = personalityTraits["openArtisticInterests"] as! Double
                           tempContact.personalityData.traits!.openness!.emotionality = personalityTraits["openEmotionality"] as! Double
                           tempContact.personalityData.traits!.openness!.imagination = personalityTraits["openImagination"] as! Double
                           tempContact.personalityData.traits!.openness!.intellect = personalityTraits["openIntellect"] as! Double
                           tempContact.personalityData.traits!.openness!.liberalism = personalityTraits["openLiberalism"] as! Double
                            
                            //cons
                           tempContact.personalityData.traits!.conscientiousness!.conscientiousnessKey = personalityTraits["conscientiousnessKey"] as! String
                           tempContact.personalityData.traits!.conscientiousness!.conscientiousnessValue = personalityTraits["conscientiousnessValue"] as! Double
                           tempContact.personalityData.traits!.conscientiousness!.achievementStriving = personalityTraits["conscientiousAchievementStriving"] as! Double
                           tempContact.personalityData.traits!.conscientiousness!.cautiousness = personalityTraits["conscientiousCautiousness"] as! Double
                           tempContact.personalityData.traits!.conscientiousness!.dutifulness = personalityTraits["conscientiousDutifulness"] as! Double
                           tempContact.personalityData.traits!.conscientiousness!.orderliness = personalityTraits["conscientiousOrderliness"] as! Double
                           tempContact.personalityData.traits!.conscientiousness!.selfDiscipline = personalityTraits["conscientiousSelfDiscipline"]  as! Double
                           tempContact.personalityData.traits!.conscientiousness!.selfEfficacy = personalityTraits["conscientiousSelfEfficacy"]  as! Double
                            
                            //agreeable
                           tempContact.personalityData.traits!.agreeableness!.agreeablenessKey = personalityTraits["agreeablenessKey"] as! String
                           tempContact.personalityData.traits!.agreeableness!.agreeablenessValue = personalityTraits["agreeablenessValue"] as! Double
                           tempContact.personalityData.traits!.agreeableness!.altruism = personalityTraits["agreeableAltruism"] as! Double
                           tempContact.personalityData.traits!.agreeableness!.cooperation = personalityTraits["agreeableCooperation"] as! Double
                           tempContact.personalityData.traits!.agreeableness!.modesty = personalityTraits["agreeableModesty"] as! Double
                           tempContact.personalityData.traits!.agreeableness!.morality = personalityTraits["agreeableMorality"] as! Double
                           tempContact.personalityData.traits!.agreeableness!.sympathy = personalityTraits["agreeableSympathy"] as! Double
                           tempContact.personalityData.traits!.agreeableness!.trust = personalityTraits["agreeableTrust"]  as! Double
                            
                            //neuroticism
                           tempContact.personalityData.traits!.neuroticism!.neuroticismKey = personalityTraits["neuroticismKey"] as! String
                           tempContact.personalityData.traits!.neuroticism!.neuroticismValue = personalityTraits["neuroticismValue"] as! Double
                           tempContact.personalityData.traits!.neuroticism!.anger = personalityTraits["neuroticismAnger"] as! Double
                           tempContact.personalityData.traits!.neuroticism!.anxiety = personalityTraits["neuroticismAnxiety"] as! Double
                           tempContact.personalityData.traits!.neuroticism!.depression = personalityTraits["neuroticismDepression"] as! Double
                           tempContact.personalityData.traits!.neuroticism!.immoderation = personalityTraits["neuroticismImmoderation"] as! Double
                           tempContact.personalityData.traits!.neuroticism!.selfConsciousness = personalityTraits["neuroticismSelfConsciousness"] as! Double
                           tempContact.personalityData.traits!.neuroticism!.vulnerability = personalityTraits["neuroticismVulnerability"] as! Double
                            
                            //agreeable
                           tempContact.personalityData.traits!.extraversion!.extraversionKey = personalityTraits["extraversionKey"] as! String
                           tempContact.personalityData.traits!.extraversion!.extraversionValue = personalityTraits["extraversionValue"] as! Double
                           tempContact.personalityData.traits!.extraversion!.activityLevel = personalityTraits["extraversionActivityLevel"]  as! Double
                           tempContact.personalityData.traits!.extraversion!.assertiveness = personalityTraits["extraversionAssertiveness"] as! Double
                           tempContact.personalityData.traits!.extraversion!.cheerfulness = personalityTraits["extraversionCheerfulness"] as! Double
                           tempContact.personalityData.traits!.extraversion!.excitementSeeking = personalityTraits["extraversionExcitementSeeking"] as! Double
                           tempContact.personalityData.traits!.extraversion!.friendliness = personalityTraits["extraversionFriendliness"] as! Double
                           tempContact.personalityData.traits!.extraversion!.gregariousness = personalityTraits["extraversionGregariousness"] as! Double
                        }
                    }
                    index++
                    matchingProfiles.append(tempContact)
                    //print(matchingProfiles.count)
                    completionHandler(data: true, error: error)
                }
            } else {
                completionHandler(data: false, error: error)
            }
            //} else {
            //    print("Error: \(error!) \(error!.userInfo)")
            //}
        }
    }
}