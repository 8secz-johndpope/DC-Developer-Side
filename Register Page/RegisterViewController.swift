//
//  ViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 30/11/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications
import GoogleMobileAds


class RegisterViewController: UIViewController, GADBannerViewDelegate, controlsReSendVerifyCode{
    
    //creating ab adMob banner
    var bannerView: GADBannerView!
    
    //animate the phoneTxtField and phoneCode
    @IBOutlet weak var centerAlignPhoneCode: NSLayoutConstraint!
    
    @IBOutlet weak var centerAlignPhoneNumber: NSLayoutConstraint!
    
    @IBOutlet weak var minusSignView: UIView!
    
    @IBOutlet weak var continueAsGuestBtn: UIButton!

    @IBOutlet weak var gifAnimatedLogo: UIImageView!
    

    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var verifyBtnDontDelete: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerAlignPhoneCode.constant -= view.bounds.width
        centerAlignPhoneNumber.constant += view.bounds.width
        minusSignView.alpha = 0
        continueAsGuestBtn.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, delay: 0.00,  options: .curveEaseOut, animations: {

            self.centerAlignPhoneCode.constant += self.view.bounds.width
            self.view.layoutIfNeeded()

        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.10, options: .curveEaseOut, animations: {

            self.centerAlignPhoneNumber.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()

        }, completion: nil)

