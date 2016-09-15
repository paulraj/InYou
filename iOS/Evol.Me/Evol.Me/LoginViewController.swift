//
//  ViewController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/9/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import FBSDKLoginKit
import TwitterKit
import Fabric
import SafariServices
//import LinkedinSwift

let userDefaults = NSUserDefaults.standardUserDefaults()
let progressHUD = ProgressHUD(text: "Loading...")

var currentAddress = ""

var googleContacts: [GoogleContact] = [GoogleContact]()
var facebookContacts: [GoogleContact] = [GoogleContact]()
var twitterContacts: [GoogleContact] = [GoogleContact]()
var twitterFollowingContacts: [GoogleContact] = [GoogleContact]()
var twitterFollowerContacts: [GoogleContact] = [GoogleContact]()
var matchingProfiles: [GoogleContact] = [GoogleContact]()

let loadingProfile = ProgressHUD(text: "Loading profile...")
let readingEmails = ProgressHUD(text: "Reading Emails...")
let analyzingEmails = ProgressHUD(text: "Analyzing Emails...")
let analyzingLikes = ProgressHUD(text: "Analyzing Likes...")
let analyzingTweets = ProgressHUD(text: "Analyzing Tweets...")
let retrievingContacts = ProgressHUD(text: "Retrieving Contacts...")
let discoveringPersonality = ProgressHUD(text: "Discovering Personality...")
let loadingContacts = ProgressHUD(text: "Loading contacts...")
let signingOut = ProgressHUD(text: "Signing out...")

//let swifter = Swifter(consumerKey: "LuIM7Infby1eVfqVXvFyv3XDd", consumerSecret: "kPzqEqpNgWJfJb2K0dq98qlIGl2Z7T9JPAipV0VFCY37fTMynG")

