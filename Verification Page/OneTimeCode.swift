//
//  OneTimeCode.swift
//  DentCar
//
//  Created by Pavel Petrenko on 02/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import AudioToolbox
import FirebaseAuth
import Lottie
import GoogleMobileAds

//protocol for the registerVC
protocol controlsReSendVerifyCode {
    func phoneSignInAndResindIn()//Resend in if I need to resend the verification code
    func verifyCode(data: String)
}

class OneTimeCode: UIViewController,GADBannerViewDelegate, CountdownTimerDelegate {

    //set-up Banner Ads -> in the bottom of the screen will appear this banner
    var bannerView: GADBannerView!

    
    
    var delegate: controlsReSendVerifyCode?
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var resendVerifyCodeBtn: UIButton!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var startTimerBtn: UIButton!
    
    @IBOutlet var backGroundView: UIView!
    @IBAction func backButtonPressed(_ sender: Any) {
//        let transition = CATransition()
//        transition.duration = 0.35
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//
//        dismiss(animated: false)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //user pressed on resend code btn
    @IBAction func resendCodeBtnPressed(_ sender: Any) {
        print("enter on resend btn 1")
        //flags to avoid fast clock and progress bar
        globaFlagFromResend = true
        flagInsideFromResend = false
        
        //hide the buttons (reloading screen)
        viewDidLoad()
        //clean field.text = ""
        
        //resend new SMS
        self.delegate?.phoneSignInAndResindIn()
        //reload timer
        viewDidAppear(true)
        
        
    }
    
  
    
    //CIRCLE DOWN COUNTER
    
    var countdownTimerDidStart = false
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    
    // Test, for dev
    let selectedSecs:Int = 60
    
    
    
    //label that pops up when timer is END
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "RESEND IT!"
        
        return label
    }()
 
    //pop up when sending a verifying code
    let alert = AlertService.shared
    
    
    var globaFlagFromResend = true
    var flagInsideFromResend = false
    //load and reload timer
    override func viewDidAppear(_ animated: Bool) {
        print("GLOBAL FLAG IS \(globaFlagFromResend)")
        if(globaFlagFromResend){
            countdownTimer.pause()
            progressBar.start()
            countdownTimerDidStart = true
            globaFlagFromResend = false
            //inside check if resend button is pressed
            print("INSIDE FLAG IS \(flagInsideFromResend)")
            if(flagInsideFromResend){
              countdownTimer.start()
              flagInsideFromResend = false
            }
        }
        else{
            countdownTimer.start()
            progressBar.start()
        }
    }
    
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
      
        
        //start counting down automatically
        countdownTimerDidStart = false
        
        //resend button is hidden
        resendVerifyCodeBtn.isHidden = true
        progressBar.isHidden = false
        seconds.isHidden = false
        
      //  startTimer()
        
        //the Veridying code field
        codeTextField.defaultCharacter = "-"
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            print(code)
            self!.delegate?.verifyCode(data: code)
           
            //hide keyboard
            self?.view.endEditing(true)
            self?.startAnimation()

            
            //start in N seconds
            // Waiting for the call back from FireBase if user is register or not to know where app will redirect user
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                print("podojdal 5 sec ")
                if (Auth.auth().currentUser != nil){
                    print("INTO IF USER NOT NIL ")
                    print("1 This is Current User in system \(Auth.auth().currentUser)")
                    print("USER IS REGISTERED END REDIRECT INTO HOME PAGE")
//                    let newViewController = (self?.storyboard?.instantiateViewController(withIdentifier: "AppManagerViewController") as? AppManagerViewController)!
//                    self?.present(newViewController, animated: true, completion: nil)
                }
                else{
                    //Wrong number or error while register procedure need a pop up that's tell it to the user and not to redirect
                    print("USER IS NOT REGISTERED YET END STAY INTO ONE TIME CODE")
                    //pop Up
                    guard let alert = self?.alert.unSuccessMessage(with: code) else { return }
                    self?.present(alert, animated: true)
                }
                
            }
            
        }
        
        
        //Circle Down Counter
        countdownTimer.delegate = self
        countdownTimer.setTimer(hours: 0, minutes: 0, seconds: selectedSecs)
        progressBar.setProgressBar(hours: 0, minutes: 0, seconds: selectedSecs)
//        stopBtn.isEnabled = false
//        stopBtn.alpha = 0.5
        
        view.addSubview(messageLabel)
        
        var constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        
        messageLabel.isHidden = true
        
//        counterView.isHidden = false
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
    
    
    

    //Circle Down Counter
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Countdown Timer Delegate
    
    
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
//        hours.text = time.hours
//        minutes.text = time.minutes
        seconds.text = time.seconds
        print("remain \((seconds.text)!)")
        
        if(seconds.text! == "30"){
            //change color of whole progressBar orange
        }
        if(seconds.text! == "15"){
            //change color of whole progressBar red
        }
    }
    
    //timer is finished
    func countdownTimerDone() {
        
        resendVerifyCodeBtn.isHidden = false
//        counterView.isHidden = true
        
        //label pops up
//********   messageLabel.isHidden = false
        
        seconds.text = String(selectedSecs)
        countdownTimerDidStart = false
        progressBar.isHidden = true
        seconds.isHidden = true
//        stopBtn.isEnabled = false
//        stopBtn.alpha = 0.5
//        startBtn.setTitle("START",for: .normal)
        
        //Vibrate when the counter gets 00
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        print("countdownTimerDone")
    }
    
    
    //MARK: - Actions
    func startTimer(){
        messageLabel.isHidden = true
        //        counterView.isHidden = false
        //
        //        stopBtn.isEnabled = true
        //        stopBtn.alpha = 1.0
        
        if !countdownTimerDidStart{
            countdownTimer.start()
            progressBar.start()
            countdownTimerDidStart = true
//            startBtn.setTitle("PAUSE",for: .normal)
            
        }else{
            countdownTimer.pause()
            progressBar.pause()
            countdownTimerDidStart = false
//            startBtn.setTitle("RESUME",for: .normal)
        }
    }
    @IBAction func startTimer(_ sender: UIButton) {
        print("+==============+")
        messageLabel.isHidden = true
//        counterView.isHidden = false
//
//        stopBtn.isEnabled = true
//        stopBtn.alpha = 1.0
        
        if !countdownTimerDidStart{
            countdownTimer.start()
            progressBar.start()
            countdownTimerDidStart = true
//            startBtn.setTitle("PAUSE",for: .normal)
            
        }else{
            countdownTimer.pause()
            progressBar.pause()
            countdownTimerDidStart = false
//            startBtn.setTitle("RESUME",for: .normal)
        }
    }

    //hide the keyboard if touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        
    }
    
    func startAnimation(){
        
        var viewThatContainAnimationNewManually : UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        viewThatContainAnimationNewManually.backgroundColor = UIColor.init(ciColor: .white)
        viewThatContainAnimationNewManually.layer.opacity = 1
        let animation = AnimationView(name: "faceRegister")
        //        let animation = AnimationView(name: "loadingS1")
        //animationView.contentMode = .scaleAspectFit
        backGroundView.addSubview(viewThatContainAnimationNewManually)
        
        
        animation.frame = view.frame
        
        
        viewThatContainAnimationNewManually.addSubview(animation)
        
        //        viewThatConsistAnimation.addSubview(animationView)
        animation.play()
        animation.animationSpeed = 0.8
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            animation.stop()
            viewThatContainAnimationNewManually.removeFromSuperview()
            //self.animationView.removeFromSuperview()
        }
    }
    
}