        UIView.animate(withDuration: 1, delay: 1.2, options: .curveEaseOut, animations: {

            self.minusSignView.alpha = 1
            self.continueAsGuestBtn.alpha = 1

        }, completion: nil)
        
    }

    
    //Getting Data from the OneTimeCode VC
    func phoneSignInAndResindIn(){
        print("From the OneTimeVC")
        phoneSignIn((Any).self)
    }
    var smsCode : String!
    func verifyCode(data: String){
        smsCode = data
        verifyOtpPressed((Any).self)
        print("This is the code that I got \(smsCode)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContinueAsGuest"{
            let destinationVC = segue.destination as! OneTimeCode
            destinationVC.delegate = self
        }
        else{
        
        }
    }
   
    @IBOutlet weak var phoneNumTxt: UITextField!
    @IBOutlet weak var dropDownTF: DropDownSwift!
    @IBOutlet weak var gifLogoView: UIView!
      
      
      let defaults = UserDefaults.standard

    //israel phone country code
    var countryCode = "+972"

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
        //hide the dropDown button to avoid see it on the previous screen while doing the segue between AppManager to Register view controller
        dropDownTF.alpha = 0
        //after 0.4 sec we can show this button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            self.dropDownTF.alpha = 1
        }
        //End - Changes
        
        

        //Notification (Local)
        let notificContent = UNMutableNotificationContent()
        notificContent.title = "ברוכים הבאים"
        notificContent.body = "היי אנו שמחים שבחרת באפליקציה שלנו נשמח לשמוע האם אהבת את השירות "
        notificContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
        let request = UNNotificationRequest(identifier: "testNotification", content: notificContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerVC = self
        
        
        //hiding the singnInBtn
        self.signInBtn.alpha = 0
        self.signInBtn?.isHidden = true
        //always hidden button verify sms
        verifyBtnDontDelete.isHidden = true
        self.dropDownTF.showList()
        self.dropDownTF.hideList()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: {
            self.dropDownTF.arrow.position = .up
            })
            UIView.animate(withDuration: 0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: {
            
            self.dropDownTF.arrow.position = .down
            })
        }

        dropDownTF.inputView = UIView()
        dropDownTF.rowHeight = 40
        dropDownTF.listHeight = 140
        dropDownTF.optionArray = ["050", "051", "052", "053", "054", "055", "056", "058", "059"]
        
          DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if self.dropDownTF.selectedIndex != nil {
                print("now is selected \(self.dropDownTF.selectedIndex)")
            }
        }

        
        try! print("this is Current User in system : \(Auth.auth().currentUser)")
        if Auth.auth().currentUser != nil {
            print("Into the IF")
        }
        
        print("Hello")
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    
    @IBAction func continueAsGuest(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "שימו לב!", message: "משתמש אשר לא ירשם לא יוכל להנות משירות רשימת מכוניות. לרישום מהיר לחץ על כפתור רשם עכישו!", preferredStyle: .alert)
        
        let signUpAction = UIAlertAction(title: "רשם עכשיו", style: UIAlertAction.Style.default) { (UIAlertAction) in
            NSLog("signUpNow is pressed")
                        
        }
        
        let notNowAction = UIAlertAction(title: "לא כרגע", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            NSLog("notNowAction is pressed")
            
             let vc = (self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as? NavigationViewController)!
            //        vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

        alert.addAction(signUpAction)
        alert.addAction(notNowAction)
        
        self.present(alert, animated: true)
        
        
    }
    
    @IBAction func phoneSignIn(_ sender: Any) {
        print("INTO PhoneSignIn")
        print("countryCode \(countryCode)")
        print("phoneCodeThatWasSelected \(RegisterViewController.phoneCodeThatWasSelected)")
        print("phoneNum.text \(phoneNumTxt.text)")
        
        var phoneCodeWithoutFirstZero = RegisterViewController.phoneCodeThatWasSelected
        print("phone code before removing ZERO \(phoneCodeWithoutFirstZero)")
            phoneCodeWithoutFirstZero.remove(at: phoneCodeWithoutFirstZero.startIndex)
        print("phone code after removing ZERO \(phoneCodeWithoutFirstZero)")
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "OneTimeCode") as? OneTimeCode)!
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        //JUST FOR TEST UNCOMMENT IT FOR KEEP SEND SMS Authentication
        
        if(phoneNumTxt.text != "" && RegisterViewController.phoneCodeThatWasSelected != "" && countryCode != ""){
            print("into the sign in IF")
            let phoneNumber = "\(countryCode)\(phoneCodeWithoutFirstZero)\((phoneNumTxt.text)!)"
            //creating thread
            let globalQueue = DispatchQueue.global()
            globalQueue.sync {
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
                    if(error == nil){//Authentication has no errors
                        //do something
                        print("This is verificationId ",verificationId)

                        guard let verifyId = verificationId else {return}
                        //saving the verificationId into the device to avoid every single sign up through the phone
                        self.defaults.set(verifyId, forKey: "verificationId")
                        self.defaults.synchronize()

                    }
                    else{
                        print("There some error with SMS  verification ", error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    @IBAction func verifyOtpPressed(_ sender: Any) {
        
        guard let verificationId = defaults.string(forKey: "verificationId") else {return}
        guard let confirmationCode = smsCode else {return}
        
        print("!!! confirmationCode \(confirmationCode)")
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: confirmationCode)
        
        Auth.auth().signIn(with: credential) { (success, error) in
            if(error == nil){//signed in
                print("success to signed in ... \(success)")
                print("This is the verificationId \(verificationId)")
                //perform segue to signed VC
//                self.dismiss(animated: true, completion: nil)
                
               let newViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as? NavigationViewController)!
                self.navigationController?.pushViewController(newViewController, animated: true)
                
            }
            else{
                print("error to signed in ... \(error?.localizedDescription)")
            }
        }
        
    }
    
    //method that fetch which PhoneCode was choosen
    static var phoneCodeThatWasSelected : String = ""
    func getTextThatWasSelected(phoneCode : String){
        print("! before was selected \(RegisterViewController.phoneCodeThatWasSelected)")
        if phoneCode != ""{
            print("NOW WE CHANGE IT")
            RegisterViewController.phoneCodeThatWasSelected = phoneCode
        }
       
        print("! after was selected \(RegisterViewController.phoneCodeThatWasSelected)")
        
        print("going from phoneCodeThatWasSelected")
        
    
        phoneCodeAndPhoneNumberStatus()
    }
    
    
    
    static var limitPreviousStr = ""
    @IBAction func phoneNumberDidChanged(_ sender: Any) {
       
        if((phoneNumTxt.text?.count)! > 7){
            phoneNumTxt.text! = RegisterViewController.limitPreviousStr
            return
        }
        else{
            RegisterViewController.limitPreviousStr = phoneNumTxt.text!
        }
        
        phoneCodeAndPhoneNumberStatus()
        
    }
    
    
    //global - prevent encounter dropDowmTF -> phoneNumb (while changing deropDownTF auto deleting phoneNum) not good
    
    func phoneCodeAndPhoneNumberStatus(){//shows the button sign in only if phoneCode and phoneNumber is correct
        print("coming from phoneCodeThatWasSelected")
        if dropDownTF != nil{
             print("dorpDownText is \(dropDownTF.text)")
        }
        print("BEFOFRE THE IF")
        print("Button is \(signInBtn)")
        print("phoneCodeThatWasSelected \(RegisterViewController.phoneCodeThatWasSelected)")
        print("phoneNumTxt \(RegisterViewController.limitPreviousStr)")
        print("phoneNumTxt.text \(RegisterViewController.limitPreviousStr)")
        print("dropDown \(dropDownTF)")

        if(RegisterViewController.limitPreviousStr.count == 7 && RegisterViewController.phoneCodeThatWasSelected != ""){
            print("SOF SOF")
             print("sign in is \(signInBtn)")
            if signInBtn == nil{
                UIView.animate(withDuration: 0.4, animations: {
                    self.signInBtn.alpha = 0
                })
//                self.signInBtn?.isHidden = true
            }
            print("Now sign in is \(signInBtn)")
            UIView.animate(withDuration: 0.4, animations: {
                self.signInBtn.alpha = 1
                self.signInBtn?.isHidden = false
            })
            
        }
        else{
            UIView.animate(withDuration: 0.4, animations: {
                self.signInBtn.alpha = 0
            })
//            self.signInBtn?.isHidden = true
        }
        
    }
   
    
    //hide the keyboard if touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
       
        //hiding the dropDownTF list if was open
        dropDownTF.hideList()
        
    }
    
}
