//
//  ProgressHUD.swift
//  Evol.Me
//
//  Created by Paul.Raj on 7/11/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation

import UIKit

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .Light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        super.init(coder: aDecoder)!
        self.setup()
        
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        vibrancyView.contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            //let width = superview.frame.size.width / 2
            let width: CGFloat = 200
            let height: CGFloat = 50.0
            self.frame = CGRectMake(superview.frame.size.width / 2 - width / 2,
                superview.frame.height / 2 - height / 2,
                200,
                height)
            vibrancyView.frame = self.bounds
            //vibrancyView.frame = CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50)

            vibrancyView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRectMake(5, height / 2 - activityIndicatorSize / 2,
                activityIndicatorSize,
                activityIndicatorSize)
            
            layer.cornerRadius = 20
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.Center
            label.frame = CGRectMake(activityIndicatorSize, 0, width - activityIndicatorSize , height)
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize(14)
        }
    }
    
    func show() {
        self.hidden = false
    }
    
    func hide() {
        self.hidden = true
    }
}