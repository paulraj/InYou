//
//  GMailAPI_Handler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/11/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import UIKit
import Alamofire

var currentContactEmail = ""

class GMailAPIHandler {
    
    var accessToken: String = ""
    var refreshToken: String = ""
    var userID: String = ""
    var userEmail: String = ""
    var mailsDict = [Dictionary<String,String>]()
    var mail:String = ""
    var nextPage: Bool = false
    //var nextPageToken: String = ""
    var totalEmailsCount = 0
    var emailToAnalyze = loggedInUser.mailsToAnalyze
    var defaultPersonality = "Big Five:\n You are eager to experience new things. You are less concerned with artistic or creative activities than most people. You do not frequently think about or openly express your emotions. You have a wild imagination. You are open to and intrigued by new ideas and love to explore them. You prefer to challenge authority and traditional values to help bring about change. You set high goals for yourself and work hard to achieve them. You carefully think through decisions before making them. You do what you want, disregarding rules and obligations. You do not make a lot of time for organization in your daily life. You appreciate a relaxed pace in life. You prefer to listen than to talk, especially in group settings. You are generally serious and do not joke much. You prefer activities that are quiet, calm, and safe. You are a private person and do not let many people in. You have a strong desire to have time to yourself. You are more concerned with taking care of yourself than taking time for others. You do not shy away from contradicting others. You hold yourself in high regard and are satisfied with who you are. You are comfortable using every trick in the book to get what you want. You think people should generally rely more on themselves than on others. You are wary of other people's intentions and do not trust easily. It takes a lot to get you angry. You tend to feel calm and self-assured. You are generally comfortable with yourself as you are. You have control over your desires, which are not particularly intense. You are hard to embarrass and are self-confident most of the time. You handle unexpected events calmly and effectively.\n\nNeeds:\n\nValues:\nYou seek personal success for themselves.\n\n\nTwo Dimension:\nHelpful, cooperative, considerate, respectful, polite. Soft-hearted, agreeable, obliging, humble, lenient. Generous, pleasant, tolerant, peaceful, flexible. Dependent, simple. Cautious, confident, punctual, formal, thrifty. Thorough, steady, consistent, self-disciplined, logical. Traditional, conventional. Tranquil, sedate, placid, impartial, unassuming. Somber, meek, unadventurous, passive, apathetic. Imperturbable, insensitive."
    var contact = GoogleContact()
    
    init () {
        if loggedInUser.mailsToAnalyze != 0 {
            self.emailToAnalyze = loggedInUser.mailsToAnalyze
        } else {
            self.emailToAnalyze = 100
        }
        /*GoogleOAuth().refreshAccessToken(){ data, error in
            print("Access token is refreshed now.")
        }*/
        
        self.contact = loggedInUser
        self.userEmail = loggedInUser.email
        self.accessToken = loggedInUser.accessToken
        //print(self.accessToken)
    }
    
