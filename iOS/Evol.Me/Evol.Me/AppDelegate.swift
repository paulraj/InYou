//
//  AppDelegate.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/9/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import UIKit
import Contacts
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4
import TwitterKit
import Fabric
import Alamofire
//import LISDK
//import AWSMobileClient

let kUserHasOnboardedKey: String = "user_has_onboarded"
var loggedInUser: GoogleContact = GoogleContact()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
    , GIDSignInDelegate
{
    var user:   GIDGoogleUser?
    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    //var signedUpWithGoogle = true
    //var signedUpWithFacebook = true
    var contactStore = CNContactStore()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var configureError: NSError?
        //GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        //Parse
        Parse.enableLocalDatastore()
        Parse.setApplicationId("xBevoFrtcJJeUTtIXkh3ElYpFx6JKqazivye6WvH", clientKey: "DwMQ4Eu9pNPvX0VZHa3nLVQJOeYwYOsuGzbX6Xgn")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFTwitterUtils.initializeWithConsumerKey("LuIM7Infby1eVfqVXvFyv3XDd", consumerSecret:"kPzqEqpNgWJfJb2K0dq98qlIGl2Z7T9JPAipV0VFCY37fTMynG")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        PFFacebookUtils.facebookLoginManager().loginBehavior = FBSDKLoginBehavior.SystemAccount
        
        //Facebook
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "215446193980-lbv6cqv1or1d8gf4oi6g4n3tpq44ujrk.apps.googleusercontent.com"
        
        //Twitter
        Twitter.sharedInstance().startWithConsumerKey("LuIM7Infby1eVfqVXvFyv3XDd", consumerSecret: "kPzqEqpNgWJfJb2K0dq98qlIGl2Z7T9JPAipV0VFCY37fTMynG")
        Fabric.with([Twitter.sharedInstance()])
        
        //Remove Push notification for now
        let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes:
            [UIUserNotificationType.Alert, UIUserNotificationType.Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        //return AWSMobileClient.sharedInstance().didFinishLaunching(application, withOptions: launchOptions)
        
        //return true
        //*/
        //
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //self.window!.backgroundColor = UIColor.whiteColor()
        // determine if the user has onboarded yet or not
        var userHasOnboarded: Bool = NSUserDefaults.standardUserDefaults().boolForKey(kUserHasOnboardedKey)
        // if the user has already onboarded, just set up the normal root view controller
        // for the application
        print("below is loggedin or not")
        print(loggedInUser.signedInWith)
        
            print("userHasOnboarded")
            print(userHasOnboarded)
            if userHasOnboarded {
                self.setupNormalRootViewController()
            } else {
                self.window!.rootViewController = self.generateFirstDemoVC()
            }
            application.statusBarStyle = .LightContent
            self.window!.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //AWSMobileClient.sharedInstance().applicationDidBecomeActive(application)
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var result: Bool = false
        if loggedInUser.signedInWith == "Google" {
            result = GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        if loggedInUser.signedInWith == "Facebook" {
            result = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        if loggedInUser.signedInWith == "Linkedin" {
            //if LISDKCallbackHandler.shouldHandleUrl(url) {
            //    result = LISDKCallbackHandler.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
            //}
        }
        //return AWSMobileClient.sharedInstance().withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation)
        return result
    }
    
    /*
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            return GIDSignIn.sharedInstance().handleURL(url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    */
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        AWSMobileClient.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        /*
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        installation.saveInBackground()*/
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        /*print("didFailToRegisterForRemoteNotificationsWithError")
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }*/
        //AWSMobileClient.sharedInstance().application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        /*print("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }*/
        //AWSMobileClient.sharedInstance().application(application, didReceiveRemoteNotification: userInfo)
    }

    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error != nil ){
            print(error)
        } else {
            //self.view.addSubview(loadingProfile)
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
                        //self.getProfileImage("Google",imageURLString: json["image"]["url"].stringValue)
                    }
            }
        }
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        //let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        //let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        //presentedViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        //let addressBookRef = CNContactStore()
        //contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { success, error in print("done now")})
        
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        print(authorizationStatus)
        switch authorizationStatus {
        case .Authorized:
            print("yes")
            completionHandler(accessGranted: true)
        case .Denied, .NotDetermined:
            print("denied")
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    print("access")
                    completionHandler(accessGranted: access)
                } else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        print("denied now.")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message)
                            print(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    */
    func setupNormalRootViewController() {
        print("setupNormalRootViewController")
        // create whatever your root view controller is going to be, in this case just a simple view controller
        // wrapped in a navigation controller
        //var mainVC: UIViewController = LoginViewController()
        //mainVC.title = "Main Application"
        //self.window!.rootViewController = UINavigationController(rootViewController: mainVC)
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initViewController: UIViewController = storyBoard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
            self.window!.rootViewController = initViewController
            self.window!.makeKeyAndVisible()
    }
    
    func handleOnboardingCompletion() {
        print("handleOnboardingCompletion")
        // set that we have completed onboarding so we only do it once... for demo
        // purposes we don't want to have to set this every time so I'll just leave
        // this here...
        //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
        // transition to the main application
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kUserHasOnboardedKey)
        self.setupNormalRootViewController()
    }
    
    func generateFirstDemoVC() -> OnboardingViewController {
        var firstPage: OnboardingContentViewController = OnboardingContentViewController.contentWithTitle("InYou", body: "Get to know yourself!", image: UIImage(named: "appicon_120-120"), buttonText: "", action: {() -> Void in })
        var secondPage: OnboardingContentViewController = OnboardingContentViewController.contentWithTitle("InYou", body: "Get to know about your friends!", image: UIImage(named: "appicon_120-120"), buttonText: "", action: {() -> Void in })
        //secondPage.movesToNextViewController = true
        //secondPage.viewDidAppearBlock = {(A) -> Void in }
        var thirdPage: OnboardingContentViewController = OnboardingContentViewController.contentWithTitle("InYou", body: "Get to know people around you!", image: UIImage(named: "appicon_120-120"), buttonText: "Get Started", action: {() -> Void in
            self.handleOnboardingCompletion()
        })
        var onboardingVC: OnboardingViewController = OnboardingViewController.onboardWithBackgroundImage(UIImage(named: "login_bg.JPG"), contents: [firstPage, secondPage, thirdPage])
        onboardingVC.shouldFadeTransitions = true
        onboardingVC.fadePageControlOnLastPage = true
        onboardingVC.fadeSkipButtonOnLastPage = true
        // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
        // when the user hits the skip button.
        onboardingVC.allowSkipping = true
        onboardingVC.skipHandler = {() -> Void in
            self.handleOnboardingCompletion()
        }
        return onboardingVC
    }
    
}