//
//  GoogleContact.swift
//  Evol.Me
//
//  Created by Paul.Raj on 7/20/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation

class GoogleContact: NSObject, NSCoding {
    
    var signedInWith = ""
    
    var isLoggedIn = false
    var accessToken = ""
    var refreshToken = ""
    var accessTokenExpirationDate = NSDate()
    
    var id = ""
    var firstName = ""
    var lastName = ""
    var name: String! = ""
    var website: String! = ""
    
    var phoneNumber = ""
    var birthday = NSDate()
    var birthYear = ""
    
    //address related
    var location = ""
    var address = ""
    var locality = ""
    var postCode = ""
    var administrativeArea = ""
    var subAdministrativeArea = ""
    var subLocality = ""
    var subThoroughfare = ""
    var thoroughfare = ""
    var country = ""
    var countryCode = ""
    
    var email = ""
    var images: [UIImage!] = []
    var profileImage: UIImage! = UIImage()
    var backgroundImage: UIImage! = UIImage()
    var profileImageURL = ""
    var backgroundImageURL = ""
    
    
    var lastUpdated = ""
    var groups: [Dictionary<String, String>] = []
    var age:String! = ""
    
    var jobTitle = ""
    var organization = ""
    
    //Google related
    var googleClientId = ""
    var googleGender = ""
    var googleId = ""
    var googleName = ""
    var googleFamilyName = ""
    var googleLastName = ""
    var googleCircledByCount = ""
    var googleObjectType = ""
    var googleIsPlusUser = ""
    
    //Facebook properties
    var facebookId = ""
    var facebookUserName = ""
    var facebookProfileImageUrl = ""
    
    //app properties
    var emailCount:Int! = 0
    var emailSubject: [Dictionary<String, String>] = []
    var allEmailContent:String! = ""
    var wordsToAnalyze = 0
    var analysisAccuracy = 0.0
    var inviteSent = Bool()
    
    //Google plus contacts propertis
    var googlePlusUser = false
    var googlePlusId = ""
    var googlePlusImageURL = ""
    var googlePlusImage = UIImage()
    var gender = ""
    var givenName = ""
    var familyName = ""
    var coverImage = UIImage()
    var placesLived: [Dictionary<String, String>] = []
    var occupation = ""
    var relationshipStatus = ""
    var aboutMe: String! = ""
    
    //phone contacts properties
    //var socialProfiles: [Dictionary<String, String>] = []
    var urls: [Dictionary<String, String>] = []

    var personalityData: PersonalityData = PersonalityData()
    var socialProfiles: [SocialProfile] = []
    var mailsToAnalyze = 200
    var analyzeOnWifiOnly  = false
    
    var popularityScore = ""
    
    //twitter properties
    var twitterId = ""
    var twitterUserId = ""
    var twitterScreenName = ""
    var twitterName = ""
    var twitterFriendsCount = 0
    var twitterFollowersCount = 0
    var twitterStatusesCount = 0
    var twitterProfileImageUrl = ""
    var twitterProfileBackgroundImageUrl = ""
    var twitterProfileImageUrlHttps = ""
    var twitterProfileBackgroundImageUrlHttps = ""
    var twitterLocation = ""
    var twitterDescription = ""
    var twitterTotalTweets = 0
    var twitterOauthTokenKey = ""
    var twitterOauthTokenSecret = ""
    var twitterFriendsListCursor = ""
    var twitterFollowersListCursor = ""
    
    var authData: AuthData = AuthData()
    
    //linked profiles
    var linkedinPictureUrl = ""
    var linkedinCompanyName = ""
    var linkedinCompanyType = ""
    var linkedinCompanyIndustry = ""
    var linkedinPositionCurrent = ""
    var linkedinPositionStartDate = ""
    var linkedinPositionTitle = ""
    
    /*override init() {
        super.init(nibName: nil, bundle: nil)
        //Do whatever you want here
    }
    */
    
    /*override init(){
        personalityData = PersonalityData()
        image = UIImage(named: "default_avatar.png")
        emailCount = 0
    }*/
    
    override init() {
        super.init()
        //image = UIImage(named: "default_avatar.png")
        //emailCount = 0
    }
    