    func listMessages(label: String, nextPageToken: String, queryString: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        if (!nextPageToken.isEmpty && nextPageToken != "No") {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages",
                parameters: [ "labelIds": label,"maxResults":"100", "q": queryString, "fields":"messages/id, nextPageToken", "pageToken": nextPageToken, "access_token": accessToken])
                .responseJSON { response in
                    completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
            }
        } else if (nextPageToken == "N" || nextPageToken.isEmpty) {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages",
                parameters: [ "labelIds": label,"maxResults":"100", "q": queryString, "access_token": accessToken])
                .responseJSON { response in
                    completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
            }
        }
    }
    
    func listThreads(label: String, nextPageToken: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        if (!nextPageToken.isEmpty && nextPageToken != "No") {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/threads",
                parameters: [ "labelIds": label,"maxResults":"49",  "pageToken": nextPageToken, "access_token": accessToken])
                .responseJSON { response in
                    completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
            }
        } else if (nextPageToken == "N" || nextPageToken.isEmpty) {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/threads",
                parameters: [ "labelIds": label,"maxResults":"49", "access_token": accessToken])
                .responseJSON { response in
                    completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
            }
        }
    }
    
    func createDraft(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.POST, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/drafts", parameters: [ "access_token": accessToken])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func sendDraft(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.POST, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/drafts", parameters: [ "access_token": accessToken])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getThread(threadId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/threads/\(threadId)", parameters: [ "access_token": accessToken])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getMessage(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages/\(messageId)",
            parameters: [ "access_token": accessToken, "fields":"snippet, payload"])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getDraft(draftId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/drafts/\(draftId)", parameters: [ "access_token": accessToken])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getAttachment(messageId: String, attachmentId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages/\(messageId)/attachments/\(attachmentId)",
            parameters: [ "access_token": accessToken])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
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
    
    func update(mailMsg: String){
        self.mail = self.mail+"\n"+mailMsg
    }
    /*
    func getNextPage(label: String, nextPageToken: String){    //print(self.mail)
        if nextPageToken == "N" {
            print(String(self.totalEmailsCount) + " Emails analysed")
            //IBMWatsonAPIHandler().invokeAPI(self.mail)
            print("All mails start here")
            print(self.mail)
            print("All mails end here")
            //IBMAlchemyAPIHandler().TextGetCombinedData(self.mail)
            //AylienTextAnalysisAPI().summarize(self.mail)
            //SaploTextAnalysisAPI().authenticate(self.mail)
            //SaploTextAnalysisAPI().createCollection(self.mail)
            //HomeViewController().moveNow()
            //TraitifyAPIHandler().listDecks()
            IBMWatsonAPIHandler().invokeAPI(self.mail) { data, error in
                print(data)
            }
            
        } else {
            //self.processMailsLastYear(label, nextPageToken: nextPageToken)
        }
    }
    */
    func getAllInboxEmailsLastYear(contact: GoogleContact, nextPageToken: String, queryString: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        self.contact = contact
        self.processMailsLastYear("INBOX", nextPageToken: nextPageToken, queryString: queryString){ data, error in
            completionHandler(data: data, error: error as? NSError!)
        }
    }
    
    func getMailsCount(nextPageToken: String, queryString: String, id: String, email: String, name: String,
        completionHandler: (id: String, email: String, name: String, count: Int, error: NSError?) -> ()) {
        var count = 0
        self.getMailsCountImpl("INBOX", count: count ,nextPageToken: nextPageToken, queryString: queryString){ data, error in
            completionHandler(id: id, email: email , name: name , count: data , error: error)
        }
    }
    
    func getMailCount(queryString: String, contactId: String, completionHandler: (id: String, count: Int, error: NSError?) -> ()) {
            self.getMailsCountImpl("INBOX", count: 0, nextPageToken: "", queryString: queryString){ data, error in
                completionHandler(id: contactId, count: data , error: error)
            }
    }
    
    func getAllSentEmailsLastYear(contact: GoogleContact, nextPageToken: String, queryString: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        //print("getAllSentEmailsLastYear")
        self.contact = contact
        self.processMailsLastYear("SENT", nextPageToken: nextPageToken, queryString: queryString){ data, error in
            completionHandler(data: data, error: error)
        }
    }
    
    func getAllDraftEmailsLastYear(nextPageToken: String, queryString: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        self.processMailsLastYear("DRAFT", nextPageToken: nextPageToken, queryString: queryString){ data, error in
            completionHandler(data: data, error: error)
        }
    }
    
    func getAllChatEmailsLastYear(nextPageToken: String, queryString: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        self.processMailsLastYear("CHAT", nextPageToken: nextPageToken, queryString: queryString){ data, error in
            completionHandler(data: data, error: error)
        }
    }
    
    
    func getMailsCountImpl(label: String, count: Int, nextPageToken: String, queryString: String, completionHandler: (data: Int, error: NSError?) -> ()) {
        var _nextPageToken: String = ""
        listMessages(label, nextPageToken: nextPageToken, queryString: queryString ) { responseObject, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(responseObject!)
                var _count = json["messages"].count + count
                if (json["nextPageToken"]) {
                    _nextPageToken = json["nextPageToken"].string!
                    self.getMailsCountImpl(label, count: _count, nextPageToken: _nextPageToken, queryString: queryString) { data, error in
                        completionHandler(data: data, error: error)
                    }
                } else {
                    completionHandler(data: _count, error: error)
                }
            }
        }
    }
    
    func processMailsLastYear(label: String, nextPageToken: String, queryString: String, completionHandler: (data: NSString?, error: NSError?) -> ()) {
        //print("processMailsLastYear")
        var _nextPageToken: String = ""
        //print(self.totalEmailsCount)
        listMessages(label, nextPageToken: nextPageToken, queryString: queryString ) { responseObject, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(responseObject!)
                //print(json)
                if (json["nextPageToken"]) {    //print("Email: Next page token: "+json["nextPageToken"].string!)
                    _nextPageToken = json["nextPageToken"].string!
                } else {    //print("Email: No next page")
                    _nextPageToken = "N"
                }
                var total: Int = json["messages"].count
                //print("Total Emails: "+String(self.totalEmailsCount))
                var ind:Int  = 0
                if total > 0 {
                    for (index, subJson):(String, JSON) in json["messages"] {
                        var id = subJson["id"].string!
                        if self.totalEmailsCount >= self.emailToAnalyze {
                            //self.getNextPage(label,  nextPageToken: "N")
                            //print(String(self.totalEmailsCount) + " Emails analysed")
                            //print(self.mail)
                            self.contact.emailCount = self.totalEmailsCount
                            self.contact.allEmailContent = self.mail
                            IBMWatsonAPIHandler().invokeAPI(self.contact, mail: self.mail) { data, error in
                                //print(data)
                                completionHandler(data: data, error: error)
                                //completionHandler(data: self.defaultPersonality, error: error)
                            }
                            break
                        }
                        self.getMessage(id) { messageData, messageError in
                            if messageError != nil {
                                print("Could not complete the request \(messageError)")   } else {
                                let messageJson = JSON(messageData!)
                                //print("########################################")
                                //print(messageJson)
                                ind = ind + 1
                                self.processEmailSnippet(messageJson)
                                if (self.processEmailPayloadHeader(messageJson)) {
                                    self.totalEmailsCount++
                                    self.processEmailPayloadParts(messageJson)
                                }
                            }
                            if ind == total {
                                //self.getNextPage(label, nextPageToken: _nextPageToken)
                                if _nextPageToken == "N" {
                                    //print(String(self.totalEmailsCount) + " Emails analysed")
                                    self.contact.emailCount = self.totalEmailsCount
                                    self.contact.allEmailContent = self.mail
                                    
                                    IBMWatsonAPIHandler().invokeAPI(self.contact, mail: self.mail) { data, error in
                                        //print(data)
                                        //completionHandler(data: self.defaultPersonality, error: error)
                                        completionHandler(data: data, error: error)
                                    }
                                } else {
                                    self.processMailsLastYear(label, nextPageToken: _nextPageToken, queryString: queryString) { data, error in
                                        //print("done.")
                                        completionHandler(data: data, error: error)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.contact.personalityData.personalitySummary = "No emails found"
                    var _error = NSError(domain: "No emails found", code: 100, userInfo: [:] )
                    
                    self.contact.personalityData.personalitySummary = _error.domain as String!
                    self.contact.personalityData.personalitySummaryStatus = "ERROR"
                    
                    completionHandler(data: "", error: _error)
                }
            }
        }
    }
    
    func getThreadsImpl(label: String, threadId: String, count: Int, total: Int, nextPageToken: String){
        var _count:Int = 0
        self.getThread(threadId) { threadData, threadError in
            if threadError != nil {
                print("Could not complete the request \(threadError)")
            } else {
                let threadJson = JSON(threadData!) //print(threadJson)
                _count = count + 1
                for (index, msgJson):(String, JSON) in threadJson["messages"] { //print(msgJson)
                    self.processEmailSnippet(msgJson)
                    if (self.processEmailPayloadHeader(msgJson)) {
                        self.processEmailPayloadParts(msgJson)
                    } else {
                        //
                    }
                }
                if _count == total {
                    //self.getNextPage(label, nextPageToken: nextPageToken)
                }
            }
        }
    }
    
    func processEmailSnippet(msgJson: JSON) {
        if (msgJson["snippet"].string != nil) {
            //self.update(msgJson["snippet"].string!)
        }
    }
    
    func processEmailPayloadHeader (msgJson: JSON) -> Bool {
        //print("processEmailPayloadHeader")
        var returnBool: Bool = false
        var headers = msgJson["payload"]["headers"]
        var subject = ""
        for (index, header):(String, JSON) in headers {
            if (header["name"]=="Subject"){
                if (header["value"].string != nil) {
                    //print("Subject: " + header["value"].string!)
                    subject = header["value"].string!
                }
            }
            
            if (header["name"] == "To"){ }
            
            if (header["name"] == "From" && (header["value"].string! as NSString).containsString(currentContactEmail)) {
                returnBool = true
                //break
            } else {
                //returnBool = false
            }
            if (header["name"] == "Date") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
                //let date = dateFormatter.dateFromString(/*your_date_string*/)
            }
        }
        if returnBool == true {
            self.update(subject+": ")
        }
        return returnBool
    }
    
    func processEmailPayloadParts (msgJson: JSON) {
        //print("processEmailPayloadParts")
        for (index, messagePayloadPart):(String, JSON) in msgJson["payload"]["parts"] {
            var attachment = messagePayloadPart["body"]["attachmentId"].string
            if let name = attachment {
                //print(messagePayloadPart["filename"].string!)
            }
            decodeEmailBodyParts(messagePayloadPart)
            for (index, messagePayloadPartsPart):(String, JSON) in messagePayloadPart["parts"] {
                decodeEmailBodyParts(messagePayloadPartsPart)
            }
        }
    }
    
    func decodeEmailBodyParts(messagePayloadPart: JSON){
        //print("decodeEmailBodyParts")
        if ((messagePayloadPart["mimeType"].string! ==  "text/plain") && messagePayloadPart["body"]["data"] != nil) {
            //print(messagePayloadPart["mimeType"].string!)
            var decodedString = self.convertToBase64URLDecoding(messagePayloadPart["body"]["data"].string!)
            if !decodedString.isEmpty {
                //print(decodedString)
                //self.update(decodedString as String)
            }
            var dataString = decodedString as NSString
            var messageType:String = ""
            if let test = decodedString.rangeOfString("---------- Forwarded message ----------") {
                //print("Your message from forward starts here")
                let startIndex = decodedString.startIndex
                let endIndex = test.startIndex
                let range = decodedString.startIndex..<endIndex
                let myNewString = decodedString.substringWithRange( range )
                //print(myNewString)
                self.update(myNewString as String)
                //print("Your message from forward ends here")
                messageType = "Forward"
            }
            if let test = decodedString.rangeOfString("Begin forwarded message:") {
                //print("Your message from forward starts here")
                let startIndex = decodedString.startIndex
                let endIndex = test.startIndex
                let range = decodedString.startIndex..<endIndex
                let myNewString = decodedString.substringWithRange( range )
                self.update(myNewString as String)
                //print("Your message from forward ends here")
                messageType = "Forward"
            }
            
            if (dataString.containsString("On ") && dataString.containsString("wrote:") ) {
                //&& dataString.containsString(">")
                if let test = decodedString.rangeOfString("On ") {
                    let startIndex = decodedString.startIndex
                    let endIndex = test.startIndex
                    let range = decodedString.startIndex..<endIndex
                    let myNewString = decodedString.substringWithRange( range )
                    self.update(myNewString as String)
                    //print("Your message from reply ends here")
                    messageType = "Reply"
                }
            }
            
            if let test = decodedString.rangeOfString("You received this message because you are subscribed to the Google Groups") {
                if ((dataString.containsString("On ") == true && dataString.containsString("wrote:")) == true ||
                    decodedString.containsString("Begin forwarded message:") == true ||
                    decodedString.containsString("---------- Forwarded message ----------") == true) {
                        //do nothing
                } else {
                    //print("Your message from forward starts here")
                    let startIndex = decodedString.startIndex
                    let endIndex = test.startIndex
                    let range = decodedString.startIndex..<endIndex
                    let myNewString = decodedString.substringWithRange( range )
                    //print(myNewString)
                    self.update(myNewString as String)
                    //print("Your message from forward ends here")
                    messageType = "Reply"
                }
            }
            
            if (messageType=="") {
                //print("Your initial message starts here")
                //print(decodedString)
                self.update(decodedString as String)
                //print("Your initial message ends here")
                
            }
            
        }
        if (( messagePayloadPart["mimeType"].string! ==  "text/html") && messagePayloadPart["body"]["data"] != nil) {
            var decodedString = self.convertToBase64URLDecoding(messagePayloadPart["body"]["data"].string!)
            if !decodedString.isEmpty {
                //print(decodedString)
                //self.update(decodedString as String)
            }
            if let test = decodedString.rangeOfString("gmail_signature\">") {
                //print("Your signature starts here")
                let startIndex = test.endIndex
                let endIndex = decodedString.endIndex
                let range = startIndex..<endIndex
                let myNewString = decodedString.substringWithRange( range )
                //print(myNewString)
                //print("Your signature ends here")
            }
        }
    }
}