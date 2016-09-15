//
//  ImageFullscreenViewController.swift
//  Evol.Me
//
//  Created by Paul.Raj on 7/30/15.
//  Copyright (c) 2015 paul-anne. All rights reserved.
//

import Foundation
class ImageFullscreenViewController:UIViewController{
    
    //var imageLocal =  UIImage(named:"default_avatar.png")
    var name =  ""
    var contact: GoogleContact = GoogleContact()
    var currentImage = UIImage()
    var noOfImages = 0
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var photoCarousal: iCarousel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   /*
    @IBAction func saveButton(sender: AnyObject) {
        let image = takeSnapshot()
        if let imageA = image as UIImage? {
            print("it is an image")
        }
        
    }
    */
    override func viewWillAppear(animated: Bool) {
        pageControl.numberOfPages = noOfImages
        if noOfImages == 1 {
            pageControl.hidden = true
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem!.title = name
        self.photoCarousal.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.photoCarousal.frame)
        self.pageControl.frame = CustomUISize().getNewFrameWidthHeightNoTabBar(self.pageControl.frame)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Image Imported!", message: "Image is saved to your Photos Album.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func imageAll(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        //pageControl.numberOfPages = 3
        return noOfImages
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        var image :  UIImageView
        var width = photoCarousal.bounds.width
        var height = photoCarousal.bounds.height
        image =  UIImageView(frame:CGRect(x:0, y:0, width:width, height:height))
        var iconsView = UIView(frame:CGRect(x:0, y:photoCarousal.bounds.maxY, width:width, height:height))
        
        /*if index == 0 {
            image.image = self.contact.image
            iconsView.addSubview(image)
        } else if index == 1 {
            image.image = self.contact.image2
            iconsView.addSubview(image)
        } else if index == 2 {
            image.image = self.contact.image3
            iconsView.addSubview(image)
        } else if index == 3 {
            image.image = self.contact.image4
            iconsView.addSubview(image)
        } else if index == 4 {
            image.image = self.contact.image5
            iconsView.addSubview(image)
        }*/
        if index == 0 {
            image.image = self.contact.profileImage
        } else {
            if self.contact.images.count > 0 {
                image.image = self.contact.images[index-1]
            }
        }
        iconsView.addSubview(image)
        return iconsView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        carousel.bounces = false
        carousel.pagingEnabled = true
        
        if (option == .Spacing) {
            return value * 1.2
        }
        
        return value
    }
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        pageControl.currentPage = photoCarousal.currentItemIndex
        /*switch photoCarousal.currentItemIndex {
        case 0:
            currentImage = self.contact.image
        case 1:
            currentImage = self.contact.image2
        case 2:
            currentImage = self.contact.image3
        case 3:
            currentImage = self.contact.image4
        case 4:
            currentImage = self.contact.image5
        default:
            println("default")
        }*/
        if photoCarousal.currentItemIndex == 0 {
            currentImage = self.contact.profileImage
        } else {
            if self.contact.images.count > 0 {
                currentImage = self.contact.images[photoCarousal.currentItemIndex-1]
            }
        }
    }
    
    func takeSnapshot() -> UIImage {
        //UIGraphicsBeginImageContextWithOptions(CGSize(width: 400, height: 345), false, UIScreen.mainScreen().scale);
        UIGraphicsBeginImageContextWithOptions(photoCarousal.contentView.bounds.size, false, UIScreen.mainScreen().scale);
        
        photoCarousal.contentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        //self.photoCarousal?.drawViewHierarchyInRect(self.photoCarousal.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, self,"image:didFinishSavingWithError:contextInfo:", nil)
        return image;
    }
}