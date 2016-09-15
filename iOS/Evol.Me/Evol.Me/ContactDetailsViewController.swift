//
//  File.swift
//  Evol.Me
//
//  Created by Paul.Raj on 5/9/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate, iCarouselDataSource, iCarouselDelegate {
    
    let width = UIScreen.mainScreen().bounds.width
    
    //var screenWidth = screenC.size.width
    var openCircle = CircleView(frame: CGRectMake(3, 245, CGFloat(60), CGFloat(60)),color:UIColor.brownColor().CGColor)
    var conscientiousnessCircle = CircleView(frame: CGRectMake(67, 245, CGFloat(60), CGFloat(60)),color:UIColor.blueColor().CGColor)
    var extraversionCircle = CircleView(frame: CGRectMake(131, 245, CGFloat(60), CGFloat(60)),color:UIColor.greenColor().CGColor)
    var agreeablenessCircle = CircleView(frame: CGRectMake(194, 245, CGFloat(60), CGFloat(60)),color:UIColor.yellowColor().CGColor)
    var emotionalRangeCircle = CircleView(frame: CGRectMake(257, 245, CGFloat(60), CGFloat(60)),color:UIColor.redColor().CGColor)
    
    var needCircle = CircleView(frame: CGRectMake(100, 210, CGFloat(61), CGFloat(61)),color:UIColor.blueColor().CGColor)
    var valueCircle = CircleView(frame: CGRectMake(160, 210, CGFloat(61), CGFloat(61)),color:UIColor.yellowColor().CGColor)
    
    var lineLayer = CALayer()
    
    var errorText = UITextView()
    var inviteButton = UIButton()
    var checkButton = TKAnimatedCheckButton()
    
    //let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    
    var contact = GoogleContact()
    var _userName = ""
    var _userEmail = ""
    var _userImage = UIImage()
    var _userPhoneNumber = ""
    var _userDob = ""
    var _emailsSent = ""
    var _userLocation = ""
    var _lastEmailed = ""
    var index = 0
    
    var analysisAccuracy = 1
    var wordsToAnalyze = 0
    var topFacetsArray = [Dictionary<String, Any>]()
    var topNeedsArray = [Dictionary<String, Any>]()
    var topValuesArray = [Dictionary<String, Any>]()
    
    var relationship : [String: String] = ["status":"","value":""]
    var religion : [String: String] = ["status":"","value":""]
    var politics : [String: String] = ["status":"","value":""]
    var concentration : [String: String] = ["status":"","value":""]
    
    var noOfImages = 1
    
    var fullContactAPICalled = false
    
    let mailComposer = MailComposer()
    
    var popViewController : PopUpViewControllerSwift!
    
    //var personalitySummary = ""
    var emailAnalyzed: Bool = false
    var errorOccurred: Bool = false
    var analyzeInProgress: Bool = false
    
    /*var defaultPersonality = "Big Five:\n You are eager to experience new things. You are less concerned with artistic or creative activities than most people. You do not frequently think about or openly express your emotions. You have a wild imagination. You are open to and intrigued by new ideas and love to explore them. You prefer to challenge authority and traditional values to help bring about change. You set high goals for yourself and work hard to achieve them. You carefully think through decisions before making them. You do what you want, disregarding rules and obligations. You do not make a lot of time for organization in your daily life. You appreciate a relaxed pace in life. You prefer to listen than to talk, especially in group settings. You are generally serious and do not joke much. You prefer activities that are quiet, calm, and safe. You are a private person and do not let many people in. You have a strong desire to have time to yourself. You are more concerned with taking care of yourself than taking time for others. You do not shy away from contradicting others. You hold yourself in high regard and are satisfied with who you are. You are comfortable using every trick in the book to get what you want. You think people should generally rely more on themselves than on others. You are wary of other people's intentions and do not trust easily. It takes a lot to get you angry. You tend to feel calm and self-assured. You are generally comfortable with yourself as you are. You have control over your desires, which are not particularly intense. You are hard to embarrass and are self-confident most of the time. You handle unexpected events calmly and effectively.\n\nNeeds:\n\nValues:\nYou seek personal success for themselves.\n\n\nTwo Dimension:\nHelpful, cooperative, considerate, respectful, polite. Soft-hearted, agreeable, obliging, humble, lenient. Generous, pleasant, tolerant, peaceful, flexible. Dependent, simple. Cautious, confident, punctual, formal, thrifty. Thorough, steady, consistent, self-disciplined, logical. Traditional, conventional. Tranquil, sedate, placid, impartial, unassuming. Somber, meek, unadventurous, passive, apathetic. Imperturbable, insensitive."
    */
    
    //@IBOutlet weak var personalitySummaryText: UITextView!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var profileImage3: UIImageView!
    @IBOutlet weak var profileImage4: UIImageView!
    
    /*@IBOutlet weak var topTrait1: UIImageView!
    @IBOutlet weak var topTrait2: UIImageView!
    @IBOutlet weak var topTrait3: UIImageView!
    @IBOutlet weak var topTrait4: UIImageView!
    @IBOutlet weak var topTrait5: UIImageView!
    */
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var personalityCarousel: iCarousel!
    
    //@IBOutlet weak var matchMeButton: UIButton!
    //@IBOutlet weak var MatchLabel: UILabel!
    
    @IBOutlet weak var topTraits: UILabel!
    @IBOutlet weak var tweetCount: UILabel!
    
    @IBOutlet weak var bestTraits: UITextView!
    //@IBOutlet weak var emailCountLabel: UILabel!
    
    //@IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareButtonClicked(sender: UIBarButtonItem) {
        
        var academic = ""
        if Int(self.contact.personalityData.academicPerformance) > 90 {
            academic = "A+"
        } else if Int(self.contact.personalityData.academicPerformance) > 80 {
            academic = "A"
        } else if Int(self.contact.personalityData.academicPerformance) > 70 {
            academic = "B+"
        } else if Int(self.contact.personalityData.academicPerformance) > 60 {
            academic = "B"
        } else {
            academic = "C"
        }
        
        //self.contact.personalityData.intelligenceQuotient = String(Int(self.contact.personalityData.traits!.openness!.intellect))
        //self.contact.personalityData.emotionalQuotient = String(Int(self.contact.personalityData.traits!.openness!.emotionality))
        //self.contact.personalityData.friendlinessScore = String(Int(self.contact.personalityData.traits!.extraversion!.friendliness))
        
        var strength = self.contact.personalityData.strengths.joinWithSeparator(", ")
        var text =  ""
        if loggedInUser.signedInWith != "Facebook" {
            text =  self.contact.name + "'s InYou profile: \n\n" +
                "Traits: " + self.contact.personalityData.personalityTraits + "\n" +
                "Life Satisfaction: " + self.contact.personalityData.lifeSatisfaction + "\n" +
                "Friendly: " + self.contact.personalityData.friendlinessScore + "\n" +
                "Trustworthy: " + self.contact.personalityData.trustScore + "\n" +
                "Lovable: " + self.contact.personalityData.personalRelationship + "\n" +
                "Strengths: " + strength + "\n" +
                "Intelligence Quotient: " + String(self.contact.personalityData.intelligenceQuotient) + "\n" +
                "Emotional Quotient: " + self.contact.personalityData.emotionalQuotient + "\n" +
                "Academic Performance: " + self.contact.personalityData.academicPerformance + "\n" +
                "Career Performance: " + self.contact.personalityData.carreerPerformance + "\n" +
                "Innovation: " + self.contact.personalityData.innovation + "\n" +
                "Creativity: " + self.contact.personalityData.creativity + "\n" +
                "Thinking Style: " + self.contact.personalityData.thinkingStyleDegree + "\n" +
                "Pesonality Type: " + self.contact.personalityData.personalityType + "\n" +
                "Summary: " + self.contact.personalityData.personalitySummary
        } else {
            text =  self.contact.name + "'s Personality: \n\n" +
                "Feeling Like: " + self.contact.personalityData.feelByAge + "\n" +
                "Life Satisfaction: " + self.contact.personalityData.lifeSatisfaction + "\n" +
                "Friendly: " + self.contact.personalityData.friendlinessScore + "\n" +
                "Lovable: " + self.contact.personalityData.personalRelationship + "\n" +
                "Intelligence Quotient: " + String(self.contact.personalityData.intelligenceQuotient) + "\n" +
                "Emotional Quotient: " + self.contact.personalityData.emotionalQuotient + "\n" +
                "Academic Performance: " + self.contact.personalityData.academicPerformance + "\n" +
                "Career Interest: " + self.contact.personalityData.careerArea + "\n" +
                "Innovation: " + self.contact.personalityData.innovation + "\n" +
                "Creativity: " + self.contact.personalityData.creativity
        }
        
        var image  = self.takeScreenshot(self)
        
        let textToShare = self.contact.personalityData.personalitySummary
        //let google:NSURL = NSURL(string:"http://google.com/")!
        let url = NSBundle.mainBundle().URLForResource("", withExtension:"png")!
        //var image = UIImage(named: "Big-Five-Factors-of-Personality.jpg")
        let activityVC = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        //activityVC.excludedActivityTypes =  [UIActivityTypePrint]
        activityVC.excludedActivityTypes = [UIActivityTypePostToWeibo, UIActivityTypePostToTwitter]
        
        activityVC.completionWithItemsHandler = { UIActivityViewControllerCompletionWithItemsHandler in
            //print("")
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    /*
    @IBAction func macthMeClicked(sender: AnyObject) {
    self.performSegueWithIdentifier("relationship", sender: self)
    }*/
    
    /*
    @IBAction func pageControlValueChanged(sender: AnyObject) {
    carousel.scrollToItemAtIndex(pageControl.currentPage * 5, aimated: true)
    }
    */
    
    /*
    @IBOutlet weak var happyImage: UIImageView!
    @IBOutlet weak var strengthImage: UIImageView!
    @IBOutlet weak var intelligentImage: UIImageView!
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var trustImage: UIImageView!
    
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var intelligentLabel: UILabel!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var trustLabel: UILabel!
    */
    /*
    override func loadView() {
    // calling self.view later on will return a UIView!, but we can simply call
    // self.scrollView to adjust properties of the scroll view:
    self.view = self.scrollView
    
    // setup the scroll view
    self.scrollView.contentSize = CGSize(width:1234, height: 5678)
    // etc...
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.backgroundColor = UIColor.blackColor()
    scrollView.contentSize = imageView.bounds.size
    scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    
    scrollView.addSubview(imageView)
    view.addSubview(scrollView)
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        
        /*icon.imageColorOn = UIColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        icon.circleColor = UIColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
        icon.lineColor = UIColor(red: 226/255, green: 96/255, blue: 96/255, alpha: 1.0)
        */
        
        //self.callMSFaceAPI()
        self.follower.hidden = true
        self.following.hidden = true
        self.followerLabel.hidden = true
        self.followingLabel.hidden = true
        
        
        if loggedInUser.signedInWith == "Google" || loggedInUser.signedInWith == "Twitter" {
            pageControl.numberOfPages = 13
        } else if loggedInUser.signedInWith == "Facebook" {
            pageControl.numberOfPages = 7
        }
        
        if self.contact.images.count == 0 {
            self.callFullContactAPI()
        } else {
            for (var i = 0; i < self.contact.images.count; i++) {
                if i == 0 {
                    self.profileImage2.image = self.contact.images[0]
                    self.profileImage2.hidden = false
                }
                if i == 1 {
                    self.profileImage3.image = self.contact.images[1]
                    self.profileImage3.hidden = false
                }
                if i == 2 {
                    self.profileImage4.image = self.contact.images[2]
                    self.profileImage4.hidden = false
                }
            }
        }
        
        if self.contact.personalityData.personalitySummaryStatus.isEmpty {
            self.setPersonalityViewHidden(true)
            if loggedInUser.signedInWith == "Google" {
                //print("signedInWithGoogle")
                if self.analyzeInProgress == false {
                    self.callPersonalityAPI()
                }
            } else if loggedInUser.signedInWith == "Facebook" {
                self.profileBackgroundImage.image = self.contact.profileImage
                let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
                if (reachability.currentReachabilityStatus != .ReachableViaWiFi && loggedInUser.analyzeOnWifiOnly == true) {
                    var title = "Not Connected to Wi-fi"
                    var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using current intenet connection?"
                    var actionTitle1 = "Yes"
                    var actionTitle2 = "No"
                    
                    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                        //self.analyzeEmailsNow()
                        self.view.addSubview(analyzingLikes)
                        analyzingLikes.show()
                        loggedInUser.analyzeOnWifiOnly = false
                        FB().friend_likes(self.contact.facebookId, nextCursor: nil) { responseObject, error in
                            if error != nil {
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
                            }
                        }
                        //switcher.setOn(false, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                        //print("User said No.")
                        self.contact.personalityData.personalitySummary = "Personality Analysis can not be done with current internet connection. Please change Analysis Wifi Only setting or connect to WiFi."
                        //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                        //self.personalitySummaryText.hidden = false
                        self.errorText.text = self.contact.personalityData.personalitySummary
                        self.errorText.hidden = false
                        self.inviteButton.hidden = true
                        //self.checkButton.hidden = false
                        self.shareButton.tintColor = UIColor.clearColor()
                        loggedInUser.analyzeOnWifiOnly = true
                        self.topTraits.hidden = false
                        //switcher.setOn(true, animated: true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else  {
                    self.view.addSubview(analyzingLikes)
                    analyzingLikes.show()
                    FB().friend_likes(self.contact.facebookId, nextCursor: nil){ responseObject, error in
                        if error != nil {
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
                    }
                }
            } else if loggedInUser.signedInWith == "Twitter" {
                /*
                swifter.getAccountSettingsWithSuccess({ (settings: Dictionary<String, JSONValue>?) in
                print(settings)
                }, failure: {
                (error: NSError) in
                print(error)
                })*/
                
                //print("contact twitter id:"+self.contact.twitterId)
                self.getProfileBackgroundImage("Twitter", imageURLString: self.contact.twitterProfileBackgroundImageUrlHttps)
                let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
                if (reachability.currentReachabilityStatus != .ReachableViaWiFi && loggedInUser.analyzeOnWifiOnly == true) {
                    var title = "Not Connected to Wi-fi"
                    var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using current intenet connection?"
                    var actionTitle1 = "Yes"
                    var actionTitle2 = "No"
                    
                    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                        //self.analyzeEmailsNow()
                        loggedInUser.analyzeOnWifiOnly = false
                        self.view.addSubview(analyzingTweets)
                        analyzingTweets.show()
                        var allTweets = ""
                        TwitterAPIHandler().getUserTimelineWithUserId(self.contact.twitterScreenName, userId: loggedInUser.id) { allTweets, count, error in
                            //print("All tweet text from a contact: "+allTweets!)
                            self.contact.twitterTotalTweets = count!
                            IBMWatsonAPIHandler().invokeAPI(self.contact, mail: allTweets!) { data, error in
                                var _data = data as! String
                                if _data.isEmpty {
                                    analyzingTweets.hide()
                                    self.errorOccurred = true
                                    self.errorText.text = self.contact.personalityData.personalitySummary
                                    self.errorText.hidden = false
                                    self.inviteButton.hidden = false
                                    self.topTraits.hidden = false
                                    //self.checkButton.hidden = false
                                    self.shareButton.tintColor = UIColor.clearColor()
                                    //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                                    //self.personalitySummaryText.hidden = false
                                } else {
                                    ReceptivitiAPIHandler().invokeAPI(self.contact, text: allTweets!){ data, error in
                                        analyzingTweets.hide()
                                        self.updatePersonality()
                                        self.setPersonalityViewHidden(false)
                                        ParseAPIHandler().saveUserInCloud()
                                    }
                                }
                            }
                        }
                        //self.analyzeEmailsNow()
                        //switcher.setOn(false, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                        //print("User said No.")
                        self.contact.personalityData.personalitySummary = "Personality Analysis can not be done with current internet connection. Please change Analysis Wifi Only setting or connect to WiFi."
                        //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                        //self.personalitySummaryText.hidden = false
                        self.errorText.text = self.contact.personalityData.personalitySummary
                        self.errorText.hidden = false
                        self.inviteButton.hidden = true
                        //self.checkButton.hidden = false
                        self.shareButton.tintColor = UIColor.clearColor()
                        loggedInUser.analyzeOnWifiOnly = true
                        self.topTraits.hidden = false
                        //switcher.setOn(true, animated: true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else  {
                    self.view.addSubview(analyzingTweets)
                    analyzingTweets.show()
                    var allTweets = ""
                    TwitterAPIHandler().getUserTimelineWithUserId(self.contact.twitterScreenName, userId: loggedInUser.id) { allTweets, count, error in
                        //print("All tweet text from a contact: "+allTweets!)
                        self.contact.twitterTotalTweets = count!
                        IBMWatsonAPIHandler().invokeAPI(self.contact, mail: allTweets!) { data, error in
                            var _data = data as! String
                            if _data.isEmpty {
                                analyzingTweets.hide()
                                self.errorOccurred = true
                                self.errorText.text = self.contact.personalityData.personalitySummary
                                self.errorText.hidden = false
                                self.inviteButton.hidden = false
                                self.topTraits.hidden = false
                                //self.checkButton.hidden = false
                                self.shareButton.tintColor = UIColor.clearColor()
                                //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                                //self.personalitySummaryText.hidden = false
                            } else {
                                ReceptivitiAPIHandler().invokeAPI(self.contact, text: allTweets!){ data, error in
                                    analyzingTweets.hide()
                                    self.updatePersonality()
                                    self.setPersonalityViewHidden(false)
                                    ParseAPIHandler().saveUserInCloud()
                                }
                            }
                        }
                    }
                }
            }
        } else if self.contact.personalityData.personalitySummaryStatus == "ERROR" {
            self.setPersonalityViewHidden(true)
            errorText.text = self.contact.personalityData.personalitySummary
            errorText.hidden = false
            inviteButton.hidden = false
            self.topTraits.hidden = false
            //checkButton.hidden = false
            self.shareButton.tintColor = UIColor.clearColor()
            //self.personalitySummaryText.hidden = false
            //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
        } else {
            self.updatePersonality()
            //self.setPersonalityViewHidden(false)
        }
    }
    
    func setPersonalityViewHidden(flag: Bool){
        self.openCircle.hidden = flag
        self.conscientiousnessCircle.hidden = flag
        self.agreeablenessCircle.hidden = flag
        self.extraversionCircle.hidden = flag
        self.emotionalRangeCircle.hidden = flag
        
        self.bestTraits.hidden = flag
        //self.emailCountLabel.hidden = flag
        
        /*self.topTrait1.hidden = flag
        self.topTrait2.hidden = flag
        self.topTrait3.hidden = flag
        self.topTrait4.hidden = flag
        self.topTrait5.hidden = flag
        */
        
        self.topTraits.hidden = flag
        self.personalityCarousel.hidden = flag
        self.pageControl.hidden = flag
        self.lineLayer.hidden = flag
        //self.matchMeButton.hidden = flag
        //self.MatchLabel.hidden = flag
        
        //self.personalitySummaryText.hidden = flag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var value = 70*UIScreen.mainScreen().bounds.size.width/414
        var circleHeight = 305*UIScreen.mainScreen().bounds.size.height/736
        
        //if UIScreen.mainScreen().bounds.size.height == 568 {
        circleHeight = circleHeight + 25
        //}
        
        openCircle = CircleView(frame: CGRectMake((width/5-value)/2, circleHeight, value, value),color:UIColor.redColor().CGColor)
        conscientiousnessCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5, circleHeight, value, value),color:UIColor.greenColor().CGColor)
        extraversionCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5*2, circleHeight, value, value),color:UIColor.blueColor().CGColor)
        agreeablenessCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5*3, circleHeight, value, value),color:UIColor.yellowColor().CGColor)
        emotionalRangeCircle = CircleView(frame: CGRectMake((width/5-value)/2+width/5*4, circleHeight, value, value),color:UIColor.orangeColor().CGColor)
        
        self.profileImage.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.profileImage.frame)
        self.profileImage2.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.profileImage2.frame)
        self.profileImage3.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.profileImage3.frame)
        self.profileImage4.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.profileImage4.frame)
        
        self.topTraits.frame = CustomUISize().getNewFrameWidthHeight(self.topTraits.frame)
        
        self.inviteButton.frame = CustomUISize().getNewFrameWidthHeight(self.inviteButton.frame)
        
        //self.matchMeButton.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.matchMeButton.frame)
        //self.MatchLabel.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.MatchLabel.frame)
        
        /*self.topTrait1.frame = CustomUISize().getNewFrameNoTabBar(self.topTrait1.frame)
        self.topTrait2.frame = CustomUISize().getNewFrameNoTabBar(self.topTrait2.frame)
        self.topTrait3.frame = CustomUISize().getNewFrameNoTabBar(self.topTrait3.frame)
        self.topTrait4.frame = CustomUISize().getNewFrameNoTabBar(self.topTrait4.frame)
        self.topTrait5.frame = CustomUISize().getNewFrameNoTabBar(self.topTrait5.frame)
        */
        self.pageControl.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.pageControl.frame)
        self.personalityCarousel.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.personalityCarousel.frame)
        
        self.bestTraits.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.bestTraits.frame)
        //self.emailCountLabel.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.emailCountLabel.frame)
        self.tweetCount.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.tweetCount.frame)
        self.profileBackgroundImage.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.profileBackgroundImage.frame)
        self.backgroundImage.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.backgroundImage.frame)
        self.visualEffect.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.visualEffect.frame)
        
        var newFontSize = UIScreen.mainScreen().bounds.size.width/414
        self.bestTraits.font = UIFont(name: "HelveticaNeue-Bold", size: self.bestTraits.font!.pointSize*newFontSize)
        self.bestTraits.textAlignment = .Center
        //self.bestTraits.sizeThatFits()
        //self.bestTraits.numberOfLines = 0;
        //self.bestTraits.automaticallyAdjustsScrollViewInsets = false
        self.bestTraits.userInteractionEnabled = false
        self.bestTraits.editable = false
        //self.bestTraits.verticalAlignment = .Center

        
        navBar.topItem!.title = contact.name
        //userEmail.text = contact.email
        profileImage.image = contact.profileImage
        //backgroundImage.image = UIImage(named: "simple.jpg")
        backgroundImage.image = UIImage(named: "bg_1.jpg")
        //backgroundImage.backgroundColor = UIColor(hexString: "#EBEBEB")
        
        //self.view.backgroundColor = UIColor.grayColor()
        if loggedInUser.signedInWith == "Google" {
            /*GoogleOAuth().refreshAccessToken(){ data, error in
            //print("Access token is refreshed now.")
            }*/
        }
        
        
        let imageSize = 60 as CGFloat
        profileImage.layer.borderWidth = 3
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.cornerRadius = 75*UIScreen.mainScreen().bounds.size.width/414
        profileImage.clipsToBounds = true
        profileImage.userInteractionEnabled = true
        profileImage.multipleTouchEnabled = true
        
        switch loggedInUser.signedInWith {
        case "Google":
            topTraits.text = self.contact.email
        case "Facebook":
            topTraits.text = self.contact.location
        case "Twitter":
            topTraits.text = "@"+self.contact.twitterScreenName
        default:""
        print("nothing")
        }
        
        /*
        topTrait1.userInteractionEnabled = true
        topTrait1.multipleTouchEnabled = true
        topTrait2.userInteractionEnabled = true
        topTrait2.multipleTouchEnabled = true
        topTrait3.userInteractionEnabled = true
        topTrait3.multipleTouchEnabled = true
        topTrait4.userInteractionEnabled = true
        topTrait4.multipleTouchEnabled = true
        topTrait5.userInteractionEnabled = true
        topTrait5.multipleTouchEnabled = true
        
        var tapGestureForTopTraits = UITapGestureRecognizer(target: self, action: Selector("tapOnTopTraits"))
        tapGestureForTopTraits.numberOfTapsRequired = 1
        topTrait1.addGestureRecognizer(tapGestureForTopTraits)
        
        var tapGestureForTopTraits2 = UITapGestureRecognizer(target: self, action: Selector("tapOnTopTraits"))
        tapGestureForTopTraits2.numberOfTapsRequired = 1
        topTrait2.addGestureRecognizer(tapGestureForTopTraits2)
        
        var tapGestureForTopTraits3 = UITapGestureRecognizer(target: self, action: Selector("tapOnTopTraits"))
        tapGestureForTopTraits3.numberOfTapsRequired = 1
        topTrait3.addGestureRecognizer(tapGestureForTopTraits3)
        
        var tapGestureForTopTraits4 = UITapGestureRecognizer(target: self, action: Selector("tapOnTopTraits"))
        tapGestureForTopTraits4.numberOfTapsRequired = 1
        topTrait4.addGestureRecognizer(tapGestureForTopTraits4)
        
        var tapGestureForTopTraits5 = UITapGestureRecognizer(target: self, action: Selector("tapOnTopTraits"))
        tapGestureForTopTraits5.numberOfTapsRequired = 1
        topTrait5.addGestureRecognizer(tapGestureForTopTraits5)
        */
        var tapgesture = UITapGestureRecognizer(target: self, action: Selector("tap"))
        tapgesture.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tapgesture)
        //self.addCircleView()
        
        profileImage2.layer.borderWidth = 1
        profileImage2.layer.masksToBounds = false
        profileImage2.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage2.layer.cornerRadius = 75*UIScreen.mainScreen().bounds.size.width/414
        profileImage2.clipsToBounds = true
        profileImage2.userInteractionEnabled = true
        profileImage2.multipleTouchEnabled = true
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
        
        if self.contact.googlePlusUser {
            GPlusAPIHandler().getGPlusContactImpl(self.contact){ data, error in
                GPlusAPIHandler().getGPlusContactActivitiesImpl(self.contact){ data, error in
                    
                }
            }
        }
        /*
        personalitySummaryText.backgroundColor = UIColor.clearColor()
        personalitySummaryText.textColor = UIColor.whiteColor()
        personalitySummaryText.text = self.contact.personalityData.personalitySummary
        personalitySummaryText.backgroundColor = UIColor.clearColor()
        personalitySummaryText.userInteractionEnabled = true
        personalitySummaryText.editable = false
        */
        lineLayer = self.drawLineFromPoint(CGPoint(x:37,y: 495), toPoint:CGPoint(x:275,y:495), ofColor: UIColor.whiteColor())
        //view.layer.addSublayer(lineLayer)
        
        var widthRatio = UIScreen.mainScreen().bounds.size.width/414
        var heightRatio = UIScreen.mainScreen().bounds.size.height/736
        
        errorText = UITextView(frame:CGRect(x:0, y:self.view.bounds.height/2, width:self.view.bounds.width, height:200*heightRatio))
        errorText.backgroundColor = UIColor.clearColor()
        errorText.textAlignment = .Center
        errorText.font = UIFont.systemFontOfSize(15*widthRatio)
        errorText.textColor = UIColor.whiteColor()
        errorText.text = self.contact.personalityData.personalitySummary
        errorText.userInteractionEnabled = true
        errorText.editable = false
        errorText.hidden = true
        self.view.addSubview(errorText)
        
        checkButton = TKAnimatedCheckButton(frame: CGRectMake(self.view.bounds.width/2-30*widthRatio, self.view.bounds.height/2+75*heightRatio, 50*widthRatio, 50*heightRatio))
        checkButton.color = UIColor.whiteColor().CGColor
        checkButton.skeletonColor = UIColor.greenColor().CGColor
        checkButton.selected = true
        checkButton.hidden = true
        
        self.view.addSubview(checkButton)
        
        inviteButton = UIButton(frame:CGRect(x:self.view.bounds.width/2-90*widthRatio, y:self.view.bounds.height/2+150*heightRatio, width:180*widthRatio, height:50*heightRatio))
        //inviteButton.backgroundColor = UIColor.redColor()
        if !self.contact.inviteSent {
            inviteButton = UIButton(frame:CGRect(x:self.view.bounds.width/2-90*widthRatio, y:self.view.bounds.height/2+150*heightRatio, width:180*widthRatio, height:50*heightRatio))
            inviteButton.setTitle("Invite", forState: UIControlState.Normal)
            inviteButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        } else {
            inviteButton = UIButton(frame:CGRect(x:self.view.bounds.width/2-90*widthRatio, y:self.view.bounds.height/2+150*heightRatio, width:180*widthRatio, height:50*heightRatio))
            checkButton.hidden = false
            topTraits.hidden = false
            inviteButton.setTitle("Invite Sent", forState: UIControlState.Normal)
            inviteButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        }
        
        //inviteButton.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(inviteButton.frame)
        
        inviteButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 30*widthRatio)
        inviteButton.tag = 1
        inviteButton.hidden = true
        inviteButton.layer.borderColor = UIColor.whiteColor().CGColor
        inviteButton.layer.borderWidth = 2.0
        inviteButton.layer.cornerRadius = 8.0
        
        inviteButton.addTarget(self, action: "inviteButtonTapAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(inviteButton)
        
        
        //setCosmosView()
        personalityCarousel.type = .Linear
    }
    
    func inviteButtonTapAction(sender:UIButton!){
        if (mailComposer.canSendMail()) {
            let mailComposeVC = mailComposer.configuredMailComposeViewController()
            var emailAddresses  = self.contact.email
            
            var obj = [emailAddresses as AnyObject]
            mailComposeVC.setToRecipients(obj as? [String])
            presentViewController(mailComposeVC, animated: true, completion: {
                //print(self.mailComposer.composeResult)
                //if self.mailComposer.composeResult == "Sent" {
                sender.setTitle("Invite Sent", forState: UIControlState.Normal)
                sender.setTitleColor(UIColor.greenColor(), forState: .Normal)
                self.checkButton.hidden = false
                self.topTraits.hidden = false
                self.contact.inviteSent = true
                //self.inviteButton.hidden = true
                //}
                
                /*var inviteButtonNew = UIButton(frame:CGRect(x:self.view.bounds.width/2-90, y:self.view.bounds.height/2+150, width:180, height:50))
                inviteButtonNew.setTitle("Invite Sent", forState: UIControlState.Normal)
                inviteButtonNew.setTitleColor(UIColor.greenColor(), forState: .Normal)
                inviteButtonNew.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
                inviteButtonNew.tag = 1
                inviteButtonNew.layer.borderColor = UIColor.whiteColor().CGColor
                inviteButtonNew.layer.borderWidth = 2.0
                inviteButtonNew.layer.cornerRadius = 8.0
                //self.view.addSubview(inviteButtonNew)
                */
                //UIButton(frame:CGRect(x:self.view.bounds.width/2-90, y:self.view.bounds.height/2+100, width:180, height:100))
                //sender.setValue(true, forKey: "hidden")
                //sender.hidden = true
                //
            })
            
        } else {
            let errorAlert = UIAlertView(title: "Cannot Send Mail Message", message: "Your device is not able to send mail messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
    func setCosmosView(){
        
        // Change the cosmos view rating
        //cosmosView.rating = 4
        
        // Change the text
        //cosmosView.text = "(123)"
        //cosmosView.backgroundColor = UIColor.clearColor()
        /*
        // Show only fully filled stars
        cosmosView.settings.fillMode = .Full
        
        // Change the size of the stars
        cosmosView.settings.starSize = 30
        
        // Set the distance between stars
        cosmosView.settings.starMargin = 5
        
        // Set the color of a filled star
        cosmosView.settings.colorFilled = UIColor.orangeColor()
        
        // Set the border color of an empty star
        cosmosView.settings.bor derColorEmpty = UIColor.orangeColor()
        
        // Change the rating when the view is touched
        cosmosView.settings.updateOnTouch = true
        */
    }
    
    func updatePersonalityForFacebook (json: JSON){
        for (index, trait):(String, JSON) in json["predictions"] {
            //print(trait["value"])
            var value = trait["value"].doubleValue
            
            switch trait["trait"] {
            case "BIG5_Openness" :
                self.contact.personalityData.traits!.openness!.opennessValue = value*100
            case "BIG5_Conscientiousness":
                self.contact.personalityData.traits!.conscientiousness!.conscientiousnessValue = value*100
            case "BIG5_Extraversion":
                self.contact.personalityData.traits!.extraversion!.extraversionValue = value*100
            case "BIG5_Agreeableness":
                self.contact.personalityData.traits!.agreeableness!.agreeablenessValue = value*100
            case "BIG5_Neuroticism":
                self.contact.personalityData.traits!.neuroticism!.neuroticismValue = value*100
            case "Age":
                //print(value)
                var predictedAge = (String(value) as! NSString).substringWithRange(NSRange(location: 0, length: 2))
                //print("predicted age")
                //print(predictedAge)
                if self.contact.age != "" {
                    if Double(self.contact.age) > Double(predictedAge) {
                        self.contact.personalityData.feelByAge = String(Int(self.contact.age)!-Int(predictedAge)!) + " years younger"
                    } else if Double(self.contact.age) < Double(predictedAge) {
                        self.contact.personalityData.feelByAge = String(Int(predictedAge)!-Int(self.contact.age)!) + " years older"
                    } else {
                        self.contact.personalityData.feelByAge = "Same as actual age"
                    }
                } else {
                    self.contact.personalityData.feelByAge = predictedAge + " years old"
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
                case 29..<35 :
                    self.contact.personalityData.lifeSatisfaction = "Extremely Happy"
                case 22..<29 :
                    self.contact.personalityData.lifeSatisfaction = "Just Happy"
                case 16..<22:
                    self.contact.personalityData.lifeSatisfaction = "Slightly Happy"
                case 13..<16:
                    self.contact.personalityData.lifeSatisfaction = "Neither Happy or Sad"
                case 9..<13:
                    self.contact.personalityData.lifeSatisfaction = "Slightly Unhappy"
                case 4..<9:
                    self.contact.personalityData.lifeSatisfaction = "Totally Unhappy"
                case 2..<4:
                    self.contact.personalityData.lifeSatisfaction = "Extremely Unhappy"
                default:
                    self.contact.personalityData.lifeSatisfaction = "Very Extremely Unhappy"
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
                case 144..<200 :
                    self.contact.personalityData.intelligenceQuotient = "Genius"
                case 130..<144 :
                    self.contact.personalityData.intelligenceQuotient = "Gifted"
                case 115..<130 :
                    self.contact.personalityData.intelligenceQuotient = "High Intelligent"
                case 100..<115 :
                    self.contact.personalityData.intelligenceQuotient = "Above Average Intelligent"
                case 85..<100 :
                    self.contact.personalityData.intelligenceQuotient = "Average Intelligent"
                case 70..<85 :
                    self.contact.personalityData.intelligenceQuotient = "Below Average"
                case 55..<70 :
                    self.contact.personalityData.intelligenceQuotient = "Challenged"
                default:
                    self.contact.personalityData.intelligenceQuotient = "Severly Challenged"
                }
                
            default:
                break
            }
        }
        //print(politics["status"])
        //print(concentration["status"])
        //print(relationship["status"])
        //print(religion["status"])
        self.contact.personalityData.careerArea = concentration["status"]!
        
        //loggedInUser.getHappinessScore(loggedInUser)
        //loggedInUser.getCarreerPerformanceScore2(loggedInUser)
        self.contact.getCreativityScore(self.contact)
        self.contact.getInnovationScore(self.contact)
        self.contact.getPersonalRelationshipScore(self.contact)
        //loggedInUser.getThiningkStyle(loggedInUser)
        self.contact.getAcademicPerformanceScore(self.contact)
        //loggedInUser.getIntelligenceQuotientScore(loggedInUser)
        self.contact.getEmotionalQuotientScore(self.contact)
        self.contact.getFriendlinessScore(self.contact)
        //loggedInUser.personalityData.trustScore = String(Int(loggedInUser.personalityData.traits!.agreeableness!.trust))
        //loggedInUser.personalityData.strengths = loggedInUser.getStrengths(self.topFacetsArray)
        
        var array = self.contact.personalityData.personalityTraits.componentsSeparatedByString(",")
        /*self.bestTraits.text = loggedInUser.personalityData.strengths[0]+" • "+loggedInUser.personalityData.strengths[1]+" • "+loggedInUser.personalityData.strengths[2]+" • "+loggedInUser.personalityData.strengths[3]+" • "+loggedInUser.personalityData.strengths[4]
        //self.emailCountLabel.text = "Based on "+String(self.contact.emailCount)+" emails sent to you"
        */
        self.contact.personalityData.personalityAnalyzed = true
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
    
    func addCircleView() {
        /*
        var needValue = self.contact.personalityData.needs!.needValue
        needCircle.updateLabelInside(Int(needValue),name: self.contact.personalityData.needs!.needKey)
        needCircle.updateEndAngle(Int(needValue))
        view.addSubview(needCircle)
        needCircle.animateCircle(1.0)
        
        var valueValue = self.contact.personalityData.values!.valueValue
        valueCircle.updateLabelInside(Int(valueValue), name: self.contact.personalityData.values!.valueKey)
        valueCircle.updateEndAngle(Int(valueValue))
        view.addSubview(valueCircle)
        valueCircle.animateCircle(1.0)
        */
        var opennessValue = self.contact.personalityData.traits!.openness!.opennessValue
        openCircle.updateLabelInside(Int(opennessValue),name: "Open")
        openCircle.updateEndAngle(Int(opennessValue))
        view.addSubview(openCircle)
        openCircle.animateCircle(1.0)
        
        var agreeablenessValue = self.contact.personalityData.traits!.agreeableness!.agreeablenessValue
        agreeablenessCircle.updateLabelInside(Int(agreeablenessValue), name: "Agreeable")
        agreeablenessCircle.updateEndAngle(Int(agreeablenessValue))
        view.addSubview(agreeablenessCircle)
        agreeablenessCircle.animateCircle(1.0)
        
        var conscientiousnessValue = self.contact.personalityData.traits!.conscientiousness!.conscientiousnessValue
        conscientiousnessCircle.updateLabelInside(Int(conscientiousnessValue),name: "Conscientious")
        conscientiousnessCircle.updateEndAngle(Int(conscientiousnessValue))
        view.addSubview(conscientiousnessCircle)
        conscientiousnessCircle.animateCircle(1.0)
        
        var extraversionValue = self.contact.personalityData.traits!.extraversion!.extraversionValue
        extraversionCircle.updateLabelInside(Int(extraversionValue),name: "Extroverted")
        extraversionCircle.updateEndAngle(Int(extraversionValue))
        view.addSubview(extraversionCircle)
        extraversionCircle.animateCircle(1.0)
        
        var emotionalRangeValue = self.contact.personalityData.traits!.neuroticism!.neuroticismValue
        emotionalRangeCircle.updateLabelInside(Int(emotionalRangeValue),name: "Emotional")
        emotionalRangeCircle.updateEndAngle(Int(emotionalRangeValue))
        view.addSubview(emotionalRangeCircle)
        emotionalRangeCircle.animateCircle(1.0)
        
        self.carousel(personalityCarousel, viewForItemAtIndex: 1, reusingView: self.view)
    }
    /*
    func callMSFaceAPI(){
    print("calling MS FaceAPI")
    var imageUrl = "https://www.google.com/m8/feeds/photos/media/default/\(self.contact.id)?access_token=\(loggedInUser.accessToken)"
    MSFaceAPI().invokeAPI(imageUrl) { data, error in
    self.contact.age = data
    }
    }
    */
    func callFullContactAPI(){
        FullContactAPI().getAllDetails(self.contact) { data, error in
            //print("Contact is loaded with all details")
            //self.twitterAccount()
            //self.googlePlusAccount()
            //self.kloutAccount()
            
            //print(self.contact.images.count)
            for (var i = 0; i < self.contact.images.count; i++) {
                if i == 0 {
                    self.profileImage2.image = self.contact.images[0]
                    self.profileImage2.hidden = false
                }
                if i == 1 {
                    self.profileImage3.image = self.contact.images[1]
                    self.profileImage3.hidden = false
                }
                if i == 2 {
                    self.profileImage4.image = self.contact.images[2]
                    self.profileImage4.hidden = false
                }
            }
        }
    }
    
    func callPersonalityAPI(){
        if emailAnalyzed {
            /*if self.errorOccurred {
            //self.showError("Error", message: self.personalitySummary, actionTitle: "OK")
            self.contact.personalityData.personalitySummary = self.contact.personalityData.personalitySummary
            //self.updatePersonality()
            }*/
            if self.errorOccurred {
                self.setPersonalityViewHidden(true)
                errorText.text = self.contact.personalityData.personalitySummary
                errorText.hidden = false
                inviteButton.hidden = false
                topTraits.hidden = false
                //checkButton.hidden = false
                self.shareButton.tintColor = UIColor.clearColor()
            } else {
                self.setPersonalityViewHidden(false)
            }
            //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
            //self.personalitySummaryText.hidden = false
        } else {
            emailAnalyzed = true
            if contact.email.isEmpty{
                self.contact.personalityData.personalitySummary = "Contact does not have email address in profile."
                errorText.text = "Contact does not have email address in profile."
                errorText.hidden = false
                inviteButton.hidden = false
                topTraits.hidden = false
                //checkButton.hidden = false
                self.shareButton.tintColor = UIColor.clearColor()
                //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                //self.personalitySummaryText.hidden = false
            } else {
                let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
                
                if (reachability.currentReachabilityStatus != .ReachableViaWiFi && loggedInUser.analyzeOnWifiOnly == true) {
                    var title = "Not Connected to Wi-fi"
                    var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using current intenet connection?"
                    var actionTitle1 = "Yes"
                    var actionTitle2 = "No"
                    
                    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                        self.analyzeEmailsNow()
                        loggedInUser.analyzeOnWifiOnly = false
                        self.analyzeEmailsNow()
                        //switcher.setOn(false, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                        //print("User said No.")
                        self.contact.personalityData.personalitySummary = "Personality Analysis can not be done with current internet connection. Please change Analysis Wifi Only setting or connect to WiFi."
                        //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                        //self.personalitySummaryText.hidden = false
                        self.errorText.text = self.contact.personalityData.personalitySummary
                        self.errorText.hidden = false
                        self.inviteButton.hidden = true
                        //self.checkButton.hidden = false
                        self.shareButton.tintColor = UIColor.clearColor()
                        loggedInUser.analyzeOnWifiOnly = true
                        self.topTraits.hidden = false
                        //switcher.setOn(true, animated: true)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else  {
                    self.analyzeEmailsNow()
                }
            }
        }
    }
    
    func analyzeEmailsNow(){
        self.analyzeInProgress = true
        currentContactEmail = contact.email
        GMailAPIHandler().getAllInboxEmailsLastYear(self.contact, nextPageToken: "", queryString: contact.email) { data, error in
            analyzingEmails.hide()
            var _data = data as! String
            if _data.isEmpty {
                self.errorOccurred = true
                self.errorText.text = self.contact.personalityData.personalitySummary
                self.errorText.hidden = false
                self.inviteButton.hidden = false
                self.topTraits.hidden = false
                //self.checkButton.hidden = false
                self.shareButton.tintColor = UIColor.clearColor()
                //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
                //self.personalitySummaryText.hidden = false
            } else {
                //self.contact.personalityData.personalitySummary = data as! String
                self.updatePersonality()
                self.setPersonalityViewHidden(false)
                //self.contact.index = self.index
                Cache().updatePersonalitySumaryInUserDefaults(self.index, personalityText: self.contact.personalityData.personalitySummary)
                /*
                if let totalContacts = userDefaults.objectForKey("totalContacts") as? Int {
                print("updating personalitySummary")
                var i = 0
                for (i=0; i<totalContacts; i++) {
                self.updatePersonalitySumaryInUserDefaults(i, personalityText: self.contact.personalityData.personalitySummary)
                }
                }*/
            }
        }
    }
    
    func updatePersonality(){
        //self.personalitySummaryText.text = self.contact.personalityData.personalitySummary
        self.following.text = String(self.contact.twitterFriendsCount)
        self.follower.text = String(self.contact.twitterFollowersCount)
        self.follower.hidden = false
        self.following.hidden = false
        self.followerLabel.hidden = false
        self.followingLabel.hidden = false
        
        
        self.topFacetsArray = self.getTopFacetsValues(self.contact)
        self.topNeedsArray = self.getTopNeedsValues(self.contact)
        self.topValuesArray = self.getTopValuesValues(self.contact)
        
        self.contact.getFamilyOrientedScore(self.contact)
        self.contact.getAnalyticalThiningkStyle(self.contact)
        self.contact.getIndependent(self.contact)
        self.contact.getHappinessScore(self.contact)
        self.contact.getCarreerPerformanceScore2(self.contact)
        self.contact.getCreativityScore(self.contact)
        self.contact.getInnovationScore(self.contact)
        self.contact.getPersonalRelationshipScore(self.contact)
        //self.contact.getThiningkStyle(self.contact)
        self.contact.getAcademicPerformanceScore(self.contact)
        self.contact.getIntelligenceQuotientScore(self.contact)
        self.contact.getEmotionalQuotientScore(self.contact)
        self.contact.getFriendlinessScore(self.contact)
        self.contact.personalityData.trustScore = String(Int(self.contact.personalityData.traits!.agreeableness!.trust))
        self.contact.personalityData.strengths = self.contact.getStrengths(self.topFacetsArray)
        
        var array = contact.personalityData.personalityTraits.componentsSeparatedByString(",")
        switch loggedInUser.signedInWith {
        case "Google" :
            self.bestTraits.text = ""
        case "Facebook" :
            self.bestTraits.text = ""
        case "Twitter" :
            self.bestTraits.text = contact.twitterDescription
            self.tweetCount.text = "Analysis based on last " + String(self.contact.twitterTotalTweets) + " tweets"
            self.tweetCount.text = self.contact.twitterLocation
        default:
            print("signed with something else")
        }
        //self.bestTraits.text = contact.personalityData.strengths[0]+" • "+contact.personalityData.strengths[1]+" • "+contact.personalityData.strengths[2]+" • "+contact.personalityData.strengths[3]+" • "+contact.personalityData.strengths[4]
        //self.emailCountLabel.text = "Based on "+String(self.contact.emailCount)+" emails sent to you"
        
        self.personalityCarousel.reloadData()
        self.addCircleView()
        
    }
    
    func tap(){
        self.performSegueWithIdentifier("imageFullscreen", sender: self)
    }
    
    func takeScreenshot(vc: UIViewController) -> UIImage {
        //print("takeScreenshot")
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        vc.view.drawViewHierarchyInRect(vc.view.bounds, afterScreenUpdates: true)
        var image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return image;
    }
    
    func tapOnTopTraits(){
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
        
        self.view.addSubview(popupView)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "imageFullscreen" {
            let destinationVC = segue.destinationViewController as! ImageFullscreenViewController
            if let navTitle = navBar.topItem?.title {
                destinationVC.name = navTitle
            }
            destinationVC.noOfImages = self.contact.images.count+1
            destinationVC.contact = self.contact
        }
        /*if segue.identifier == "relationship" {
        let destinationVC = segue.destinationViewController as! RelationshipViewController
        destinationVC.contactImage = self.contact.profileImage
        }*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor) -> CAShapeLayer {
        
        //design the path
        var path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        
        //design path in layer
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.lineWidth = 1.0
        
        return shapeLayer
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        //pageControl.numberOfPages = 3
        if loggedInUser.signedInWith == "Facebook" {
            return 7
        } else {
            return 13
        }
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        //var iconsView = UIView(frame:CGRect(x:15, y:230, width:290, height:200))
        return ContactDetailsViewController().populatePersonalityCarousalView (self.contact, carousel: carousel, path:"CONTACTS", index: index)
    }
    
    func populatePersonalityCarousalView (contact: GoogleContact, carousel: iCarousel, path:String, index: Int) -> UIView{
        var iconsView = UIView(frame: carousel.frame)
        var label: UITextView
        var width = carousel.frame.width
        var height = carousel.frame.height
        
        if loggedInUser.signedInWith == "Google" || loggedInUser.signedInWith == "Twitter" {
            if index == 0 {
                //ContactDetailsViewController().multiTextCarousalView(path, width: width, height: height, imageIn: "Like Filled-100_Green.png", percentageValue: "", labelValue: "Traits", texts:contact.personalityData.personalityTraits.componentsSeparatedByString(","), carouselView: iconsView)
                //    ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Happy Filled-100_Green.png", percentageValue: contact.personalityData.lifeSatisfaction, labelValue: "Happy", carouselView: iconsView)
                label = UITextView(frame:CGRect(x:20, y:30, width:width-40, height:height-40))
                label.backgroundColor = UIColor.clearColor()
                label.textAlignment = .Left
                label.font = UIFont.systemFontOfSize(13)
                label.textColor = UIColor.whiteColor()
                //label.textColor = UIColor.blackColor()
                label.text = contact.personalityData.personalitySummary
                //label.text = contact.personalityData.
                
                label.userInteractionEnabled = true
                label.editable = false
                
                iconsView.addSubview(label)
            } else if index == 1 {
                //loggedInUser.personalityData.intelligenceQuotient = String(Int(loggedInUser.personalityData.traits!.openness!.intellect))
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Happy Filled-100_Green.png", percentageValue: contact.personalityData.lifeSatisfaction, labelValue: "Happy", carouselView: iconsView)
            } else if index == 2 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "User Group 2-100.png", percentageValue: contact.personalityData.friendlinessScore, labelValue: "Friendly", carouselView: iconsView)
            } else if index == 3 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Shield Filled-100.png", percentageValue: contact.personalityData.familyOriented, labelValue: "Family Oriented", carouselView: iconsView)
            } else if index == 4 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Date-100.png", percentageValue: contact.personalityData.independent, labelValue: "Independent", carouselView: iconsView)
            } else if index == 5 {
                ContactDetailsViewController().multiTextCarousalView(path, width: width, height: height, imageIn: "Flex Biceps Filled-100.png", percentageValue: "", labelValue: "Strength", texts:contact.personalityData.strengths, carouselView: iconsView)
            } else if index == 6 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "For Experienced-100.png", percentageValue: contact.personalityData.intelligenceQuotient, labelValue: "Intelligence Quotient", carouselView: iconsView)
            } else if index == 7 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Like Filled-100_Green.png", percentageValue: contact.personalityData.emotionalQuotient, labelValue: "Emotional Quotient", carouselView: iconsView)
            } else if index == 8 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Student Filled-100.png", percentageValue: contact.personalityData.academicPerformance, labelValue: "Academic Performance", carouselView: iconsView)
            } else if index == 9 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Businessman-100.png", percentageValue: contact.personalityData.carreerPerformance, labelValue: "Career Performance", carouselView: iconsView)
            /*} else if index == 10 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Idea-100_green.png", percentageValue: contact.personalityData.innovation, labelValue: "Busines-Minded", carouselView: iconsView)
            } else if index == 11 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Paint Palette Filled-100.png", percentageValue: contact.personalityData.creativity, labelValue: "Creativity", carouselView: iconsView)
            */} else if index == 10 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "For Experienced-100.png", percentageValue: contact.personalityData.thinkingStyle, labelValue: "Thinking Style", carouselView: iconsView)
            } else if index == 11 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Student Filled-100.png", percentageValue: contact.personalityData.personalityType, labelValue: "Personality Type", carouselView: iconsView)
            } else {
                //if labelValue == "Work Style" {
                    var temp1  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
                    temp1.text = "Achievement Driven"
                    var temp1width = temp1.intrinsicContentSize().width + 8
                    
                    var sliderLabel = UILabel(frame: CGRectMake(120, 50, width, 20.0))
                    sliderLabel.text = "Achievement Driven"
                    sliderLabel.backgroundColor = UIColor.clearColor()
                    sliderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
                    sliderLabel.textColor = UIColor.whiteColor()
                    sliderLabel.textAlignment = .Left
                    //sliderLabel.layer.borderColor = UIColor.orangeColor().CGColor
                    //sliderLabel.layer.borderWidth = 2.0
                    //sliderLabel.layer.cornerRadius = 8.0
                
                let button = SwiftyButton()
                button.buttonColor  = .cyanColor()
                button.shadowColor  = .blueColor()
                button.shadowHeight = 5
                button.cornerRadius = 5
                iconsView.addSubview(button)

                
                    var imageView = UIImageView(frame: CGRect(x:50, y:50, width:30, height:30))
                    imageView.image = UIImage(named: "medal.png")
                
                
                
                    var image1View = UIImageView(frame: CGRect(x:width/2+20, y:50, width:25, height:25))
                    image1View.image = UIImage(named: "medal.png")
                    var image2View = UIImageView(frame: CGRect(x:width/2+40, y:50, width:25, height:25))
                    image2View.image = UIImage(named: "medal.png")
                    var image3View = UIImageView(frame: CGRect(x:width/2+60, y:50, width:25, height:25))
                    image3View.image = UIImage(named: "medal.png")
                    var image4View = UIImageView(frame: CGRect(x:width/2+80, y:50, width:25, height:25))
                    image4View.image = UIImage(named: "medal.png")
                    var image5View = UIImageView(frame: CGRect(x:width/2+100, y:50, width:25, height:25))
                    image5View.image = UIImage(named: "medal.png")
                    var image6View = UIImageView(frame: CGRect(x:width/2+120, y:50, width:25, height:25))
                    image6View.image = UIImage(named: "medal_empty.png")
                    var image7View = UIImageView(frame: CGRect(x:width/2+140, y:50, width:25, height:25))
                    image7View.image = UIImage(named: "medal_empty.png")
                    var image8View = UIImageView(frame: CGRect(x:width/2+160, y:50, width:25, height:25))
                    image8View.image = UIImage(named: "medal_empty.png")
                    var image9View = UIImageView(frame: CGRect(x:width/2+180, y:50, width:25, height:25))
                    image9View.image = UIImage(named: "medal_empty.png")
                
                
                iconsView.addSubview(imageView)
                //iconsView.addSubview(image1View)
                //iconsView.addSubview(image2View)
                //iconsView.addSubview(image3View)
                //iconsView.addSubview(image4View)
                //iconsView.addSubview(image5View)
                //iconsView.addSubview(image6View)
                //iconsView.addSubview(image7View)
                //iconsView.addSubview(image8View)
                //iconsView.addSubview(image9View)
                
                    var temp2  = UILabel(frame: CGRectMake(120, 90, width, 20.0))
                    temp2.text = "Idea Driven"
                    var temp2width = temp2.intrinsicContentSize().width + 8
                    
                    var slider2Label = UILabel(frame: CGRectMake(120, 85, width, 20.0))
                    slider2Label.text = "Idea Driven"
                    slider2Label.backgroundColor = UIColor.clearColor()
                    slider2Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
                    slider2Label.textColor = UIColor.whiteColor()
                    slider2Label.textAlignment = .Left
                    //slider2Label.layer.borderColor = UIColor.redColor().CGColor
                    //slider2Label.layer.borderWidth = 2.0
                    //slider2Label.layer.cornerRadius = 8.0
                
                
                var ideaView = UIImageView(frame: CGRect(x:50, y:90, width:30, height:30))
                ideaView.image = UIImage(named: "idea")
                var idea1View = UIImageView(frame: CGRect(x:width/2+20, y:90, width:25, height:25))
                idea1View.image = UIImage(named: "idea")
                var idea2View = UIImageView(frame: CGRect(x:width/2+40, y:90, width:25, height:25))
                idea2View.image = UIImage(named: "idea")
                var idea3View = UIImageView(frame: CGRect(x:width/2+60, y:90, width:25, height:25))
                idea3View.image = UIImage(named: "idea")
                var idea4View = UIImageView(frame: CGRect(x:width/2+80, y:90, width:25, height:25))
                idea4View.image = UIImage(named: "idea")
                var idea5View = UIImageView(frame: CGRect(x:width/2+100, y:90, width:25, height:25))
                idea5View.image = UIImage(named: "idea")
                var idea6View = UIImageView(frame: CGRect(x:width/2+120, y:90, width:25, height:25))
                idea6View.image = UIImage(named: "idea_empty.png")
                var idea7View = UIImageView(frame: CGRect(x:width/2+140, y:90, width:25, height:25))
                idea7View.image = UIImage(named: "idea_empty.png")
                var idea8View = UIImageView(frame: CGRect(x:width/2+160, y:90, width:25, height:25))
                idea8View.image = UIImage(named: "idea_empty.png")
                var idea9View = UIImageView(frame: CGRect(x:width/2+180, y:90, width:25, height:25))
                idea9View.image = UIImage(named: "idea_empty.png")
                
                iconsView.addSubview(ideaView)
                //iconsView.addSubview(idea1View)
                //iconsView.addSubview(idea2View)
                //iconsView.addSubview(idea3View)
                //iconsView.addSubview(idea4View)
                //iconsView.addSubview(idea5View)
                //iconsView.addSubview(idea6View)
                //iconsView.addSubview(idea7View)
                //iconsView.addSubview(idea8View)
                //iconsView.addSubview(idea9View)
                
                    var temp3  = UILabel(frame: CGRectMake(120, 90, width, 20.0))
                    temp3.text = "Independent"
                    var temp3width = temp3.intrinsicContentSize().width + 8
                    
                    var slider3Label = UILabel(frame: CGRectMake(120, 120, width, 20.0))
                    slider3Label.text = "Independent"
                    slider3Label.backgroundColor = UIColor.clearColor()
                    slider3Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
                    slider3Label.textColor = UIColor.whiteColor()
                    slider3Label.textAlignment = .Left
                    //slider3Label.layer.borderColor = UIColor.blueColor().CGColor
                    //slider3Label.layer.borderWidth = 2.0
                    //slider3Label.layer.cornerRadius = 8.0
                
                var ideaView2 = UIImageView(frame: CGRect(x:50, y:120, width:30, height:30))
                ideaView2.image = UIImage(named: "idea")
                
                    var temp4  = UILabel(frame: CGRectMake(120, 90, width, 20.0))
                    temp4.text = "Power Driven"
                    var temp4width = temp4.intrinsicContentSize().width + 8
                    
                    var slider4Label = UILabel(frame: CGRectMake(120, 155, width, 20.0))
                    slider4Label.text = "Power Driven"
                    slider4Label.backgroundColor = UIColor.clearColor()
                    slider4Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
                    slider4Label.textColor = UIColor.whiteColor()
                    slider4Label.textAlignment = .Left
                    //slider4Label.layer.borderColor = UIColor.magentaColor().CGColor
                    //slider4Label.layer.borderWidth = 2.0
                    //slider4Label.layer.cornerRadius = 8.0
                
                var ideaView3 = UIImageView(frame: CGRect(x:50, y:155, width:30, height:30))
                ideaView3.image = UIImage(named: "idea")
                
                    var temp5  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
                    temp5.text = "Type-A"
                    var temp5width = temp5.intrinsicContentSize().width + 8
                    
                    var slider5Label = UILabel(frame: CGRectMake(120, 190, width, 20.0))
                    slider5Label.text = "Type A Personality"
                    slider5Label.backgroundColor = UIColor.clearColor()
                    slider5Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
                    slider5Label.textColor = UIColor.whiteColor()
                    slider5Label.textAlignment = .Left
                    //slider5Label.layer.borderColor = UIColor.cyanColor().CGColor
                    //slider5Label.layer.borderWidth = 2.0
                    //slider5Label.layer.cornerRadius = 8.0
                
                var ideaView4 = UIImageView(frame: CGRect(x:50, y:190, width:30, height:30))
                ideaView4.image = UIImage(named: "idea")
                
                    var temp6  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
                    temp6.text = "Workhorse"
                    var temp6width = temp5.intrinsicContentSize().width + 8
                
                    var slider6Label = UILabel(frame: CGRectMake(120, 225, width, 20.0))
                    slider6Label.text = "Workhorse"
                    slider6Label.backgroundColor = UIColor.clearColor()
                    slider6Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
                    slider6Label.textColor = UIColor.whiteColor()
                    slider6Label.textAlignment = .Left
                    //slider6Label.layer.borderColor = UIColor.darkGrayColor().CGColor
                    //slider6Label.layer.borderWidth = 2.0
                    //slider6Label.layer.cornerRadius = 8.0
                
                var ideaView5 = UIImageView(frame: CGRect(x:50, y:225, width:30, height:30))
                ideaView5.image = UIImage(named: "idea")
                
                    var heightLabel = 40*UIScreen.mainScreen().bounds.size.height/736
                    if path == "HOME" {
                        heightLabel = 40*(UIScreen.mainScreen().bounds.size.height-49)/687
                    }
                
                    var label = UILabel(frame:CGRect(x:0, y:height-heightLabel, width:width, height:heightLabel))
                    label.backgroundColor = UIColor.clearColor()
                    label.font = UIFont(name: "HelveticaNeue-Bold", size: 28*UIScreen.mainScreen().bounds.size.width/414)
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = .Center
                    label.text = "Work Style"
                
                    iconsView.addSubview(label)
                    //iconsView.addSubview(imageView)
                    //iconsView.addSubview(image1View)
                    //iconsView.addSubview(image2View)
                    //iconsView.addSubview(image3View)
                    //iconsView.addSubview(image4View)
                    //iconsView.addSubview(image5View)
                
                    iconsView.addSubview(sliderLabel)
                    iconsView.addSubview(slider2Label)
                    iconsView.addSubview(slider3Label)
                    iconsView.addSubview(slider4Label)
                    iconsView.addSubview(slider5Label)
                    iconsView.addSubview(slider6Label)
                
                    //iconsView.addSubview(ideaView)
                    iconsView.addSubview(ideaView2)
                    iconsView.addSubview(ideaView3)
                    iconsView.addSubview(ideaView4)
                    iconsView.addSubview(ideaView5)
                
                //}
                //ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Student Filled-100.png", percentageValue: contact.personalityData.personalityType, labelValue: "Work Style", carouselView: iconsView)
            }
            /*} else {
                label = UITextView(frame:CGRect(x:20, y:30, width:width-40, height:height-40))
                label.backgroundColor = UIColor.clearColor()
                label.textAlignment = .Left
                label.font = UIFont.systemFontOfSize(13)
                label.textColor = UIColor.whiteColor()
                //label.textColor = UIColor.blackColor()
                label.text = contact.personalityData.personalitySummary
                
                //label.text = contact.personalityData.
                
                label.userInteractionEnabled = true
                label.editable = false
                
                iconsView.addSubview(label)
            *///}
        } else if loggedInUser.signedInWith == "Facebook" {
            if index == 0 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Happy Filled-100_Green.png", percentageValue: contact.personalityData.feelByAge, labelValue: "Feeling Like", carouselView: iconsView)
            } else if index == 1 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Happy Filled-100_Green.png", percentageValue: contact.personalityData.lifeSatisfaction, labelValue: "Life Satisfaction", carouselView: iconsView)
            } else if index == 2 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "User Group 2-100.png", percentageValue: contact.personalityData.friendlinessScore, labelValue: "Friendly", carouselView: iconsView)
            //} else if index == 3 {
            //    ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Date-100.png", percentageValue: contact.personalityData.personalRelationship, labelValue: "Lovable", carouselView: iconsView)
            } else if index == 3 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "For Experienced-100.png", percentageValue: contact.personalityData.intelligenceQuotient, labelValue: "Intelligence Quotient", carouselView: iconsView)
            } else if index == 4 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Like Filled-100_Green.png", percentageValue: contact.personalityData.emotionalQuotient, labelValue: "Emotional Quotient", carouselView: iconsView)
            } else if index == 5 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Student Filled-100.png", percentageValue: contact.personalityData.academicPerformance, labelValue: "Academic Performance", carouselView: iconsView)
            } else if index == 6 {
                ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Idea-100_green.png", percentageValue: contact.personalityData.careerArea, labelValue: "Career Interest", carouselView: iconsView)
            //} else if index == 7 {
            //    ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Idea-100_green.png", percentageValue: contact.personalityData.innovation, labelValue: "Innnovation", carouselView: iconsView)
            //} else if index == 8 {
            //    ContactDetailsViewController().carouselCustomView(path, width:width, height: height, imageIn: "Paint Palette Filled-100.png", percentageValue: contact.personalityData.creativity, labelValue: "Creativity", carouselView: iconsView)
            }
        }
        return iconsView
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
    
    func getTopFacetsValues(contact: GoogleContact) -> [Dictionary<String, Any>] {
        var topFacets = [Dictionary<String, Any>]()
        
        if contact.personalityData.traits!.openness!.adventurousness > 68 {
            topFacets.append(["Adventurous":contact.personalityData.traits!.openness!.adventurousness])
        } else {
            topFacets.append(["Consistent":100-contact.personalityData.traits!.openness!.adventurousness])
        }
        if contact.personalityData.traits!.openness!.artisticInterests > 68 {
            topFacets.append(["Appreciative of Art":contact.personalityData.traits!.openness!.artisticInterests])
        } else {
            
        }
        if contact.personalityData.traits!.openness!.emotionality > 68 {
            topFacets.append(["Emotional":contact.personalityData.traits!.openness!.emotionality])
        } else {
            
        }
        if contact.personalityData.traits!.openness!.intellect > 68 {
            topFacets.append(["Philosophical":contact.personalityData.traits!.openness!.intellect])
        } else {
            topFacets.append(["Concrete":100-contact.personalityData.traits!.openness!.intellect])
        }
        
        if contact.personalityData.traits!.openness!.imagination > 68 {
            topFacets.append(["Imaginative":contact.personalityData.traits!.openness!.imagination])
        } else {
            topFacets.append(["Down-to-earth":100-contact.personalityData.traits!.openness!.imagination])
        }
        
        if contact.personalityData.traits!.openness!.liberalism > 68 {
            topFacets.append(["Authority-challenging":contact.personalityData.traits!.openness!.liberalism])
        } else {
            topFacets.append(["Respectful of authority":100-contact.personalityData.traits!.openness!.liberalism])
        }
        
        
        if contact.personalityData.traits!.conscientiousness!.achievementStriving > 68 {
            topFacets.append(["Achievement Striving":contact.personalityData.traits!.conscientiousness!.achievementStriving])
        } else {
            topFacets.append(["Content":100-contact.personalityData.traits!.conscientiousness!.achievementStriving])
        }
        if contact.personalityData.traits!.conscientiousness!.cautiousness > 68 {
            topFacets.append(["Deliberate":contact.personalityData.traits!.conscientiousness!.cautiousness])
        } else {
            topFacets.append(["Bold":100-contact.personalityData.traits!.conscientiousness!.cautiousness])
        }
        if contact.personalityData.traits!.conscientiousness!.dutifulness > 68 {
            topFacets.append(["Dutiful":contact.personalityData.traits!.conscientiousness!.dutifulness])
        } else {
            topFacets.append(["Carefree":100-contact.personalityData.traits!.conscientiousness!.dutifulness])
        }
        if contact.personalityData.traits!.conscientiousness!.orderliness > 68 {
            topFacets.append(["Organized":contact.personalityData.traits!.conscientiousness!.orderliness])
        } else {
            topFacets.append(["Unstructured":100-contact.personalityData.traits!.conscientiousness!.orderliness])
        }
        if contact.personalityData.traits!.conscientiousness!.selfDiscipline > 68 {
            topFacets.append(["Persistent":contact.personalityData.traits!.conscientiousness!.selfDiscipline])
        } else {
            //    topFacets.append(["Intermittent":100-contact.personalityData.traits!.conscientiousness!.selfDiscipline])
        }
        if contact.personalityData.traits!.conscientiousness!.selfEfficacy > 68 {
            topFacets.append(["Self-assured":contact.personalityData.traits!.conscientiousness!.selfEfficacy])
        } else {
            //   topFacets.append(["Self-doubting":contact.personalityData.traits!.conscientiousness!.selfEfficacy])
        }
        
        
        if contact.personalityData.traits!.extraversion!.activityLevel > 68 {
            topFacets.append(["Energetic":contact.personalityData.traits!.extraversion!.activityLevel])
        } else {
            topFacets.append(["Laid-back":100-contact.personalityData.traits!.extraversion!.activityLevel])
        }
        if contact.personalityData.traits!.extraversion!.assertiveness > 68 {
            topFacets.append(["Assertive":contact.personalityData.traits!.extraversion!.assertiveness])
        } else {
            topFacets.append(["Modest":100-contact.personalityData.traits!.extraversion!.assertiveness])
        }
        if contact.personalityData.traits!.extraversion!.cheerfulness > 68 {
            topFacets.append(["Cheerful":contact.personalityData.traits!.extraversion!.cheerfulness])
        }
        if contact.personalityData.traits!.extraversion!.excitementSeeking > 68 {
            topFacets.append(["Excitement Seeking":contact.personalityData.traits!.extraversion!.excitementSeeking])
        } else {
            topFacets.append(["Calm-seeking":100-contact.personalityData.traits!.extraversion!.excitementSeeking])
        }
        if contact.personalityData.traits!.extraversion!.friendliness > 68 {
            topFacets.append(["Friendly":contact.personalityData.traits!.extraversion!.friendliness])
        } else {
            topFacets.append(["Reserved":100-contact.personalityData.traits!.extraversion!.friendliness])
        }
        if contact.personalityData.traits!.extraversion!.gregariousness > 68 {
            topFacets.append(["Sociable":contact.personalityData.traits!.extraversion!.gregariousness])
        } else {
            topFacets.append(["Independent":100-contact.personalityData.traits!.extraversion!.gregariousness])
        }
        
        
        if contact.personalityData.traits!.agreeableness!.altruism > 68 {
            topFacets.append(["Kind":contact.personalityData.traits!.agreeableness!.altruism])
        } else {
            topFacets.append(["Self-focused":100-contact.personalityData.traits!.agreeableness!.altruism])
        }
        if contact.personalityData.traits!.agreeableness!.cooperation > 68 {
            topFacets.append(["Cooperative":contact.personalityData.traits!.agreeableness!.cooperation])
        } else {
            //    topFacets.append(["Cooperative":contact.personalityData.traits!.agreeableness!.cooperation])
        }
        if contact.personalityData.traits!.agreeableness!.modesty > 68 {
            topFacets.append(["Modest":contact.personalityData.traits!.agreeableness!.modesty])
        } else {
            topFacets.append(["Proud":100-contact.personalityData.traits!.agreeableness!.modesty])
        }
        if contact.personalityData.traits!.agreeableness!.morality > 68 {
            topFacets.append(["Determined":contact.personalityData.traits!.agreeableness!.morality])
        } else {
            topFacets.append(["Compromising":100-contact.personalityData.traits!.agreeableness!.morality])
        }
        if contact.personalityData.traits!.agreeableness!.sympathy > 68 {
            topFacets.append(["Empathetic":contact.personalityData.traits!.agreeableness!.sympathy])
        } else {
            //    topFacets.append(["Empathetic":contact.personalityData.traits!.agreeableness!.sympathy])
        }
        if contact.personalityData.traits!.agreeableness!.trust > 68 {
            topFacets.append(["Trusting Others":contact.personalityData.traits!.agreeableness!.trust])
        } else {
            topFacets.append(["Cautious of others":100-contact.personalityData.traits!.agreeableness!.trust])
        }
        
        
        if contact.personalityData.traits!.neuroticism!.anger < 32 {
            //    topFacets.append(["Not fiery":contact.personalityData.traits!.neuroticism!.anger])
        }
        if contact.personalityData.traits!.neuroticism!.anxiety < 32 {
            topFacets.append(["Self-assured":100-contact.personalityData.traits!.neuroticism!.anxiety])
        }
        if contact.personalityData.traits!.neuroticism!.depression < 32 {
            topFacets.append(["Content":100-contact.personalityData.traits!.neuroticism!.depression])
        }
        if contact.personalityData.traits!.neuroticism!.immoderation < 32 {
            topFacets.append(["Self-controlled":100-contact.personalityData.traits!.neuroticism!.immoderation])
        }
        if contact.personalityData.traits!.neuroticism!.selfConsciousness < 32 {
            topFacets.append(["Confident":100-contact.personalityData.traits!.neuroticism!.selfConsciousness])
        }
        if contact.personalityData.traits!.neuroticism!.vulnerability < 32 {
            topFacets.append(["Calm Under Pressure":100-contact.personalityData.traits!.neuroticism!.vulnerability])
        }
        
        var topFacetsArray = Array(topFacets)
        var topFacetsArrayNew = topFacetsArray.sort { p1, p2 in
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
        return topFacetsArrayNew
    }
    
    func getTopNeedsValues(contact: GoogleContact) -> [Dictionary<String, Any>] {
        var topNeeds = [Dictionary<String, Any>]()
        
        if self.contact.personalityData.needs!.challenge > 0 {
            topNeeds.append(["Challenge":self.contact.personalityData.needs!.challenge])
        }
        if self.contact.personalityData.needs!.closeness > 0 {
            topNeeds.append(["Closeness":self.contact.personalityData.needs!.closeness])
        }
        if self.contact.personalityData.needs!.curiosity > 0 {
            topNeeds.append(["Curiosity":self.contact.personalityData.needs!.curiosity])
        }
        if self.contact.personalityData.needs!.excitement > 0 {
            topNeeds.append(["Excitement":self.contact.personalityData.needs!.excitement])
        }
        if self.contact.personalityData.needs!.harmony > 0 {
            topNeeds.append(["Harmony":self.contact.personalityData.needs!.harmony])
        }
        if self.contact.personalityData.needs!.ideal > 0 {
            topNeeds.append(["Ideal":self.contact.personalityData.needs!.ideal])
        }
        if self.contact.personalityData.needs!.liberty > 0 {
            topNeeds.append(["Liberty":self.contact.personalityData.needs!.liberty])
        }
        if self.contact.personalityData.needs!.love > 0 {
            topNeeds.append(["Love":self.contact.personalityData.needs!.love])
        }
        if self.contact.personalityData.needs!.practicality > 0 {
            topNeeds.append(["Practicality":self.contact.personalityData.needs!.practicality])
        }
        if self.contact.personalityData.needs!.selfExpression > 0 {
            topNeeds.append(["Self Expression":self.contact.personalityData.needs!.selfExpression])
        }
        if self.contact.personalityData.needs!.stability > 0 {
            topNeeds.append(["Stability":self.contact.personalityData.needs!.stability])
        }
        if self.contact.personalityData.needs!.structure > 0 {
            topNeeds.append(["Structure":self.contact.personalityData.needs!.structure])
        }
        
        var topNeedsArray = Array(topNeeds)
        var topNeedsArrayNew = topNeedsArray.sort { p1, p2 in
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
        //self.topNeedsArray = topNeedsArrayNew
        return topNeedsArrayNew
    }
    
    func getTopValuesValues(contact: GoogleContact) -> [Dictionary<String, Any>] {
        var topValues = [Dictionary<String, Any>]()
        
        if self.contact.personalityData.values!.conservation > 0 {
            topValues.append(["Conservation":self.contact.personalityData.values!.conservation])
        }
        if self.contact.personalityData.values!.opennessToChange > 0 {
            topValues.append(["Openness To Change":self.contact.personalityData.values!.opennessToChange])
        }
        if self.contact.personalityData.values!.hedonism > 0 {
            topValues.append(["Hedonism":self.contact.personalityData.values!.hedonism])
        }
        if self.contact.personalityData.values!.selfEnhancement > 0 {
            topValues.append(["Self Enhancement":self.contact.personalityData.values!.selfEnhancement])
        }
        if self.contact.personalityData.values!.selfTranscendence > 0 {
            topValues.append(["Self Transcendence":self.contact.personalityData.values!.selfTranscendence])
        }
        
        var topValuesArray = Array(topValues)
        var topValuesArrayNew = topValuesArray.sort { p1, p2 in
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
        //self.topValuesArray = topValuesArrayNew
        return topValuesArrayNew
    }
    
    
    
    func carouselCustomView(path:String, width: CGFloat, height: CGFloat, imageIn: String, percentageValue: String, labelValue: String, carouselView: UIView){
        var widthNew = 60*UIScreen.mainScreen().bounds.size.width/414
        
        var iconImage = UIImageView(frame:CGRect(x:width/2-widthNew/2, y:20, width:widthNew, height:widthNew))
        iconImage.image = UIImage(named: imageIn)
        
        //var circle = CircleView(frame: CGRectMake(width/2-70, height/2-50, CGFloat(120), CGFloat(120)),color:UIColor.redColor().CGColor)
        
        //circle.updateEndAngle(percentageValue.toInt()!)
        //circle.animateCircle(1.0)
        var heightPercentage = 120*UIScreen.mainScreen().bounds.size.height/736
        if path == "HOME" {
            heightPercentage = 120*(UIScreen.mainScreen().bounds.size.height-49)/687
        }
        
        var percentage = UILabel(frame:CGRect(x:0, y:heightPercentage, width:width, height:heightPercentage))
        percentage.backgroundColor = UIColor.clearColor()
        percentage.font = UIFont.systemFontOfSize(60*UIScreen.mainScreen().bounds.size.width/414)
        percentage.textColor = UIColor.whiteColor()
        percentage.textAlignment = .Center
        percentage.text = percentageValue
        
        switch (labelValue) {
        case "Personality Type","Happy","Friendly","Family Oriented","Thinking Style","Career Performance","Independent":
            percentage.font = UIFont.systemFontOfSize(30*UIScreen.mainScreen().bounds.size.width/414)
        case "Feeling Like", "Life Satisfaction", "Career Interest", "Intelligence Quotient":
            if loggedInUser.signedInWith == "Facebook" {
                percentage.font = UIFont.systemFontOfSize(25*UIScreen.mainScreen().bounds.size.width/414)
            }
        default:
            percentage.font = UIFont.systemFontOfSize(60*UIScreen.mainScreen().bounds.size.width/414)
        }
        
        
        
        var heightLabel = 40*UIScreen.mainScreen().bounds.size.height/736
        if path == "HOME" {
            heightLabel = 40*(UIScreen.mainScreen().bounds.size.height-49)/687
        }
        
        var label = UILabel(frame:CGRect(x:0, y:height-heightLabel, width:width, height:heightLabel))
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28*UIScreen.mainScreen().bounds.size.width/414)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = labelValue
        
        if labelValue == "Personality Type" {
            var description = UITextView(frame:CGRect(x:0, y:height-2.5*heightLabel, width:width, height:2*heightLabel))
            description.backgroundColor = UIColor.clearColor()
            description.font = UIFont(name: "HelveticaNeue", size: 13*UIScreen.mainScreen().bounds.size.width/414)
            description.textColor = UIColor.whiteColor()
            description.textAlignment = .Left
            description.editable = false
            description.userInteractionEnabled = false
            
            if percentage == "Type A" {
                description.text = "You are hightly time-conscious, impatient, ambitious, and competitive. You find it very difficult to relax. While chasing efficiency they somehow end up compromising with effectiveness."
            } else {
                description.text = "You are relaxed, easy going who rarely feel urgency of time. If properly guided you can take wise decisions and normally quite effective."
            }
            carouselView.addSubview(description)
        }
        
        if labelValue == "Work Style" {
            var temp1  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp1.text = contact.personalityData.lifeSatisfaction
            var temp1width = temp1.intrinsicContentSize().width + 8
            
            var sliderLabel = UILabel(frame: CGRectMake(100, 90, temp1width, 20.0))
            sliderLabel.text = contact.personalityData.lifeSatisfaction
            sliderLabel.backgroundColor = UIColor.clearColor()
            sliderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            sliderLabel.textColor = UIColor.whiteColor()
            sliderLabel.textAlignment = .Center
            sliderLabel.layer.borderColor = UIColor.redColor().CGColor
            sliderLabel.layer.borderWidth = 2.0
            sliderLabel.layer.cornerRadius = 8.0
            
            var temp2  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp2.text = contact.personalityData.friendlinessScore
            var temp2width = temp2.intrinsicContentSize().width + 8
            
            var slider2Label = UILabel(frame: CGRectMake(100, 125, temp2width, 20.0))
            slider2Label.text = contact.personalityData.friendlinessScore
            slider2Label.backgroundColor = UIColor.clearColor()
            slider2Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider2Label.textColor = UIColor.whiteColor()
            slider2Label.textAlignment = .Center
            slider2Label.layer.borderColor = UIColor.redColor().CGColor
            slider2Label.layer.borderWidth = 2.0
            slider2Label.layer.cornerRadius = 8.0
            
            var temp3  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp3.text = contact.personalityData.familyOriented
            var temp3width = temp3.intrinsicContentSize().width + 8
            
            var slider3Label = UILabel(frame: CGRectMake(100, 160, temp3width, 20.0))
            slider3Label.text = contact.personalityData.familyOriented
            slider3Label.backgroundColor = UIColor.clearColor()
            slider3Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider3Label.textColor = UIColor.whiteColor()
            slider3Label.textAlignment = .Center
            slider3Label.layer.borderColor = UIColor.redColor().CGColor
            slider3Label.layer.borderWidth = 2.0
            slider3Label.layer.cornerRadius = 8.0
            
            var temp4  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp4.text = contact.personalityData.carreerPerformance
            var temp4width = temp4.intrinsicContentSize().width + 8
            
            var slider4Label = UILabel(frame: CGRectMake(100, 195, temp4width, 20.0))
            slider4Label.text = contact.personalityData.carreerPerformance
            slider4Label.backgroundColor = UIColor.clearColor()
            slider4Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider4Label.textColor = UIColor.whiteColor()
            slider4Label.textAlignment = .Center
            slider4Label.layer.borderColor = UIColor.redColor().CGColor
            slider4Label.layer.borderWidth = 2.0
            slider4Label.layer.cornerRadius = 8.0
            
            var temp5  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp5.text = contact.personalityData.thinkingStyle
            var temp5width = temp5.intrinsicContentSize().width + 8
            
            var slider5Label = UILabel(frame: CGRectMake(100, 230, temp5width, 20.0))
            slider5Label.text = contact.personalityData.thinkingStyle
            slider5Label.backgroundColor = UIColor.clearColor()
            slider5Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider5Label.textColor = UIColor.whiteColor()
            slider5Label.textAlignment = .Center
            slider5Label.layer.borderColor = UIColor.redColor().CGColor
            slider5Label.layer.borderWidth = 2.0
            slider5Label.layer.cornerRadius = 8.0
            
            carouselView.addSubview(sliderLabel)
            carouselView.addSubview(slider2Label)
            carouselView.addSubview(slider3Label)
            carouselView.addSubview(slider4Label)
            carouselView.addSubview(slider5Label)
        }
        
        if labelValue == "Academic Performance" {
            var temp1  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp1.text = "Cautious"
            var temp1width = temp1.intrinsicContentSize().width + 8
            
            var sliderLabel = UILabel(frame: CGRectMake(width/2-temp1width/2, 90, temp1width, 20.0))
            sliderLabel.text = "Cautious"
            sliderLabel.backgroundColor = UIColor.clearColor()
            sliderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            sliderLabel.textColor = UIColor.whiteColor()
            sliderLabel.textAlignment = .Center
            sliderLabel.layer.borderColor = UIColor.redColor().CGColor
            sliderLabel.layer.borderWidth = 2.0
            sliderLabel.layer.cornerRadius = 8.0
            
            var temp2  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp2.text = "Organized"
            var temp2width = temp2.intrinsicContentSize().width + 8
            
            var slider2Label = UILabel(frame: CGRectMake(width/2-temp2width/2, 125, temp2width, 20.0))
            slider2Label.text = "Organized"
            slider2Label.backgroundColor = UIColor.clearColor()
            slider2Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider2Label.textColor = UIColor.whiteColor()
            slider2Label.textAlignment = .Center
            slider2Label.layer.borderColor = UIColor.redColor().CGColor
            slider2Label.layer.borderWidth = 2.0
            slider2Label.layer.cornerRadius = 8.0
            
            var temp3  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp3.text = "Outgoing"
            var temp3width = temp3.intrinsicContentSize().width + 8
            
            var slider3Label = UILabel(frame: CGRectMake(width/2-temp3width/2, 160, temp3width, 20.0))
            slider3Label.text = "Outgoing"
            slider3Label.backgroundColor = UIColor.clearColor()
            slider3Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider3Label.textColor = UIColor.whiteColor()
            slider3Label.textAlignment = .Center
            slider3Label.layer.borderColor = UIColor.redColor().CGColor
            slider3Label.layer.borderWidth = 2.0
            slider3Label.layer.cornerRadius = 8.0
            
            var temp4  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp4.text = "Sensitive"
            var temp4width = temp4.intrinsicContentSize().width + 8
            
            var slider4Label = UILabel(frame: CGRectMake(width/2-temp4width/2, 195, temp4width, 20.0))
            slider4Label.text = "Sensitive"
            slider4Label.backgroundColor = UIColor.clearColor()
            slider4Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider4Label.textColor = UIColor.whiteColor()
            slider4Label.textAlignment = .Center
            slider4Label.layer.borderColor = UIColor.redColor().CGColor
            slider4Label.layer.borderWidth = 2.0
            slider4Label.layer.cornerRadius = 8.0
            
            var temp5  = UILabel(frame: CGRectMake(10, 90, width, 20.0))
            temp5.text = "Compassionate"
            var temp5width = temp5.intrinsicContentSize().width + 8
            
            var slider5Label = UILabel(frame: CGRectMake(width/2-temp5width/2, 230, temp5width, 20.0))
            slider5Label.text = "Compassionate"
            slider5Label.backgroundColor = UIColor.clearColor()
            slider5Label.font = UIFont(name: "HelveticaNeue-Bold", size: 15*UIScreen.mainScreen().bounds.size.width/414)
            slider5Label.textColor = UIColor.whiteColor()
            slider5Label.textAlignment = .Center
            slider5Label.layer.borderColor = UIColor.redColor().CGColor
            slider5Label.layer.borderWidth = 2.0
            slider5Label.layer.cornerRadius = 8.0
            
            carouselView.addSubview(sliderLabel)
            carouselView.addSubview(slider2Label)
            carouselView.addSubview(slider3Label)
            carouselView.addSubview(slider4Label)
            carouselView.addSubview(slider5Label)
        }
        
        if labelValue == "Emotional Quotient" {
            var slider: UISlider = UISlider(frame: CGRectMake(75, 90, width-140, 20.0))
            slider.addTarget(self, action: "sliderAction:", forControlEvents: .ValueChanged)
            slider.backgroundColor = UIColor.clearColor()
            slider.minimumValue = 0.0
            slider.maximumValue = 100.0
            slider.continuous = true
            slider.value = 0
            slider.setValue(Float(loggedInUser.personalityData.traits!.openness!.opennessValue), animated: true)
            slider.userInteractionEnabled = false
            slider.tintColor = UIColor.redColor()
            //slider.thumbTintColor =
            
            var slider2: UISlider = UISlider(frame: CGRectMake(75, 125, width-140, 20.0))
            slider2.addTarget(self, action: "sliderAction:", forControlEvents: .ValueChanged)
            slider2.backgroundColor = UIColor.clearColor()
            slider2.minimumValue = 0.0
            slider2.maximumValue = 100.0
            slider2.continuous = true
            slider2.value = Float(loggedInUser.personalityData.traits!.conscientiousness!.conscientiousnessValue)
            slider2.userInteractionEnabled = false
            slider2.tintColor = UIColor.redColor()
            
            var slider3: UISlider = UISlider(frame: CGRectMake(75, 160, width-140, 20.0))
            slider3.addTarget(self, action: "sliderAction:", forControlEvents: .ValueChanged)
            slider3.backgroundColor = UIColor.clearColor()
            slider3.minimumValue = 0.0
            slider3.maximumValue = 100.0
            slider3.continuous = true
            slider3.value = Float(loggedInUser.personalityData.traits!.agreeableness!.agreeablenessValue)
            slider3.userInteractionEnabled = false
            slider3.tintColor = UIColor.redColor()
            
            var slider4: UISlider = UISlider(frame: CGRectMake(75, 195, width-140, 20.0))
            slider4.addTarget(self, action: "sliderAction:", forControlEvents: .ValueChanged)
            slider4.backgroundColor = UIColor.clearColor()
            slider4.minimumValue = 0.0
            slider4.maximumValue = 100.0
            slider4.continuous = true
            slider4.value = Float(loggedInUser.personalityData.traits!.extraversion!.extraversionValue)
            slider4.userInteractionEnabled = false
            slider4.tintColor = UIColor.redColor()
            
            var slider5: UISlider = UISlider(frame: CGRectMake(75, 230, width-140, 20.0))
            slider5.addTarget(self, action: "sliderAction:", forControlEvents: .ValueChanged)
            slider5.backgroundColor = UIColor.clearColor()
            slider5.minimumValue = 0.0
            slider5.maximumValue = 100.0
            slider5.continuous = true
            slider5.value = Float(loggedInUser.personalityData.traits!.neuroticism!.neuroticismValue)
            slider5.userInteractionEnabled = false
            slider5.tintColor = UIColor.redColor()
            
            var sliderLabel = UILabel(frame: CGRectMake(10, 90, width-120, 20.0))
            sliderLabel.text = "Cautious"
            sliderLabel.backgroundColor = UIColor.clearColor()
            sliderLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            sliderLabel.textColor = UIColor.whiteColor()
            
            var slider2Label = UILabel(frame: CGRectMake(10, 125, width-120, 20.0))
            slider2Label.text = "Organized"
            slider2Label.backgroundColor = UIColor.clearColor()
            slider2Label.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider2Label.textColor = UIColor.whiteColor()
            
            var slider3Label = UILabel(frame: CGRectMake(10, 160, width-120, 20.0))
            slider3Label.text = "Outgoing"
            slider3Label.backgroundColor = UIColor.clearColor()
            slider3Label.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider3Label.textColor = UIColor.whiteColor()
            
            var slider4Label = UILabel(frame: CGRectMake(10, 195, width-120, 20.0))
            slider4Label.text = "Sensitive"
            slider4Label.backgroundColor = UIColor.clearColor()
            slider4Label.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider4Label.textColor = UIColor.whiteColor()
            
            var slider5Label = UILabel(frame: CGRectMake(10, 230, width-120, 20.0))
            slider5Label.text = "Compassionate"
            slider5Label.backgroundColor = UIColor.clearColor()
            slider5Label.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider5Label.textColor = UIColor.whiteColor()
            
            ///
            var sliderLabelRight = UILabel(frame: CGRectMake(0, 90, width-10, 20.0))
            sliderLabelRight.text = "Curious"
            sliderLabelRight.backgroundColor = UIColor.clearColor()
            sliderLabelRight.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            sliderLabelRight.textColor = UIColor.whiteColor()
            sliderLabelRight.textAlignment = .Right
            
            var slider2LabelRight = UILabel(frame: CGRectMake(0, 125, width-10, 20.0))
            slider2LabelRight.text = "Easy Going"
            slider2LabelRight.backgroundColor = UIColor.clearColor()
            slider2LabelRight.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider2LabelRight.textColor = UIColor.whiteColor()
            slider2LabelRight.textAlignment = .Right
            
            var slider3LabelRight = UILabel(frame: CGRectMake(0, 160, width-10, 20.0))
            slider3LabelRight.text = "Reserved"
            slider3LabelRight.backgroundColor = UIColor.clearColor()
            slider3LabelRight.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider3LabelRight.textColor = UIColor.whiteColor()
            slider3LabelRight.textAlignment = .Right
            
            var slider4LabelRight = UILabel(frame: CGRectMake(0, 195, width-10, 20.0))
            slider4LabelRight.text = "Confident"
            slider4LabelRight.backgroundColor = UIColor.clearColor()
            slider4LabelRight.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider4LabelRight.textColor = UIColor.whiteColor()
            slider4LabelRight.textAlignment = .Right
            
            var slider5LabelRight = UILabel(frame: CGRectMake(0, 230, width-10, 20.0))
            slider5LabelRight.text = "Analytical"
            slider5LabelRight.backgroundColor = UIColor.clearColor()
            slider5LabelRight.font = UIFont(name: "HelveticaNeue-Bold", size: 12*UIScreen.mainScreen().bounds.size.width/414)
            slider5LabelRight.textColor = UIColor.whiteColor()
            slider5LabelRight.textAlignment = .Right
            
            carouselView.addSubview(slider)
            carouselView.addSubview(slider2)
            carouselView.addSubview(slider3)
            carouselView.addSubview(slider4)
            carouselView.addSubview(slider5)
            
            carouselView.addSubview(sliderLabel)
            carouselView.addSubview(slider2Label)
            carouselView.addSubview(slider3Label)
            carouselView.addSubview(slider4Label)
            carouselView.addSubview(slider5Label)
            
            carouselView.addSubview(sliderLabelRight)
            carouselView.addSubview(slider2LabelRight)
            carouselView.addSubview(slider3LabelRight)
            carouselView.addSubview(slider4LabelRight)
            carouselView.addSubview(slider5LabelRight)
            
            carouselView.addSubview(iconImage)
            carouselView.addSubview(label)
        } else {
            carouselView.addSubview(iconImage)
            //carouselView.addSubview(circle)
            carouselView.addSubview(percentage)
            carouselView.addSubview(label)
        }
    }
    
    //["Compromising", "Proud", "Independent", "Reserved", "Imaginative", "Self-focused", "Laid-back", "Philosophical", "Unstructured", "Calm-seeking", "Authority-challenging", "Adventurous", "Cautious of others", "Modest", "Carefree", "Achievement Striving", "Deliberate", "Persistent", "Self-doubting", "Content", "Self-controlled", "Confident", "Calm Under Pressure", "Not fiery", "Self-assured"]
    func multiTextCarousalView(path:String, width: CGFloat, height: CGFloat, imageIn: String, percentageValue: String, labelValue: String, texts: [String], carouselView: UIView){
        var widthRatio = UIScreen.mainScreen().bounds.size.width/414
        var heightRatio = UIScreen.mainScreen().bounds.size.height/736
        
        var iconImage = UIImageView(frame:CGRect(x:width/2-60*widthRatio/2, y:20*UIScreen.mainScreen().bounds.size.height/736, width:widthRatio*60, height:60*widthRatio))
        iconImage.image = UIImage(named: imageIn)
        var lineNumber = 0
        var textWidth = [CGFloat]()
        for (var i=0; i < texts.count; i++) {
            var label = UILabel(frame:CGRect(x:8*widthRatio, y:85*heightRatio, width:50*widthRatio, height:30*heightRatio))
            label.text = texts[i].stringByReplacingOccurrencesOfString(" ", withString: "")
            var temp = label.intrinsicContentSize().width*widthRatio + 8*widthRatio
            
            if i==0 {
                label = UILabel(frame:CGRect(x:8*widthRatio, y:85*heightRatio, width:temp, height:30*heightRatio))
                textWidth.append(temp+8*widthRatio)
            } else {
                var count = textWidth.count
                if textWidth[count-1]+8*widthRatio+temp > width {
                    var firstWidth = textWidth[count-1]+8*widthRatio
                    textWidth.removeAll()
                    lineNumber = lineNumber+1
                    if lineNumber >= 4 {
                        break
                    }
                    label = UILabel(frame:CGRect(x:8*widthRatio, y:85*heightRatio+40*heightRatio*CGFloat(lineNumber), width:temp, height:30*heightRatio))
                    textWidth.append(temp+8*widthRatio)
                } else {
                    var firstWidth = textWidth[count-1]+8*widthRatio
                    label = UILabel(frame:CGRect(x:textWidth[count-1]+8*widthRatio, y:85*heightRatio+40*heightRatio*CGFloat(lineNumber), width:temp, height:30*heightRatio))
                    textWidth.append(firstWidth+temp)
                }
            }
            
            label.backgroundColor = UIColor.clearColor()
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 14*UIScreen.mainScreen().bounds.size.width/414)
            label.textColor = UIColor.orangeColor()
            label.textAlignment = .Center
            label.text = texts[i]
            label.layer.borderColor = UIColor.orangeColor().CGColor
            label.layer.borderWidth = 2.0
            label.layer.cornerRadius = 8.0
            carouselView.addSubview(label)
        }
        var heightLabel = 40*UIScreen.mainScreen().bounds.size.height/736
        if path == "HOME" {
            heightLabel = 40*(UIScreen.mainScreen().bounds.size.height-49)/687
        }
        
        var label = UILabel(frame:CGRect(x:0, y:height-heightLabel, width:width, height:heightLabel))
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28*UIScreen.mainScreen().bounds.size.width/414)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = labelValue
        
        carouselView.addSubview(iconImage)
        carouselView.addSubview(label)
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
                        self.contact.backgroundImage = image
                        //self.profileBackgroundImage.image = image
                        self.profileBackgroundImage.image = self.contact.profileImage
                    }
                }
            }
        }
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
    
    
    override func touchesBegan(touches: Set<UITouch>,  withEvent event: UIEvent?) {
        if let touch = touches.first as UITouch! {
            if loggedInUser.signedInWith == "Google" || loggedInUser.signedInWith == "Twitter"{
                
                if let circle = touch.view as? CircleView {
                    if circle.frame.contains(self.openCircle.frame) {
                        var circleNameValues = [["Adventure":self.contact.personalityData.traits?.openness?.adventurousness],
                            ["Artistic":self.contact.personalityData.traits?.openness?.artisticInterests],
                            ["Emotional":self.contact.personalityData.traits?.openness?.emotionality],
                            ["Imagination":self.contact.personalityData.traits?.openness?.imagination],
                            ["Intellect":self.contact.personalityData.traits?.openness?.intellect],
                            ["Authority":self.contact.personalityData.traits?.openness?.liberalism]
                        ]
                        var message = "Openness is a general appreciation for art, emotion, adventure, unusual ideas, imagination, curiosity, and variety of experience. People who are open to experience are intellectually curious, open to emotion, sensitive to beauty and willing to try new things. They tend to be, when compared to closed people, more creative and more aware of their feelings. They are also more likely to hold unconventional beliefs."
                        if UIScreen.mainScreen().bounds.size.width > 320 {
                            if UIScreen.mainScreen().scale == 3 {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                            } else {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                            }
                        } else {
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.showInView(self.view, backgroundColor: "#F98A5F", withImage: UIImage(named: "Idea-100.png"), title: "Openness", withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                    if circle.frame.contains(self.conscientiousnessCircle.frame) {
                        var circleNameValues = [["Achievement":self.contact.personalityData.traits?.conscientiousness?.achievementStriving],
                            ["Cautious":self.contact.personalityData.traits?.conscientiousness?.cautiousness],
                            ["Dutiful":self.contact.personalityData.traits?.conscientiousness?.dutifulness],
                            ["Orderly":self.contact.personalityData.traits?.conscientiousness?.orderliness],
                            ["Discipline":self.contact.personalityData.traits?.conscientiousness?.selfDiscipline],
                            ["Efficacy":self.contact.personalityData.traits?.conscientiousness?.selfEfficacy]
                        ]
                        var message = "Conscientiousness is a tendency to show self-discipline, act dutifully, and aim for achievement against measures or outside expectations. It is related to the way in which people control, regulate, and direct their impulses. High scores on conscientiousness indicate a preference for planned rather than spontaneous behavior. The average level of conscientiousness rises among young adults and then declines among older adults."
                        if UIScreen.mainScreen().bounds.size.width > 320 {
                            if UIScreen.mainScreen().scale == 3 {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                            } else {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                            }
                        } else {
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.showInView(self.view, backgroundColor: "#77BA9B", withImage: UIImage(named: "Medal Filled-100.png"), title: "Conscientiuosness", withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                    if circle.frame.contains(self.extraversionCircle.frame) {
                        var circleNameValues = [["Activity":self.contact.personalityData.traits?.extraversion?.activityLevel],
                            ["Assertive":self.contact.personalityData.traits?.extraversion?.assertiveness],
                            ["Cheerful":self.contact.personalityData.traits?.extraversion?.cheerfulness],
                            ["Excitement":self.contact.personalityData.traits?.extraversion?.excitementSeeking],
                            ["Friendly":self.contact.personalityData.traits?.extraversion?.friendliness],
                            ["Gregarious":self.contact.personalityData.traits?.extraversion?.gregariousness]
                        ]
                        var message = "Extraversion is characterized by breadth of activities (as opposed to depth), surgency from external activity/situations, and energy creation from external means. The trait is marked by pronounced engagement with the external world. Extraverts enjoy interacting with people, and are often perceived as full of energy. They tend to be enthusiastic, action-oriented individuals. They possess high group visibility, like to talk, and assert themselves."
                        if UIScreen.mainScreen().bounds.size.width > 320 {
                            if UIScreen.mainScreen().scale == 3 {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                            } else {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                            }
                        } else {
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.showInView(self.view, backgroundColor: "#4A96AD", withImage: UIImage(named: "Talk-100.png"), title: "Extraversion",withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                    if circle.frame.contains(self.agreeablenessCircle.frame) {
                        var circleNameValues = [["Altruism":self.contact.personalityData.traits?.agreeableness?.altruism],
                            ["Cooperation":self.contact.personalityData.traits?.agreeableness?.cooperation],
                            ["Modesty":self.contact.personalityData.traits?.agreeableness?.modesty],
                            ["Morality":self.contact.personalityData.traits?.agreeableness?.morality],
                            ["Sympathy":self.contact.personalityData.traits?.agreeableness?.sympathy],
                            ["Trust":self.contact.personalityData.traits?.agreeableness?.trust]
                        ]
                        var message = "The agreeableness trait reflects individual differences in general concern for social harmony. Agreeable individuals value getting along with others. They are generally considerate, kind, generous, trusting and trustworthy, helpful, and willing to compromise their interests with others. Agreeable people also have an optimistic view of human nature."
                        if UIScreen.mainScreen().bounds.size.width > 320 {
                            if UIScreen.mainScreen().scale == 3 {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                            } else {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                            }
                        } else {
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.showInView(self.view, backgroundColor: "#BFAF80", withImage: UIImage(named: "Handshake-100.png"), title: "Agreeableness", withMessage: message,  circleNameValues: circleNameValues, animated: true)
                    }
                    if circle.frame.contains(self.emotionalRangeCircle.frame) {
                        var circleNameValues = [["Anger":self.contact.personalityData.traits?.neuroticism?.anger],
                            ["Anxiety":self.contact.personalityData.traits?.neuroticism?.anxiety],
                            ["Depression":self.contact.personalityData.traits?.neuroticism?.depression],
                            ["Excessive":self.contact.personalityData.traits?.neuroticism?.immoderation],
                            ["Conscious":self.contact.personalityData.traits?.neuroticism?.selfConsciousness],
                            ["Vulnerable":self.contact.personalityData.traits?.neuroticism?.vulnerability]
                        ]
                        var message = "Neuroticism is the tendency to experience negative emotions, such as anger, anxiety, or depression. It is sometimes called emotional instability, or is reversed and referred to as emotional stability. According to Eysenck's theory of personality, neuroticism is interlinked with low tolerance for stress or aversive stimuli. Those who score high in neuroticism are emotionally reactive and vulnerable to stress."
                        if UIScreen.mainScreen().bounds.size.width > 320 {
                            if UIScreen.mainScreen().scale == 3 {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                            } else {
                                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                            }
                        } else {
                            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                        }
                        self.popViewController.showInView(self.view, backgroundColor: "#6A8D9D", withImage: UIImage(named: "emotional.png"), title: "Emotional Range", withMessage: message, circleNameValues: circleNameValues,animated: true)
                    }
                }
            }
        }
        //super.touchesBegan(touches , withEvent:event)
    }
    
}