//
//  Relationship.swift
//  InYou
//
//  Created by Paul.Raj on 9/1/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation

class RelationshipViewCell: UITableViewCell {
    var button: TKAnimatedCheckButton! = nil
    
    //@IBOutlet weak var radioButton: SSRadioButton!
    @IBOutlet weak var openTrait: UILabel!
    @IBOutlet weak var conTrait: UILabel!
    @IBOutlet weak var extraversionTrait: UILabel!
    @IBOutlet weak var emotionalTrait: UILabel!
    @IBOutlet weak var hedoTrait: UILabel!
    
    
    @IBOutlet weak var imageViewObj: UIImageView!

}

class RelationshipViewController:UIViewController {

    var contactImage = UIImage()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        leftImage.image = contactImage
        rightImage.image = loggedInUser.profileImage
        backgroundImage.image = UIImage(named: "bg_1.jpg")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageSize = 60 as CGFloat
        leftImage.layer.borderWidth = 1
        leftImage.layer.masksToBounds = false
        leftImage.layer.borderColor = UIColor.whiteColor().CGColor
        leftImage.layer.cornerRadius = leftImage.frame.height/2
        leftImage.clipsToBounds = true
        leftImage.userInteractionEnabled = true
        leftImage.multipleTouchEnabled = true
        
        rightImage.layer.borderWidth = 1
        rightImage.layer.masksToBounds = false
        rightImage.layer.borderColor = UIColor.whiteColor().CGColor
        rightImage.layer.cornerRadius = leftImage.frame.height/2
        rightImage.clipsToBounds = true
        rightImage.userInteractionEnabled = true
        rightImage.multipleTouchEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}