//
//  TableViewController.swift
//  Test
//
//  Created by Socialbit - Tassilo Karge on 14.02.15.
//  Copyright (c) 2015 socialbit. All rights reserved.
//

import UIKit
import SwiftAddressBook
import AddressBook

class TableViewController: UITableViewController {

    
    var groups : [SwiftAddressBookGroup]? = []
    var people : [SwiftAddressBookPerson]? = []
    var names : [String?]? = []
    var numbers : [Array<String?>?]? = []
    var birthdates : [NSDate?]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftAddressBook?.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
            if b {
                
                //to test adding a new person uncomment the following 

				/*
                var person = SwiftAddressBookPerson.create()
                person.firstName = "newTestuserFirstname"
                person.lastName = "newTestuserLastname"
                person.organization = "newTestuserCompanyname"
                
                var phone = MultivalueEntry(value: "newTestuserNumber", label: "mobile", id: 1)
                person.phoneNumbers = [phone]

				var addresses : Array<MultivalueEntry<Dictionary<SwiftAddressBookAddressProperty,AnyObject>>>? = nil
				let address1 = [SwiftAddressBookAddressProperty.street:"testStreet" as AnyObject, SwiftAddressBookAddressProperty.city:"testCity"];
				let address2 = [SwiftAddressBookAddressProperty.street:"testStreet2" as AnyObject, SwiftAddressBookAddressProperty.city:"testCity2"];
				addresses = [MultivalueEntry(value: address1, label: kABWorkLabel, id: 0),MultivalueEntry(value: address2, label: kABHomeLabel, id: 0)];

				person.addresses = addresses;
                
                swiftAddressBook?.addRecord(person)
                swiftAddressBook?.save()
				*/


                self.people = swiftAddressBook?.allPeople
                
                //to test adding a new group uncomment the following
                /*
                var group = SwiftAddressBookGroup.create()
                
                group.name = "Testgroup"
                
                swiftAddressBook?.addRecord(group)
                
                //it is necessary to save before adding people
                swiftAddressBook?.save()
                
                //add every second person
                for var i = 0; i < self.people?.count; i += 2 {
                    group.addMember(self.people![i])
                }
                
                swiftAddressBook?.save()
                */

                
                //save objects for tableview
                
                let sources = swiftAddressBook?.allSources
                for source in sources! {
                    //println("\(source.sourceName)") //TODO: This throws an exception
                    let newGroups = swiftAddressBook!.allGroupsInSource(source)!
                    self.groups = self.groups! + newGroups
                }
                
                self.numbers = self.people?.map { (p) -> (Array<String?>?) in
                    return p.phoneNumbers?.map { return $0.value }
                }
                self.names = self.people?.map { (p) -> (String?) in
                    return p.compositeName
                }
                self.birthdates = self.people?.map { (p) -> (NSDate?) in
                    return p.birthday
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groups == nil ? 1 : groups!.count+1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if groups == nil || section == groups?.count {
            return people == nil ? 0 : people!.count
        }
        else {
            if let members = groups![section].allMembers {
                return members.count
            }
            else {
                return 0
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("addressCell", forIndexPath: indexPath) as! AddressViewCell
        
        if groups == nil || indexPath.section == groups?.count {
            // Configure the cell...
            cell.nameLabel.text = people![indexPath.row].compositeName
            cell.birthdateLabel.text = birthdates![indexPath.row]?.description
            cell.phoneNumberLabel.text = numbers![indexPath.row]?.first!
        }
        else {
            cell.nameLabel.text = groups![indexPath.section].allMembers![indexPath.row].compositeName
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if groups == nil || section == groups?.count {
            return "All people"
        }
        else {
            return groups![section].name
        }
    }

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

}
