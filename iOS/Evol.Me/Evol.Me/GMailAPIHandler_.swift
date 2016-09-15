//
//  GMailAPI_Handler.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/11/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import UIKit
import Alamofire

class GMailAPIHandler_ {

    var accessToken: String = ""
    var refreshToken: String = ""
    var userID: String = ""
    var userEmail: String = ""
    var mailsDict = [Dictionary<String,String>]()
    var mail: String = ""
    var nextPage: Bool = false
    //var nextPageToken: String = ""
    
    init (userEmail: String, accessToken: String, refreshToken: String) {
        self.userEmail = userEmail
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func listMessages(label: String, nextPageToken: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        if (!nextPageToken.isEmpty && nextPageToken != "No") {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages",
                parameters: [ "labelIds": label,"maxResults":"49",  "pageToken": nextPageToken, "access_token": accessToken])
                .responseJSON { (request, response, responseObject, error) in
                    completionHandler(responseObject: responseObject as? NSDictionary, error: error)
            }
        } else if (nextPageToken == "N" || nextPageToken.isEmpty) {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages",
                parameters: [ "labelIds": label,"maxResults":"49", "access_token": accessToken])
                .responseJSON { (request, response, responseObject, error) in
                    completionHandler(responseObject: responseObject as? NSDictionary, error: error)
            }
        }
    }
    
    func _listMessages(label: String, nextPageToken: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        if (!nextPageToken.isEmpty && nextPageToken != "No") {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages",
                parameters: [ "labelIds": label,"maxResults":"49",  "pageToken": nextPageToken, "access_token": accessToken])
                .responseJSON { (request, response, responseObject, error) in
                    completionHandler(responseObject: responseObject as? NSDictionary, error: error)
            }
        } else if (nextPageToken == "N" || nextPageToken.isEmpty) {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages",
                parameters: [ "labelIds": label,"maxResults":"49", "access_token": accessToken])
                .responseJSON { (request, response, responseObject, error) in
                    completionHandler(responseObject: responseObject as? NSDictionary, error: error)
            }
        }
    }
    
    func listThreads(label: String, nextPageToken: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        _listThreads(label, nextPageToken: nextPageToken, completionHandler: completionHandler)
    }
    
    func _listThreads(label: String, nextPageToken: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        if (!nextPageToken.isEmpty && nextPageToken != "No") {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/threads",
                parameters: [ "labelIds": label,"maxResults":"49",  "pageToken": nextPageToken, "access_token": accessToken])
                .responseJSON { (request, response, responseObject, error) in
                    completionHandler(responseObject: responseObject as? NSDictionary, error: error)
            }
        } else if (nextPageToken == "N" || nextPageToken.isEmpty) {
            Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/threads",
                parameters: [ "labelIds": label,"maxResults":"49", "access_token": accessToken])
                .responseJSON { (request, response, responseObject, error) in
                    completionHandler(responseObject: responseObject as? NSDictionary, error: error)
            }
        }
    }
    
    func createDraft(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        _createDraft(messageId, completionHandler: completionHandler)
    }
    
    func _createDraft(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.POST, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/drafts", parameters: [ "access_token": accessToken])
            .responseJSON { (request, response, responseObject, error) in
                completionHandler(responseObject: responseObject as? NSDictionary, error: error)
        }
    }
    
    func getThread(threadId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        _getThread(threadId, completionHandler: completionHandler)
    }
    
    func _getThread(threadId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/threads/\(threadId)", parameters: [ "access_token": accessToken])
            .responseJSON { (request, response, responseObject, error) in
                completionHandler(responseObject: responseObject as? NSDictionary, error: error)
        }
    }
    
    func getMessage(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        _getMessage(messageId, completionHandler: completionHandler)
    }
    
    func _getMessage(messageId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages/\(messageId)", parameters: [ "access_token": accessToken])
            .responseJSON { (request, response, responseObject, error) in
                completionHandler(responseObject: responseObject as? NSDictionary, error: error)
        }
    }
  
    func getAttachment(messageId: String, attachmentId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        _getAttachment(messageId, attachmentId: attachmentId, completionHandler: completionHandler)
    }
    
    func _getAttachment(messageId: String, attachmentId: String, completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/gmail/v1/users/\(userEmail)/messages/\(messageId)/attachments/\(attachmentId)",
            parameters: [ "access_token": accessToken])
            .responseJSON { (request, response, responseObject, error) in
                completionHandler(responseObject: responseObject as? NSDictionary, error: error)
        }
    }
    
    func convertToBase64URLDecoding(data: String) -> String {
        var messagePayloadPartBodyData = data
        if !messagePayloadPartBodyData.isEmpty {
            messagePayloadPartBodyData = messagePayloadPartBodyData.stringByReplacingOccurrencesOfString("-", withString: "+")
            messagePayloadPartBodyData = messagePayloadPartBodyData.stringByReplacingOccurrencesOfString("_", withString: "/")
            let messagePayloadPartBodyDataUTF8 = (messagePayloadPartBodyData as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
            let messagePayloadPartBodyDataUTF8DecodedData = NSData(base64EncodedData: messagePayloadPartBodyDataUTF8, options: NSDataBase64DecodingOptions(rawValue: 0))
            var decodedString = NSString()
            if(messagePayloadPartBodyDataUTF8DecodedData != nil ){
                decodedString = NSString(data: messagePayloadPartBodyDataUTF8DecodedData!, encoding: NSUTF8StringEncoding)!
            }
            return decodedString as String
        } else {
            return ""
        }
    }
    
    func update(mailMsg: String){
        self.mail = self.mail+" "+mailMsg
    }
    
    func getNextPage(nextPageToken: String){    //println(self.mail)
        if nextPageToken == "N" {
            //IBMWatsonAPIHandler().invokeAPI(self.mail)
        } else {
            self.processMails(nextPageToken)
        }
    }
    
    func getAllInboxEmailsLastYear () {}
    
    func getAllSentEmailsLastYear() {}
    
    func processMails(nextPageToken: String) {
        var _nextPageToken: String = ""
        println("GMail API...")
        listMessages("SENT", nextPageToken: nextPageToken) { responseObject, error in
            if error != nil {
                println("Could not complete the request \(error)")
            } else {
                let json = JSON(responseObject!)    //println(json)
                if (json["nextPageToken"]) {    //println("Email: Next page token: "+json["nextPageToken"].string!)
                    _nextPageToken = json["nextPageToken"].string!
                } else {    //println("Email: No next page")
                    _nextPageToken = "N"
                }
                var total: Int = json["messages"].count
                println("Total Emails: "+String(total))
                var ind:Int  = 0
                for (index: String, subJson: JSON) in json["messages"] {
                    var threadId = subJson["threadId"].string!
                    self.getThread(threadId) { threadData, threadError in
                        if threadError != nil {
                            println("Could not complete the request \(threadError)")
                        } else {
                            let threadJson = JSON(threadData!) //println(threadJson)
                            ind = ind + 1
                            for (index: String, msgJson: JSON) in threadJson["messages"] { //println(msgJson)
                                self.processEmailSnippet(msgJson)
                                if (self.processEmailPayloadHeader(msgJson)) {
                                    self.processEmailPayloadParts(msgJson)
                                } else {
                                    //
                                }
                            }
                            if ind == total {
                                  self.getNextPage(_nextPageToken)
                            }
                        }
                    }
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
        var returnBool: Bool = false
        var headers = msgJson["payload"]["headers"]
        for (index: String, header: JSON) in headers {
            if (header["name"]=="Subject"){
                if (header["value"].string != nil) {
                    self.update(header["value"].string!)
                }
            }
            if (header["name"] == "To"){ }
            
            if (header["name"] == "From" && (header["value"].string! as NSString).containsString(self.userEmail)) {
                returnBool = true
                break
            } else {
                returnBool = false
            }
            if (header["name"] == "Date") { println(header["value"])}
        }
        return returnBool
    }
    
    func processEmailPayloadParts (msgJson: JSON) {
        for (index: String, messagePayloadPart: JSON) in msgJson["payload"]["parts"] {
            var attachment: String! = messagePayloadPart["body"]["attachmentId"].string
            if let name: String? = attachment {
                //println(messagePayloadPart["filename"].string!)
            }
            decodeEmailBodyParts(messagePayloadPart)
            for (index: String, messagePayloadPartsPart: JSON) in messagePayloadPart["parts"] {
                decodeEmailBodyParts(messagePayloadPartsPart)
            }
        }
    }
    
    func decodeEmailBodyParts(messagePayloadPart: JSON){
        var shoudlDecode: Bool = true
        
        for (index: String, messagePayloadPartHeader: JSON) in messagePayloadPart["headers"] {
            if (messagePayloadPartHeader["value"] == "text/plain; charset=UTF-8") {
                shoudlDecode = true
                break
            } else{
                shoudlDecode = false
            }
        }
        if (shoudlDecode) {
            var decodedString = self.convertToBase64URLDecoding(messagePayloadPart["body"]["data"].string!)
            if !decodedString.isEmpty {
                self.update(decodedString as String)
            }
        }
    }
}