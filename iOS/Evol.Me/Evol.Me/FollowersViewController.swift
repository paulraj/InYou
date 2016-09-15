//
//  FolllowersViewController
//  InYou
//
//  Created by Paul.Raj on 7/17/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class FolllowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableViewObject: UITableView!
    //@IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var personalitySummary = ""
    var filteredContacts = [GoogleContact()]
    //var viewableContacts: [Dictionary<String, Any>] = []
    var selectedContact = GoogleContact()
    var selectedContactEmail = ""
    var selectedContactImage = UIImage()
    var selectedContactName = ""
    var selectedIndex = 0
    var tableContacts = [GoogleContact]()
    var pageNumber = 1
    
    /*lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    
    return refreshControl
    }()*/
    
    override func viewWillAppear(animated: Bool) {
        self.view.addSubview(loadingContacts)
        loadingContacts.show()
        
        switch loggedInUser.signedInWith {
        case "Google" :
            tableContacts = googleContacts
            self.loadContactsImage()
        case "Facebook" :
            tableContacts = facebookContacts
            self.loadContactsImage()
        case "Twitter" :
            tableContacts = twitterFollowerContacts
            self.loadContactsImage()
        default:
            print("signed with something else")
        }
        
        self.tableViewObject.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewObject.frame = CustomUISize().getNewFrameOnlyWidthHeight(self.tableViewObject.frame)
        //self.tableViewObject.addSubview(self.refreshControl)
        //UIScreen.mainScreen().bounds.size.height-16-44-44-49-self.tableViewObject.frame.height
        self.tableViewObject.frame = CGRectMake(self.tableViewObject.frame.minX , self.tableViewObject.frame.minY, self.tableViewObject.frame.width, UIScreen.mainScreen().bounds.size.height-16-44-44-49)
        if loggedInUser.signedInWith == "Google" {
            if googleContacts.count == 0 {
                var noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableViewObject.bounds.size.width, self.tableViewObject.bounds.size.height))
                noDataLabel.text = "No Contacts Available"
                noDataLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                
                noDataLabel.textColor = UIColor.grayColor()
                noDataLabel.textAlignment = NSTextAlignment.Center
                self.tableViewObject.backgroundView = noDataLabel
                self.tableViewObject.separatorStyle = .None
            } else {
                tableViewObject.backgroundColor = UIColor.grayColor()
            }
        } else  if loggedInUser.signedInWith == "Facebook" {
            //
            if facebookContacts.count == 0 {
                var noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableViewObject.bounds.size.width, self.tableViewObject.bounds.size.height))
                noDataLabel.text = "No Contacts Available"
                noDataLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                
                noDataLabel.textColor = UIColor.grayColor()
                noDataLabel.textAlignment = NSTextAlignment.Center
                self.tableViewObject.backgroundView = noDataLabel
                self.tableViewObject.separatorStyle = .None
            } else {
                self.tableViewObject.backgroundColor = UIColor.grayColor()
            }
            self.tableViewObject.reloadData()
        } else  if loggedInUser.signedInWith == "Twitter" {
            //
            if twitterFollowerContacts.count == 0 {
                var noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableViewObject.bounds.size.width, self.tableViewObject.bounds.size.height))
                noDataLabel.text = "No Contacts Available"
                noDataLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                
                noDataLabel.textColor = UIColor.grayColor()
                noDataLabel.textAlignment = NSTextAlignment.Center
                self.tableViewObject.backgroundView = noDataLabel
                self.tableViewObject.separatorStyle = .None
            } else {
                print("twitterFollowerContacts count "+String(twitterFollowerContacts.count))
                self.tableViewObject.backgroundColor = UIColor.grayColor()
            }
            self.tableViewObject.reloadData()
        }
        //print("contacts view loaded.")
    }
    
    func getAllContacts(){
        self.view.addSubview(retrievingContacts)
        retrievingContacts.show()
        if let hasContactsLoaded = userDefaults.objectForKey("hasContactsLoaded") as? Bool {
            if hasContactsLoaded {
                switch loggedInUser.signedInWith {
                case "Google" :
                    googleContacts.removeAll()
                    if let totalContacts = userDefaults.objectForKey("totalContacts") as? Int {
                        var i = 0
                        for (i=0; i<totalContacts; i++) {
                            if let data = userDefaults.objectForKey("googleContacts[\(i)]") as? NSData {
                                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                                let contact = unarc.decodeObjectForKey("root") as! GoogleContact
                                googleContacts.append(contact)
                            }
                        }
                    }
                case "Facebook" :
                    facebookContacts.removeAll()
                case "Twitter" :
                    twitterFollowerContacts.removeAll()
                    if let totalContacts = userDefaults.objectForKey("totalContacts") as? Int {
                        var i = 0
                        for (i=0; i<totalContacts; i++) {
                            if let data = userDefaults.objectForKey("twitterFollowerContacts[\(i)]") as? NSData {
                                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                                let contact = unarc.decodeObjectForKey("root") as! GoogleContact
                                twitterFollowerContacts.append(contact)
                            }
                        }
                    }
                default:
                    print("signed in with something else")
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
    
    func loadContactsImage(){
        //print("loadContactsImage")
        if let hasContactsImageLoaded = userDefaults.objectForKey("contactsImageLoaded") as? Bool {
            if hasContactsImageLoaded == true {
                //GoogleContactsAPIHandler().sortContacts()
                switch loggedInUser.signedInWith {
                case "Google":
                    GoogleContactsAPIHandler().loadContactImage(){ data, error in
                        //print("loadContactImage is complete.")
                        //self.filterContacts()
                        //GoogleContactsAPIHandler().sortContacts()
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                    }
                case "Facebook":
                    //print(facebookContacts)
                    FB().getFacebookContactImage(){ data, error in
                        //print("loadContactImage is complete for twitter.")
                        //self.filterContacts()
                        //GoogleContactsAPIHandler().sortContacts()
                        
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                        //Cache().updateTwitterImageInUserDefaults()
                    }
                    //print("no contacts")
                case "Twitter":
                    //print("contactsImageLoaded loaded but false")
                    TwitterAPIHandler().getTwitterContactImage(twitterFollowerContacts){ data, error in
                        //print("loadContactImage is complete.")
                        //self.filterContacts()
                        //GoogleContactsAPIHandler().sortContacts()
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                        //Cache().updateTwitterImageInUserDefaults()
                    }
                default:
                    print("")
                }
            } else {
                /*GoogleContactsAPIHandler().getMailCount(){ data, error in
                print("getMailCount is complete.")
                
                }*/
                switch loggedInUser.signedInWith {
                case "Google":
                    GoogleContactsAPIHandler().loadContactImage(){ data, error in
                        //print("loadContactImage is complete.")
                        //self.filterContacts()
                        //GoogleContactsAPIHandler().sortContacts()
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                    }
                case "Facebook":
                    //print(facebookContacts)
                    FB().getFacebookContactImage(){ data, error in
                        //print("loadContactImage is complete for twitter.")
                        //self.filterContacts()
                        //GoogleContactsAPIHandler().sortContacts()
                        
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                        //Cache().updateTwitterImageInUserDefaults()
                    }
                    //print("no contacts")
                case "Twitter":
                    //print("contactsImageLoaded loaded but false")
                    TwitterAPIHandler().getTwitterContactImage(twitterFollowerContacts){ data, error in
                        //print("loadContactImage is complete.")
                        //self.filterContacts()
                        //GoogleContactsAPIHandler().sortContacts()
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                        //Cache().updateTwitterImageInUserDefaults()
                    }
                default:
                    print("")
                }
                
                /*GPlusAPIHandler().loadGooglePlusContactImage(){ data, error in
                print("loadGooglePlusContactImage is complete.")
                ProgressHUD(text: "Syncing Phone Contacts...").show()
                self.syncPhoneContacts(){ data, error in
                ProgressHUD(text: "Syncing Phone Contacts...").hide()
                self.tableViewObject.reloadData()
                }
                //self.filterContacts()
                GoogleContactsAPIHandler().sortContacts()
                self.loadingContacts.hide()
                self.tableViewObject.reloadData()
                }*/
            }
        } else {
            /*GoogleContactsAPIHandler().getMailCount(){ data, error in
            print("getMailCount is complete.")
            }*/
            switch loggedInUser.signedInWith {
            case "Google":
                GoogleContactsAPIHandler().loadContactImage(){ data, error in
                    //print("loadContactImage is complete.")
                    //self.filterContacts()
                    //GoogleContactsAPIHandler().sortContacts()
                    loadingContacts.hide()
                    self.tableViewObject.reloadData()
                }
            case "Facebook":
                //print("facebook contacts")
                FB().getFacebookContactImage(){ data, error in
                    //print("loadContactImage is complete for twitter.")
                    //self.filterContacts()
                    //GoogleContactsAPIHandler().sortContacts()
                    
                    loadingContacts.hide()
                    self.tableViewObject.reloadData()
                    //Cache().updateTwitterImageInUserDefaults()
                }
            case "Twitter":
                //print("contactsImageLoaded not loaded")
                TwitterAPIHandler().getTwitterContactImage(twitterFollowerContacts){ data, error in
                    //print("loadContactImage is complete for twitter.")
                    //self.filterContacts()
                    //GoogleContactsAPIHandler().sortContacts()
                    
                    loadingContacts.hide()
                    self.tableViewObject.reloadData()
                    //Cache().updateTwitterImageInUserDefaults()
                }
            default:
                print("")
            }
            /*GPlusAPIHandler().loadGooglePlusContactImage(){ data, error in
            print("loadGooglePlusContactImage is complete.")
            //self.filterContacts()
            print("loadGooglePlusContactImage is complete.")
            ProgressHUD(text: "Syncing Phone Contacts...").show()
            self.syncPhoneContacts(){ data, error in
            ProgressHUD(text: "Syncing Phone Contacts...").hide()
            self.tableViewObject.reloadData()
            }
            GoogleContactsAPIHandler().sortContacts()
            self.loadingContacts.hide()
            self.tableViewObject.reloadData()
            }*/
        }
        //dispatch_async(dispatch_get_main_queue(), {
        self.tableViewObject.reloadData()
        //})
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var widthRatio = UIScreen.mainScreen().bounds.size.width/414
        var heightRatio = UIScreen.mainScreen().bounds.size.height/736
        
        return 60.0*heightRatio;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredContacts.count
        } else {
            return tableContacts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        var widthRatio = UIScreen.mainScreen().bounds.size.width/414
        var heightRatio = UIScreen.mainScreen().bounds.size.height/736
        //-20*heightRatio/4
        var label1: UILabel = UILabel()
        if UIScreen.mainScreen().bounds.size.height == 736 {
            label1 = UILabel(frame: CGRectMake(tableView.frame.width - 90*widthRatio, cell.frame.height/2-3, 60*widthRatio, 20))
        } else if UIScreen.mainScreen().bounds.size.height == 667 {
            label1 = UILabel(frame: CGRectMake(tableView.frame.width - 90*widthRatio, cell.frame.height/2-6, 60*widthRatio, 20))
        } else if UIScreen.mainScreen().bounds.size.height == 568 {
            label1 = UILabel(frame: CGRectMake(tableView.frame.width - 90*widthRatio, cell.frame.height/2-9, 60*widthRatio, 20))
        }
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            var email = filteredContacts[indexPath.row].email
            var name = filteredContacts[indexPath.row].name
            cell.textLabel!.text = name.isEmpty ? email: name
            cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: cell.textLabel!.font.pointSize*widthRatio)
            if let image = filteredContacts[indexPath.row].profileImage as UIImage! {
                //if loggedInUser.signedInWith == "Facebook" {
                cell.imageView!.image = image
                //} else {
                //    cell.imageView!.image = cropToBounds(image, width: image.size.width, height:image.size.height)
                //}
            } else {
                cell.imageView!.image = UIImage(named: "default_avatar.png")!
            }
            
            if filteredContacts[indexPath.row].inviteSent {
                label1.text = "Invited"
                label1.font = UIFont(name: "HelveticaNeue-Bold", size: 14*widthRatio)
                label1.textAlignment = .Center
                label1.layer.borderColor = UIColor.greenColor().CGColor
                label1.layer.borderWidth = 2.0
                label1.layer.cornerRadius = 4.0
                label1.textColor = UIColor.greenColor()
                cell.addSubview(label1)
            } else if let count = filteredContacts[indexPath.row].twitterTotalTweets as Int! {
                var countString = String(count)
                label1.font = UIFont(name: "HelveticaNeue", size: 11*widthRatio)
                label1.textAlignment = .Right
                var textHeight = label1.intrinsicContentSize().height
                //label1 = UILabel(frame: CGRectMake(label1.frame.minX, label1.frame.midY-textHeight/2, label1.frame.width, textHeight))
                
                if count > 0 {
                    label1.text = countString + " tweets"
                }
                cell.addSubview(label1)
            }
            
            let imageSize = 60*widthRatio as CGFloat
            cell.imageView!.layer.cornerRadius = imageSize / 2.0
            cell.imageView!.clipsToBounds = true
            var location = filteredContacts[indexPath.row].location
            //if  !location.isEmpty {
            //    cell.detailTextLabel!.text = location
            //}
            var strength = filteredContacts[indexPath.row].personalityData.strengths
            if  !strength.isEmpty {
                cell.detailTextLabel!.text = strength[0]+", "+strength[1]+", "+strength[2]
                cell.detailTextLabel!.font = UIFont(name: "HelveticaNeue", size: cell.detailTextLabel!.font.pointSize*widthRatio)
            }
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            print(tableContacts[indexPath.row].name)
            print("name")
            var email = tableContacts[indexPath.row].email
            var name = tableContacts[indexPath.row].name
            cell.textLabel!.text = name.isEmpty ? email: name
            cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: cell.textLabel!.font.pointSize*widthRatio)
            if let image = tableContacts[indexPath.row].profileImage as UIImage! {
                if loggedInUser.signedInWith == "Facebook" {
                    cell.imageView!.image = image
                } else {
                    cell.imageView!.image = cropToBounds(image, width: image.size.width, height:image.size.height)
                }
            } else {
                cell.imageView!.image = UIImage(named: "default_avatar.png")!
            }
            if tableContacts[indexPath.row].inviteSent {
                //label1.text = "Invited"
                //var textHeight = label1.intrinsicContentSize().height
                //label1 = UILabel(frame: CGRectMake(label1.frame.minX, label1.frame.midY-textHeight/2, label1.frame.width, textHeight))
                label1.text = "Invited"
                label1.font = UIFont(name: "HelveticaNeue-Bold", size: 14*widthRatio)
                label1.textAlignment = .Center
                label1.layer.borderColor = UIColor.greenColor().CGColor
                label1.layer.borderWidth = 2.0
                label1.layer.cornerRadius = 4.0
                label1.textColor = UIColor.greenColor()
                cell.addSubview(label1)
                
            } else if let count = tableContacts[indexPath.row].twitterTotalTweets as Int! {
                //self.contact.twitterTotalTweets = count
                
                var countString = String(count)
                //var textHeight = label1.intrinsicContentSize().height
                //print("textHeight")
                //print(textHeight)
                //label1 = UILabel(frame: CGRectMake(label1.frame.minX, label1.frame.midY-textHeight/2, label1.frame.width, textHeight))
                label1.font = UIFont(name: "HelveticaNeue", size: 11*widthRatio)
                
                label1.textAlignment = .Right
                
                if count > 0 {
                    label1.text = countString + " tweets"
                }
                //else {
                //    label1.text = "No emails"
                //}
                cell.addSubview(label1)
            }
            
            let imageSize = 60*widthRatio as CGFloat
            //cell.imageView!.layer.cornerRadius = (imageSize*imageWidth)/(imageHeight * 2.0)
            cell.imageView!.layer.cornerRadius = imageSize/2.0
            
            cell.imageView!.frame.size = CGSize(width: 60, height: 60)
            cell.imageView!.clipsToBounds = true
            //cell.imageView!.layer.masksToBounds = true
            
            var location = tableContacts[indexPath.row].location
            //if  !location.isEmpty {
            //        cell.detailTextLabel!.text = location
            //}
            var strength = tableContacts[indexPath.row].personalityData.strengths
            if  !strength.isEmpty {
                cell.detailTextLabel!.text = strength[0]+", "+strength[1]+", "+strength[2]
                cell.detailTextLabel!.font = UIFont(name: "HelveticaNeue", size: cell.detailTextLabel!.font.pointSize*widthRatio)
            }
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        var contact = tableContacts[row]
        if tableView == self.searchDisplayController!.searchResultsTableView {
            contact = self.filteredContacts[row]
        } else {
            contact  = tableContacts[row]
        }
        selectedContact = contact
        //self.callFullContactAPI(contact)
        selectedIndex = row
        self.performSegueWithIdentifier("contactDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //print(indexPath.row)
        
        switch loggedInUser.signedInWith {
        case "Google" :
            print("Google")
            //tableContacts = googleContacts
            //self.loadContactsImage()
        case "Facebook" :
            print("Google")
            //tableContacts = facebookContacts
            //self.loadContactsImage()
        case "Twitter" :
            if indexPath.row == 24*pageNumber {
                loadingContacts.show()
                TwitterAPIHandler().getFollowerslistWithUserId(loggedInUser.twitterFollowersListCursor) { data, error in
                    self.tableContacts = twitterFollowerContacts
                    TwitterAPIHandler().getTwitterContactImage(twitterFollowerContacts, pageNumber: self.pageNumber){ data, error in
                        //print("loadContactImage is complete for twitter.")
                        //self.filterContacts()
                        loadingContacts.hide()
                        self.tableViewObject.reloadData()
                        //self.refreshControl.endRefreshing()
                        //Cache().updateTwitterImageInUserDefaults()
                    }
                }
                pageNumber++
            }
        default:
            print("signed with something else")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! ContactDetailsViewController
        destinationVC.contact = selectedContact
        destinationVC.index = selectedIndex
    }
    
    func showError(title: String, message: String, actionTitle: String ){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredContacts = []
        
        
        for contact in tableContacts {
            var email: String = contact.email
            if let textRange = email.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                filteredContacts.append(contact)
                continue
            }
            var firstname = contact.firstName
            if let textRange = firstname.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                filteredContacts.append(contact)
                continue
            }
            var lastname = contact.lastName
            var name = contact.name
            if let textRange = name.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                filteredContacts.append(contact)
                continue
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    /*
    func syncPhoneContacts(completionHandler: (data: String?, error: NSError?) -> ()){
    swiftAddressBook?.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
    if b {
    var people = swiftAddressBook!.allPeople!
    var phoneContactsCount = people.count
    for (var i = 0; i<phoneContactsCount; i++)  {
    if (people[i].image != nil && people[i].emails?.count != 0) {
    var emailsCount = people[i].emails?.count
    for (var p = 0; p < emailsCount; p++)  {
    var phoneContactEmail =  people[i].emails?[p].value.uppercaseString
    var googleContactsCount = googleContacts.count
    for (var j = 0; j<googleContactsCount;j++) {
    if !googleContacts[j].email.isEmpty {
    if googleContacts[j].email.uppercaseString == phoneContactEmail {
    print("contact Matched for "+phoneContactEmail!)
    if people[i].birthday != nil {
    googleContacts[j].birthday = people[i].birthday!
    }
    if people[i].instantMessage?.first!.value != nil {
    var instantMsgsCount = people[i].instantMessage?.count
    for (var y = 0; y < instantMsgsCount; y++){
    print(people[i].instantMessage?[y].value)
    }
    }
    if people[i].jobTitle != nil {
    googleContacts[j].jobTitle = people[i].jobTitle!
    }
    if people[i].organization != nil {
    googleContacts[j].organization = people[i].organization!
    }
    if people[i].addresses?.first?.value != nil{
    print("Addresses")
    var addressesCount = people[i].addresses?.count
    for (var x = 0; x < addressesCount; x++){
    print(people[i].addresses?[x].value)
    print(people[i].addresses?[x].label)
    print(people[i].addresses?[x].id)
    }
    }
    if people[i].department != nil {
    print(people[i].department)
    }
    if people[i].socialProfiles?.first?.value != nil {
    print("Social Profiles")
    var socialProfilesCount = people[i].socialProfiles?.count
    for (var m=0; m<socialProfilesCount; m++){
    print(people[i].socialProfiles?[m].value)
    print(people[i].socialProfiles?[m].label)
    print(people[i].socialProfiles?[m].id)
    }
    }
    
    if people[i].urls?.first?.value != nil {
    print("Urls")
    var urlsCount = people[i].urls?.count
    for (var m = 0; m < urlsCount; m++){
    print(people[i].urls?[m].value)
    print(people[i].urls?[m].label)
    print(people[i].urls?[m].id)
    }
    }
    
    var defaultImageData = UIImagePNGRepresentation(UIImage(named: "default_avatar.png")!)
    var contactImageData = UIImagePNGRepresentation(googleContacts[j].profileImage)
    if contactImageData!.isEqualToData(defaultImageData!) {
    print(googleContacts[j].email)
    googleContacts[j].profileImage = people[i].image
    print("Contact matched. Image synced.")
    }
    userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(googleContacts[j]), forKey: "googleContacts[\(j)]")
    }
    }
    }
    }
    }
    }
    userDefaults.setObject(true, forKey: "phoneContactsLoaded")
    completionHandler(data: "", error:nil)
    }
    }
    }*/
    /* func callFullContactAPI(contact: GoogleContact){
    print("calling Full Contact API")
    FullContactAPI().getByEmail(contact.email) { data, error in
    print(data)
    let json = JSON(data!)
    if (json["contactInfo"]){
    contact.familyName = json["contactInfo"]["familyName"].stringValue
    contact.givenName = json["contactInfo"]["givenName"].stringValue
    contact.name = json["contactInfo"]["fullName"].stringValue
    }
    if (json["socialProfiles"].count != 0 ){
    for (index: String, profile: JSON) in json["socialProfiles"] {
    if (profile["type"] == "twitter") {
    var id = profile["id"].stringValue
    KloutAPIHandler().getKloutScoreByTwitter(id) { data, error in
    let json = JSON(data!)
    contact.popularityScore = (json["score"].stringValue as NSString).substringWithRange(NSRange(location: 0, length: 2))
    }
    }
    if (profile["type"] == "googleplus") {
    var id = profile["id"].stringValue
    KloutAPIHandler().getKloutScoreByGoogle(id) { data, error in
    let json = JSON(data!)
    if (json["score"].stringValue > contact.popularityScore) {
    contact.popularityScore = (json["score"].stringValue as NSString).substringWithRange(NSRange(location: 0, length: 2))
    }
    }
    }
    }
    }
    }
    }
    */
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}