class LoginViewController: UIViewController, CLLocationManagerDelegate, GIDSignInDelegate, GIDSignInUIDelegate,
FBSDKLoginButtonDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    //@IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appCaption: UILabel!
    @IBOutlet weak var facebookCaption: UILabel!
    @IBOutlet weak var twitterCaption: UILabel!
    
    @IBOutlet weak var appIcon: UIImageView!
    
    var locationManager = CLLocationManager()
    var window: UIWindow?
    
    //let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "75svh122dyicgr", clientSecret: "v9HY044pVjF3Fqhf", state: "DLKDJF45sd6ikMMZI", permissions: ["r_basicprofile", "r_emailaddress", "rw_company_admin"], redirectUrl: "http://paul-anne.com/"))
    
    var signIn: GIDSignIn?
    var user:   GIDGoogleUser?
    
    //let sampleTextField = UITextView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2+50, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height/2-50))
    
    //@IBOutlet weak var googleLoginButton: UIButton!
    //@IBOutlet weak var linkedinLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var twitterLoginButton: TWTRLogInButton!
    
    //@IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var backButtonBarItem: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        if let data = userDefaults.objectForKey("loggedInUser") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let user = unarc.decodeObjectForKey("root") as! GoogleContact
            loggedInUser = user
            //print("logged In user retrieved from userdefaults")
        }
        /*ParseAPIHandler().retrieveUserFromCloud(){ exists, error in
        if let isloggedIn = exists as Bool?{
        //print(loggedInUser.accessToken)
        if (isloggedIn != false) {
        if loggedInUser.signedInWith == "Google" {
        /*GoogleOAuth().refreshAccessToken(){ data, error in
        //print("Access token is refreshed now.")
        }*/
        }
        print("isloggedIn")
        self.view.hidden = true
        } else {
        self.view.hidden = false
        }
        }
        }*/
        /*
        if let isloggedIn = loggedInUser.isLoggedIn as Bool?{
        //print(loggedInUser.accessToken)
        if (isloggedIn != false) {
        //if loggedInUser.signedInWith == "Google" {
        /*GoogleOAuth().refreshAccessToken(){ data, error in
        //print("Access token is refreshed now.")
        }*/
        //}
        //print("isloggedIn")
        self.view.hidden = true
        } else {
        self.view.hidden = false
        }
        } else {
        self.view.hidden = false
        }*/
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        let modelName = UIDevice.currentDevice().modelName
        //GIDSignIn.sharedInstance().delegate = self
        
        /*
        if modelName != "iPhone 5" && modelName != "iPhone 5c" && modelName != "iPhone 5s" && modelName != "iPhone 6" && modelName != "iPhone 6 Plus"
        && modelName != "iPhone 6s" && modelName != "iPhone 6s Plus"
        && modelName != "Simulator"
        {
        print(modelName)
        //self.loginButton.hidden = true
        //self.appIcon.hidden = true
        //self.appCaption.hidden = true
        //self.appName.hidden = true
        //self.backgroundImage.hidden = true
        
        var title = "App Not Supported"
        var message = "InYou App is not supported on "+modelName+"."
        var actionTitle1 = "OK"
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
        alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.view.backgroundColor = UIColor.whiteColor()
        self.presentViewController(alert, animated: true, completion: nil)
        
        var labelTitle = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2-60, UIScreen.mainScreen().bounds.size.width, 40))
        labelTitle.text = "InYou"
        labelTitle.textColor = UIColor.redColor()
        labelTitle.textAlignment = NSTextAlignment.Center
        //self.view.addSubview(labelTitle)
        
        var label = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2+40, UIScreen.mainScreen().bounds.size.width, 40))
        //label.center = CGPointMake(160, 284)
        label.textColor = UIColor.redColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "App Not Supported on "+modelName+"."
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        var labelSize = label.font.pointSize*UIScreen.mainScreen().bounds.size.width/414
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: labelSize)
        //label.title = title
        
        self.view.addSubview(label)
        } else {*/
        //self.loginButton.hidden = false
        self.appIcon.hidden = false
        self.appCaption.hidden = false
        self.appName.hidden = false
        self.backgroundImage.hidden = false
        //print("cheking is isloggedIn")
        
        if let isloggedIn = loggedInUser.isLoggedIn as Bool? {
            //print("isloggedIn")
            if (isloggedIn == true) {
                //print("isloggedIn true")
                if loggedInUser.signedInWith == "Facebook" {
                    //FBSDKAccessToken.refreshCurrentAccessToken(){
                    //}
                    
                    if (FBSDKAccessToken.currentAccessToken() != nil) {
                        //print("FBSDKAccessToken.currentAccessToken()")
                        //print(FBSDKAccessToken.currentAccessToken())
                        // User is already logged in, do work such as go to next view controller.
                        self.performSegueWithIdentifier("facebook_home", sender: self)
                        //let loginManager = FBSDKLoginManager()
                        //loginManager.logOut()
                        
                    } else {
                        //do nothing
                        print("accss token empty")
                    }
                } else {
                    self.performSegueWithIdentifier("home", sender: self)
                }
            }
        }
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loginButton.frame = self.getNewFrame(loginButton.frame)
        //registerButton.frame = self.getNewFrame(registerButton.frame)
        
        self.appName.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.appName.frame)
        self.appCaption.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.appCaption.frame)
        
        //self.facebookCaption.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.facebookCaption.frame)
        //self.twitterCaption.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.twitterCaption.frame)
        
        self.appIcon.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(appIcon.frame)
        self.facebookLoginButton.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(facebookLoginButton.frame)
        self.twitterLoginButton.frame = CGRectMake(234, 543, 160, 38)
        
        // make the buttons classier
        customizeButton(facebookLoginButton!)
        customizeButton(twitterLoginButton!)
        //customizeButton(logInView?.signUpButton!)
        
        //twitterLoginButton.text = "twitter"
        
        //print(twitterLoginButton.frame)
        twitterLoginButton.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(twitterLoginButton.frame)
        //print(twitterLoginButton.frame)
        
        var nameSize = appName.font.pointSize*UIScreen.mainScreen().bounds.size.width/414
        var captionSize = appCaption.font.pointSize*UIScreen.mainScreen().bounds.size.width/414
        
        //print(twitterLoginButton.frame.width)
        //print("twitterLoginButton.frame.width")
        //print(twitterLoginButton.frame.width)
        //print("twitterLoginButton.frame.width")
        if twitterLoginButton.frame.width < 170 {
            let view = self.twitterLoginButton.subviews.last! as UIView
            var label = view.subviews.first as! UILabel
            label.text = "Log in"
        }
        
        appName.font = UIFont(name: "HelveticaNeue-Bold", size: nameSize)
        appCaption.font = UIFont(name: "HelveticaNeue-Bold", size: captionSize)
        //facebookCaption.font = UIFont(name: "HelveticaNeue", size: facebookCaption.font.pointSize*UIScreen.mainScreen().bounds.size.width/414)
        //twitterCaption.font = UIFont(name: "HelveticaNeue", size: twitterCaption.font.pointSize*UIScreen.mainScreen().bounds.size.width/414)
        
        twitterLoginButton.logInCompletion = {(session, error) -> Void in
            if error != nil {
                print("Error: "+error!.localizedDescription)
            } else {
                if let session = session {
                    loggedInUser.signedInWith = "Twitter"
                    loggedInUser.isLoggedIn = true
                    
                    // Digging the view hierarchy
                    var view = self.twitterLoginButton.subviews.last! as UIView
                    var label = view.subviews.first as! UILabel
                    label.text = "Log out"
                    
                    //print(session)
                    print("signed in as \(session.userName)")
                    var username = session.userName
                    var userId = session.userID
                    var authToken = session.authToken
                    var authTokenSecret = session.authTokenSecret
                    
                    //print(session.authToken)
                    //print(session.authTokenSecret)
                    
                    if let userID = Twitter.sharedInstance().sessionStore.session()!.userID {
                        let client = TWTRAPIClient(userID: userID)
                        client.loadUserWithID(userID) { (user, error) -> Void in
                            
                            if error != nil {
                                print(error)
                            } else {
                                if let user = user {
                                    print(user)
                                    print("above is user")
                                    /*print(user.screenName)
                                    print(user.isVerified)
                                    print(user.isProtected)
                                    print(user.profileImageURL)
                                    print(user.profileImageMiniURL)
                                    print(user.profileImageLargeURL)
                                    print(user.formattedScreenName)
                                    */
                                    loggedInUser.name = user.screenName
                                    loggedInUser.id = user.userID
                                    loggedInUser.twitterId = user.userID
                                    loggedInUser.twitterScreenName = user.screenName
                                    
                                    //loggedInUser.id = user.id
                                    //loggedInUser.address = currentAddress
                                    //loggedInUser.twitterDescription = user.description
                                    /*
                                    loggedInUser.twitterFriendsCount = myInfo!["friends_count"]!.integer!
                                    loggedInUser.twitterLocation = myInfo!["location"]!.string!
                                    loggedInUser.twitterDescription = myInfo!["description"]!.string!
                                    loggedInUser.twitterName = myInfo!["name"]!.string!
                                    loggedInUser.twitterStatusesCount = myInfo!["statuses_count"]!.integer!
                                    loggedInUser.twitterId = myInfo!["id_str"]!.string!
                                    loggedInUser.twitterProfileImageUrl = myInfo!["profile_image_url"]!.string!
                                    loggedInUser.twitterProfileImageUrlHttps = myInfo!["profile_image_url_https"]!.string!
                                    loggedInUser.twitterProfileBackgroundImageUrl = myInfo!["profile_background_image_url"]!.string!
                                    loggedInUser.twitterProfileBackgroundImageUrlHttps = myInfo!["profile_background_image_url_https"]!.string!
                                    loggedInUser.twitterScreenName = myInfo!["screen_name"]!.string!
                                    loggedInUser.twitterFollowersCount = myInfo!["followers_count"]!.intege
                                    */
                                    loggedInUser.profileImageURL = user.profileImageURL
                                    TwitterAPIHandler().getUsersShow(){ data, error in
                                        self.getProfileImage("Twitter",imageURLString: loggedInUser.twitterProfileImageUrl)
                                    }
                                    //self.getProfileImage("Twitter",imageURLString: user.profileImageURL)
                                    
                                    //TwitterAPIHandler().getFriendslistWithUserId(user.screenName, userId: user.userID)
                                    //TwitterAPIHandler().getFollowerslistWithUserId(user.screenName, userId: user.userID)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //no need to check here as user might want to offline login and see his personality.
        //if !(IJReachability.isConnectedToNetwork()) {
        //    print("No internet connection.")
        //    self.showError("Connection Error", message: "The Internet connection appears to be offline.", actionTitle: "OK")
        //} else {
        //self.view.backgroundColor = UIColor.blackColor()
        self.view.addSubview(progressHUD)
        // Do any additional setup after loading the view, typically from a nib.
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        progressHUD.hide()
        
        //if (FBSDKAccessToken.currentAccessToken() != nil) {
        // User is already logged in, do work such as go to next view controller.
        //let loginManager = FBSDKLoginManager()
        //loginManager.logOut()
        //} else {
        //let loginView : FBSDKLoginButton = FBSDKLoginButton()
        //self.view.addSubview(loginView)
        //loginView.center = self.view.center
        //FBSDKAccessToken.setCurrentAccessToken(nil)
        //FBSDKProfile.setCurrentProfile(nil)
        
        loggedInUser.signedInWith = "Facebook"
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends",
            "user_birthday", "user_likes", "user_location",
            "user_posts", "user_relationships", "user_status",
            //"user_photos",
            //"user_place_visits",
            //"user_actions.books", "user_actions.fitness", "user_actions.music", "user_actions.news",
            //"user_actions.video", "user_education_history", "user_events",
            //"user_groups",
            //"user_hometown", "user_managed_groups",
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
        facebookLoginButton.delegate = self
        
        //}
        
        //self.signInButton.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //twitterLoginButton.frame = CGRectMake(114, 550, 185, 38)
        
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        //self.googleLoginButton.frame = CustomUISize().getNewFrame(self.googleLoginButton.frame)
        
        if (reachability.currentReachabilityStatus == .NotReachable) {
            print("No internet connection.")
            self.showError("No Internet Connection", message: "There is no internet connection at this time. Please try again.", actionTitle: "OK")
        } else {
            //if loggedInUser.signedInWith == "Google" {
            if (user?.authentication.accessToken == nil) {
                signIn = GIDSignIn.sharedInstance()
                signIn?.shouldFetchBasicProfile = true
                signIn?.shouldGroupAccessibilityChildren = true
                signIn?.clientID = "215446193980-lbv6cqv1or1d8gf4oi6g4n3tpq44ujrk.apps.googleusercontent.com"
                //signIn?.delegate = self
                //signIn?.uiDelegate = self
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
                //signIn?.delegate = self
                //signIn?.shouldFetchBasicProfile = true
                //signIn?.allowsSignInWithBrowser = true
                //signIn?.allowsSignInWithWebView = true
                signIn?.signInSilently()
            }
            //}
            /* else if loggedInUser.signedInWith == "Facebook" {
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
            //} else {
            //let loginView : FBSDKLoginButton = FBSDKLoginButton()
            //self.view.addSubview(loginView)
            //loginView.center = self.view.center
            facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_likes", "user_location", "user_photos",
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
            
            facebookLoginButton.delegate = self
            }
            }*/
        }
        locationManager.requestWhenInUseAuthorization()

    }
    
    @IBAction func SignInWithGoogleClicked(sender: AnyObject) {
        //self.performSegueWithIdentifier("register", sender: self)
        
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        loggedInUser.signedInWith = "Google"
        if (reachability.currentReachabilityStatus == .NotReachable) {
            print("No internet connection.")
            self.showError("Connection Error", message: "The Internet connection appears to be offline.", actionTitle: "OK")
        } else {
            //var signIn = GIDSignIn.sharedInstance()
            signIn!.checkGoogleSignInAppInstalled({ (available: Bool) -> Void in
                print(available)
                print("checkGoogleSignInAppInstalled")
                if(available == true) {
                    self.signIn!.signIn()
                } else {
                    self.signIn!.signIn()
                }
            })
        }
    }
    @IBAction func signupClicked(sender: AnyObject) {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let menuViewController = ZLSwipeableViewController()
            window.rootViewController = UINavigationController(rootViewController: menuViewController)
            window.makeKeyAndVisible()
        }
    }
    
    @IBAction func SignInWithLinkedinClicked(sender: AnyObject) {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        loggedInUser.signedInWith = "Linkedin"
        if (reachability.currentReachabilityStatus == .NotReachable) {
            print("No internet connection.")
            self.showError("Connection Error", message: "The Internet connection appears to be offline.", actionTitle: "OK")
        } else {
            /*linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
                
                print("token below")
                print("Login success lsToken: \(lsToken)")
                self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,publications,interests,skills,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                    //var json = JSON(response)
                    print("Request success with response: \(response)")
                    print(response.jsonObject["pictureUrls"])
                    loggedInUser.name = response.jsonObject["firstName"] as! String
                    loggedInUser.email = response.jsonObject["emailAddress"] as! String
                    loggedInUser.firstName = response.jsonObject["firstName"] as! String
                    loggedInUser.id = response.jsonObject["id"] as! String
                    loggedInUser.lastName = response.jsonObject["lastName"] as! String
                    loggedInUser.location = response.jsonObject["location"]!["name"] as! String
                    
                    if response.jsonObject["pictureUrls"]!["_total"] as! Int > 0 {
                        var pictureUrls = JSON(response.jsonObject["pictureUrls"]!)
                        for (index, pictureUrl):(String, JSON) in pictureUrls["values"] {
                            loggedInUser.linkedinPictureUrl = pictureUrl.stringValue
                            print(loggedInUser.linkedinPictureUrl)
                        }
                    } else {
                        loggedInUser.linkedinPictureUrl = ""
                    }
                    var positions = JSON(response.jsonObject["positions"]!)
                    //var count = 0
                    for (index, position):(String, JSON) in positions["values"] {
                        loggedInUser.linkedinCompanyName = position["company"]["name"].stringValue
                        loggedInUser.linkedinCompanyType = position["company"]["type"].stringValue
                        loggedInUser.linkedinCompanyIndustry = position["company"]["industry"].stringValue
                        //loggedInUser.pictureUrls = json["positions"]["values"]["id"].stringValue
                        loggedInUser.linkedinPositionCurrent = position["isCurrent"].stringValue
                        loggedInUser.linkedinPositionStartDate = position["startDate"]["year"].stringValue
                        loggedInUser.linkedinPositionTitle = position["title"].stringValue
                        //loggedInUser.linkedinPositionSummary = position["summary"] as! String
                    }
                    loggedInUser.isLoggedIn = true
                    self.getProfileImage("Linkedin",imageURLString: loggedInUser.linkedinPictureUrl)
                    
                    //self.performSegueWithIdentifier("home", sender: self)
                }) { [unowned self] (error) -> Void in
                        print("Encounter1 error: \(error.localizedDescription)")
                        }
                }, error: { [unowned self] (error) -> Void in
                    print("Encounter2 error: \(error.localizedDescription)")
                }, cancel: { [unowned self] () -> Void in
                    print("User Cancelled!")
                })*/
        }
    }
    
    @IBAction func signInWithFacebookClicked(sender: AnyObject) {
        loggedInUser.signedInWith = "Facebook"
        //print(FBSDKAccessToken.currentAccessToken())
        //print("FBSDKAccessToken.currentAccessToken()")
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else {
            //let loginView : FBSDKLoginButton = FBSDKLoginButton()
            //self.view.addSubview(loginView)
            //loginView.center = self.view.center
            loggedInUser.signedInWith = "Facebook"
            facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends",
                //"user_birthday",
                "user_likes",
                //"user_location",
                //"user_photos",
                //"user_place_visits",
                //"user_actions.books", "user_actions.fitness", "user_actions.music", "user_actions.news",
                //"user_actions.video", "user_education_history", "user_events",
                //"user_groups",
                //"user_hometown", "user_managed_groups",
                //"user_posts", "user_relationships", "user_status",
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
            facebookLoginButton.delegate = self
        }
    }
    
    @IBAction func signInWithTwitterClicked(sender: AnyObject){
        loggedInUser.signedInWith = "Twitter"
        
        /*swifter.authorizeAppOnlyWithSuccess({ (accessToken, response) in
        print(accessToken)
        print("authorizeAppOnlyWithSuccess")
        }, failure: {
        (error: NSError) in
        
        print(error)
        
        })*/
        /*swifter.authorizeWithCallbackURL(NSURL(string: "swifter://success")!, success: { (accessToken, response) in
        self.view.addSubview(loadingProfile)
        loggedInUser.twitterUserId = accessToken!.userID!
        loggedInUser.twitterScreenName = accessToken!.screenName!
        loggedInUser.twitterOauthTokenKey = accessToken!.key
        loggedInUser.twitterOauthTokenSecret = accessToken!.secret
        
        print(loggedInUser.twitterOauthTokenKey)
        print(loggedInUser.twitterOauthTokenSecret)
        
        loggedInUser.isLoggedIn = true
        self.view.addSubview(loadingProfile)
        swifter.getAccountVerifyCredentials(false, skipStatus: true, success: { (myInfo: Dictionary<String, JSONValue>?) in
        print(myInfo)
        //store all Twitter account details
        loggedInUser.name = myInfo!["name"]!.string
        loggedInUser.id = myInfo!["id_str"]!.string!
        loggedInUser.address = currentAddress
        
        loggedInUser.twitterFriendsCount = myInfo!["friends_count"]!.integer!
        loggedInUser.twitterLocation = myInfo!["location"]!.string!
        loggedInUser.twitterDescription = myInfo!["description"]!.string!
        loggedInUser.twitterName = myInfo!["name"]!.string!
        loggedInUser.twitterStatusesCount = myInfo!["statuses_count"]!.integer!
        loggedInUser.twitterId = myInfo!["id_str"]!.string!
        loggedInUser.twitterProfileImageUrl = myInfo!["profile_image_url"]!.string!
        loggedInUser.twitterProfileImageUrlHttps = myInfo!["profile_image_url_https"]!.string!
        loggedInUser.twitterProfileBackgroundImageUrl = myInfo!["profile_background_image_url"]!.string!
        loggedInUser.twitterProfileBackgroundImageUrlHttps = myInfo!["profile_background_image_url_https"]!.string!
        loggedInUser.twitterScreenName = myInfo!["screen_name"]!.string!
        loggedInUser.twitterFollowersCount = myInfo!["followers_count"]!.integer!
        
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
        */
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    //Google SignIn Override methods
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil ){
            print(error)
        } else {
            self.view.addSubview(loadingProfile)
            loadingProfile.show()
            print("Google Signed in.")
            self.user = user
            //print(self.user!.authentication.accessToken)
            Alamofire.request(.GET, "https://www.googleapis.com/plus/v1/people/\(self.user!.userID)",
                parameters: [ "access_token": self.user!.authentication.accessToken, "alt": "json", "sz": 1000]).responseJSON { response in
                    if response.result.error != nil {
                        print("Could not complete the request \(error)")
                    } else {
                        let json = JSON(response.result.value!)
                        //loggedInUser = GoogleContact()
                        //print(response)
                        /*loggedInUser.googleGender = json["gender"]
                        loggedInUser.googleId = json["id"]
                        loggedInUser.googleName = json["displayName"]
                        loggedInUser.googleFamilyName = json["name"]["familyName"]
                        loggedInUser.googleLastName = json["name"]["lastName"]
                        loggedInUser.googleCircledByCount = json["circledByCount"]
                        loggedInUser.googleObjectType = json["objectType"]
                        loggedInUser.googleIsPlusUser = json["isPlusUser"]
                        */
                        loggedInUser.isLoggedIn = true
                        loggedInUser.googlePlusUser = false
                        loggedInUser.email = self.user!.profile.email!
                        loggedInUser.name = self.user!.profile.name!
                        loggedInUser.id = self.user!.userID
                        loggedInUser.location = currentAddress
                        
                        loggedInUser.accessToken = self.user!.authentication.accessToken
                        loggedInUser.refreshToken = self.user!.authentication.refreshToken
                        
                        loggedInUser.accessTokenExpirationDate = self.user!.authentication!.accessTokenExpirationDate
                        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
                        self.getProfileImage("Google",imageURLString: json["image"]["url"].stringValue)
                    }
            }
        }
    }
    
    
    /*
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    print("signInWillDispatch")
    }*/
    
    // Present a view that prompts the user to sign in with Google
    /*func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
    self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    */
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil) {
            print("Status: Failed to disconnect: \(error)")
        } else {
            print("Status: Disconnected")
        }
    }
    
    func finishedWithAuth(auth: GIDAuthentication!, error: NSError!) {
        print("finishedWithAuth")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "home") {
            if loggedInUser.signedInWith == "Twitter" {
                let destinationVC = segue.destinationViewController as! UITabBarController
                var homeViewController = destinationVC.viewControllers?.first as! HomeViewController
                //var contactsViewController = destinationVC.viewControllers?[1] as! ContactsViewController
                //var twitterFollowersViewController = destinationVC.viewControllers?[2] as! ContactsViewController
                //var settingsTableViewController = destinationVC.viewControllers?[2] as! SettingsTableViewController
            }
            loadingProfile.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]!) {
        print("locationManager now")
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        if (reachability.currentReachabilityStatus == .NotReachable) {
            print("No internet connection.")
        } else {
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                    return
                }
                if placemarks!.count > 0 {
                    let pm = placemarks?.first as CLPlacemark!
                    self.displayLocationInfo(pm)
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        print("displayLocationInfo")
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let addressComplete = locality! + ", " + administrativeArea! + " - " + postalCode! + " " + country!
            print(addressComplete)
            currentAddress = addressComplete
            let defaults = NSUserDefaults.standardUserDefaults()
            //if let data = userDefaults.objectForKey("loggedInUser") as? NSData {
            //    let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                loggedInUser.location = addressComplete
                loggedInUser.locality = locality!
                loggedInUser.postCode = postalCode!
                loggedInUser.administrativeArea = administrativeArea!
                loggedInUser.country = country!
                loggedInUser.address = addressComplete
            //    userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
            //}
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func showError(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //print(result.grantedPermissions)
        if ((error) != nil) {
            print(error)
        } else if result.isCancelled {
            // Handle cancellations
            print("user has cancelled the operation.")
        } else {
            self.view.addSubview(loadingProfile)
            print("User logged In with Facebook")
            //print(FBSDKAccessToken.currentAccessToken())
            
            loggedInUser.signedInWith = "Facebook"
            loggedInUser.isLoggedIn = true
            if result.grantedPermissions.contains("email") {
                //print(result)
                FB().me() { responseObject, error in
                    if error != nil {
                        print("Could not complete the request \(error)")
                    } else {
                        let json = responseObject
                        //JSON(responseObject!)
                        //print(json)
                        loggedInUser.address = currentAddress
                        loggedInUser.isLoggedIn = true
                        loggedInUser.googlePlusUser = false
                        //loggedInUser.email = self.user!.profile.email!
                        //loggedInUser.facebookName = json!["name"].stringValue
                        //loggedInUser.facebookLastName = json!["last_name"].stringValue
                        //loggedInUser.facebookFirstName = json!["first_name"].stringValue
                        //loggedInUser.facebookGender = json!["gender"].stringValue
                        
                        loggedInUser.name = json!["name"].stringValue
                        loggedInUser.lastName = json!["last_name"].stringValue
                        loggedInUser.firstName = json!["first_name"].stringValue
                        loggedInUser.gender = json!["gender"].stringValue
                        //print(json!["birthday"].stringValue)
                        //print("birthday")
                        //loggedInUser.birthday = json!["birthday"].stringValue
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        let date = dateFormatter.dateFromString(json!["birthday"].stringValue)
                        loggedInUser.birthday = date!
                        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date!)
                        let year = components.year
                        loggedInUser.birthYear = String(year)
                        loggedInUser.age = String(self.calculateAge(date!))
                        //print("age is ")
                        
                        loggedInUser.id = json!["id"].stringValue
                        loggedInUser.facebookId = json!["id"].stringValue
                        
                        //loggedInUser.birthday = json["birthday"].stringValue
                        loggedInUser.gender = json!["gender"].stringValue
                        
                        //loggedInUser.accessToken = self.user!.authentication.accessToken
                        //loggedInUser.refreshToken = self.user!.authentication.refreshToken
                        
                        //loggedInUser.accessTokenExpirationDate = self.user!.authentication!.accessTokenExpirationDate
                        loggedInUser.profileImageURL = json!["picture"]["data"]["url"].stringValue
                        self.getProfileImage("Facebook",imageURLString: json!["picture"]["data"]["url"].stringValue)
                    }
                }
            } else {
                print("no email permission yet.")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func calculateAge (birthday: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: NSDate(), options: []).year
    }
    
    func getProfileImage(signedInWith:String, imageURLString: String){
        var imageURLStrArr = []
        var imageURLStr = ""
        
        if imageURLString != "" {
            if signedInWith == "Twitter" {
                imageURLStrArr = imageURLString.componentsSeparatedByString("_normal")
                imageURLStr = (imageURLStrArr[0] as! String)+".png"
            } else if signedInWith == "Google" {
                imageURLStrArr = imageURLString.componentsSeparatedByString("?sz=50")
                imageURLStr = (imageURLStrArr[0] as! String)
            } else {
                imageURLStr = imageURLString
            }
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
                        } else if signedInWith == "Facebook" {
                            loadingProfile.hide()
                            self.performSegueWithIdentifier("facebook_home", sender: self)
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
        } else {
            loggedInUser.profileImage = UIImage(named: "default"+signedInWith+"ProfileImage.png")!
            if signedInWith == "Google" {
                    self.performSegueWithIdentifier("home", sender: self)
            } else if signedInWith == "Facebook" {
                self.performSegueWithIdentifier("facebook_home", sender: self)
            } else {
                self.performSegueWithIdentifier("home", sender: self)
            }
            //self.performSegueWithIdentifier("home", sender: self)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("Error while updating location " + error.localizedDescription)
    }
}