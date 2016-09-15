//
//  TableViewController.swift
//  Test
//
//  Created by Socialbit - Tassilo Karge on 14.02.15.
//  Copyright (c) 2015 socialbit. All rights reserved.
//

import UIKit
import Social
import Contacts
import ContactsUI

class AddressViewCell: UITableViewCell{
    var button: TKAnimatedCheckButton! = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var imageViewObj: UIImageView!
    
    //@IBOutlet weak var checkButton: TKAnimatedCheckButton!
    
    //var radioButtonController: SSRadioButtonsController? = SSRadioButtonsController()
    
    /*init(){
        self.checkButton.color = UIColor.redColor().CGColor
        self.checkButton.skeletonColor = UIColor.blueColor().CGColor
    }*/
    
    /*
    init(){
        super.init()
        radioButtonController = SSRadioButtonsController(buttons: radioButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
    }*/
}
/*
protocol PhoneViewControllerDelegate {
    func didFetchContacts(contacts: [CNContact])
}
*/
class PhoneViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate  {

    @IBOutlet var tableViewObject: UITableView!
    var contacts = [CNContact]()
    private var addressBookStore: CNContactStore!
    private var menuArray: NSMutableArray?
    let picker = CNContactPickerViewController()
    
    var store = CNContactStore()
    
