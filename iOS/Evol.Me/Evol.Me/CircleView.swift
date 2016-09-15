//
//  CircleView.swift
//  Evol.Me
//
//  Created by Paul.Raj on 8/5/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
    let circleLayer: CAShapeLayer! = CAShapeLayer()
    var labelInsideCircle = "100"
    
    var localFrame =  CGRect()
    
    init(frame: CGRect, color: CGColor) {
        super.init(frame: frame)
        localFrame = frame
        self.backgroundColor = UIColor.clearColor()
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        
        circleLayer.path = circlePath.CGPath
        //circleLayer.fillMode = kCAFillRuleEvenOdd
        circleLayer.fillColor =  UIColor.clearColor().CGColor
        //circleLayer.fillColor = UIColor.grayColor().CGColor
        //circleLayer.fillColor = UIColor(rgba: "ffcc00dd").CGColor
        circleLayer.strokeColor = color
        circleLayer.lineWidth = 5.0;
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateEndAngle(percentage: Int){
        var per = Double(percentage)/100 as Double
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2 * per), clockwise: true)
        circleLayer.path = circlePath.CGPath
    }
    
    func updateLabelInside(value: Int, name: String){
        var label: CATextLayer = CATextLayer()
        label.font = "Helvetica"
        label.fontSize = localFrame.width/4+localFrame.width/20
        label.frame = CGRect (x: 0, y: localFrame.width/4+localFrame.width/20, width: localFrame.width, height: 100)
        label.string = String(value)
        label.alignmentMode = kCAAlignmentCenter
        label.foregroundColor = UIColor.whiteColor().CGColor
        //label.foregroundColor = UIColor(hue: 0.9194, saturation: 0.93, brightness: 0.6, alpha: 1.0).CGColor
        circleLayer.addSublayer(label)
        
        var bottomLabel: CATextLayer = CATextLayer()
        //bottomLabel.font = "Helvetica"
        bottomLabel.fontSize = 12*UIScreen.mainScreen().bounds.size.width/414
        bottomLabel.frame = CGRect(x: -5, y: localFrame.width, width: localFrame.width+5, height: 20)
        bottomLabel.string = name
        bottomLabel.alignmentMode = kCAAlignmentCenter
        bottomLabel.foregroundColor = UIColor.whiteColor().CGColor
        //bottomLabel.textColor = UIColor.whiteColor().CGColor
        //bottomLabel.foregroundColor = UIColor(hue: 0.9194, saturation: 0.93, brightness: 0.6, alpha: 1.0).CGColor
        circleLayer.addSublayer(bottomLabel)
    }
    
    func updatePercentageInside(value: Int){
        var label: CATextLayer = CATextLayer()
        label.font = "Helvetica"
        label.fontSize = localFrame.width/4+localFrame.width/20
        label.frame = CGRect (x: 0, y: localFrame.width/4+localFrame.width/20, width: localFrame.width, height: 100)
        label.string = String(value)
        label.alignmentMode = kCAAlignmentCenter
        label.foregroundColor = UIColor.whiteColor().CGColor
        //label.foregroundColor = UIColor(hue: 0.9194, saturation: 0.93, brightness: 0.6, alpha: 1.0).CGColor
        circleLayer.addSublayer(label)
    }
    
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        UIColor(hue: 0.0639, saturation: 0.67, brightness: 0.95, alpha: 1.0).set()
        CGContextAddArc(context, (frame.size.width)/2, frame.size.height/2, (frame.size.width - 10)/2, 0.0, CGFloat(M_PI * 2), 1)
        CGContextStrokePath(context);
    }
    
    func animateCircle(duration: NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer.strokeEnd = 1.0
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
}