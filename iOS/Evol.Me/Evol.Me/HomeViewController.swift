//
//  File.swift
//  InYou
//
//  Created by Paul.Raj on 5/9/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import UIKit
import Parse
import ActiveLabel

var popUpOpen = false

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate,iCarouselDataSource, iCarouselDelegate {
    
    var imageUrl: String = ""
    var image:UIImage? = nil
    var signIn: GIDSignIn? = nil
    //var personalitySummary = ""
    var pesonalityText: NSString = ""
    
    var analyzeInProgress: Bool = false
    
    var emailAnalyzed: Bool = false
    var errorOccurred: Bool = false
    
    let label = ActiveLabel()
    var animator = UIDynamicAnimator()
    
    let width = UIScreen.mainScreen().bounds.width
    
    var openCircle = CircleView(frame: CGRectMake(3, 285, CGFloat(80), CGFloat(80)),color:UIColor.brownColor().CGColor)
    var conscientiousnessCircle = CircleView(frame: CGRectMake(67, 285, CGFloat(80), CGFloat(80)),color:UIColor.blueColor().CGColor)
    var extraversionCircle = CircleView(frame: CGRectMake(131, 285, CGFloat(80), CGFloat(80)),color:UIColor.greenColor().CGColor)
    var agreeablenessCircle = CircleView(frame: CGRectMake(194, 285, CGFloat(80), CGFloat(80)),color:UIColor.yellowColor().CGColor)
    var emotionalRangeCircle = CircleView(frame: CGRectMake(257, 285, CGFloat(80), CGFloat(80)),color:UIColor.redColor().CGColor)
    
    var needCircle = CircleView(frame: CGRectMake(100, 210, CGFloat(60), CGFloat(60)),color:UIColor.blueColor().CGColor)
    var valueCircle = CircleView(frame: CGRectMake(160, 210, CGFloat(60), CGFloat(60)),color:UIColor.yellowColor().CGColor)
    
    var topFacetsArray = [Dictionary<String, Any>]()
    var topNeedsArray = [Dictionary<String, Any>]()
    var topValuesArray = [Dictionary<String, Any>]()
    
    var relationship : [String: String] = ["status":"","value":""]
    var religion : [String: String] = ["status":"","value":""]
    var politics : [String: String] = ["status":"","value":""]
    var concentration : [String: String] = ["status":"","value":""]
    
    var errorText = UITextView()
    //var inviteButton = UIButton()
    var popViewController : PopUpViewControllerSwift!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var personalityCarousel: iCarousel!
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    var containerView = UIView()
    //http://koreyhinton.com/blog/uiscrollview-crud.html
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //@IBOutlet weak var userName: UILabel!
    //@IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var opennessLabel: UILabel!
    @IBOutlet weak var conscientiousnessLabel: UILabel!
    @IBOutlet weak var extraversionLabel: UILabel!
    @IBOutlet weak var agreeablenessLabel: UILabel!
    @IBOutlet weak var emotionalRange: UILabel!
    
    @IBOutlet weak var openName: UILabel!
    @IBOutlet weak var conName: UILabel!
    @IBOutlet weak var extravertName: UILabel!
    @IBOutlet weak var agreeName: UILabel!
    @IBOutlet weak var emotionalName: UILabel!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var profileImage3: UIImageView!
    @IBOutlet weak var profileImage4: UIImageView!
    
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var bestTraits: UITextView!
    @IBOutlet weak var tweetCount: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        performSegueWithIdentifier("register", sender: self)
    }
    
    /*@IBAction func refreshButton(sender: AnyObject) {
    self.view.reloadInputViews()
    }
    */
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        print("logged out")
        cleanUpData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func settingsButtonClicked(sender: UIBarButtonItem) {
        performSegueWithIdentifier("settings", sender: self)
    }
    
    @IBAction func shareButtonClicked(sender: UIBarButtonItem) {
        //let screenshot = self.view?.pb_takeSnapshot()
        //UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        /*loggedInUser.personalityData.intelligenceQuotient = String(Int(loggedInUser.personalityData.traits!.openness!.intellect))
        loggedInUser.personalityData.emotionalQuotient = String(Int(loggedInUser.personalityData.traits!.openness!.emotionality))
        loggedInUser.personalityData.friendlinessScore = String(Int(loggedInUser.personalityData.traits!.extraversion!.friendliness))
        
        var academic = ""
        if Int(loggedInUser.personalityData.academicPerformance) > 90 {
        academic = "A+"
        } else if Int(loggedInUser.personalityData.academicPerformance) > 80 {
        academic = "A"
        } else if Int(loggedInUser.personalityData.academicPerformance) > 70 {
        academic = "B+"
        } else if Int(loggedInUser.personalityData.academicPerformance) > 60 {
        academic = "B"
        } else {
        academic = "C"
        }
        */
        var strength = loggedInUser.personalityData.strengths.joinWithSeparator(", ")
        var text = ""
        if loggedInUser.signedInWith != "Facebook" {
            text = loggedInUser.name + "'s InYou profile: \n\n" +
                "Traits: " + loggedInUser.personalityData.personalityTraits + "\n" +
                "Happy: " + loggedInUser.personalityData.lifeSatisfaction + "\n" +
                "Friendly: " + loggedInUser.personalityData.friendlinessScore + "\n" +
                "Trustworthy: " + loggedInUser.personalityData.trustScore + "\n" +
                "Lovable: " + loggedInUser.personalityData.personalRelationship + "\n" +
                "Strengths: " + strength + "\n" +
                "Intelligence Quotient: " + String(loggedInUser.personalityData.intelligenceQuotient) + "\n" +
                "Emotional Quotient: " + loggedInUser.personalityData.emotionalQuotient + "\n" +
                "Academic Performance: " + loggedInUser.personalityData.academicPerformance + "\n" +
                "Career Performance: " + loggedInUser.personalityData.carreerPerformance + "\n" +
                "Innovation: " + loggedInUser.personalityData.innovation + "\n" +
                "Creativity: " + loggedInUser.personalityData.creativity + "\n" +
                "Thinking Style: " + loggedInUser.personalityData.thinkingStyleDegree + "\n" +
                "Pesonality Type: " + loggedInUser.personalityData.personalityType + "\n" +
                "Summary: " + loggedInUser.personalityData.personalitySummary
        } else {
            text = loggedInUser.name + "'s InYou profile: \n\n" +
                "Feeling Like: " + loggedInUser.personalityData.feelByAge + "\n" +
                "Life Satisfaction: " + loggedInUser.personalityData.lifeSatisfaction + "\n" +
                "Friendly: " + loggedInUser.personalityData.friendlinessScore + "\n" +
                "Lovable: " + loggedInUser.personalityData.personalRelationship + "\n" +
                "Intelligence Quotient: " + String(loggedInUser.personalityData.intelligenceQuotient) + "\n" +
                "Emotional Quotient: " + loggedInUser.personalityData.emotionalQuotient + "\n" +
                "Academic Performance: " + loggedInUser.personalityData.academicPerformance + "\n" +
                "Career Interest: " + loggedInUser.personalityData.careerArea + "\n" +
                "Innovation: " + loggedInUser.personalityData.innovation + "\n" +
                "Creativity: " + loggedInUser.personalityData.creativity
        }
        
        var image  = ContactDetailsViewController().takeScreenshot(self)
        
        let textToShare = loggedInUser.personalityData.personalitySummary
        //let google:NSURL = NSURL(string:"http://google.com/")!
        let url = NSBundle.mainBundle().URLForResource("", withExtension:"png")!
        //var shareItems:Array = [screenshot]
        let activityVC = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        
        //activityVC.excludedActivityTypes =  [UIActivityTypePrint]
        activityVC.excludedActivityTypes = [UIActivityTypePostToWeibo, UIActivityTypePostToTwitter ]
        /*
        activityVC.completionWithItemsHandler = {(activityType: String!, completed: Bool, arrayOptions: [AnyObject]!) in
        print(activityType)
        }
        */
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if loggedInUser.signedInWith == "Google" || loggedInUser.signedInWith == "Twitter" {
            pageControl.numberOfPages = 13
        } else if loggedInUser.signedInWith == "Facebook" {
            pageControl.numberOfPages = 7
        }
        
        if loggedInUser.images.count == 0 {
            //disabled as no email address is stored
            self.callFullContactAPI()
        } else {
            for (var i = 0; i < loggedInUser.images.count; i++) {
                if i == 0 {
                    self.profileImage2.image = loggedInUser.images[0]
                    self.profileImage2.hidden = false
                }
                if i == 1 {
                    self.profileImage3.image = loggedInUser.images[1]
                    self.profileImage3.hidden = false
                }
                if i == 2 {
                    self.profileImage4.image = loggedInUser.images[2]
                    self.profileImage4.hidden = false
                }
            }
        }
        if loggedInUser.profileImage == nil {
            //print("profile image is nil")
            self.getProfileImage()
        }
        
        if loggedInUser.personalityData.personalitySummaryStatus.isEmpty {
            //print("personalitySummary.isEmpty")
            if loggedInUser.signedInWith == "Google" {
                self.setPersonalityViewHidden(true)
                
                //print("signedInWithGoogle")
                if loggedInUser.personalityData.personalitySummary.isEmpty {
                    if self.analyzeInProgress == false {
                        self.callPersonalityAPI()
                    }
                }
                self.currentLocation.text = loggedInUser.location
                self.getAllContacts()
                /*GoogleOAuth().refreshAccessToken(){ data, error in
                }*/
            } else if loggedInUser.signedInWith == "Facebook" {
                self.profileBackgroundImage.image = loggedInUser.profileImage
                self.currentLocation.text = loggedInUser.location
                let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
                if loggedInUser.analyzeOnWifiOnly == true && reachability.currentReachabilityStatus != .ReachableViaWiFi {
                    var title = "Not Connected to Wi-fi"
                    var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using current intenet connection?"
                    var actionTitle1 = "Yes"
                    var actionTitle2 = "No"
                    
                    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                        self.view.addSubview(analyzingLikes)
                        analyzingLikes.show()
                        loggedInUser.analyzeOnWifiOnly = false
                        FB().likes(nil) { responseObject, error in
                            if error != nil {
                                loggedInUser.personalityData.personalityAnalyzed = true
                                analyzingLikes.hide()
                                print("Could not complete the request \(error)")
                                self.errorText.text = "Personality can not be determined as Facebook Likes are protected or not many Likes."
                                self.errorText.hidden = false
                                self.shareButton.tintColor = UIColor.clearColor()
                            } else {
                                //print(responseObject)
                                //let json = JSON(responseObject!)
                                //print(responseObject)
                                analyzingLikes.hide()
                                self.updatePersonalityForFacebook(responseObject!)
                                self.setPersonalityViewHidden(false)
                                self.bestTraits.hidden = true
                                self.errorText.hidden = true
                            }
                            ParseAPIHandler().saveUserInCloud()
                            FB().friends()
                        }
                    }))
                    alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                        loggedInUser.analyzeOnWifiOnly = true
                        self.presentViewController(alert, animated: true, completion: nil)
                        loggedInUser.personalityData.personalitySummary = "Personality Analysis can not be done. Please change Analysis Wifi Only setting."
                        self.errorText.text = loggedInUser.personalityData.personalitySummary
                        self.errorText.hidden = false
                        self.shareButton.tintColor = UIColor.clearColor()
                        //self.inviteButton.hidden = false
                        //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
                        //self.personalitySummaryText.hidden = false
                        //switcher.setOn(true, animated: true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.view.addSubview(analyzingLikes)
                    if loggedInUser.personalityData.personalityAnalyzed != true {
                        self.setPersonalityViewHidden(true)
                        analyzingLikes.show()
                        FB().likes(nil) { responseObject, error in
                            if error != nil {
                                loggedInUser.personalityData.personalityAnalyzed = true
                                analyzingLikes.hide()
                                print("Could not complete the request \(error)")
                                self.errorText.text = "Personality can not be determined as Facebook Likes are protected or not many Likes."
                                self.errorText.hidden = false
                                self.shareButton.tintColor = UIColor.clearColor()
                            } else {
                                //print(responseObject)
                                //let json = JSON(responseObject!)
                                //print(responseObject)
                                analyzingLikes.hide()
                                self.updatePersonalityForFacebook(responseObject!)
                                self.setPersonalityViewHidden(false)
                                self.bestTraits.hidden = true
                                self.errorText.hidden = true
                            }
                            ParseAPIHandler().saveUserInCloud()
                            FB().friends()
                        }
                    }
                }
            } else if loggedInUser.signedInWith == "Twitter" {
                //self.getProfileBackgroundImage("Twitter", imageURLString: loggedInUser.twitterProfileBackgroundImageUrlHttps)
                self.profileBackgroundImage.image = loggedInUser.profileImage
                let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
                if loggedInUser.analyzeOnWifiOnly == true && reachability.currentReachabilityStatus != .ReachableViaWiFi {
                    var title = "Not Connected to Wi-fi"
                    var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using current intenet connection?"
                    var actionTitle1 = "Yes"
                    var actionTitle2 = "No"
                    
                    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                        loggedInUser.analyzeOnWifiOnly = false
                        self.view.addSubview(analyzingTweets)
                        analyzingTweets.show()
                        var allTweets = ""
                        self.currentLocation.text = loggedInUser.location
                        TwitterAPIHandler().getUserTimelineWithUserId(loggedInUser.twitterScreenName, userId: loggedInUser.id) { tweetText, count, error in
                            loggedInUser.twitterTotalTweets = count!
                            IBMWatsonAPIHandler().invokeAPI(loggedInUser, mail: tweetText!) { data, error in
                                if loggedInUser.personalityData.personalitySummaryStatus == "ERROR" {
                                    analyzingTweets.hide()
                                    self.errorOccurred = true
                                    self.errorText.text = loggedInUser.personalityData.personalitySummary
                                    self.errorText.hidden = false
                                    self.shareButton.tintColor = UIColor.clearColor()
                                    TwitterAPIHandler().getFriendslistWithUserId("-1") { data, error in
                                        //print("first contacts load is done now.")
                                    }
                                    TwitterAPIHandler().getFollowerslistWithUserId("-1") { data, error in
                                        //print("first contacts load is done now.")
                                    }
                                } else {
                                    ReceptivitiAPIHandler().invokeAPI(loggedInUser, text: tweetText!){ data, error in
                                        analyzingTweets.hide()
                                        self.updatePersonality()
                                        self.setPersonalityViewHidden(false)
                                        self.errorText.hidden = true
                                        IBMWatsonToneAnalyzerAPIHandler().invokeAPI(loggedInUser,text:tweetText!){ data, error in
                                            
                                        }
                                        TwitterAPIHandler().getFriendslistWithUserId("-1") { data, error in
                                            //print("first contacts load is done now.")
                                        }
                                        TwitterAPIHandler().getFollowerslistWithUserId("-1") { data, error in
                                            //print("first contacts load is done now.")
                                        }
                                        //print(loggedInUser.personalityData.personalityType)
                                        //print(loggedInUser.personalityData.thinkingStyleDegree)
                                        //print("All done now")
                                        print(error)
                                    }
                                }
                                ParseAPIHandler().saveUserInCloud()
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                        loggedInUser.analyzeOnWifiOnly = true
                        self.presentViewController(alert, animated: true, completion: nil)
                        loggedInUser.personalityData.personalitySummary = "Personality Analysis can not be done. Please change Analysis Wifi Only setting."
                        self.errorText.text = loggedInUser.personalityData.personalitySummary
                        self.errorText.hidden = false
                        self.shareButton.tintColor = UIColor.clearColor()
                        //self.inviteButton.hidden = false
                        //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
                        //self.personalitySummaryText.hidden = false
                        //switcher.setOn(true, animated: true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.view.addSubview(analyzingTweets)
                    analyzingTweets.show()
                    var allTweets = ""
                    self.currentLocation.text = loggedInUser.location
                    self.setPersonalityViewHidden(true)
                    TwitterAPIHandler().getUserTimelineWithUserId(loggedInUser.twitterScreenName, userId: loggedInUser.id) { tweetText, count, error in
                        loggedInUser.twitterTotalTweets = count!
                        IBMWatsonAPIHandler().invokeAPI(loggedInUser, mail: tweetText!) { data, error in
                            if loggedInUser.personalityData.personalitySummaryStatus == "ERROR" {
                                analyzingTweets.hide()
                                self.errorOccurred = true
                                self.errorText.text = loggedInUser.personalityData.personalitySummary
                                self.errorText.hidden = false
                                self.shareButton.tintColor = UIColor.clearColor()
                                TwitterAPIHandler().getFriendslistWithUserId("-1") { data, error in
                                    //print("first contacts load is done now.")
                                }
                                TwitterAPIHandler().getFollowerslistWithUserId("-1") { data, error in
                                    //print("first contacts load is done now.")
                                }
                            } else {
                                ReceptivitiAPIHandler().invokeAPI(loggedInUser, text: tweetText!){ data, error in
                                    self.updatePersonality()
                                    self.setPersonalityViewHidden(false)
                                    self.errorText.hidden = true
                                    analyzingTweets.hide()
                                    IBMWatsonToneAnalyzerAPIHandler().invokeAPI(loggedInUser,text:tweetText!){ data, error in
                                    
                                    }
                                    TwitterAPIHandler().getFriendslistWithUserId("-1") { data, error in
                                        //print("first contacts load is done now.")
                                    }
                                    TwitterAPIHandler().getFollowerslistWithUserId("-1") { data, error in
                                        //print("first contacts load is done now.")
                                    }
                                    //print(loggedInUser.personalityData.personalityType)
                                    //print(loggedInUser.personalityData.thinkingStyleDegree)
                                    //print("All done now")
                                    print(error)
                                }
                            }
                            ParseAPIHandler().saveUserInCloud()
                        }
                    }
                }
                
                
                /*swifter.getStatusesUserTimelineWithUserID(loggedInUser.twitterUserId, count: 2000, success: { (statuses: [JSONValue]?) in
                    for status in statuses! {
                        var text: String = status["text"].description
                        allTweets = allTweets + "\n" + text
                    }
                    
                    IBMWatsonAPIHandler().invokeAPI(loggedInUser, mail: allTweets) { data, error in
                        analyzingTweets.hide()
                        self.updatePersonality()
                        self.setPersonalityViewHidden(false)
                        ParseAPIHandler().saveUserInCloud()
                        TwitterAPIHandler().getTwitterFriends() { data, error in
                            print("getTwitterFriends done now")
                            
                        }
                    }
                }, failure: {
                        (error: NSError) in
                        print(error)
                })*/
            }
        } else if loggedInUser.personalityData.personalitySummaryStatus == "ERROR" {
            //print("personalitySummaryStatus == ERROR")
            self.setPersonalityViewHidden(true)
            errorText.text = loggedInUser.personalityData.personalitySummary
            errorText.hidden = false
            self.shareButton.tintColor = UIColor.clearColor()
            
            //inviteButton.hidden = false
            //self.personalitySummaryText.hidden = false
            //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
        } else {
            //print("none")
            if popUpOpen == false {
                self.updatePersonality()
                self.currentLocation.text = loggedInUser.location
                self.setPersonalityViewHidden(false)
            }
        }
    }
    
    func getProfileImage(){
        var imageURLStrArr = []
        var imageURLStr = ""
        
        if loggedInUser.signedInWith == "Twitter" {
            imageURLStrArr = loggedInUser.profileImageURL.componentsSeparatedByString("_normal")
            imageURLStr = (imageURLStrArr[0] as! String)+".png"
        } else if loggedInUser.signedInWith == "Google" {
            imageURLStrArr = loggedInUser.profileImageURL.componentsSeparatedByString("?sz=50")
            imageURLStr = (imageURLStrArr[0] as! String)
        } else {
            imageURLStr = loggedInUser.profileImageURL
        }
        if let url = NSURL(string: imageURLStr) {
            var request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                if let data = data {
                    if let image = UIImage(data: data) {
                        loggedInUser.profileImage = image
                    } else {
                        loggedInUser.profileImage = UIImage(named: "default"+loggedInUser.signedInWith+"ProfileImage.png")!
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        var x = frame.midX*UIScreen.mainScreen().bounds.size.width/414
        var y = frame.midY*UIScreen.mainScreen().bounds.size.height/736
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*UIScreen.mainScreen().bounds.size.width/736
        */
        var value = 70*UIScreen.mainScreen().bounds.size.width/414
        var circleHeight = 295*(UIScreen.mainScreen().bounds.size.height-49)/687
        
        openCircle = CircleView(frame: CGRectMake((width/5-value)/2, circleHeight, value, value),color:UIColor.redColor().CGColor)
        conscientiousnessCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5, circleHeight, value, value),color:UIColor.greenColor().CGColor)
        extraversionCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5*2, circleHeight, value, value),color:UIColor.blueColor().CGColor)
        agreeablenessCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5*3, circleHeight, value, value),color:UIColor.yellowColor().CGColor)
        emotionalRangeCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5*4, circleHeight, value, value),color:UIColor.orangeColor().CGColor)
        
        self.currentLocation.frame = CustomUISize().getNewFrameWidthHeight(self.currentLocation.frame)
        self.profileImage.frame = CustomUISize().getNewFrameWidthHeight(self.profileImage.frame)
        self.profileImage2.frame = CustomUISize().getNewFrameWidthHeight(self.profileImage2.frame)
        self.profileImage3.frame = CustomUISize().getNewFrameWidthHeight(self.profileImage3.frame)
        self.profileImage4.frame = CustomUISize().getNewFrameWidthHeight(self.profileImage4.frame)
        
        /*self.topTrait1.frame = CustomUISize().getNewFrame(self.topTrait1.frame)
        self.topTrait2.frame = CustomUISize().getNewFrame(self.topTrait2.frame)
        self.topTrait3.frame = CustomUISize().getNewFrame(self.topTrait3.frame)
        self.topTrait4.frame = CustomUISize().getNewFrame(self.topTrait4.frame)
        self.topTrait5.frame = CustomUISize().getNewFrame(self.topTrait5.frame)
        */
        self.pageControl.frame = CustomUISize().getNewFrameWidthHeight(self.pageControl.frame)
        
        self.personalityCarousel.frame = CustomUISize().getNewFrameWidthHeight(self.personalityCarousel.frame)
        
        self.bestTraits.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.bestTraits.frame)
        //self.emailCountLabel.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.emailCountLabel.frame)
        self.tweetCount.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.tweetCount.frame)
        self.profileBackgroundImage.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.profileBackgroundImage.frame)
        self.backgroundImage.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.backgroundImage.frame)
        self.visualEffect.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.visualEffect.frame)
        
        var newFontSize = UIScreen.mainScreen().bounds.size.width/414
        self.bestTraits.font = UIFont(name: "HelveticaNeue-Bold", size: self.bestTraits.font!.pointSize*newFontSize)
        self.bestTraits.textAlignment = .Center
        self.bestTraits.userInteractionEnabled = true
        self.bestTraits.editable = false
        backgroundImage.image = UIImage(named: "bg_1.jpg")
        //backgroundImage.image = UIImage(named: "sample_2.jpg")
        //backgroundImage.backgroundColor = UIColor(hexString: "#F5F5F5")
        //backgroundImage.image = self.imageToGreyImage(image)
        //backgroundImage.tintColor = UIColor.blackColor()

        if loggedInUser.isLoggedIn {
            navBar.topItem!.title = "Welcome " + loggedInUser.name
            //userName.text = "Welcome " + loggedInUser.name
            //userEmail.text = loggedInUser.email
            if let image = loggedInUser.profileImage as UIImage! {
                profileImage.image = image
            }
        }
        
        let imageSize = 70 as CGFloat
        profileImage.layer.borderWidth = 3
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        /*
        var container: UIView = UIView(frame: profileImage.frame)
        container.layer.shadowOffset = CGSizeMake(0, 0)
        container.layer.shadowOpacity = 0.8
        container.layer.shadowRadius = 10
        container.layer.shadowColor = UIColor.redColor().CGColor
        container.layer.shadowPath = UIBezierPath(roundedRect: profileImage.layer.bounds, cornerRadius: 10.0).CGPath
        container.layer.cornerRadius = profileImage.frame.height/2
        */
        //profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.cornerRadius = 75*UIScreen.mainScreen().bounds.size.width/414
        profileImage.layer.masksToBounds = true
        profileImage.userInteractionEnabled = true
        profileImage.multipleTouchEnabled = true
        profileImage.clipsToBounds = true
        
        /*
        profileImage.layer.shadowColor = UIColor.darkGrayColor().CGColor
        profileImage.layer.shadowPath = UIBezierPath(roundedRect: profileImage.layer.bounds, cornerRadius: 10.0).CGPath
        profileImage.layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
        profileImage.layer.shadowOpacity = 0.5
        profileImage.layer.shadowRadius = 10
        //profileImage.layer.cornerRadius = 10
        */
        
        //view2.addSubview(profileImage)
        //profileImage.release()
        
        var tapgesture = UITapGestureRecognizer(target: self, action: Selector("tap"))
        tapgesture.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tapgesture)
        
        profileImage2.layer.borderWidth = 1
        profileImage2.layer.masksToBounds = false
        profileImage2.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage2.layer.cornerRadius = 75*UIScreen.mainScreen().bounds.size.width/414
        profileImage2.clipsToBounds = true
        profileImage2.userInteractionEnabled = true
        profileImage2.multipleTouchEnabled = true
        profileImage2.hidden = true
        
        profileImage3.layer.borderWidth = 1
        profileImage3.layer.masksToBounds = false
        profileImage3.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage3.layer.cornerRadius = 75*UIScreen.mainScreen().bounds.size.width/414
        profileImage3.clipsToBounds = true
        profileImage3.userInteractionEnabled = true
        profileImage3.multipleTouchEnabled = true
        profileImage3.hidden = true
        
        profileImage4.layer.borderWidth = 1
        profileImage4.layer.masksToBounds = false
        profileImage4.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage4.layer.cornerRadius = 75*UIScreen.mainScreen().bounds.size.width/414
        profileImage4.clipsToBounds = true
        profileImage4.userInteractionEnabled = true
        profileImage4.multipleTouchEnabled = true
        profileImage4.hidden = true
        
        self.currentLocation.text = loggedInUser.location
        errorText = UITextView(frame:CGRect(x:0, y:self.view.bounds.height/2, width:self.view.bounds.width, height:200))
        errorText.backgroundColor = UIColor.clearColor()
        errorText.textAlignment = .Center
        errorText.font = UIFont.systemFontOfSize(15)
        errorText.textColor = UIColor.whiteColor()
        errorText.text = loggedInUser.personalityData.personalitySummary
        errorText.userInteractionEnabled = true
        errorText.editable = false
        errorText.hidden = true
        self.view.addSubview(errorText)
        
        //inviteButton = UIButton(frame:CGRect(x:self.view.bounds.width/2-50, y:self.view.bounds.height/2+100, width:100, height:100))
        //inviteButton.setTitle("Invite", forState: UIControlState.Normal)
        //inviteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //inviteButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        //inviteButton.tag = 1
        //inviteButton.hidden = true
        //self.view.addSubview(inviteButton)
        
        
        //self.personalitySummaryText.text = defaultPersonality
        //personalitySummaryText.backgroundColor = UIColor.clearColor()
        //personalitySummaryText.textColor = UIColor.whiteColor()
        //personalitySummaryText.userInteractionEnabled = true
        //personalitySummaryText.editable = false
        
        segments.layer.cornerRadius = 5.0  // Don't let background bleed
        segments.backgroundColor = UIColor.whiteColor()
        segments.tintColor = UIColor.redColor()
        segments.addTarget(self, action: "segmentTarget:", forControlEvents: .ValueChanged)

        personalityCarousel.type = .Linear
    }
    
    func segmentTarget(sender: UISegmentedControl) {
        print("Change color handler is called.")
        switch sender.selectedSegmentIndex {
        case 1:
            //self.view.backgroundColor = UIColor.greenColor()
            print("Green")
        case 2:
            //self.view.backgroundColor = UIColor.blueColor()
            print("Blue")
        default:
            //self.view.backgroundColor = UIColor.purpleColor()
            print("Purple")
        }
    }
    
    func callPersonalityAPI(){
        //print("CallPersonalityAPI")
        if self.emailAnalyzed {
            if self.errorOccurred {
                self.setPersonalityViewHidden(true)
                errorText.text = loggedInUser.personalityData.personalitySummary
                errorText.hidden = false
                //inviteButton.hidden = false
                self.shareButton.tintColor = UIColor.clearColor()
            } else {
                self.setPersonalityViewHidden(false)
            }
            //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
            //self.personalitySummaryText.hidden = false
        } else {
            let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
            if loggedInUser.analyzeOnWifiOnly == true && reachability.currentReachabilityStatus != .ReachableViaWiFi {
                var title = "Not Connected to Wi-fi"
                var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using current intenet connection?"
                var actionTitle1 = "Yes"
                var actionTitle2 = "No"
                
                var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                    loggedInUser.analyzeOnWifiOnly = false
                    self.analyzeEmailsNow()
                }))
                alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                    loggedInUser.analyzeOnWifiOnly = true
                    self.presentViewController(alert, animated: true, completion: nil)
                    loggedInUser.personalityData.personalitySummary = "Personality Analysis can not be done. Please change Analysis Wifi Only setting."
                    self.errorText.text = loggedInUser.personalityData.personalitySummary
                    self.errorText.hidden = false
                    self.shareButton.tintColor = UIColor.clearColor()
                    //self.inviteButton.hidden = false
                    //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
                    //self.personalitySummaryText.hidden = false
                    //switcher.setOn(true, animated: true)
                }))
            } else {
                self.analyzeEmailsNow()
            }
        }
    }
    
    func analyzeEmailsNow(){
        self.analyzeInProgress = true
        self.view.addSubview(analyzingEmails)
        
        currentContactEmail = loggedInUser.email
        GMailAPIHandler().getAllSentEmailsLastYear(loggedInUser, nextPageToken: "", queryString:"") { data, error in
            analyzingEmails.hide()
            self.emailAnalyzed = true
            self.pesonalityText = data!
            //print(data)
            ParseAPIHandler().saveUserInCloud()
            var _data = data as! String
            if _data.isEmpty {
                print(error)
                self.errorOccurred = true
                self.errorText.text = loggedInUser.personalityData.personalitySummary
                self.errorText.hidden = false
                self.shareButton.tintColor = UIColor.clearColor()
                //self.inviteButton.hidden = false
                
                //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
                //self.personalitySummaryText.hidden = false
            } else {
                //print(loggedInUser.personalityData.personalitySummary)
                self.updatePersonality()
                self.setPersonalityViewHidden(false)
            }
        }
    }
    
    func getAllContacts(){
        self.view.addSubview(retrievingContacts)
        
        if let hasContactsLoaded = userDefaults.objectForKey("hasContactsLoaded") as? Bool {
            if hasContactsLoaded {
                googleContacts.removeAll()
                if let totalContacts = userDefaults.objectForKey("totalContacts") as? Int {
                    //print(totalContacts)
                    var i = 0
                    for (i=0; i<totalContacts; i++) {
                        if let data = userDefaults.objectForKey("googleContacts[\(i)]") as? NSData {
                            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                            let contact = unarc.decodeObjectForKey("root") as! GoogleContact
                            googleContacts.append(contact)
                        }
                    }
                }
                retrievingContacts.hide()
                //print("All contacts loaded from NSSUserDefaults.")
            } else {
                //print("Loading contacts...")
                GoogleContactsAPIHandler().getAllGmailContacts() { data, error in
                    //print("All contacts loaded from Gmail.")
                    retrievingContacts.hide()
                }
                /*GPlusAPIHandler().getAllGPlusContacts() { data, error in
                print("All contacts loaded from google plus.")
                loadingProfile.hide()
                }*/
            }
        } else {
            //print("Loading contacts...")
            GoogleContactsAPIHandler().getAllGmailContacts() { data, error in
                //print("All contacts loaded from Gmail.")
                //print("calling Contacts Groups API now...")
                /*GoogleContactsAPIHandler().getAllGmailContactGroups(){  data, error in
                print(data)
                print("Called Contacts Groups API now...")
                }*/
                
                retrievingContacts.hide()
            }
            /*GPlusAPIHandler().getAllGPlusContacts() { data, error in
            print("All contacts loaded Google Plus.")
            loadingProfile.hide()
            }*/
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "imageFullscreen" {
            let destinationVC = segue.destinationViewController as! ImageFullscreenViewController
            //destinationVC.imageLocal = profileImage.image
            destinationVC.name = loggedInUser.name
            destinationVC.noOfImages = loggedInUser.images.count+1
            destinationVC.contact = loggedInUser
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap(){
        self.performSegueWithIdentifier("imageFullscreen", sender: self)
    }
    
    func tapOnTopTraits(){
        //print("tapOnTopTraits")
        let contentView = UIView(frame: CGRectMake(0, 0, 300, 250))
        
        // create the title label
        let titleLabel = UILabel(frame: CGRectMake(0, 6, 300, 30))
        titleLabel.text = "Personality Traits"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        contentView.addSubview(titleLabel)
        
        // create the detail label
        let detailLabel = UILabel(frame: CGRectMake(10, 30, 280, 214))
        detailLabel.text = loggedInUser.personalityData.personalityTraits
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .ByWordWrapping
        detailLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        
        contentView.addSubview(detailLabel)
        contentView.backgroundColor = UIColor.lightGrayColor()
        let popupView = MVPopupView(frame: self.view.frame, contentView: contentView, offsetY: 200)
        
        //SCLAlertView().showInfo("Personality Traits", subTitle: loggedInUser.personalityData.personalityTraits, closeButtonTitle: "OK")
        
        //self.view.addSubview(popupView)
    }
    
    func cleanUpData() {
        loggedInUser.isLoggedIn = false
        loggedInUser = GoogleContact()
        googleContacts.removeAll()
        //globalGoogleContactsFinal.removeAll()
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func showError(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setPersonalityViewHidden(flag: Bool){
        self.openCircle.hidden = flag
        self.conscientiousnessCircle.hidden = flag
        self.agreeablenessCircle.hidden = flag
        self.extraversionCircle.hidden = flag
        self.emotionalRangeCircle.hidden = flag
        
        self.bestTraits.hidden = flag
        //self.personalitySummaryText.hidden = flag
        /*
        self.topTrait1.hidden = flag
        self.topTrait2.hidden = flag
        self.topTrait3.hidden = flag
        self.topTrait4.hidden = flag
        self.topTrait5.hidden = flag*/
        self.personalityCarousel.hidden = flag
        self.pageControl.hidden = flag
        
    }
    
    func addCircleView() {
        /*var needValue = loggedInUser.personalityData.needs!.needValue
        needCircle.updateLabelInside(Int(needValue),name: loggedInUser.personalityData.needs!.needKey)
        needCircle.updateEndAngle(Int(needValue))
        view.addSubview(needCircle)
        needCircle.animateCircle(1.0)
        
        var valueValue = loggedInUser.personalityData.values!.valueValue
        valueCircle.updateLabelInside(Int(valueValue), name: loggedInUser.personalityData.values!.valueKey)
        valueCircle.updateEndAngle(Int(valueValue))
        view.addSubview(valueCircle)
        valueCircle.animateCircle(1.0)
        */
        var opennessValue = loggedInUser.personalityData.traits!.openness!.opennessValue
        openCircle.updateLabelInside(Int(opennessValue),name: "Open")
        openCircle.updateEndAngle(Int(opennessValue))
        //view.addSubview(openCircle)
        openCircle.animateCircle(1.0)
        
        var agreeablenessValue = loggedInUser.personalityData.traits!.agreeableness!.agreeablenessValue
        agreeablenessCircle.updateLabelInside(Int(agreeablenessValue), name: "Agreeable")
        agreeablenessCircle.updateEndAngle(Int(agreeablenessValue))
        //view.addSubview(agreeablenessCircle)
        agreeablenessCircle.animateCircle(1.0)
        
        var conscientiousnessValue = loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessValue
        conscientiousnessCircle.updateLabelInside(Int(conscientiousnessValue),name: "Conscientious")
        conscientiousnessCircle.updateEndAngle(Int(conscientiousnessValue))
        //view.addSubview(conscientiousnessCircle)
        conscientiousnessCircle.animateCircle(1.0)
        
        var extraversionValue = loggedInUser.personalityData.traits!.extraversion!.extraversionValue
        extraversionCircle.updateLabelInside(Int(extraversionValue),name: "Extroverted")
        extraversionCircle.updateEndAngle(Int(extraversionValue))
        //view.addSubview(extraversionCircle)
        extraversionCircle.animateCircle(1.0)
        
        var emotionalRangeValue = loggedInUser.personalityData.traits!.neuroticism!.neuroticismValue
        emotionalRangeCircle.updateLabelInside(Int(emotionalRangeValue),name: "Emotional")
        emotionalRangeCircle.updateEndAngle(Int(emotionalRangeValue))
        //view.addSubview(emotionalRangeCircle)
        emotionalRangeCircle.animateCircle(1.0)
    }
    
    func updatePersonality(){
        //self.personalitySummaryText.text = loggedInUser.personalityData.personalitySummary
        self.topFacetsArray = ContactDetailsViewController().getTopFacetsValues(loggedInUser)
        self.topNeedsArray = ContactDetailsViewController().getTopNeedsValues(loggedInUser)
        self.topValuesArray = ContactDetailsViewController().getTopValuesValues(loggedInUser)
        
        loggedInUser.getFamilyOrientedScore(loggedInUser)
        
        loggedInUser.getAnalyticalThiningkStyle(loggedInUser)
        loggedInUser.getIndependent(loggedInUser)
        loggedInUser.getHappinessScore(loggedInUser)
        loggedInUser.getCarreerPerformanceScore2(loggedInUser)
        loggedInUser.getCreativityScore(loggedInUser)
        loggedInUser.getInnovationScore(loggedInUser)
        loggedInUser.getPersonalRelationshipScore(loggedInUser)
        //loggedInUser.getThiningkStyle(loggedInUser)
        loggedInUser.getAcademicPerformanceScore(loggedInUser)
        loggedInUser.getIntelligenceQuotientScore(loggedInUser)
        loggedInUser.getEmotionalQuotientScore(loggedInUser)
        loggedInUser.getFriendlinessScore(loggedInUser)
        loggedInUser.personalityData.trustScore = String(Int(loggedInUser.personalityData.traits!.agreeableness!.trust))
        loggedInUser.personalityData.strengths = loggedInUser.getStrengths(self.topFacetsArray)
        
        var array = loggedInUser.personalityData.personalityTraits.componentsSeparatedByString(",")
        
        switch loggedInUser.signedInWith {
        case "Google" :
            self.bestTraits.text = ""
        case "Facebook" :
            self.bestTraits.text = ""
        case "Twitter" :
            self.bestTraits.text = loggedInUser.twitterDescription
            self.tweetCount.text = "Analysis based on last " + String(loggedInUser.twitterTotalTweets) + " tweets"
        default:
            print("signed with something else")
        }
        
        //self.bestTraits.text = loggedInUser.personalityData.strengths[0]+" • "+loggedInUser.personalityData.strengths[1]+" • "+loggedInUser.personalityData.strengths[2]+" • "+loggedInUser.personalityData.strengths[3]+" • "+loggedInUser.personalityData.strengths[4]
        //self.emailCountLabel.text = "Based on "+String(self.contact.emailCount)+" emails sent to you"
        self.currentLocation.text = loggedInUser.location
        self.personalityCarousel.reloadData()
        self.addCircleView()
    }
    
    func updatePersonalityForFacebook (json: JSON){
        
        //relationship["status"] = ""
        //relationship["value"] = ""
        
        for (index, trait):(String, JSON) in json["predictions"] {
            //print(trait["value"])
            var value = trait["value"].doubleValue
            
            switch trait["trait"] {
            case "BIG5_Openness" :
                loggedInUser.personalityData.traits!.openness!.opennessValue = value*100
            case "BIG5_Conscientiousness":
                loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessValue = value*100
            case "BIG5_Extraversion":
                loggedInUser.personalityData.traits!.extraversion!.extraversionValue = value*100
            case "BIG5_Agreeableness":
                loggedInUser.personalityData.traits!.agreeableness!.agreeablenessValue = value*100
            case "BIG5_Neuroticism":
                loggedInUser.personalityData.traits!.neuroticism!.neuroticismValue = value*100
            case "Age":
                //print(value)
                var predictedAge = (String(value) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
                //print("predicted age")
                //print(predictedAge)
                if loggedInUser.age != "" {
                    if Double(loggedInUser.age) > Double(predictedAge) {
                        loggedInUser.personalityData.feelByAge = String(Int(loggedInUser.age)!-Int(predictedAge)!) + " years Younger"
                    } else if Double(loggedInUser.age) < Double(predictedAge) {
                        loggedInUser.personalityData.feelByAge = String(Int(predictedAge)!-Int(loggedInUser.age)!) + " years Older"
                    } else {
                        loggedInUser.personalityData.feelByAge = "Same as actual age"
                    }
                } else {
                    loggedInUser.personalityData.feelByAge = predictedAge + " years old"
                }

                break
            case "Female":
                break
            case "Gay":
                break
            case "Lesbian":
                break
            //religion
            case "Religion_None":
                self.updateReligionStatus("None", value: value)
            case "Religion_Jewish":
                self.updateReligionStatus("Jewish", value: value)
            case "Religion_Catholic":
                self.updateReligionStatus("Catholic", value: value)
            case "Religion_Christian_Other":
                self.updateReligionStatus("Christian_Other", value: value)
            case "Religion_Mormon":
                self.updateReligionStatus("Mormon", value: value)
            case "Religion_Lutheran":
                self.updateReligionStatus("Lutheran", value: value)
                
            //concentration
            case "Concentration_Journalism":
                self.updateConcentrationStatus("Journalism", value: value)
            case "Concentration_Art":
                self.updateConcentrationStatus("Art", value: value)
            case "Concentration_Biology":
                self.updateConcentrationStatus("Biology", value: value)
            case "Concentration_Law":
                self.updateConcentrationStatus("Law", value: value)
            case "Concentration_Nursing":
                self.updateConcentrationStatus("Nursing", value: value)
            case "Concentration_History":
                self.updateConcentrationStatus("History", value: value)
            case "Concentration_Education":
                self.updateConcentrationStatus("Education", value: value)
            case "Concentration_Business":
                self.updateConcentrationStatus("Business", value: value)
            case "Concentration_IT":
                self.updateConcentrationStatus("Information Technology", value: value)
            case "Concentration_Engineering":
                self.updateConcentrationStatus("Engineering", value: value)
            case "Concentration_Finance":
                self.updateConcentrationStatus("Finance", value: value)
            case "Concentration_Psychology":
                self.updateConcentrationStatus("Psychology", value: value)
                
            //relationship
            case "Relationship_None":
                 self.updateRelationshipStatus("None", value: value)
            case "Relationship_Yes":
                 self.updateRelationshipStatus("Yes", value: value)
            case "Relationship_Married":
                self.updateRelationshipStatus("Married", value: value)
            
            //politics
            case "Politics_Uninvolved":
                self.updatePoliticsStatus("Uninvolved", value: value)
            case "Politics_Libertanian":
                self.updatePoliticsStatus("Libertanian", value: value)
            case "Politics_Liberal":
                self.updatePoliticsStatus("Liberal", value: value)
            case "Politics_Conservative":
                self.updatePoliticsStatus("Conservative", value: value)
                
            case "Satisfaction_Life":
                
                var lifeSatisfaction = (String(value*100.00) as NSString).substringWithRange(NSRange(location: 0, length: 2))
                //print("life satidfacrtion")
                //print(Int(lifeSatisfaction)!*35/100)
                switch (Int(lifeSatisfaction)!*35/100) {
                case 29..<35:
                    loggedInUser.personalityData.lifeSatisfaction = "Mostly Very Happy"
                case 22..<29:
                    loggedInUser.personalityData.lifeSatisfaction = "Always Happy"
                case 16..<22:
                    loggedInUser.personalityData.lifeSatisfaction = "Just Happy"
                case 13..<16:
                    loggedInUser.personalityData.lifeSatisfaction = "Slightly Happy"
                case 9..<13:
                    loggedInUser.personalityData.lifeSatisfaction = "Neither Happy or Sad"
                case 4..<9:
                    loggedInUser.personalityData.lifeSatisfaction = "Slightly Unhappy"
                case 2..<4:
                    loggedInUser.personalityData.lifeSatisfaction = "Extremely Unhappy"
                default:
                    loggedInUser.personalityData.lifeSatisfaction = "Very Extremely Unhappy"
                }
            case "Intelligence":
                var intelligenceQuotient = ""
                if value <= 0.16 {
                    intelligenceQuotient = (String(85-(16-value*100)*30/16) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
                } else if value >= 0.84{
                    intelligenceQuotient  = (String((value*100-84)*30/16+115.00) as! NSString).substringWithRange(NSRange(location: 0, length: 3))
                } else if value >= 0.5 {
                    intelligenceQuotient  = (String((value*100-50)*15/34+100.00) as! NSString).substringWithRange(NSRange(location: 0, length: 3))
                } else {
                    intelligenceQuotient  = (String((value*100-16)*15/34+85.00) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
                }
                switch (Int(intelligenceQuotient)!) {
                case 144..<200:
                     loggedInUser.personalityData.intelligenceQuotient = "Genius"
                case 130..<144:
                     loggedInUser.personalityData.intelligenceQuotient = "Gifted"
                case 115..<130:
                    loggedInUser.personalityData.intelligenceQuotient = "High Intelligent"
                case 100..<115:
                    loggedInUser.personalityData.intelligenceQuotient = "Above Average Intelligent"
                case 85..<100:
                    loggedInUser.personalityData.intelligenceQuotient = "Average Intelligent"
                case 70..<85:
                    loggedInUser.personalityData.intelligenceQuotient = "Below Average"
                case 55..<70:
                    loggedInUser.personalityData.intelligenceQuotient = "Challenged"
                default:
                    loggedInUser.personalityData.intelligenceQuotient = "Severly Challenged"
                }
            default:
                break
            }
        }
        //print(politics["status"])
        //print(concentration["status"])
        //print(relationship["status"])
        //print(religion["status"])
        loggedInUser.personalityData.careerArea = concentration["status"]!
        
        //loggedInUser.getHappinessScore(loggedInUser)
        //loggedInUser.getCarreerPerformanceScore2(loggedInUser)
        loggedInUser.getCreativityScore(loggedInUser)
        loggedInUser.getInnovationScore(loggedInUser)
        loggedInUser.getPersonalRelationshipScore(loggedInUser)
        //loggedInUser.getThiningkStyle(loggedInUser)
        loggedInUser.getAcademicPerformanceScore(loggedInUser)
        //loggedInUser.getIntelligenceQuotientScore(loggedInUser)
        loggedInUser.getEmotionalQuotientScore(loggedInUser)
        loggedInUser.getFriendlinessScore(loggedInUser)
        //loggedInUser.personalityData.trustScore = String(Int(loggedInUser.personalityData.traits!.agreeableness!.trust))
        //loggedInUser.personalityData.strengths = loggedInUser.getStrengths(self.topFacetsArray)
        
        var array = loggedInUser.personalityData.personalityTraits.componentsSeparatedByString(",")
        /*self.bestTraits.text = loggedInUser.personalityData.strengths[0]+" • "+loggedInUser.personalityData.strengths[1]+" • "+loggedInUser.personalityData.strengths[2]+" • "+loggedInUser.personalityData.strengths[3]+" • "+loggedInUser.personalityData.strengths[4]
        //self.emailCountLabel.text = "Based on "+String(self.contact.emailCount)+" emails sent to you"
        */
        loggedInUser.personalityData.personalityAnalyzed = true
        self.personalityCarousel.reloadData()
        self.addCircleView()
    }
    
    func updateRelationshipStatus(name: String, value: Double){
        if !relationship["status"]!.isEmpty {
            if value > Double(relationship["value"]!) {
                relationship["status"]! = name
                relationship["value"]! = String(value)
            }
        } else {
            relationship["status"] = name
            relationship["value"] = String(value)
        }
    }
    
    func updatePoliticsStatus(name: String, value: Double){
        if !politics["status"]!.isEmpty {
            if value > Double(politics["value"]!) {
                politics["status"]! = name
                politics["value"]! = String(value)
            }
        } else {
            politics["status"] = name
            politics["value"] = String(value)
        }
    }
    
    func updateConcentrationStatus(name: String, value: Double){
        if !concentration["status"]!.isEmpty {
            if value > Double(concentration["value"]!) {
                concentration["status"]! = name
                concentration["value"]! = String(value)
            }
        } else {
            concentration["status"] = name
            concentration["value"] = String(value)
        }
    }
    
    func updateReligionStatus(name: String, value: Double){
        if !religion["status"]!.isEmpty {
            if value > Double(religion["value"]!) {
                religion["status"]! = name
                religion["value"]! = String(value)
            }
        } else {
            religion["status"] = name
            religion["value"] = String(value)
        }
    }
    
    func getProfileBackgroundImage(signedInWith:String, imageURLString: String){
        print("getProfileBackgroundImage")
        if imageURLString != "" {
            if let url = NSURL(string: imageURLString) {
                print("imageURLStr")
                print(url)
                var request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                    if let image = UIImage(data: data!) {
                        print("UIImage")
                        loggedInUser.backgroundImage = image
                        //self.profileBackgroundImage.image = image
                        self.profileBackgroundImage.image = loggedInUser.profileImage
                    }
                }
            }
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>,  withEvent event: UIEvent?) {
        if let touch = touches.first as UITouch! {
            if loggedInUser.signedInWith == "Google" || loggedInUser.signedInWith == "Twitter"{
                if let circle = touch.view as? CircleView {
                    popUpOpen = true
                    if circle.frame.contains(self.openCircle.frame) {
                        var circleNameValues = [["Adventure":loggedInUser.personalityData.traits?.openness?.adventurousness],
                            ["Artistic":loggedInUser.personalityData.traits?.openness?.artisticInterests],
                            ["Emotional":loggedInUser.personalityData.traits?.openness?.emotionality],
                            ["Imagination":loggedInUser.personalityData.traits?.openness?.imagination],
                            ["Intellect":loggedInUser.personalityData.traits?.openness?.intellect],
                            ["Authority":loggedInUser.personalityData.traits?.openness?.liberalism]
                        ]
                        var message = "Openness is a general appreciation for art, emotion, adventure, unusual ideas, imagination, curiosity, and variety of experience. People who are open to experience are intellectually curious, open to emotion, sensitive to beauty and willing to try new things. They tend to be, when compared to closed people, more creative and more aware of their feelings. They are also more likely to hold unconventional beliefs."
                        
                        let modelName = UIDevice.currentDevice().modelName
                        switch modelName {
                        case "iPhone 6s Plus", "iPhone 6s":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        case "iPhone 6", "iPhone 6 Plus":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                        default:
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, backgroundColor: "#F98A5F",withImage: UIImage(named: "Idea-100.png"), title: "Openness", withMessage: message, circleNameValues: circleNameValues,animated: true)
                        //self.performSegueWithIdentifier("showView", sender: self.openCircle)//EB7260
                    }
                    if circle.frame.contains(self.conscientiousnessCircle.frame) {
                        var circleNameValues = [["Achievement":loggedInUser.personalityData.traits?.conscientiousness?.achievementStriving],
                            ["Cautious":loggedInUser.personalityData.traits?.conscientiousness?.cautiousness],
                            ["Dutiful":loggedInUser.personalityData.traits?.conscientiousness?.dutifulness],
                            ["Orderly":loggedInUser.personalityData.traits?.conscientiousness?.orderliness],
                            ["Discipline":loggedInUser.personalityData.traits?.conscientiousness?.selfDiscipline],
                            ["Efficacy":loggedInUser.personalityData.traits?.conscientiousness?.selfEfficacy]
                        ]
                        var message = "Conscientiousness is a tendency to show self-discipline, act dutifully, and aim for achievement against measures or outside expectations. It is related to the way in which people control, regulate, and direct their impulses. High scores on conscientiousness indicate a preference for planned rather than spontaneous behavior. The average level of conscientiousness rises among young adults and then declines among older adults."
                        let modelName = UIDevice.currentDevice().modelName
                        switch modelName {
                        case "iPhone 6s Plus", "iPhone 6s":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        case "iPhone 6", "iPhone 6 Plus":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                        default:
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, backgroundColor: "#77BA9B", withImage: UIImage(named: "Medal Filled-100.png"), title: "Conscientiuosness", withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                    if circle.frame.contains(self.extraversionCircle.frame) {
                        var circleNameValues = [["Activity":loggedInUser.personalityData.traits?.extraversion?.activityLevel],
                            ["Assertive":loggedInUser.personalityData.traits?.extraversion?.assertiveness],
                            ["Cheerful":loggedInUser.personalityData.traits?.extraversion?.cheerfulness],
                            ["Excitement":loggedInUser.personalityData.traits?.extraversion?.excitementSeeking],
                            ["Friendly":loggedInUser.personalityData.traits?.extraversion?.friendliness],
                            ["Gregarious":loggedInUser.personalityData.traits?.extraversion?.gregariousness]
                        ]
                        var message = "Extroversion is characterized by breadth of activities (as opposed to depth), surgency from external activity/situations, and energy creation from external means. The trait is marked by pronounced engagement with the external world. Extroverts enjoy interacting with people, and are often perceived as full of energy. They tend to be enthusiastic, action-oriented individuals. They possess high group visibility, like to talk, and assert themselves."
                        let modelName = UIDevice.currentDevice().modelName
                        switch modelName {
                        case "iPhone 6s Plus", "iPhone 6s":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        case "iPhone 6", "iPhone 6 Plus":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                        default:
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, backgroundColor: "#4A96AD", withImage: UIImage(named: "Talk-100.png"), title: "Extroversion",withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                    if circle.frame.contains(self.agreeablenessCircle.frame) {
                        var circleNameValues = [["Altruism":loggedInUser.personalityData.traits?.agreeableness?.altruism],
                            ["Cooperation":loggedInUser.personalityData.traits?.agreeableness?.cooperation],
                            ["Modesty":loggedInUser.personalityData.traits?.agreeableness?.modesty],
                            ["Morality":loggedInUser.personalityData.traits?.agreeableness?.morality],
                            ["Sympathy":loggedInUser.personalityData.traits?.agreeableness?.sympathy],
                            ["Trust":loggedInUser.personalityData.traits?.agreeableness?.trust]
                        ]
                        var message = "The agreeableness trait reflects individual differences in general concern for social harmony. Agreeable individuals value getting along with others. They are generally considerate, kind, generous, trusting and trustworthy, helpful, and willing to compromise their interests with others. Agreeable people also have an optimistic view of human nature."
                        let modelName = UIDevice.currentDevice().modelName
                        switch modelName {
                        case "iPhone 6s Plus", "iPhone 6s":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        case "iPhone 6", "iPhone 6 Plus":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                        default:
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, backgroundColor: "#BFAF80", withImage: UIImage(named: "Handshake-100.png"), title: "Agreeableness", withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                    if circle.frame.contains(self.emotionalRangeCircle.frame) {
                        var circleNameValues = [["Anger":loggedInUser.personalityData.traits?.neuroticism?.anger],
                            ["Anxiety":loggedInUser.personalityData.traits?.neuroticism?.anxiety],
                            ["Depression":loggedInUser.personalityData.traits?.neuroticism?.depression],
                            ["Excesive":loggedInUser.personalityData.traits?.neuroticism?.immoderation],
                            ["Conscious":loggedInUser.personalityData.traits?.neuroticism?.selfConsciousness],
                            ["Vulnerable":loggedInUser.personalityData.traits?.neuroticism?.vulnerability]
                        ]
                        var message = "Neuroticism is the tendency to experience negative emotions, such as anger, anxiety, or depression. It is sometimes called emotional instability, or is reversed and referred to as emotional stability. According to Eysenck's theory of personality, neuroticism is interlinked with low tolerance for stress or aversive stimuli. Those who score high in neuroticism are emotionally reactive and vulnerable to stress."
                        let modelName = UIDevice.currentDevice().modelName
                        switch modelName {
                        case "iPhone 6s Plus", "iPhone 6s":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        case "iPhone 6", "iPhone 6 Plus":
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                        default:
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, backgroundColor: "#6A8D9D", withImage: UIImage(named: "emotional.png"), title: "Emotional Range", withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                }
            }
        }
        //super.touchesBegan(touches , withEvent:event)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)
    }
    // MARK: UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        var path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        if loggedInUser.signedInWith == "Google" || loggedInUser.signedInWith == "Twitter" {
            return 13
        } else {
            return 10
        }
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        return ContactDetailsViewController().populatePersonalityCarousalView (loggedInUser, carousel: carousel, path:"HOME", index: index)
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        carousel.bounces = false
        carousel.pagingEnabled = true
        
        if (option == .Spacing) {
            return value * 1.2
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    func drawCustomImage(size: CGSize) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 3.0)
        
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        //CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        //CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    
    /*
    func callMSFaceAPI(){
    print("calling MS FaceAPI")
    var imageUrl = "https://www.google.com/m8/feeds/photos/media/default/\(loggedInUser.id)?access_token=\(loggedInUser.accessToken)"
    MSFaceAPI().invokeAPI(imageUrl) { data, error in
    loggedInUser.age = data
    }
    }
    */
    func callFullContactAPI(){
        //print("callFullContactAPI")
        FullContactAPI().getAllDetails(loggedInUser) { data, error in
            //print("Contact is loaded with all details")
            //self.twitterAccount()
            //self.googlePlusAccount()
            //self.KloutAccount()
            //print(loggedInUser.images.count)
            for (var i = 0; i < loggedInUser.images.count; i++) {
                if i == 0 {
                    self.profileImage2.image = loggedInUser.images[0]
                    self.profileImage2.hidden = false
                }
                if i == 1 {
                    self.profileImage3.image = loggedInUser.images[1]
                    self.profileImage3.hidden = false
                }
                if i == 2 {
                    self.profileImage4.image = loggedInUser.images[2]
                    self.profileImage4.hidden = false
                }
            }
        }
    }
    /*
    func twitterAccount(){
    print("twitterAccount")
    for profile in loggedInUser.socialProfiles {
    if (profile.type == "twitter") {
    var id = profile.id
    var name = profile.username
    var tweetsText  = ""
    TwitterAPIHandler().getTweets(id, screen_name: name){ data, error in
    if error != nil {
    print(error)
    } else {
    print("error is null")
    }
    if data != nil {
    //print(data)
    let json = JSON(data!)
    for (index,tweet):(String, JSON) in json {
    print(tweet["text"])
    tweetsText = tweetsText + " " + tweet["text"].stringValue
    }
    } else {
    print("data is null")
    }
    print("All Tweets")
    print(tweetsText)
    print("All Tweets")
    
    }
    }
    }
    }
    
    func googlePlusAccount(){
    func twitterAccount(){
    for profile in loggedInUser.socialProfiles {
    if (profile.type == "googleplus") {
    var id = profile.id
    var name = profile.username
    var url = profile.url
    }
    }
    }
    }
    
    func KloutAccount(){
    for profile in loggedInUser.socialProfiles {
    if (profile.type == "twitter") {
    var id = profile.id
    var name = profile.username
    if loggedInUser.popularityScore.isEmpty {
    KloutAPIHandler().getKloutScoreByTwitter(id) { data, error in
    let json = JSON(data!)
    loggedInUser.popularityScore = (json["score"].stringValue as NSString).substringWithRange(NSRange(location: 0, length: 2))
    }
    }
    }
    
    if (profile.type == "googleplus") {
    var id = profile.id
    if loggedInUser.popularityScore.isEmpty {
    KloutAPIHandler().getKloutScoreByGoogle(id) { data, error in
    let json = JSON(data!)
    if (json["score"].stringValue > loggedInUser.popularityScore) {
    loggedInUser.popularityScore = (json["score"].stringValue as NSString).substringWithRange(NSRange(location: 0, length: 2))
    }
    }
    }
    }
    }
    }
    */
    /*
    func imageToGreyImage(image: UIImage) -> UIImage {
    
    // Create image rectangle with current image width/height
    var actualWidth = image.size.width;
    var actualHeight = image.size.height;
    
    var imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    var colorSpace = CGColorSpaceCreateDeviceGray();
    
    //var bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
    
    var context = CGBitmapContextCreate(nil, Int(actualWidth), Int(actualHeight), 8, 0, colorSpace, 0);
    CGContextDrawImage(context, imageRect, image.CGImage);
    
    var grayImage = CGBitmapContextCreateImage(context);
    //bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.Only.rawValue)
    context = CGBitmapContextCreate(nil, Int(actualWidth), Int(actualHeight), 8, 0, nil, 0);
    CGContextDrawImage(context, imageRect, image.CGImage);
    var mask = CGBitmapContextCreateImage(context);
    
    var grayScaleImage = UIImage(CGImage: CGImageCreateWithMask(grayImage, mask)!, scale: image.scale, orientation: image.imageOrientation)
    
    // Return the new grayscale image
    return grayScaleImage
    }*/
    /*
    func imageToGreyImage(image: UIImage) -> UIImage {
    var actualWidth: CGFloat = image.size.width
    var actualHeight: CGFloat = image.size.height
    
    var imageRect: CGRect = CGRectMake(0, 0, actualWidth, actualHeight)
    var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
    var context: CGContextRef = CGBitmapContextCreate(nil, Int(actualWidth), Int(actualHeight), 8, 0, colorSpace, 0)!
    CGContextDrawImage(context, imageRect, image.CGImage)
    var grayImage: CGImageRef = CGBitmapContextCreateImage(context)!
    //CGColorSpaceRelease(colorSpace)
    //CGContextRelease(context)
    context = CGBitmapContextCreate(nil, Int(actualWidth), Int(actualHeight), 8, 0, nil, 0)!
    CGContextDrawImage(context, imageRect, image.CGImage)
    var mask: CGImageRef = CGBitmapContextCreateImage(context)!
    //CGContextRelease(context)
    //var grayScaleImage: UIImage = UIImage.CGImageCreateWithMask(CGImageCreateWithMask(grayImage, mask)!, scale: image.scale, orientation: image.imageOrientation)
    //CGImageRelease(grayImage)
    //CGImageRelease(mask)
    return grayScaleImage
    
    }*/
    /*
    func convertImageToGrayScale(image: UIImage) -> UIImage {
    var imageRect: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
    var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()
    var context: CGContextRef = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, 0)
    CGContextDrawImage(context, imageRect, image.CGImage())
    var imageRef: CGImageRef = CGBitmapContextCreateImage(context)
    var newImage: UIImage = UIImage.imageWithCGImage(imageRef)
    CGColorSpaceRelease(colorSpace)
    CGContextRelease(context)
    CFRelease(imageRef)
    return newImage
    }
    */
}