//
//  PersonalityViewController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 6/25/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation

class PersonalityViewController: UIViewController {
    
    var personalityTitle: String = "Your Personality"
    
    @IBOutlet weak var personalityText: UITextView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var _personalityText:String = "Your personality goes here."
    
    @IBAction func shareButtonClicked(sender: UIBarButtonItem) {
        
        let textToShare = self.personalityText.text
        //let google:NSURL = NSURL(string:"http://google.com/")!
        let url = NSBundle.mainBundle().URLForResource("", withExtension:"png")!
        let activityVC = UIActivityViewController(activityItems: [url,textToShare], applicationActivities: nil)
        //activityVC.excludedActivityTypes =  [UIActivityTypePrint]
        activityVC.excludedActivityTypes = [
            UIActivityTypePostToWeibo
        ]
        /*
        activityVC.completionWithItemsHandler = {(activityType: String!, completed: Bool, arrayOptions: [AnyObject]!, error: NSError!) in
            println(activityType)
        }
        */
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleOAuth().refreshAccessToken(){ data, error in
            //print("Access token is refreshed now.")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        personalityText.text = _personalityText
       navBar.topItem!.title = personalityTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
     self.dismissViewControllerAnimated(true, completion: nil)
    }
}