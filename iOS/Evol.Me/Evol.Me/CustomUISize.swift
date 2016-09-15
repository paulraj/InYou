//
//  File.swift
//  InYou
//
//  Created by Paul.Raj on 11/30/15.
//  Copyright © 2015 paul-anne. All rights reserved.
//

import Foundation

class CustomUISize {
    /*
    iPhone 4/s - 320 × 480
    
    iPhone 5/s - 320 × 568
    
    iPhone 6/s Zoom     - 320 × 568
    iPhone 6/s          - 375 × 667
    
    iPhone 6/sP Zoom    - 375 × 667
    iPhone 6/sP         - 414 × 736
    
    func getDeviceType
    
    func getSizeforDevice(){
        
        x = current_x*UIScreen.mainScreen().bounds.size.width/414
        y = current_y*UIScreen.mainScreen().bounds.size.height/736
        width = current_width*UIScreen.mainScreen().bounds.size.width/414
        height = current_height*UIScreen.mainScreen().bounds.size.width/736
        
        
        switch UIScreen.mainScreen().bounds.size.width {
        case 414;
        case 375;
            x = current_x*375/414
            y = current_y*667/736
            width = current_width*375/414
            height = current_height*667/736
        case 320;
        switch UIScreen.mainScreen().bounds.size.height  {
        case 568;
            x = current_x*320/414
            y = current_y*568/736
            width = current_width*320/414
            height = current_height*568/736
        case 480;
            x = current_x*320/414
            y = current_y*480/736
            width = current_width*320/414
            height = current_height*480/736
        default;
            }
        default;
            
        }
        
        if UIScreen.mainScreen().bounds.size.width > 320 {
            if UIScreen.mainScreen().scale == 3 {
                iphone 6+
            } else {
                iphone 6
                375/414
            }
        } else if UIScreen.mainScreen().bounds.size.height > 480 {
            
        } else {
            
        }
        
        x:
        
        y
        
        width
        
        height
        
    }
    
    */
    func getNewFrame(frame:CGRect) -> CGRect {
        var x = frame.midX*UIScreen.mainScreen().bounds.size.width/414
        var y = frame.midY*(UIScreen.mainScreen().bounds.size.height-49)/687
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*(UIScreen.mainScreen().bounds.size.height-49)/687
        return CGRectMake(x-width/2, y-height/2, width, height)
    }
    
    func getNewFrameWidthHeight(frame:CGRect) -> CGRect {
        var x = frame.midX*UIScreen.mainScreen().bounds.size.width/414
        var y = frame.midY*(UIScreen.mainScreen().bounds.size.height-49)/687
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*(UIScreen.mainScreen().bounds.size.height-49)/687
        return CGRectMake(x-width/2, y-height/2, width, height)
    }
    
    func getNewFrameOnlyWidthHeight(frame:CGRect) -> CGRect {
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*(UIScreen.mainScreen().bounds.size.height-49)/687
        return CGRectMake(frame.minX, frame.minY, width, height)
    }
    
    func getNewFrameNoTabBar(frame:CGRect) -> CGRect {
        var x = frame.midX*UIScreen.mainScreen().bounds.size.width/414
        var y = frame.midY*UIScreen.mainScreen().bounds.size.height/736
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*UIScreen.mainScreen().bounds.size.height/736
        return CGRectMake(x-width/2, y-height/2, frame.width, frame.height)
    }
    
    func getNewFrameWidthHeightNoTabBar(frame:CGRect) -> CGRect {
        var x = frame.midX*UIScreen.mainScreen().bounds.size.width/414
        var y = frame.midY*UIScreen.mainScreen().bounds.size.height/736
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*UIScreen.mainScreen().bounds.size.height/736
        return CGRectMake(x-width/2, y-height/2, width, height)
    }

    func getNewFrameWidthHeightForTable(frame:CGRect) -> CGRect {
        var x = frame.midX*UIScreen.mainScreen().bounds.size.width/414
        var y = frame.midY*UIScreen.mainScreen().bounds.size.height/736
        var width = frame.width*UIScreen.mainScreen().bounds.size.width/414
        var height = frame.height*UIScreen.mainScreen().bounds.size.height/736
        return CGRectMake(frame.minX, frame.minY, width, height)
    }
    
}