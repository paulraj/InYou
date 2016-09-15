//
//  RegisterController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/9/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//


//http://www.brianjcoleman.com/tutorial-how-to-use-login-in-facebook-sdk-4-0-for-swift/

import UIKit
import Alamofire
import FBSDKLoginKit
import TwitterKit
import Fabric
import SafariServices

class RegisterViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, SFSafariViewControllerDelegate {
    var signIn: GIDSignIn?
    var user:   GIDGoogleUser?
    //var imageUrl:String = ""
    //var GmailContactsIndex = 1
    //var totalContacts = 0
    //var currentAccessToken = ""
    
    let sampleTextField = UITextView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2+50, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height/2-50))
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    
    //@IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backButtonBarItem: UIBarButtonItem!
    @IBOutlet weak var signInWithGoogleLabel: UILabel!
    //@IBOutlet weak var signInWithGoogleButton: GIDSignInButton!
    
    @IBAction func SignInWithGoogleClicked(sender: AnyObject) {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        loggedInUser.signedInWith = "Google"
        if (reachability.currentReachabilityStatus == .NotReachable) {
            print("No internet connection.")
            self.showError("Connection Error", message: "The Internet connection appears to be offline.", actionTitle: "OK")
        } else {
            var signIn = GIDSignIn.sharedInstance();
            signIn.checkGoogleSignInAppInstalled({ (available: Bool) -> Void in
                if(available == true) {
                    signIn.signIn()
                } else {
                    signIn.signIn()
                }
            })
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signInWithFacebookClicked(sender: AnyObject) {
        loggedInUser.signedInWith = "Facebook"
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else {
            //let loginView : FBSDKLoginButton = FBSDKLoginButton()
            //self.view.addSubview(loginView)
            
            //loginView.center = self.view.center
            
            fbLoginButton.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_likes", "user_location",
                //"user_photos",
                //"user_place_visits",
                //"user_actions.books", "user_actions.fitness", "user_actions.music", "user_actions.news",
                //"user_actions.video", "user_education_history", "user_events",
                //"user_groups",
                //"user_hometown", "user_managed_groups",
                "user_posts",
                "user_relationships", "user_status",
                //"user_videos", "user_work_history",
                //"user_games_activity",
                //"user_groups",
                //"user_hometown",
                //"read_stream",
                //"publish_stream", "publish_actions",
                //"user_managed_groups",
                //"user_videos",
                //"status_update", "user_about_me",
                //"friends_about_me", "friends_birthday", "friends_photos"
                //,"read_mailbox"
            ]
            fbLoginButton.delegate = self
        }
    }
    /*
    @IBAction func signInWithTwitterClicked(sender: AnyObject){
        loggedInUser.signedInWith = "Twitter"
        
        /*swifter.authorizeAppOnlyWithSuccess({ (accessToken, response) in
                print(accessToken)
                print("authorizeAppOnlyWithSuccess")
            }, failure: {
                (error: NSError) in
                
                print(error)
                
            })*/
            
        swifter.authorizeWithCallbackURL(NSURL(string: "swifter://success")!, success: { (accessToken, response) in
            loggedInUser.twitterUserId = accessToken!.userID!
            loggedInUser.twitterScreenName = accessToken!.screenName!
            //loggedInUser.twitterOauthTokenKey =
            print("below is access token")
            print(accessToken)
            
            //loggedInUser.twitterAccessToken = accessToken!.accessToken
            loggedInUser.isLoggedIn = true
            self.view.addSubview(loadingProfile)
            swifter.getAccountVerifyCredentials(false, skipStatus: true, success: { (myInfo: Dictionary<String, JSONValue>?) in
                print(myInfo)
                loggedInUser.twitterScreenName = myInfo!["name"]!.string!
                if let url = myInfo!["profile_image_url_https"]!.string {
                    self.getProfileImage("Twitter",imageURLString: url)
                }
                }, failure: {
                    (error: NSError) in
                    print(error)
            })
            
            //self.performSegueWithIdentifier("home", sender: self)
            
            
            /*swifter.getFollowersIDsWithID(userID!,count: 200, success: {
                (followers: [JSONValue]?) in
                for follower in followers! {
                    print(follower)
                }
                }, failure: {
                    (error: NSError) in
                    print(error)
            })*/
            /*
            swifter.getStatusesSampleDelimited(progress: {
                (status: Dictionary<String, JSONValue>?) in
                    print(status)
                }, failure: {
                    (error: NSError) in
                    
            })*/
            
            }, failure: {
                (error: NSError) in
                
                print(error)
                
            }, openQueryURL: { (url) -> Void in
                if #available(iOS 9.0, *) {
                    let webView = SFSafariViewController(URL: url)
                    webView.delegate = self
                    self.presentViewController(webView, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.sharedApplication().openURL(url)
                }
            }, closeQueryURL: { () -> Void in
                self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        /*
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print(session)
                print("signed in as \(session!.userName)")
                var username = session!.userName
                
                if let userID = Twitter.sharedInstance().sessionStore.session()!.userID {
                    let client = TWTRAPIClient(userID: userID)
                    // make requests with client
                    print(userID)
                    print(client)
                }
                /*
                Twitter.sharedInstance().APIClient.loadTweetWithID(username) { tweet, error in
                    if error != nil {
                        print(error)
                    } else {
                        print(tweet)
                    }
                    /*if error!.domain == TWTRAPIErrorDomain && (error!.code == .InvalidOrExpiredToken || error!.code == .BadGuestToken) {
                        // can manually retry by calling Twitter.sharedInstance().logInGuestWithCompletion
                    } else {
                        print(tweet)
                    }*/
                }*/
                
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }*/
    }*/
    
    /*func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil ){
            print(error)
        } else {
            print("Google Signed in.")
            self.user = user
            self.view.addSubview(loadingProfile)
            getGoogleProfileImpl()
        }
    }*/
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil ){
            print(error)
        } else {
            self.view.addSubview(loadingProfile)
            print("Google Signed in.")
            self.user = user
            
            loggedInUser.email = self.user!.profile.email!
            loggedInUser.name = self.user!.profile.name!
            loggedInUser.id = self.user!.userID
            //print(self.user!.profile.imageURLWithDimension(1000))
            //print("profile image URL")
            loggedInUser.address = currentAddress
            
            loggedInUser.authData.accessToken = self.user!.authentication.accessToken
            loggedInUser.authData.accessTokenExpirationDate = String(self.user!.authentication!.accessTokenExpirationDate)
            loggedInUser.authData.refreshToken = self.user!.authentication.refreshToken
            //loggedInUser.authData.googleClientId = self.user!.authentication.clientID
            loggedInUser.accessToken = self.user!.authentication.accessToken
            loggedInUser.accessTokenExpirationDate = self.user!.authentication!.accessTokenExpirationDate
            loggedInUser.refreshToken = self.user!.authentication.refreshToken
            
            //loggedInUser.accessToken = self.user!.authentication.getTokensWithHandler() { }
            //loggedInUser.refreshToken = self.user!.authentication.refreshTokensWithHandler() {}
            
            //print(self.user!.authentication.accessToken)
            Alamofire.request(.GET, "https://www.googleapis.com/plus/v1/people/\(self.user!.userID)",
                parameters: [ "access_token": self.user!.authentication.accessToken, "alt": "json", "sz": 1000]).responseJSON { response in
                    if response.result.error != nil {
                        print("Could not complete the request \(error)")
                    } else {
                        let json = JSON(response.result.value!)
                        //loggedInUser = GoogleContact()
                        //print(response)
                        loggedInUser.googleGender = json["gender"].stringValue
                        loggedInUser.googleId = json["id"].stringValue
                        loggedInUser.googleName = json["displayName"].stringValue
                        loggedInUser.googleFamilyName = json["name"]["familyName"].stringValue
                        loggedInUser.googleLastName = json["name"]["lastName"].stringValue
                        loggedInUser.googleCircledByCount = json["circledByCount"].stringValue
                        loggedInUser.googleObjectType = json["objectType"].stringValue
                        loggedInUser.googleIsPlusUser = json["isPlusUser"].stringValue
                        
                        loggedInUser.isLoggedIn = true
                        
                        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
                        self.getProfileImage("Google",imageURLString: json["image"]["url"].stringValue)
                    }
            }
        }
    }
    
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
            self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil) {
            print("Status: Failed to disconnect: \(error)")
        } else {
            print("Status: Disconnected")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginButton.delegate = self
        //self.signInButton.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        twitterLoginButton.frame = CGRectMake(84, 530, 247, 50)
        
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        self.signInWithGoogleLabel.frame = CustomUISize().getNewFrame(self.signInWithGoogleLabel.frame)
        //self.signInWithGoogleButton.frame = CustomUISize().getNewFrame(self.signInWithGoogleButton.frame)
        //self.navigationBar.frame = CustomUISize().getNewFrame(self.navigationBar.frame)
        //self.backButtonBarItem.hidden = false
        //self.backButtonBarItem.frame = CustomUISize().getNewFrame(self.backButtonBarItem.frame)
        
        if (reachability.currentReachabilityStatus == .NotReachable) {
            print("No internet connection.")
            self.showError("No Internet Connection", message: "There is no internet connection at this time. Please try again.", actionTitle: "OK")
        } else {
            //if loggedInUser.signedInWithGoogle == true {
                if (user?.authentication.accessToken == nil) {
                    signIn = GIDSignIn.sharedInstance()
                    signIn?.shouldFetchBasicProfile = true
                    signIn?.shouldGroupAccessibilityChildren = true
                    signIn?.clientID = "215446193980-lbv6cqv1or1d8gf4oi6g4n3tpq44ujrk.apps.googleusercontent.com"
                    //signIn?.delegate = self
                    signIn?.uiDelegate = self
                    signIn?.scopes = [
                        //"https://mail.google.com/",
                        "email",
                        "profile",
                        //"https://www.googleapis.com/auth/userinfo.profile",
                        //"https://www.googleapis.com/auth/userinfo.email",
                        //"https://www.googleapis.com/auth/gmail.labels",
                        "https://www.googleapis.com/auth/gmail.readonly",
                        //"https://www.googleapis.com/auth/gmail.compose",
                        //"https://www.googleapis.com/auth/gmail.modify",
                        //"https://www.googleapis.com/auth/gmail.insert",
                        "https://www.googleapis.com/auth/plus.me",
                        //"https://www.googleapis.com/auth/plus.login",
                        //"https://www.googleapis.com/auth/plus.profile.emails.read",
                        //"https://www.googleapis.com/auth/plus.stream.read",
                        //"https://www.googleapis.com/auth/plus.profiles.read",
                        "https://www.googleapis.com/auth/contacts.readonly",
                        //"https://www.google.com/m8/feeds"
                    ]
                    signIn?.delegate = self
                    //signIn?.shouldFetchBasicProfile = true
                    signIn?.allowsSignInWithBrowser = true
                    signIn?.allowsSignInWithWebView = true
                    //signIn?.signInSilently()
                //}
           /* } else if loggedInUser.signedInWithFacebook == true {
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    // User is already logged in, do work such as go to next view controller.
                    print("Access Token already exists.")
                    //FB().me()
                    FB().feed()
                    FB().photos()
                    /*(FB().likes(nil, completionHandler: {(error) in
                        print(error)
                        
                    });*/
                    /*
                    FB().likes() { responseObject, error in
                        if error != nil {
                            print("Could not complete the request \(error)")
                        } else {
                            //print(responseObject)
                            
                            //print("above is the value")
                            //let json = JSON(responseObject!)
                            //sampleTextField.placeholder = "Enter text here"
                            self.sampleTextField.text = "Here goes value..."
                            
                            var error: NSError?
                            do {
                                let data = try NSJSONSerialization.dataWithJSONObject(responseObject!, options: NSJSONWritingOptions.PrettyPrinted)
                                
                                let json = NSString(data: data, encoding: NSUTF8StringEncoding)
                                if let json = json {
                                    //print(json)
                                    self.sampleTextField.text = json as String
                                }
                            } catch{
                                
                            }
                            //sampleTextField.scrollEnable=true;
                            self.sampleTextField.userInteractionEnabled = true;
                            //sampleTextField.editable=false;
                            self.sampleTextField.font = UIFont.systemFontOfSize(15)
                            //sampleTextField.borderStyle = UITextBorderStyle.RoundedRect
                            self.sampleTextField.autocorrectionType = UITextAutocorrectionType.No
                            //sampleTextField.keyboardType = UIKeyboardType.Default
                            //sampleTextField.returnKeyType = UIReturnKeyType.Done
                            //sampleTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
                            //sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
                            //sampleTextField.delegate = self
                            self.view.addSubview(self.sampleTextField)
                            //self.performSegueWithIdentifier("home", sender: self)
                        }
                    }*/
                    FB().taggable_friends()
                    FB().permissions()
                    FB().videos()
                    FB().albums()
                    FB().inbox()
                } else {
                    //let loginView : FBSDKLoginButton = FBSDKLoginButton()
                    //self.view.addSubview(loginView)
                    //loginView.center = self.view.center
                    fbLoginButton.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_likes", "user_location", "user_photos",
                        //"user_place_visits",
                        "user_actions.books", "user_actions.fitness", "user_actions.music", "user_actions.news",
                        "user_actions.video", "user_education_history", "user_events",
                        //"user_groups", 
                        "user_hometown", "user_managed_groups", "user_posts",
                        "user_relationships", "user_status", "user_videos", "user_work_history", "user_games_activity",
                        //"user_groups",
                        "user_hometown",
                        //"read_stream",
                        //"publish_stream", "publish_actions", 
                        "user_managed_groups", "user_videos",
                        //"status_update", "user_about_me",
                        //"friends_about_me", "friends_birthday", "friends_photos"
                        //,"read_mailbox"
                    ]

                    fbLoginButton.delegate = self
                }*/
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedWithAuth(auth: GIDAuthentication!, error: NSError!) {
        print("finishedWithAuth")
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        print("signInWillDispatch")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! UITabBarController
        loadingProfile.hide()
    }
    
    func showError(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            //print("User Logged In with Facebook")
            loggedInUser.signedInWith = "Facebook"
            //print(result)
            if result.grantedPermissions.contains("email") {
                //print(result)
                //print("Access Token already exists.")
                FB().me() { responseObject, error in
                    if error != nil {
                        print("Could not complete the request \(error)")
                    } else {
                        FB().profilePicture { responseObject, error in
                            if error != nil {
                                print("Could not complete the request \(error)")
                            } else {
                                //print(responseObject)
                                print("received in RegisterController")
                            }
                        }
                        
                        let json = responseObject
                        //JSON(responseObject!)
                        //print(json)
                        //loggedInUser = GoogleContact()
                        loggedInUser.isLoggedIn = true
                        loggedInUser.googlePlusUser = false
                        //loggedInUser.email = self.user!.profile.email!
                        loggedInUser.name = json!["name"].stringValue
                        loggedInUser.id = json!["id"].stringValue
                        //loggedInUser.birthday = json["birthday"].stringValue
                        loggedInUser.gender = json!["gender"].stringValue
                        
                        //loggedInUser.accessToken = self.user!.authentication.accessToken
                        //loggedInUser.refreshToken = self.user!.authentication.refreshToken
                        
                        //loggedInUser.accessTokenExpirationDate = self.user!.authentication!.accessTokenExpirationDate
                        self.getProfileImage("Facebook",imageURLString: json!["picture"]["data"]["url"].stringValue)
                    }
                }
                    
                    
                //FB().feed()
                //FB().home()
                
                //FB().photos()
                /*FB().likes(nil, failureHandler: {(error) in
                    print(error)
                });
                */
                /*
                FB().likes(nil) { responseObject, error in
                    if error != nil {
                        print("Could not complete the request \(error)")
                    } else {
                       
                    }
                }*/
                //FB().taggable_friends()
                //FB().permissions()
                //FB().videos()
                //FB().albums()
                //FB().inbox()
            }
        }
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    /*######################################*/
    
    func getGoogleProfile(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
            Alamofire.request(.GET, "https://www.googleapis.com/plus/v1/people/\(self.user!.userID)",
                parameters: [ "access_token": self.user!.authentication.accessToken, "alt": "json", "sz": 1000])
                .responseJSON { response in
                    completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getGoogleProfileImpl() {
        getGoogleProfile {  responseObject, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(responseObject!)
                
                self.createProfile()
                loggedInUser.googleGender = json["gender"] as! String
                loggedInUser.googleId = json["id"]  as! String
                loggedInUser.googleName = json["displayName"]  as! String
                loggedInUser.googleFamilyName = json["name"]["familyName"]  as! String
                loggedInUser.googleLastName = json["name"]["lastName"]  as! String
                loggedInUser.googleCircledByCount = json["circledByCount"] as! String
                loggedInUser.googleObjectType = json["objectType"]  as! String
                loggedInUser.googleIsPlusUser = json["isPlusUser"] as! String
                
                self.getProfileImage("Google",imageURLString: json["image"]["url"].stringValue)
            }
        }
    }
    
    func getFacebookProfile(completionHandler: (responseObject: NSDictionary?, error: NSError?) -> ()) {
        Alamofire.request(.GET, "https://www.googleapis.com/plus/v1/people/\(self.user!.userID)",
            parameters: [ "access_token": self.user!.authentication.accessToken, "alt": "json", "sz": 1000])
            .responseJSON { response in
                completionHandler(responseObject: response.result.value as? NSDictionary, error: response.result.error)
        }
    }
    
    func getFacebookProfileImpl() {
        getGoogleProfile {  responseObject, error in
            if error != nil {
                print("Could not complete the request \(error)")
            } else {
                let json = JSON(responseObject!)
                self.createProfile()
                self.getProfileImage("Facebook",imageURLString: json["image"]["url"].stringValue)
            }
        }
    }
    
    func getProfileImage(signedInWith:String, imageURLString: String){
        var imageURLStrArr = []
        var imageURLStr = ""
        
        if signedInWith == "Twitter" {
            imageURLStrArr = imageURLString.componentsSeparatedByString("_normal")
            imageURLStr = (imageURLStrArr[0] as! String)+".png"
        } else if signedInWith == "Google" {
            imageURLStrArr = imageURLString.componentsSeparatedByString("?sz=50")
            imageURLStr = (imageURLStrArr[0] as! String)
        } else {
            imageURLStr = imageURLString
        }
        //print(imageURLStr)
        if let url = NSURL(string: imageURLStr) {
            var request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                    if let image = UIImage(data: data!) {
                        loggedInUser.profileImage = image
                        if signedInWith == "Google" {
                            if (!self.user!.userID.isEmpty){
                                loadingProfile.hide()
                                self.performSegueWithIdentifier("home", sender: self)
                            }
                        } else {
                            loadingProfile.hide()
                            self.performSegueWithIdentifier("home", sender: self)
                        }
                    } else {
                        loggedInUser.profileImage = UIImage(named: "default"+signedInWith+"ProfileImage.png")!
                    }
                userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
            }
        }
    }
    
    func createProfile(){
        //loggedInUser = GoogleContact()
        loggedInUser.isLoggedIn = true
        loggedInUser.googlePlusUser = false
        loggedInUser.email = self.user!.profile.email!
        loggedInUser.name = self.user!.profile.name!
        loggedInUser.id = self.user!.userID
        loggedInUser.address = currentAddress
        
        loggedInUser.accessToken = self.user!.authentication.accessToken
        loggedInUser.refreshToken = self.user!.authentication.refreshToken
        
        loggedInUser.accessTokenExpirationDate = self.user!.authentication!.accessTokenExpirationDate
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
}