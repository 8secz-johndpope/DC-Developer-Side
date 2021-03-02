//
//  NavigationViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 21/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import GoogleMobileAds

class NavigationViewController: UIViewController,GADBannerViewDelegate, MFMailComposeViewControllerDelegate {

    //set-up Banner Ads -> in the bottom of the screen will appear this banner
    var bannerView: GADBannerView!
    
    @IBOutlet weak var searchFromLeftBtn: NSLayoutConstraint!
    @IBOutlet weak var uploadFromUpBtn: NSLayoutConstraint!
    @IBOutlet weak var contactUsFromRightBtn: NSLayoutConstraint!
    @IBOutlet weak var listFromDownBtn: NSLayoutConstraint!
    //constaints for a non register user -> can't see the button of List
    @IBOutlet weak var listLockFromDownBtn: NSLayoutConstraint!
    
    
    //buttons
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var listLockBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchFromLeftBtn.constant -= view.bounds.width
        uploadFromUpBtn.constant -= view.bounds.height
        contactUsFromRightBtn.constant += view.bounds.width
        listFromDownBtn.constant += view.bounds.height
        listLockFromDownBtn.constant += view.bounds.height
    }
    
    //Changes
    @IBOutlet weak var backBtn: UIButton!
    
    func hideBackBtnIfUserIsRegister(){
        //Changes
        if Auth.auth().currentUser != nil {//user is logged in backButton is hidden
            backBtn.isHidden = true
            print("login successfully")
            print("The current User is : \(Auth.auth().currentUser!)")
        
        
        } else {//no register user -> back button no hidden
            print("no user")
            backBtn.isHidden = false
        }
    }
    
    
    //END - Change
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Changes
        hideBackBtnIfUserIsRegister()
        //End - Change
        
        
        //UNBLOCKING THE listLockBtn only if user is registered
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
//
//                self.listLockBtn.alpha = 0
//            }, completion: nil)
//        }
        //if user is register -> hide the lock button
        if Auth.auth().currentUser != nil {
            
            self.listLockBtn.alpha = 0
            print("login successfully")
            print("The current User is : \(Auth.auth().currentUser!)")
            
            
        }else{
            print("no user")
        }
        
        
        
        //        UIView.animate(withDuration: 0.9,
        //                       delay: 0,
        //                       usingSpringWithDamping: 0.4,
        //                       initialSpringVelocity: 0.001,
        //                       options: .curveEaseInOut,
        //                       animations: {
        //                        self.centerAlignPhoneCode.constant += self.view.bounds.width
        //                        self.view.layoutIfNeeded()
        //
        //        })
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0,  options: .curveEaseOut, animations: {
            
            self.searchFromLeftBtn.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0,  options: .curveEaseOut, animations: {
            
            self.uploadFromUpBtn.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.contactUsFromRightBtn.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.listFromDownBtn.constant -= self.view.bounds.height
            self.listLockFromDownBtn.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    var contacUsEmailAddress = ""
    var instagramUrl = ""
    var showTheInstagramBtn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set-up adMob In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
          
        //when will go online will use this adUnitID ca-app-pub-8605484252684137/8134667744
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        
        
        //Changes
        hideBackBtnIfUserIsRegister()
        //End - Change
        
        //Changes
        //hide the search button to avoid see it on the previous screen while doing the segue between Register to Navigation view controller
        searchBtn.alpha = 0
        //after 0.4 sec we can show this button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.searchBtn.alpha = 1
        }
        //End - Changes
        
        instagramBtn.isHidden = true
        //for fetch url links at this moment Insta Url
        getDataFromFireBase()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.showTheButtons()
        }

        // Do any additional setup after loading the view.
    }
    
    //set-up AdMob Banner
      func addBannerViewToView(_ bannerView: GADBannerView) {
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(bannerView)
       view.addConstraints(
         [NSLayoutConstraint(item: bannerView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: bottomLayoutGuide,
                             attribute: .top,
                             multiplier: 1,
                             constant: 0),
          NSLayoutConstraint(item: bannerView,
                             attribute: .centerX,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .centerX,
                             multiplier: 1,
                             constant: 0)
         ])
      }
    

    //dismiss viewController by custom segue from Left -> Right
    @IBAction func backButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0.2,  options: .curveEaseOut, animations: {

            self.searchFromLeftBtn.constant -= self.view.bounds.width
            //need to hide the button after dismiss and to reveal when will appear
            self.searchBtn.alpha = 0
            self.view.layoutIfNeeded()

        }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.0,  options: .curveEaseOut, animations: {

            self.uploadFromUpBtn.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()

        }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {

            self.contactUsFromRightBtn.constant += self.view.bounds.width
            self.view.layoutIfNeeded()

        }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {

            self.listFromDownBtn.constant += self.view.bounds.height
            self.listLockFromDownBtn.constant += self.view.bounds.height
            self.view.layoutIfNeeded()

        }, completion: nil)
        
        
        
        //dismiss through the Navigation Controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.navigationController?.popViewController(animated: true)
        }
       
        //dismiss old one without Navigation Controller
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
//            let transition = CATransition()
//            transition.duration = 0.2
//            transition.type = CATransitionType.push
//            transition.subtype = CATransitionSubtype.fromLeft
//            self.view.window?.layer.add(transition, forKey: kCATransition)
//            self.dismiss(animated: false)
//        }
        
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        
         let vc = (self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func listButtonIsPressed(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpListPickerViewController") as! PopUpListPickerViewController
                                     
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        
        //pushViewController to listViewController
    }
    
    @IBAction func listLockButtonIsPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "גישה חסומה", message: "שירות של רשימת מכוניות תינתן אך ורק למשתמש רשום לרישום מהיר לחץ על כפתור רשם עכשיו!", preferredStyle: .alert)
        
        let signUpAction = UIAlertAction(title: "רשם עכשיו", style: UIAlertAction.Style.default) { (UIAlertAction) in
            NSLog("signUpNow is pressed")
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        let notNowAction = UIAlertAction(title: "לא כרגע", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            NSLog("notNowAction is pressed")
            
        }

        alert.addAction(signUpAction)
        alert.addAction(notNowAction)
        
        self.present(alert, animated: true)
        
        
   
    
    //show alert that will tell to user that only the register users can see it to unlock it he can register right now
    //2 buttons
    //first -> lyo karega - cancel
    //second -> lehirashem ahshav - popViewController
    }
    
    @IBAction func contactButtonPressed(_ sender: Any) {
        
         //For send email
        showMailComposer()
               
               
        //we do not have seperate Email ViewController at this time
//        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController)!
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
        //for email sending
        func showMailComposer() {
            
            if MFMailComposeViewController.canSendMail() {
                   let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                
                //if we didn't fetch the email it's will be with default email adress pna.apps@gmail.com
                if self.contacUsEmailAddress == ""{
                    print("DEFAULT VALUE")
                    self.contacUsEmailAddress = "pna.apps@gmail.com"
                }
                mail.setToRecipients([self.contacUsEmailAddress])
                mail.setSubject("פנייה מדנט-כאר")
                   mail.setMessageBody("<p>לצוות הדנט-כאר</p>", isHTML: true)

                   present(mail, animated: true)
               } else {
                   // show failure alert
                    print("YOU CANNOT Able to send an email chek it your permissons in your settings")
               }
        }
        
        
        //if the email was send so it's will dismiss automatically
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    
    
    
    //get instagram Url From the FB DB
    @IBAction func instagramIsPressed(_ sender: Any) {
        print("you tapped on InstaPresent")
        if instagramUrl != ""{
            print("Now you can press on instagram")
            urlReferenceForNavigationBarFindUsOn(reference: "\(instagramUrl)")
        }
    }
    
    
    //URL Reference
    func urlReferenceForNavigationBarFindUsOn(reference : String){
        let refURL = reference
        if let url = URL(string: "\(refURL)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //needs For fetching data from DB for instagramUrl and for contuctUs
    func getDataFromFireBase(){
        
        Database.database().reference().child("extras").observeSingleEvent(of: .value, with: { (snapshot) in
          
            
            
            let allInExtras = snapshot.value as? NSDictionary
            print("allInExtras NSDICTIONARY", allInExtras)
            
            //fetching contact us
            self.contacUsEmailAddress = allInExtras?["contactUs"] as? String ?? ""
            print("contacUsEmailAddress String ", self.contacUsEmailAddress)
            
            //fetching all links
            let allLinks = allInExtras?["links"] as? NSDictionary
            print("allLinks NSDictionary ", allLinks)
            
            self.instagramUrl = allLinks?["instagramUrl"] as? String ?? ""
            print("instagramUrl String ", self.instagramUrl)
            
            let allShowOnApp = allInExtras?["showOnApp"] as? NSDictionary
            print("allShowOnApp NSDictionary ", allShowOnApp)
            self.showTheInstagramBtn = allShowOnApp?["showInstaButton"] as? String ?? ""
            print("showTheInstagramBtn ", self.showTheInstagramBtn)
           
            

 
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func showTheButtons(){
        UIView.animate(withDuration: 0.3){
            print("into animate")
            if self.showTheInstagramBtn != "" && self.showTheInstagramBtn != "false"{//need to show
                print("ONLY NOW WE FETCH DATA ABOUT SHOWING THE BUTTON")
                self.instagramBtn.alpha =  0
                self.instagramBtn.isHidden = false
                 self.instagramBtn.alpha = 1
//                    if self.showTheInstagramBtn == "false"{//we do now want to show the instagram button through our DB
//                        self.instagramBtn.alpha = 0
//                    }
//                    else{// true -> we want to show our button (insta) through our DB
//
//                    }
            }
            self.view.layoutIfNeeded()
        }
    }
}