    //var delegate: PhoneViewControllerDelegate!
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func inviteAction(sender: AnyObject) {
        
        if self.contactsType == "Message" {
            if (messageComposer.canSendText()) {
                let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                var phoneNumbers  = ""
                for contact in selectedContacts {
                    phoneNumbers =  (contact.phoneNumbers.first!.value as! String) + " ; " + phoneNumbers
                }
                var to = [phoneNumbers as AnyObject]
                messageComposeVC.recipients = to as? [String]
                presentViewController(messageComposeVC, animated: true, completion: nil)
            } else {
                let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        }
        if self.contactsType == "Mail" {
            if (mailComposer.canSendMail()) {
                let mailComposeVC = mailComposer.configuredMailComposeViewController()
                var emailAddresses  = ""
                for contact in selectedContacts {
                    emailAddresses = (contact.emailAddresses.first!.value as! String) + " ; " + emailAddresses
                }
                var obj = [emailAddresses as AnyObject]
                mailComposeVC.setToRecipients(obj as? [String])
                presentViewController(mailComposeVC, animated: true, completion: nil)
            } else {
                let errorAlert = UIAlertView(title: "Cannot Send Mail Message", message: "Your device is not able to send mail messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
        }
    }
    
    //var groups : [SwiftAddressBookGroup]? = []
    //var people : [SwiftAddressBookPerson] = []
    //var phoneContacts : [SwiftAddressBookPerson] = []
    //var emailContacts : [SwiftAddressBookPerson] = []
    
    var phoneContacts = [CNContact]()
    var emailContacts = [CNContact]()
    
    //var filteredContacts : [SwiftAddressBookPerson] = []
    var filteredContacts = [CNContact]()
    
    //var selectedContacts : [SwiftAddressBookPerson] = []
    var selectedContacts = [CNContact]()
    
    var names : [String?]? = []
    var numbers : [Array<String?>?]? = []
    var birthdates : [NSDate?]? = []
    
    var contactsType = ""
    
    let messageComposer = MessageComposer()
    let mailComposer = MailComposer()
    
    //var image :  = []
    var emails : [Array<String?>?]? = []
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    /*
    func performDoneItemTap() {
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                var contacts = [CNContact]()
                
                let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
                
                do {
                    let contactStore = AppDelegate.getAppDelegate().contactStore
                    try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
                        contacts.append(contact)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate.didFetchContacts(contacts)
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                catch let error as NSError {
                    print(error.description, separator: "", terminator: "\n")
                }
            }
        }
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        //performDoneItemTap()
        //addressBookStore = CNContactStore()
        //checkContactsAccess();
        let contactPickerViewController = CNContactPickerViewController()
        
        if self.contactsType == "Message" {
            contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers != nil")
        }
        
        if self.contactsType == "Mail" {
            contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "emailAddresses != nil")
        }
            
        contactPickerViewController.delegate = self
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return groups == nil ? 1 : groups!.count+1
        return 1
    }
*/
    /*
    func refetchContact(contact contact: CNContact, atIndexPath indexPath: NSIndexPath) {
        
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                print("access granted now.")
                // let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
                let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
                
                do {
                    let contactRefetched = try AppDelegate.getAppDelegate().contactStore.unifiedContactWithIdentifier(contact.identifier, keysToFetch: keys)
                    self.contacts[indexPath.row] = contactRefetched
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableViewObject.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    })
                }
                catch {
                    print("Unable to refetch the contact: \(contact)", separator: "", terminator: "\n")
                }
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if groups == nil || section == groups?.count {
            return people == nil ? 0 : people!.count
        } else {
            if let members = groups![section].allMembers {
                return members.count
            }
            else {
                return 0
            }
        }*/
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredContacts.count
        } else {
            return contacts.count
        }
    }
    */
    /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableViewObject.dequeueReusableCellWithIdentifier("addressCell") as! AddressViewCell
       
        let currentContact = contacts[indexPath.row]
        
        // cell.lblFullname.text = "\(currentContact.givenName) \(currentContact.familyName)"
        cell.nameLabel.text = CNContactFormatter.stringFromContact(currentContact, style: .FullName)
        
        if !currentContact.isKeyAvailable(CNContactBirthdayKey) || !currentContact.isKeyAvailable(CNContactImageDataKey) ||  !currentContact.isKeyAvailable(CNContactEmailAddressesKey) {
            refetchContact(contact: currentContact, atIndexPath: indexPath)
        }
        else {
            var homePhoneNumber: String!
            for phoneNumber in currentContact.phoneNumbers {
                if phoneNumber.label == CNLabelHome {
                    homePhoneNumber = phoneNumber.description
                    break
                }
            }
            
            if homePhoneNumber != nil {
                cell.phoneNumberLabel.text = homePhoneNumber
            }
            
            
            // Set the contact image.
            if let imageData = currentContact.imageData {
                cell.imageViewObj?.image = UIImage(data: imageData)
            }
            
            // Set the contact's work email address.
            var homeEmailAddress: String!
            for emailAddress in currentContact.emailAddresses {
                if emailAddress.label == CNLabelHome {
                    homeEmailAddress = emailAddress.value as! String
                    break
                }
            }
            
            if homeEmailAddress != nil {
                cell.emailLabel.text = homeEmailAddress
            } else {
                cell.emailLabel.text = ""
            }
        }
        /*
        if tableView == self.searchDisplayController!.searchResultsTableView {
            if (filteredContacts[indexPath.row].compositeName != nil) {
                cell.nameLabel.text = filteredContacts[indexPath.row].compositeName
            } else {
                cell.nameLabel.text = ""
            }
            if self.contactsType == "Message" {
                cell.phoneNumberLabel.text = filteredContacts[indexPath.row].phoneNumbers?.first?.value
                cell.emailLabel.text = ""
            } else if self.contactsType == "Mail"  {
                cell.phoneNumberLabel.text = ""
                cell.emailLabel.text = filteredContacts[indexPath.row].emails?.first?.value
            }
            
            cell.imageViewObj?.image = filteredContacts[indexPath.row].image
            let imageSize = 30 as CGFloat
            cell.imageViewObj!.layer.cornerRadius = imageSize / 2.0
            cell.imageViewObj!.clipsToBounds = true
        } else {
            if self.contactsType == "Message" {
                if (people[indexPath.row].compositeName != nil) {
                    cell.nameLabel.text = phoneContacts[indexPath.row].compositeName
                } else {
                    cell.nameLabel.text = ""
                }
                    cell.phoneNumberLabel.text = phoneContacts[indexPath.row].phoneNumbers?.first?.value
                    cell.emailLabel.text = ""
                cell.imageViewObj?.image = phoneContacts[indexPath.row].image
            } else if self.contactsType == "Mail"  {
                if (people[indexPath.row].compositeName != nil) {
                    cell.nameLabel.text = emailContacts[indexPath.row].compositeName
                } else {
                    cell.nameLabel.text = ""
                }
                cell.phoneNumberLabel.text = ""
                cell.emailLabel.text = emailContacts[indexPath.row].emails?.first?.value
                cell.imageViewObj?.image = emailContacts[indexPath.row].image
            }
            
            let imageSize = 30 as CGFloat
            cell.imageViewObj!.layer.cornerRadius = imageSize / 2.0
            cell.imageViewObj!.clipsToBounds = true
        }*/
        //cell.backgroundColor = UIColor(red: 0.176471, green: 0.701961, blue: 0.203922, alpha: 1)
        //cell.accessoryType = UITableViewCellAccessoryType.None
        //cell.checkButton.frame = CGRectMake(0, 0, 30, 30)
        //cell.checkButton.color = UIColor.redColor().CGColor
        //cell.checkButton.skeletonColor = UIColor.blueColor().CGColor
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! AddressViewCell;
        
        //var cell = tableView.cellForRowAtIndexPath(indexPath) as! AddressViewCell
        let selectedContact = contacts[indexPath.row]
        let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        
        if selectedContact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
            let contactViewController = CNContactViewController(forContact: selectedContact)
            contactViewController.contactStore = AppDelegate.getAppDelegate().contactStore
            contactViewController.displayedPropertyKeys = keys
            navigationController?.pushViewController(contactViewController, animated: true)
        }
        else {
            AppDelegate.getAppDelegate().requestForAccess({ (accessGranted) -> Void in
                if accessGranted {
                    do {
                        let contactRefetched = try AppDelegate.getAppDelegate().contactStore.unifiedContactWithIdentifier(selectedContact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let contactViewController = CNContactViewController(forContact: contactRefetched)
                            contactViewController.contactStore = AppDelegate.getAppDelegate().contactStore
                            contactViewController.displayedPropertyKeys = keys
                            self.navigationController?.pushViewController(contactViewController, animated: true)
                        })
                    }
                    catch {
                        print("Unable to refetch the selected contact.", separator: "", terminator: "\n")
                    }
                }
            })
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60.0;
    }
    */
    /*
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*var title = self.tableView(tableView, titleForHeaderInSection: section)
        if (title == "") {
            return 0.0
        }*/
        return 60.0
    }
    */
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*
        if groups == nil || section == groups?.count {
            return "All Contacts"
        }
        else {
            return groups![section].name
        }*/
        return "Phone Contacts"
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

