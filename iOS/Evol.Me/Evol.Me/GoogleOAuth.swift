//
//  GoogleOAuth.swift
//  Evol.Me
//
//  Created by Paul.Raj on 8/16/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import Alamofire

class GoogleOAuth {
    func refreshAccessToken(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()){
        //print("refreshAccessToken")
        self.verifyAccessToken() { data, error in
            if (error != nil){
                //print("Error Occurred.")
                //print(error)
                self.getAccessTokenByRefreshToken { data, error in
                    if error != nil {
                        //print("Could not complete the request \(error)")
                    } else {
                        let response = JSON(data!)
                        //print(response)
                        loggedInUser.accessToken = response["access_token"].string!
                        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
                        //print("INFO: Access token is updated now")
                    }
                    completionHandler(responseObject: "" as? NSDictionary, error: error)
                }
            } else {
                //print("Valid data.")
                //print(data)
                var json = JSON(data!)
                if let expires_in = json["expires_in"].int {
                    if expires_in < 120 {
                        //print("INFO: Access token is about to expire")
                        self.getAccessTokenByRefreshToken { data, error in
                            if error != nil {
                                //print("Could not complete the request \(error)")
                            } else {
                                let response = JSON(data!)
                                //print(response)
                                if response["access_token"] {
                                    loggedInUser.accessToken = response["access_token"].string!
                                    userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
                                    //print("INFO: Access token is updated now")
                                } else {
                                    //print("Refresh token is empty. User has logged out.")
                                }
                            }
                            completionHandler(responseObject: "" as? NSDictionary, error: error)
                        }
                    } else {
                        //print("INFO: Access Token is valid for more than two mins.")
                        completionHandler(responseObject: "" as? NSDictionary, error: error)
                    }
                } else {
                    //print("Access Token Expired.")
                    self.getAccessTokenByRefreshToken { data, error in
                        if error != nil {
                            //print("Could not complete the request \(error)")
                        } else {
                            let response = JSON(data!)
                            //print(response)
                            loggedInUser.accessToken = response["access_token"].string!
                            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
                            //print("INFO: Access token is updated now")
                        }
                        completionHandler(responseObject: "" as? NSDictionary, error: error)
                    }
                }
            }
        }
    }
    //https://www.googleapis.com/plus/v1/people/\(self.user!.userID)
    //https://www.google.com/m8/feeds/photos/media/default/
    
    func getAccessTokenByCode(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        //print("getAccessTokenByCode")
        Alamofire.request(.POST, "https://accounts.google.com/o/oauth2/token",
            parameters: [
                "code": "",
                "client_id": "215446193980-lbv6cqv1or1d8gf4oi6g4n3tpq44ujrk.apps.googleusercontent.com",
                "client_secret": "AIzaSyAyCx0UP5J6RGz6LZ6vV9lkaw72-YQ6CfMq",
                //"redirect_uri": ,
                "grant_type": "authorization_code"])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getAccessTokenByRefreshToken(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        //print("getAccessTokenByRefreshToken")
        Alamofire.request(.POST, "https://accounts.google.com/o/oauth2/token",
            parameters: [
                "refresh_token": loggedInUser.refreshToken,
                "client_id": "215446193980-lbv6cqv1or1d8gf4oi6g4n3tpq44ujrk.apps.googleusercontent.com",
                "client_secret": "",
                "grant_type": "refresh_token"])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    //https://developers.google.com/identity/protocols/OAuth2WebServer#refresh
    func verifyAccessToken(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.POST, "https://www.googleapis.com/oauth2/v1/tokeninfo",
            parameters: [ "access_token": loggedInUser.accessToken])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
}