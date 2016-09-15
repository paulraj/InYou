import Foundation
import MessageUI

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }

    var textMessageRecipients = []

    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = (textMessageRecipients as? [String])!
        //messageComposeVC.body = "Check out InYou app - this is a personality detection mobile app based on your emails."
        messageComposeVC.body = "InYou App Invite!\n"+"Please check out InYou app to discover yourself/your friend's true self, based on your social media feed(Facebook/Twitter).\n"+"Download the app from app store https://appsto.re/us/ERzV-.i"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    var composeResult = ""
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        var emailTitle = "InYou App Invite!"
        var messageBody = "Hello!\n\n"+"Please check out InYou app to discover yourself/your friend's true self, based on your social media feed(Facebook/Twitter).\n\n"+"Download the app from app store https://appsto.re/us/ERzV-.i"
        var toRecipents = [""]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        return mc
        //self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            //print("Mail cancelled")
            self.composeResult = "Cancelled"
        case MFMailComposeResultSaved.rawValue:
            //print("Mail saved")
            self.composeResult = "Saved"
        case MFMailComposeResultSent.rawValue:
            //print("Mail sent")
            self.composeResult = "Sent"
        case MFMailComposeResultFailed.rawValue:
            //print("Mail sent failure: %@", [error!.localizedDescription])
            self.composeResult = "Sent Failure"
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}