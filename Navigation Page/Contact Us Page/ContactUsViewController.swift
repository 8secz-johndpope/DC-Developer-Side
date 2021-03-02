//
//  ContactUsViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 21/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    
    }
    
    
    @IBAction func emailButtonTapped(_ sender: SAButton) {
        // This needs to be ran on a device
        showMailComposer()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing the user
            return
        }

//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeViewController = MFMailComposeViewController()
//            mailComposeViewController.navigationBar.tintColor = .white
//            mailComposeViewController.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
//            mailComposeViewController.setToRecipients(["support@gmail.com"])
//            mailComposeViewController.setSubject("Feedback")
//            present(mailComposeViewController, animated: true)
//        } else {
//            print("This device is not configured to send email. Please set up an email account.")
//        }
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            composer.setToRecipients(["pashentiy.90@gmail.com"])
            composer.setSubject("פנייה מדנט-כאר")

            present(composer, animated: true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