/*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
*/
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    /*
    func filterContentForSearchText(searchText: String) {
        filteredContacts = []
        if self.contactsType == "Message" {
            for contact in phoneContacts {
                if let name = contact.compositeName {
                    if let textRange = name.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                        self.filteredContacts.append(contact)
                    }
                } else if let phone = contact.phoneNumbers.first!.value as! String {
                    if let textRange = phone.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                        self.filteredContacts.append(contact)
                    }
                }
            }
        }
        if self.contactsType == "Mail" {
            for contact in emailContacts {
                if let name = contact.compositeName {
                    if let textRange = name.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                        self.filteredContacts.append(contact)
                    }
                } else if let email = (contact.emailAddresses.first!.value as! String?) {
                    if let textRange = email.uppercaseString.rangeOfString(searchText.uppercaseString)  {
                        self.filteredContacts.append(contact)
                    }
                }
            }
        }
    }
    */
    /*
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    */
    
    /*func didFetchContacts(contacts: [CNContact]) {
        for contact in contacts {
            self.contacts.append(contact)
        }
        //tableViewObject.reloadData()
    }*/

    func updateContact(contactIdentifier: String) {
        do {
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys()]
            let contact = try store.unifiedContactWithIdentifier(contactIdentifier, keysToFetch:keysToFetch)
            
            let contactToUpdate = contact.mutableCopy() as! CNMutableContact
            contactToUpdate.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: "+440987654321"))]
            
            let saveRequest = CNSaveRequest()
            saveRequest.updateContact(contactToUpdate)
            try store.executeSaveRequest(saveRequest)
        } catch let error{
            print(error)
        }
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        //self.didFetchContacts([contact])
        let Kontakte = contact
        //print(Kontakte)
        
        //dismissViewControllerAnimated(true, completion: {
            //print("dismissed now.")
            if self.contactsType == "Message" {
                if (self.messageComposer.canSendText()) {
                    let messageComposeVC = self.messageComposer.configuredMessageComposeViewController()
                    var phoneNumbers  = contact.phoneNumbers.first?.value
                    //print(phoneNumbers)
                    var to = [phoneNumbers as! AnyObject]
                    messageComposeVC.recipients = to as? [String]
                    presentViewController(messageComposeVC, animated: true, completion: nil)
                } else {
                    let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            }
            if self.contactsType == "Mail" {
                if (self.mailComposer.canSendMail()) {
                    let mailComposeVC = self.mailComposer.configuredMailComposeViewController()
                    var emailAddresses  = contact.emailAddresses.first?.value
                    
                    var obj = [emailAddresses as! AnyObject]
                    mailComposeVC.setToRecipients(obj as? [String])
                    presentViewController(mailComposeVC, animated: true, completion: nil)
                } else {
                    let errorAlert = UIAlertView(title: "Cannot Send Mail Message", message: "Your device is not able to send mail messages.", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            }
        //})
    //    navigationController?.popViewControllerAnimated(true)
    }
    /*
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatusForEntityType(.Contacts) {
            // Update our UI if the user has granted access to their Contacts
        case .Authorized:
            self.showContactsPicker()
            
            // Prompt the user for access to Contacts if there is no definitive answer
        case .NotDetermined :
            print("not known")
            self.requestContactsAccess()
            
            // Display a message if the user has denied or restricted access to Contacts
        case .Denied,
        .Restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                message: "Please Enable permission! in settings!.",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    private func requestContactsAccess() {
        addressBookStore.requestAccessForEntityType(.Contacts) {granted, error in
            if granted {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showContactsPicker()
                    return
                }
            } else {
                print("error")
                print(error)
            }
        }
    }
    */
    
    //Show Contact Picker
    /*private  func showContactsPicker() {
        picker.delegate = self
        self.presentViewController(picker , animated: true, completion: nil)
        
    }*/
    
}
