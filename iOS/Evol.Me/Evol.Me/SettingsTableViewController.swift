//
//  SettingsViewController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 7/30/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import UIKit
import Social
import Contacts
import ContactsUI
import FBSDKLoginKit
import TwitterKit
import Fabric

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, CNContactViewControllerDelegate  {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var tableViewObject: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    //@IBOutlet weak var signOutButton: UIButton!
    
    var aboutCell: UITableViewCell = UITableViewCell()
    var inviteCell: UITableViewCell = UITableViewCell()
    //var shareCell: UITableViewCell = UITableViewCell()
    
    let picker = CNContactPickerViewController()
    
    let messageComposer = MessageComposer()
    let mailComposer = MailComposer()
    
    var countLabel = UILabel()
    
    var logoutCell: UITableViewCell = UITableViewCell()
    var mailsToAnalyzeCell: UITableViewCell = UITableViewCell()
    var analyzeOnWifiOnlyCell: UITableViewCell = UITableViewCell()
    
    var legalCell: UITableViewCell = UITableViewCell()
    var supportCell: UITableViewCell = UITableViewCell()
    
    var aboutText: UITextField = UITextField()
    var inviteText: UITextField = UITextField()
    var shareText: UITextField = UITextField()
    
    var mailsToAnalyzeText: UITextField = UITextField()
    var analyzeOnWifiOnlyText: UITextField = UITextField()
    
    var legalText: UITextField = UITextField()
    var supportText: UITextField = UITextField()
    
    var mailsToAnalyzeCount = 200
    var contactsType = ""
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.tableViewObject.rowHeight = 44.0
        
        self.tableViewObject.tableFooterView = UIView()
        
        
        self.title = "Settings"
        self.aboutCell.textLabel?.text = "About"
        self.aboutCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        //self.aboutCell.accessoryType = UITableViewCellAccessoryType.DetailButton
        
        self.inviteCell.textLabel?.text = "Tell a friend"
        self.inviteCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.inviteCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        //self.shareCell.textLabel?.text = "Share with your friends"
        //self.shareCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        //self.shareCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        self.logoutCell.textLabel?.text = "Logout"
        self.logoutCell.textLabel?.textColor = UIColor.redColor()
        self.logoutCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.logoutCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        //self.mailsToAnalyzeCell.textLabel?.text = "Mails to Analyze"
        //self.mailsToAnalyzeCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        //self.mailsToAnalyzeCell.tintColor = UIColor.redColor()
        //self.mailsToAnalyzeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        countLabel.text = String(mailsToAnalyzeCount)
        var width = CGFloat(50)
        countLabel.frame = CGRectMake(self.view.bounds.width-width-10, 10, width, 20)
        countLabel.textAlignment = NSTextAlignment.Right;
        countLabel.textColor = UIColor.blueColor()
        countLabel.adjustsFontSizeToFitWidth = true
            
        //countLabel.font = UIFont.boldSystemFontOfSize(15.0)
        //countLabel.textColor = UIColor.colorWithWhite(0.0, alpha: 0.5)
        //countLabel.backgroundColor = UIColor.clearColor()
        
        //self.mailsToAnalyzeCell.addSubview(countLabel)
            
        self.analyzeOnWifiOnlyCell.textLabel?.text = "Analyze on Wifi Only"
        self.analyzeOnWifiOnlyCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.analyzeOnWifiOnlyCell.accessoryType = UITableViewCellAccessoryType.None
        
        self.supportCell.textLabel?.text = "Support"
        self.supportCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.supportCell.accessoryType = UITableViewCellAccessoryType.DetailButton
        
        self.legalCell.textLabel?.text = "Legal"
        self.legalCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.legalCell.accessoryType = UITableViewCellAccessoryType.DetailButton
        //ParseAPIHandler().retrieveMatchingProfilesFromCloud(){ data,error in
        //    print("result came here.")
        //}
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Return the number of rows for each section in your static table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2    // section 0 has 2 rows
        //case 1: return 1// section 1 has 1 row
        //case 2: return 2// section 1 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.aboutCell   // section 0, row 0 is the first name
            case 1: return self.inviteCell    // section 0, row 1 is the last name
            //case 2: return self.shareCell    // section 0, row 1 is the last name
            default: fatalError("Unknown row in section 0")
            }
        /*case 1:
            switch(indexPath.row) {
            //case 0: return self.logoutCell
            //case 0: return self.mailsToAnalyzeCell       // section 1, row 0 is the share option
            case 0:
                var s: UISwitch = UISwitch()
                var switchSize: CGSize = s.sizeThatFits(CGSizeZero)
                s.frame = CGRectMake(analyzeOnWifiOnlyCell.contentView.bounds.size.width - switchSize.width - 5.0, (analyzeOnWifiOnlyCell.contentView.bounds.size.height - switchSize.height) / 2.0, switchSize.width, switchSize.height)
                s.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                s.setOn(loggedInUser.analyzeOnWifiOnly, animated: true)
                s.addTarget(self, action: "switchChanged:", forControlEvents: .ValueChanged)
                analyzeOnWifiOnlyCell.contentView.addSubview(s)
                return self.analyzeOnWifiOnlyCell       // section 1, row 0 is the share option
            default: fatalError("Unknown row in section 1")
            }*/
        /*case 2:
            switch(indexPath.row) {
            case 0: return self.supportCell       // section 1, row 0 is the share option
            case 1: return self.legalCell       // section 1, row 0 is the share option
            default: fatalError("Unknown row in section 1")
            }
            */
        default: fatalError("Unknown section")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewObject.frame = CustomUISize().getNewFrameWidthHeightForTable(self.tableViewObject.frame)
        self.versionLabel.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.versionLabel.frame)
        self.signOutButton.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.signOutButton.frame)
        //self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        //tableViewObject.backgroundColor = UIColor.lightGrayColor()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var title = self.tableView(tableView, titleForHeaderInSection: section)
        if (title == "") {
            return 0.0
        }
        return 44.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "General"
        //case 1: return "Account"
        //case 2: return "Support"
        default: fatalError("Unknown section")
        }
    }

    @IBAction func signOut(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let option0 = UIAlertAction(title: "Sign Out", style: UIAlertActionStyle.Destructive, handler:
            {(actionSheet: UIAlertAction!) in (
                self.signOutNow()
            )}
        )
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(option0)
        actionSheet.addAction(cancel)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func signOutNow(){
        self.view.addSubview(signingOut)
        if loggedInUser.signedInWith == "Google" {
            //print("signedInWithGoogle")
            GIDSignIn.sharedInstance().signOut()
            //print("Google logged out")
            self.cleanUpData()
        } else if loggedInUser.signedInWith  == "Facebook" {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            //print("Facebook logged out")
            self.cleanUpData()
        } else if loggedInUser.signedInWith == "Twitter" {
            Twitter.sharedInstance().logOut()
        }
        self.cleanUpData()
        //self.dismissViewControllerAnimated(true, completion: nil)
        signingOut.hide()
        performSegueWithIdentifier("login", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && indexPath.row == 0) {
            var title = "About"
            var message = "InYou App lets you discover yourself/your friend's true self, based on social media feed(Facebook/Twitter)."
            var actionTitle1 = "OK"
            
            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            //SCLAlertView().showInfo("About", subTitle: "InYou app is a personality finder app by analysing your emails.", closeButtonTitle: "Awesome")
        }
        /*if(indexPath.section == 1 && indexPath.row == 0) {
            GIDSignIn.sharedInstance().signOut()
            print("logged out")
            cleanUpData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }*/
        /*if(indexPath.section == 1 && indexPath.row == 0) {
            var alert = UIAlertController(title: "Mails to Analyze", message: "Enter number of emails to anayze.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = String(loggedInUser.mailsToAnalyze)
                textField.keyboardType = UIKeyboardType.NumberPad
            })
            
            alert.addAction(UIAlertAction(title: "Apply", style: .Default, handler:{ (action) in
                let textf = alert.textFields![0] as! UITextField
                let value = Int(textf.text!)
                if value == 0 {
                    SCLAlertView().showError("Mails Can't be Zero", subTitle: "Mails to analyze count can not be zero.", closeButtonTitle:"OK")
                } else {
                    self.mailsToAnalyzeCount = value!
                    self.countLabel.text = String(self.mailsToAnalyzeCount)
                    self.mailsToAnalyzeCell.addSubview(self.countLabel)
                    loggedInUser.mailsToAnalyze = value!
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }*/
        
        if(indexPath.section == 0 && indexPath.row == 1) {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let option0 = UIAlertAction(title: "Message", style: UIAlertActionStyle.Default, handler:
                {(actionSheet: UIAlertAction!) in ( self.openContacts(actionSheet.title!) )}
            )
            let option1 = UIAlertAction(title: "Mail", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!)in ( self.openContacts(actionSheet.title!))})
            let option2 = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.openContacts(actionSheet.title!))})
            let option3 = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.openContacts(actionSheet.title!))})
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            actionSheet.addAction(option0)
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(option3)
            actionSheet.addAction(cancel)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
            
        }
        if(indexPath.section == 2 && indexPath.row == 0) {
            //SCLAlertView().showInfo("Support", subTitle: "Support goes here.", closeButtonTitle: "OK")
        }
        if(indexPath.section == 2 && indexPath.row == 1) {
            //SCLAlertView().showInfo("Legal", subTitle: "Legal goes here.", closeButtonTitle: "OK")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func openContacts(option: String) {
        switch option  {
        case "Message":
            self.contactsType = option
            
            let contactPickerViewController = CNContactPickerViewController()
            if self.contactsType == "Message" {
                contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers != 0")
            }
            contactPickerViewController.delegate = self
            presentViewController(contactPickerViewController, animated: true, completion: nil)
            
            //self.performSegueWithIdentifier("iPhoneContacts", sender: self)
        case "Mail":
            self.contactsType = option
            let contactPickerViewController = CNContactPickerViewController()
            if self.contactsType == "Mail" {
                contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "emailAddresses != nil")
            }
            contactPickerViewController.delegate = self
            presentViewController(contactPickerViewController, animated: true, completion: nil)
            
            //self.performSegueWithIdentifier("iPhoneContacts", sender: self)
        case "Facebook":
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                controller.setInitialText("Please check out InYou app to discover yourself/your friend's true self, based on social media feed(Facebook/Twitter).\n"+"Download the app from app store https://appsto.re/us/ERzV-.i")
                self.presentViewController(controller, animated:true, completion:nil)
            } else {
                print("no Facebook account found on device")
            }
        case "Twitter":
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetSheet.setInitialText("Check out InYou app to discover yourself/your friends, based on social media feed(Facebook/Twitter).\n"+"Download  at https://appsto.re/us/ERzV-.i")
                
                self.presentViewController(tweetSheet, animated: true, completion: nil)
            } else {
                print("error")
            }
        default:
            print("")
        }
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! PhoneViewController
        destinationVC.contactsType = self.contactsType
    }
    */
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
            message: "You must give the app permission to add the contact first.",
            preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func switchChanged(sender: AnyObject) {
        var switcher: UISwitch = sender as! UISwitch
        var value: Bool = switcher.on
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()!
        
        if (reachability.currentReachabilityStatus == .ReachableViaWiFi) {
            //good
        } else if value == true {
            /*showQuestion("Not Connected to Wi-fi", message: "You are not connected to Wi-fi. Do you still want to analyze emails using data connection?", actionTitle1: "Yes", actionTitle2: "No")
            */
            var title = "Not Connected to Wi-fi"
            var message = "You are not connected to Wi-fi now. Do you still want to analyze emails using data connection?"
            var actionTitle1 = "Yes"
            var actionTitle2 = "No"
            
            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            var value = false
            alert.addAction(UIAlertAction(title: actionTitle1, style: .Default, handler: { index in
                loggedInUser.analyzeOnWifiOnly = false
                value = false
                switcher.setOn(false, animated: true)
            }))
            alert.addAction(UIAlertAction(title: actionTitle2, style: .Destructive, handler: { index in
                value = true
                 loggedInUser.analyzeOnWifiOnly = true
                 switcher.setOn(true, animated: true)
            }))
            if let data = userDefaults.objectForKey("loggedInUser") as? NSData {
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let loggedInUser = unarc.decodeObjectForKey("root") as! GoogleContact
                loggedInUser.analyzeOnWifiOnly = value
                userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(loggedInUser), forKey: "loggedInUser")
            }
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            loggedInUser.analyzeOnWifiOnly = false
        }
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    /*func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    // 1
                    print("Just denied")
                    self.displayCantAddContactAlert()
                } else {
                    // 2
                    print("Just authorized")
                    //self.addPetToContacts(petButton)
                }
            }
        }
    }
    */
    func cleanUpData() {
        loggedInUser.isLoggedIn = false
        loggedInUser = GoogleContact()
        
        googleContacts.removeAll()
        facebookContacts.removeAll()
        twitterContacts.removeAll()
        twitterFollowingContacts.removeAll()
        
        //globalGoogleContactsFinal.removeAll()
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    
    func showAlert(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showQuestion(title: String, message: String, actionTitle1: String, actionTitle2: String ){
    
    }
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        dismissViewControllerAnimated(true, completion: nil)
        //print(contact)
        if self.contactsType == "Message" {
            if (messageComposer.canSendText()) {
                let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                if contact.phoneNumbers.count != 0 {
                    var phoneNumber  = contact.phoneNumbers.first!.value as! CNPhoneNumber
                    var to = [phoneNumber.stringValue as! AnyObject]
                    messageComposeVC.recipients = to as? [String]
                    presentViewController(messageComposeVC, animated: true, completion: nil)
                } else {
                    let mailComposeVC = mailComposer.configuredMailComposeViewController()
                    var emailAddress  = contact.emailAddresses.first?.value
                    if emailAddress != nil {
                        var obj = [emailAddress as! AnyObject]
                        mailComposeVC.setToRecipients(obj as? [String])
                        presentViewController(mailComposeVC, animated: true, completion: nil)
                    } else {
                        print("Null email address")
                    }
                }
                
            } else {
                let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        }
        if self.contactsType == "Mail" {
            if (mailComposer.canSendMail()) {
                let mailComposeVC = mailComposer.configuredMailComposeViewController()
                
                if contact.emailAddresses.count != 0 {
                    var emailAddress  = contact.emailAddresses.first?.value
                    var obj = [emailAddress as! AnyObject]
                    mailComposeVC.setToRecipients(obj as? [String])
                    presentViewController(mailComposeVC, animated: true, completion: nil)
                } else {
                    var phoneNumber  = contact.phoneNumbers.first!.value as! CNPhoneNumber
                    if contact.phoneNumbers.count != 0 {
                        let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                        var to = [phoneNumber.stringValue as! AnyObject]
                        messageComposeVC.recipients = to as? [String]
                        presentViewController(messageComposeVC, animated: true, completion: nil)
                    } else {
                        print("phone number is null")
                    }
                }
            } else {
                let errorAlert = UIAlertView(title: "Cannot Send Mail Message", message: "Your device is not able to send mail messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        }
    }
}