    required init(coder aDecoder: NSCoder!) {
        //super.init(coder: aDecoder)
        
        if let isLoggedIn = aDecoder.decodeObjectForKey("isLoggedIn") as? Bool {
            self.isLoggedIn = isLoggedIn
        }
        if let signedInWith = aDecoder.decodeObjectForKey("signedInWith") as? String {
            self.signedInWith = signedInWith
        }
        
        if let inviteSent = aDecoder.decodeObjectForKey("inviteSent") as? Bool {
            self.inviteSent = inviteSent
        }
        
        if let accessToken = aDecoder.decodeObjectForKey("accessToken") as? String {
            self.accessToken = accessToken
        }
        if let refreshToken = aDecoder.decodeObjectForKey("refreshToken") as? String {
            self.refreshToken = refreshToken
        }
        if let accessTokenExpirationDate = aDecoder.decodeObjectForKey("accessTokenExpirationDate") as? NSDate {
            self.accessTokenExpirationDate = accessTokenExpirationDate
        }
        
        if let id = aDecoder.decodeObjectForKey("id") as? String {
            self.id = id
        }
        if let firstName = aDecoder.decodeObjectForKey("firstName") as? String {
            self.firstName = firstName
        }
        if let lastName = aDecoder.decodeObjectForKey("lastName") as? String {
            self.lastName = lastName
        }
        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
        if let website = aDecoder.decodeObjectForKey("website") as? String {
            self.website = website
        }
        
        if let birthday = aDecoder.decodeObjectForKey("birthday") as? NSDate {
            self.birthday = birthday
        }
        if let phoneNumber = aDecoder.decodeObjectForKey("phoneNumber") as? String {
            self.phoneNumber = phoneNumber
        }
        if let lastUpdated = aDecoder.decodeObjectForKey("lastUpdated") as? String {
            self.lastUpdated = lastUpdated
        }
        if let location = aDecoder.decodeObjectForKey("location") as? String {
            self.location = location
        }
        if let email = aDecoder.decodeObjectForKey("email") as? String {
            self.email = email
        }
        if let age = aDecoder.decodeObjectForKey("age") as? String {
            self.age = age
        }
        /*
        if let image = aDecoder.decodeObjectForKey("images[0]") as? NSData {
            self.images[0] = UIImage(data: image)
        }
        */
        if let profileImage = aDecoder.decodeObjectForKey("profileImage") as? NSData {
            self.profileImage = UIImage(data: profileImage)
        }
        
        if let aboutMe = aDecoder.decodeObjectForKey("aboutMe") as? String {
            self.aboutMe = aboutMe
        }
        if let groups = aDecoder.decodeObjectForKey("groups") as? [Dictionary<String, String>] {
            self.groups = groups
        }
        
        if let allEmailContent = aDecoder.decodeObjectForKey("allEmailContent") as? String {
            self.allEmailContent = allEmailContent
        }
        if let emailCount = aDecoder.decodeObjectForKey("emailCount") as? Int {
            self.emailCount = emailCount
        }
        if let emailSubject = aDecoder.decodeObjectForKey("emailSubject") as? [Dictionary<String, String>] {
            self.emailSubject = emailSubject
        }
        if let wordsToAnalyze = aDecoder.decodeObjectForKey("wordsToAnalyze") as? Int {
            self.wordsToAnalyze = wordsToAnalyze
        }
        if let analysisAccuracy = aDecoder.decodeObjectForKey("analysisAccuracy") as? Double {
            self.analysisAccuracy = analysisAccuracy
        }
        
        if let googlePlusUser = aDecoder.decodeObjectForKey("googlePlusUser") as? Bool {
            self.googlePlusUser = googlePlusUser
        }
        if let googlePlusId = aDecoder.decodeObjectForKey("googlePlusId") as? String {
            self.googlePlusId = googlePlusId
        }
        if let googlePlusImageURL = aDecoder.decodeObjectForKey("googlePlusImageURL") as? String {
            self.googlePlusImageURL = googlePlusImageURL
        }
        if let googlePlusImageData = aDecoder.decodeObjectForKey("googlePlusImage") as? NSData {
            self.googlePlusImage = UIImage(data: googlePlusImageData)!
        }
        if let gender = aDecoder.decodeObjectForKey("gender") as? String {
            self.gender = gender
        }
        if let givenName = aDecoder.decodeObjectForKey("givenName") as? String {
            self.givenName = givenName
        }
        if let familyName = aDecoder.decodeObjectForKey("familyName") as? String {
            self.familyName = familyName
        }
        if let coverImageData = aDecoder.decodeObjectForKey("coverImage") as? NSData {
            self.coverImage = UIImage(data: coverImageData)!
        }
        if let placesLived = aDecoder.decodeObjectForKey("placesLived") as? [Dictionary<String, String>] {
            self.placesLived = placesLived
        }
        if let occupation = aDecoder.decodeObjectForKey("occupation") as? String {
            self.occupation = occupation
        }
        
        if let jobTitle = aDecoder.decodeObjectForKey("jobTitle") as? String {
            self.jobTitle = jobTitle
        }
        if let organization = aDecoder.decodeObjectForKey("organization") as? String {
            self.organization = organization
        }
        if let relationshipStatus = aDecoder.decodeObjectForKey("relationshipStatus") as? String {
            self.relationshipStatus = relationshipStatus
        }
        
        /*
        if let data = aDecoder.decodeObjectForKey("personalityData") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let personalityData = unarc.decodeObjectForKey("root") as! PersonalityData
            self.personalityData = personalityData
        }*/
        
        if let mailsToAnalyze = aDecoder.decodeObjectForKey("mailsToAnalyze") as? Int {
            self.mailsToAnalyze = mailsToAnalyze
        }
        
        if let analyzeOnWifiOnly = aDecoder.decodeObjectForKey("analyzeOnWifiOnly") as? Bool {
            self.analyzeOnWifiOnly = analyzeOnWifiOnly
        }
        
        /*if let socialProfiles = aDecoder.decodeObjectForKey("socialProfiles") as? [Dictionary<String, String>] {
            self.socialProfiles = socialProfiles
        }*/
        
        if let urls = aDecoder.decodeObjectForKey("urls") as? [Dictionary<String, String>] {
            self.urls = urls
        }
        if let popularityScore = aDecoder.decodeObjectForKey("popularityScore") as? String {
            self.popularityScore = popularityScore
        }
        
        if let twitterUserId = aDecoder.decodeObjectForKey("twitterUserId") as? String {
            self.twitterUserId = twitterUserId
        }
        if let twitterScreenName = aDecoder.decodeObjectForKey("twitterScreenName") as? String {
            self.twitterScreenName = twitterScreenName
        }
        if let twitterDescription = aDecoder.decodeObjectForKey("twitterDescription") as? String {
            self.twitterDescription = twitterDescription
        }
        if let twitterOauthTokenKey = aDecoder.decodeObjectForKey("twitterOauthTokenKey") as? String {
            self.twitterOauthTokenKey = twitterOauthTokenKey
        }
        if let twitterOauthTokenSecret = aDecoder.decodeObjectForKey("twitterOauthTokenSecret") as? String {
            self.twitterOauthTokenSecret = twitterOauthTokenSecret
        }
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(isLoggedIn, forKey: "isLoggedIn")
        aCoder.encodeObject(signedInWith, forKey: "signedInWith")
        
        aCoder.encodeObject(inviteSent, forKey: "inviteSent")
        
        aCoder.encodeObject(accessToken, forKey: "accessToken")
        aCoder.encodeObject(refreshToken, forKey: "refreshToken")
        aCoder.encodeObject(accessTokenExpirationDate, forKey: "accessTokenExpirationDate")
        
        if let name = self.name {
            aCoder.encodeObject(name, forKey: "name")
        }
        if let website = self.website {
            aCoder.encodeObject(website, forKey: "website")
        }
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(firstName, forKey: "firstName")
        aCoder.encodeObject(lastName, forKey: "lastName")
        aCoder.encodeObject(birthday, forKey: "birthday")
        aCoder.encodeObject(phoneNumber, forKey: "phoneNumber")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(lastUpdated, forKey: "lastUpdated")
        aCoder.encodeObject(groups, forKey: "groups")
        
        aCoder.encodeObject(emailSubject, forKey: "emailSubject")
        aCoder.encodeObject(wordsToAnalyze, forKey: "wordsToAnalyze")
        aCoder.encodeObject(analysisAccuracy, forKey: "analysisAccuracy")
        
        aCoder.encodeObject(googlePlusUser, forKey: "googlePlusUser")
        aCoder.encodeObject(googlePlusId, forKey: "googlePlusId")
        aCoder.encodeObject(googlePlusImageURL, forKey: "googlePlusImageURL")
        aCoder.encodeObject(googlePlusImage, forKey: "googlePlusImage")
        aCoder.encodeObject(gender, forKey: "gender")
        aCoder.encodeObject(givenName, forKey: "givenName")
        aCoder.encodeObject(familyName, forKey: "familyName")
        aCoder.encodeObject(coverImage, forKey: "coverImage")
        aCoder.encodeObject(placesLived, forKey: "placesLived")
        aCoder.encodeObject(occupation, forKey: "occupation")
        aCoder.encodeObject(jobTitle, forKey: "jobTitle")
        aCoder.encodeObject(organization, forKey: "organization")
        aCoder.encodeObject(relationshipStatus, forKey: "relationshipStatus")
        
        //aCoder.encodeObject(socialProfiles, forKey: "socialProfiles")
        aCoder.encodeObject(urls, forKey: "urls")
        
        //aCoder.encodeObject(NSKeyedArchiver.archivedDataWithRootObject(personalityData), forKey: "personalityData")
        
        aCoder.encodeObject(email, forKey: "email")
        
        if let emailCount = self.emailCount {
            aCoder.encodeObject(emailCount, forKey: "emailCount")
        }
        
        if let age = self.age {
            aCoder.encodeObject(age, forKey: "age")
        }
        /*
        if let image = self.images[0] {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image[0]")
        }*/
        if let profileImage = self.profileImage {
            aCoder.encodeObject(UIImagePNGRepresentation(profileImage), forKey: "profileImage")
        }
        /*
        if let image = self.image2 {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image2")
        }
        if let image = self.image3 {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image3")
        }
        if let image = self.image4 {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image4")
        }
        if let image = self.image5 {
            aCoder.encodeObject(UIImagePNGRepresentation(image), forKey: "image5")
        }
        */
        if let allEmailContent = self.allEmailContent {
            aCoder.encodeObject(allEmailContent, forKey: "allEmailContent")
        }
        
        if let aboutMe = self.aboutMe {
            aCoder.encodeObject(aboutMe, forKey: "aboutMe")
        }
        
        aCoder.encodeObject(mailsToAnalyze, forKey: "mailsToAnalyze")
        aCoder.encodeObject(analyzeOnWifiOnly, forKey: "analyzeOnWifiOnly")
        aCoder.encodeObject(popularityScore, forKey: "popularityScore")
        
        aCoder.encodeObject(twitterUserId, forKey: "twitterUserId")
        aCoder.encodeObject(twitterScreenName, forKey: "twitterScreenName")
        
        aCoder.encodeObject(twitterDescription, forKey: "twitterDescription")
        
        aCoder.encodeObject(twitterOauthTokenKey, forKey: "twitterOauthTokenKey")
        aCoder.encodeObject(twitterOauthTokenSecret, forKey: "twitterOauthTokenSecret")
        
    }
    
