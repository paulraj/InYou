//
//  PopupViewController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 8/22/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation

class PopupViewController_User: UIViewController {
    
    @IBOutlet weak var viewObj: UIView!
    
    var circle1 = CircleView(frame: CGRectMake(3, 10, CGFloat(45), CGFloat(45)),color:UIColor.brownColor().CGColor)
    var circle2 = CircleView(frame: CGRectMake(53, 10, CGFloat(45), CGFloat(45)),color:UIColor.brownColor().CGColor)
    var circle3 = CircleView(frame: CGRectMake(103, 10, CGFloat(45), CGFloat(45)),color:UIColor.brownColor().CGColor)
    var circle4 = CircleView(frame: CGRectMake(153, 10, CGFloat(45), CGFloat(45)),color:UIColor.brownColor().CGColor)
    var circle5 = CircleView(frame: CGRectMake(203, 10, CGFloat(45), CGFloat(45)),color:UIColor.brownColor().CGColor)
    var circle6 = CircleView(frame: CGRectMake(253, 10, CGFloat(45), CGFloat(45)),color:UIColor.brownColor().CGColor)
    
    var circle1Label = ""
    var circle1Percentage = 0

    var circle2Label = ""
    var circle2Percentage = 0
    
    var circle3Label = ""
    var circle3Percentage = 0
    
    var circle4Label = ""
    var circle4Percentage = 0
    
    var circle5Label = ""
    var circle5Percentage = 0
    
    var circle6Label = ""
    var circle6Percentage = 0
    
    override func viewWillAppear(animated: Bool) {
        //self.viewObj.window!.frame = CGRect(x: 0, y: 0, width: 280, height: 100)
        self.view.backgroundColor = UIColor.grayColor()
    }
    
    override func viewDidAppear(animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCircleView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func addCircleView() {
        circle1.updateLabelInside(circle1Percentage,name: circle1Label)
        circle1.updateEndAngle(circle1Percentage)
        self.view.addSubview(circle1)
        circle1.animateCircle(1.0)
        
        circle2.updateLabelInside(circle2Percentage, name: circle2Label)
        circle2.updateEndAngle(circle2Percentage)
        self.view.addSubview(circle2)
        circle2.animateCircle(1.0)
        
        circle3.updateLabelInside(circle3Percentage,name: circle3Label)
        circle3.updateEndAngle(circle3Percentage)
        self.view.addSubview(circle3)
        circle3.animateCircle(1.0)
        
        circle4.updateLabelInside(circle4Percentage,name: circle4Label)
        circle4.updateEndAngle(circle4Percentage)
        self.view.addSubview(circle4)
        circle4.animateCircle(1.0)
        
        circle5.updateLabelInside(circle5Percentage,name: circle5Label)
        circle5.updateEndAngle(circle5Percentage)
        self.view.addSubview(circle5)
        circle5.animateCircle(1.0)
        
        circle6.updateLabelInside(circle6Percentage,name: circle6Label)
        circle6.updateEndAngle(circle6Percentage)
        self.view.addSubview(circle6)
        circle6.animateCircle(1.0)
    }
}


class ViewControllerTemplate: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}