    func getLifeSatisfactionScore(contact: GoogleContact) -> NSString {
        //http://essay.utwente.nl/64907/1/M%C3%BCller,%20ML%20-%20s0163465%20(verslag).pdf
        //file:///Users/paulraj/Downloads/SM_2013012816082918%20(4).pdf
        //http://www.hkcss.org.hk/uploadfileMgnt/0_201443011362.pdf
        //http://www.ksbe.edu/_assets/spi/pdfs/survey_toolkit/other_samples/pavot_diener.pdf
        //http://www.unt.edu/rss/SWLS.pdf
        
        var lifeSatisfaction =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.08 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.13 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.20 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.08 +
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.42
            contact.personalityData.lifeSatisfaction = (padZeros(lifeSatisfaction) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
        return contact.personalityData.lifeSatisfaction
    }
    
    func getHappinessScore(contact: GoogleContact) -> NSString {
        if contact.personalityData.happiness != "" {
            switch (((Double(contact.personalityData.happiness)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.lifeSatisfaction = "Very Extremely Happy"
            case 22..<29 :
                contact.personalityData.lifeSatisfaction = "Extremly Happy"
            case 16..<22:
                contact.personalityData.lifeSatisfaction = "Really Happy"
            case 13..<16:
                contact.personalityData.lifeSatisfaction = "Slightly Happy"
            case 9..<13:
                contact.personalityData.lifeSatisfaction = "Neither Happy or Sad"
            case 4..<9:
                contact.personalityData.lifeSatisfaction = "Slightly Unhappy"
            case 2..<4:
                contact.personalityData.lifeSatisfaction = "Totally Unhappy"
            default:
                contact.personalityData.lifeSatisfaction = "Extremely Unhappy"
            }
        }
        
        
        /*
        var lifeSatisfaction =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.19 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.30 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.28 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.44 -
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.50
        //contact.personalityData.lifeSatisfaction = padZeros(lifeSatisfaction)

        if lifeSatisfaction < 10 {
            contact.personalityData.lifeSatisfaction = padZeros(lifeSatisfaction)
            return contact.personalityData.lifeSatisfaction
        } else {
            contact.personalityData.lifeSatisfaction = (padZeros(lifeSatisfaction) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
            return contact.personalityData.lifeSatisfaction
        }*/
        return contact.personalityData.lifeSatisfaction
    }
    
    func getIntelligenceQuotientScore(contact: GoogleContact)-> NSString {
        //http://anepigone.blogspot.com/2010/01/big-5-personality-traits-and-iq-voting.html
        //http://www.people.vcu.edu/~mamcdani/Publications/McDaniel%20(2006)%20Estimating%20state%20IQ.pdf
        
        var intelligenceQuotient =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.87 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.70 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.12 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.93 +
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.76
        
        var iq = self.padZeros(intelligenceQuotient)
        
        if intelligenceQuotient >= 0 && intelligenceQuotient < 100 {
            contact.personalityData.intelligenceQuotient = (iq as! NSString).substringWithRange(NSRange(location: 0, length: 2))
            return contact.personalityData.intelligenceQuotient
        } else {
            if intelligenceQuotient > 145 {
                iq = "145"
                contact.personalityData.intelligenceQuotient = (iq as NSString).substringWithRange(NSRange(location: 0, length: 3))
                return contact.personalityData.intelligenceQuotient
            } else {
                contact.personalityData.intelligenceQuotient = (iq as NSString).substringWithRange(NSRange(location: 0, length: 3))
                return contact.personalityData.intelligenceQuotient
            }
        }
    }
    
    func getEmotionalQuotientScore(contact: GoogleContact)-> NSString {
        loggedInUser.personalityData.emotionalQuotient = String(Int(loggedInUser.personalityData.traits!.openness!.emotionality))
        var emotionalQuotient =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.29 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.27 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.22 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.31 -
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.18
        
        var eq = self.padZeros(emotionalQuotient)
        
        if emotionalQuotient >= 0 && emotionalQuotient < 99 {
            contact.personalityData.emotionalQuotient = (eq as! NSString).substringWithRange(NSRange(location: 0, length: 2))
            return contact.personalityData.emotionalQuotient
        } else {
            if emotionalQuotient > 145 {
                eq = "145"
                contact.personalityData.emotionalQuotient = (eq as! NSString).substringWithRange(NSRange(location: 0, length: 3))
                return contact.personalityData.emotionalQuotient
            } else {
                contact.personalityData.emotionalQuotient =  (eq as! NSString).substringWithRange(NSRange(location: 0, length: 3))
                return contact.personalityData.emotionalQuotient
            }
        }
    }
    
    func getIndependent(contact: GoogleContact)-> NSString {
        if contact.personalityData.independentScore != "" {
            switch (((Double(contact.personalityData.independentScore)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.independent = "True Independent"
            case 22..<29 :
                contact.personalityData.independent = "Always Independent"
            case 16..<22:
                contact.personalityData.independent = "Most of the time Independent"
            case 13..<16:
                contact.personalityData.independent = "Sometimes Independent"
            case 9..<13:
                contact.personalityData.independent = "Neither Independent or Dependent"
            case 0..<9:
                contact.personalityData.independent = "Not Really Independent"
            default:
                contact.personalityData.independent = "Not Really Independent"
            }
        }
        return contact.personalityData.independent
    }
    
    func getBuinessMinded(contact: GoogleContact)-> NSString {
        if contact.personalityData.marketingIq != "" {
            switch (((Double(contact.personalityData.marketingIq)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.businessMinded = "Expert"
            case 22..<29 :
                contact.personalityData.businessMinded = "Always Independent"
            case 16..<22:
                contact.personalityData.businessMinded = "Most of the time Independent"
            case 13..<16:
                contact.personalityData.businessMinded = "Sometimes Independent"
            case 9..<13:
                contact.personalityData.businessMinded = "Neither Independent or Dependent"
            case 0..<9:
                contact.personalityData.businessMinded = "Not Really Independent"
            default:
                contact.personalityData.businessMinded = "Not Really Independent"
            }
        }
        return contact.personalityData.independent
    }
    
    func getFamilyOrientedScore(contact: GoogleContact)-> NSString {
        if contact.personalityData.familyOrientedScore != "" {
            switch (((Double(contact.personalityData.familyOrientedScore)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.familyOriented = "Family is top priority!"
            case 22..<29 :
                contact.personalityData.familyOriented = "Family is always important"
            case 16..<22:
                contact.personalityData.familyOriented = "Family is important most of the time"
            case 13..<16:
                contact.personalityData.familyOriented = "Family is important like others"
            case 9..<13:
                contact.personalityData.familyOriented = "Family is sometimes important"
            case 4..<9:
                contact.personalityData.familyOriented = "Family is rarely important"
            case 2..<4:
                contact.personalityData.familyOriented = "Family is not important"
            default:
                contact.personalityData.familyOriented = "Family is not at all important"
            }
        }
        return contact.personalityData.familyOriented
    }
    
    func getFriendlinessScore(contact: GoogleContact)-> NSString {
        if contact.personalityData.socialSkills != "" {
            switch (((Double(contact.personalityData.socialSkills)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.friendlinessScore = "Always Very Much Friendly"
            case 22..<29 :
                contact.personalityData.friendlinessScore = "Always Very Friendly"
            case 16..<22:
                contact.personalityData.friendlinessScore = "Always Friendly"
            case 13..<16:
                contact.personalityData.friendlinessScore = "Mostly Friendly"
            case 9..<13:
                contact.personalityData.friendlinessScore = "Sometimes Friendly"
            case 4..<9:
                contact.personalityData.friendlinessScore = "Neither Friendly Nor Unfriendly"
            case 2..<4:
                contact.personalityData.friendlinessScore = "Not Friendly Always"
            default:
                contact.personalityData.friendlinessScore = "Not Friendly Always"
            }
        } else {
            var friendliness =
            (contact.personalityData.traits?.openness?.opennessValue)!*0.31 -
                (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.14 +
                (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.25 +
                (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.57 -
                (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.30
            var friendly = padZeros(friendliness)
            
            if friendliness >= 0 && friendliness < 99 {
                //contact.personalityData.friendlinessScore = padZeros(friendliness)
                
                contact.personalityData.friendlinessScore = (friendly as! NSString).substringWithRange(NSRange(location: 0, length: 2))
                var score = contact.personalityData.friendlinessScore
                switch (((Double(score)!)+1)*35/100) {
                case 29..<35 :
                    contact.personalityData.friendlinessScore = "Always Very Much Friendly"
                case 22..<29 :
                    contact.personalityData.friendlinessScore = "Always Very Friendly"
                case 16..<22:
                    contact.personalityData.friendlinessScore = "Always Friendly"
                case 13..<16:
                    contact.personalityData.friendlinessScore = "Mostly Friendly"
                case 9..<13:
                    contact.personalityData.friendlinessScore = "Sometimes Friendly"
                case 4..<9:
                    contact.personalityData.friendlinessScore = "Neither Friendly Nor Unfriendly"
                case 2..<4:
                    contact.personalityData.friendlinessScore = "Not Friendly Always"
                default:
                    contact.personalityData.friendlinessScore = "Not Friendly Always"
                }
                return contact.personalityData.friendlinessScore
            } else {
                if friendliness > 145 {
                    contact.personalityData.friendlinessScore = "145"
                    friendly = (contact.personalityData.friendlinessScore as! NSString).substringWithRange(NSRange(location: 0, length: 3))
                    return contact.personalityData.friendlinessScore
                } else {
                    friendly = (contact.personalityData.friendlinessScore as! NSString).substringWithRange(NSRange(location: 0, length: 3))
                    return contact.personalityData.friendlinessScore
                }
            }
        }

        return contact.personalityData.friendlinessScore
    }
    
    func getAcademicPerformanceScore(contact: GoogleContact) -> NSString {
       
        var academicPerformance = 0.0
        if contact.personalityData.achievementDriven != "" {
            if contact.personalityData.achievementDriven != "" {
                academicPerformance = Double(contact.personalityData.achievementDriven)!+1
            } else {
                academicPerformance =
                    (contact.personalityData.traits?.openness?.opennessValue)!*0.37 +
                    (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.43 +
                    (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.55 +
                    (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.32 -
                    (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.002
                
            }
        } else {
            academicPerformance =
            (contact.personalityData.traits?.openness?.opennessValue)!*0.37 +
                (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.43 +
                (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.55 +
                (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.32 -
                (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.002
        }
        
        
        var value = (padZeros(academicPerformance) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
        var academic = ""
        print(value)
        print("value is ")
        if Int(value) > Int(75) {
            academic = "A+"
        } else if Int(value) > Int(65) {
            academic = "A"
        } else if Int(value) > Int(55) {
            academic = "B+"
        } else if Int(value) > Int(45) {
            academic = "B"
        } else {
            academic = "B"
        }
        contact.personalityData.academicPerformance = academic
                //contact.personalityData.academicPerformance =
        
        return  contact.personalityData.academicPerformance
    }
    
    func getCarreerPerformanceScore(contact: GoogleContact) -> NSString {
        
        var carreerPerformance =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.07 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.10 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.39 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.33 -
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.26
        //contact.personalityData.carreerPerformance = padZeros(carreerPerformance)
        contact.personalityData.carreerPerformance = (padZeros(carreerPerformance) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
        
        return contact.personalityData.carreerPerformance
    }
    
    func getCarreerPerformanceScore2(contact: GoogleContact) -> NSString {
        if contact.personalityData.workhorse != "" {
            switch (((Double(contact.personalityData.workhorse)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.carreerPerformance = "Phenomenal Job"
            case 22..<29 :
                contact.personalityData.carreerPerformance = "Great Job"
            case 16..<22:
                contact.personalityData.carreerPerformance = "Excellent Job"
            case 13..<16:
                contact.personalityData.carreerPerformance = "Good Job"
            case 9..<13:
                contact.personalityData.carreerPerformance = "Average Job"
            case 0..<9:
                contact.personalityData.carreerPerformance = "Below Average Job"
            default:
                contact.personalityData.carreerPerformance = "Below Average Job"
            }
        } else {
            var carreerPerformance =
            (contact.personalityData.traits?.extraversion?.assertiveness)!*0.33 +
                (contact.personalityData.traits?.extraversion?.activityLevel)!*0.23 +
                (contact.personalityData.traits?.conscientiousness?.achievementStriving)!*0.22 +
                (contact.personalityData.traits?.conscientiousness?.selfDiscipline)!*0.43
            contact.personalityData.carreerPerformance = (padZeros(carreerPerformance) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
        }
        
        return contact.personalityData.carreerPerformance
    }
    
    func getPersonalRelationshipScore(contact: GoogleContact) -> NSString {
        //http://www.psychometriclab.com/admins/files/Twin%20Research%20-%20Trait%20EI.pdf
        var personalRelationship =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.19 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.49 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.30 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.32 -
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.37
        contact.personalityData.personalRelationship = (padZeros(personalRelationship) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
        
        return contact.personalityData.personalRelationship
    }
    
    func getInnovationScore(contact: GoogleContact) -> NSString {
        
        var innovationScore =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.192 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.063 +
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.150 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.180 +
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.128
        contact.personalityData.innovation = (padZeros(innovationScore) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
        
        return contact.personalityData.innovation
    }
   
    func getCreativityScore(contact: GoogleContact) -> NSString {
        
        var creativityScore =
        (contact.personalityData.traits?.openness?.opennessValue)!*0.16 +
            (contact.personalityData.traits?.agreeableness?.agreeablenessValue)!*0.01 -
            (contact.personalityData.traits?.conscientiousness?.conscientiousnessValue)!*0.10 +
            (contact.personalityData.traits?.extraversion?.extraversionValue)!*0.31 +
            (contact.personalityData.traits?.neuroticism?.neuroticismValue)!*0.06
        
        if creativityScore < 10 {
            contact.personalityData.creativity = (padZeros(creativityScore) as! NSString).substringWithRange(NSRange(location: 0, length: 1))
            return contact.personalityData.creativity
        } else {
            contact.personalityData.creativity = (padZeros(creativityScore) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
            return contact.personalityData.creativity
        }
    }
    
    func getAnalyticalThiningkStyle(contact: GoogleContact)-> NSString {
        if contact.personalityData.thinkingStyleDegree != "" {
            switch (((Double(contact.personalityData.thinkingStyleDegree)!)+1)*35/100) {
            case 29..<35 :
                contact.personalityData.thinkingStyle = "Great Analytical Thinker"
            case 22..<29 :
                contact.personalityData.thinkingStyle = "Excellent Analytical Thinker"
            case 16..<22:
                contact.personalityData.thinkingStyle = "Good Analytical Thinker"
            case 13..<16:
                contact.personalityData.thinkingStyle = "Above Average Analytical Thinker"
            case 9..<13:
                contact.personalityData.thinkingStyle = "Average Analytical Thinker"
            case 0..<9:
                contact.personalityData.thinkingStyle = "Below Average Analytical Thinker"
            default:
                contact.personalityData.thinkingStyle = "Below Average Analytical Thinker"
            }
        }
        return contact.personalityData.thinkingStyle
    }
    
    func getThiningkStyle(contact: GoogleContact) -> String! {
        var neuro = contact.personalityData.traits?.neuroticism?.neuroticismValue
        var extra = contact.personalityData.traits?.extraversion?.extraversionValue
        var cons = contact.personalityData.traits?.conscientiousness?.conscientiousnessValue
        var open = contact.personalityData.traits?.openness?.opennessValue
        var agree = contact.personalityData.traits?.agreeableness?.agreeablenessValue

        var allStyle: [Dictionary<String, Double>] = []
        
        //var legislative = Dictionary<String, String>()
        var value = -0.11*(neuro)!+0.20*(extra)!+0.41*(open)!-0.12*(agree)!+0.23*(cons)!
        var legislative = ["Legislative":value]
        allStyle.append(legislative)
       
        var executiveValue = 0.19*(neuro)!+0.02*(extra)!+0.08*(open)!+0.03*(agree)!+0.16*(cons)!
        var executive = ["Executive":executiveValue]
        allStyle.append(executive)
       
        var judicialValue = 0.09*(neuro)!+0.28*(extra)!+0.28*(open)!-0.15*(agree)!+0.19*(cons)!
        var judicial = ["Judicial":judicialValue]
        allStyle.append(judicial)
       
        var liberalValue = -0.09*(neuro)!+0.23*(extra)!+0.31*(open)!-0.23*(agree)!+0.11*(cons)!
        var liberal = ["Liberal":liberalValue]
        allStyle.append(liberal)
        
        var conservativeValue = 0.37*(neuro)!-0.15*(extra)!-0.22*(open)!-0.07*(agree)!+0.03*(cons)!
        var conservative = ["Conservative":conservativeValue]
        allStyle.append(conservative)
       
        var hierarchicalValue = -0.10*(neuro)!+0.24*(extra)!+0.10*(open)!+0.10*(agree)!+0.51*(cons)!
        var hierarchical = ["Hierarchical":hierarchicalValue]
        allStyle.append(hierarchical)
        
        var monarchicValue = 0.00*(neuro)!+0.16*(extra)!+0.02*(open)!-0.03*(agree)!+0.19*(cons)!
        var monarchic = ["Monarchic":monarchicValue]
        allStyle.append(monarchic)
        
        var globalValue = -0.14*(neuro)!+0.23*(extra)!+0.17*(open)!-0.11*(agree)!+0.23*(cons)!
        var global = ["Global":globalValue]
        allStyle.append(global)
        
        var localValue = 0.24*(neuro)!+0.01*(extra)!+0.01*(open)!-0.09*(agree)!+0.20*(cons)!
        var local = ["Local":localValue]
        allStyle.append(local)
        
        var internalValue = 0.04*(neuro)!-0.09*(extra)!+0.23*(open)!-0.23*(agree)!+0.04*(cons)!
        var internalStyle = ["Internal":internalValue]
        allStyle.append(internalStyle)
        
        var externalValue = 0.00*(neuro)!+0.16*(extra)!+0.02*(open)!-0.03*(agree)!+0.19*(cons)!
        var external = ["Monarchic":externalValue]
        allStyle.append(external)
        
        var topFacetsArray = Array(allStyle)
        //print(topFacetsArray)
        
        var topFacetsArrayNew =  topFacetsArray.sort { p1, p2 in
            var value1 = 0.0
            var value2 = 0.0
            
            for (key, value) in p1{
                value1 = value as! Double
            }
            for (key, value) in p2{
                value2 = value as! Double
            }
            
            return value1 > value2
        }
        //print("top thinking styles")
        //print(topFacetsArray)
        var top = topFacetsArrayNew[0] as! Dictionary<String, Double>
        var topStyleFinal  = ""
        
        for (key, value) in top {
            topStyleFinal = key
        }
        contact.personalityData.thinkingStyle = topStyleFinal
        
        return topStyleFinal
    }
    
    func getStrengths(facetArray: [Dictionary<String, Any>]) -> [String]{
        var texts: [String] = []
        var count = 0
        for dict:Dictionary in facetArray {
            if count >= 12 {
                break
            } else {
                for (key, value) in dict {
                    texts.append(key)
                }
            }
            count++
        }
        
        //print(texts)
        return texts
    }
    
    func padZeros(value: Double) -> String {
        if value < 10 {
            var valueString = String(value)
            return String(valueString.characters.dropLast(1))
        } else {
            return String(value)
        }
    }
}

class AuthData: NSObject {
    var accessToken = ""
    var accessTokenExpirationDate = ""
    var refreshToken = ""
    var secretToken = ""
    
}