// New Version 31.12.19 
//  AppManagerViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 05/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import FirebaseFunctions
import SwiftyJSON

//Changes
//App Version !
struct Constant {
    static let userCurrentAppVersion = "0.1"
}
//End - Change


class AppManagerViewController: UIViewController {

    //Changes
    //set up back-end firebase functions
    lazy var functions = Functions.functions()
    var gLinkToDownloadNewAppVersion = ""
    var gOurCurrentAppVersion = ""
    
    
    @IBOutlet weak var gifLogoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Changes
        self.checkAppVersionFromBackEnd()
        
        
       
        
        //End - Change
        
        playVideo()
        
        // Do any additional setup after loading the view.
    }
    
        
        //Changes
    func checkCurrentAppVersionVSNewVersion(){
        print("gOurCurrentAppVersion ", gOurCurrentAppVersion)
           if Constant.userCurrentAppVersion != gOurCurrentAppVersion{//user have an old version he need to update to a new Version
               print("user have an old version he need to update to a new Version")
               
               //alert is appear if photo is uploaded
               let alertController = UIAlertController(title: "Update available", message: "יצא גירסה חדשה אנא עדכן אתה בבקשה", preferredStyle: .alert)
               
               // Create the actions
            let updateAction = UIAlertAction(title: "עדכן עכשיו", style: UIAlertAction.Style.default) {
               UIAlertAction in
                   NSLog("OK Pressed")
                self.urlReferenceForNavigationBarFindUsOn(reference: "\(self.gLinkToDownloadNewAppVersion)")
                //Eeven if user has dissmised the Pop-UpAlert
                //Still This Alert will shown again Until The User Will change their App Version
                self.present(alertController, animated: true, completion: nil)
               }
               alertController.addAction(updateAction)
               self.present(alertController, animated: true, completion: nil)
               
            return
           }
           else{//User have Good (newest) AppVersion now the AppManager can continue to navigate the user
            print("Good App Version we can continue to navigate")
           }
        
    }
    
    //URL Reference
    func urlReferenceForNavigationBarFindUsOn(reference : String){
        let refURL = reference
        if let url = URL(string: "\(refURL)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
        
    func checkAppVersionFromBackEnd(){
        
        //check for a current version of the app
        functions.httpsCallable("getAppVersionIOS").call() { (result, error) in
            if let error = error as NSError? {
                print("Error is o ccured wile callable a getCarInfo from FB")
                if error.domain == FunctionsErrorDomain {
                //version is not found at all
                    print("...(ERROR) NO FOUND A VERSION AT ALL")
                }
            }
            
            if let text = (result?.data) {
                print("Succesfull call to BackEnd")
                print("this is the version data ", text)
                let json = JSON(text)
                print("json => \(json)")
                
                //only if there are a company name
                if let linkToDownloadNewAppVersion = json["link"].string{
                    self.gLinkToDownloadNewAppVersion = linkToDownloadNewAppVersion
                    print("Link to download Our new App Version \(self.gLinkToDownloadNewAppVersion)")
                }
                if let ourCurrentAppVersion = json["version"].string{
                    self.gOurCurrentAppVersion = ourCurrentAppVersion
                    print("OurCurrentAppVersion for new App Version \(self.gOurCurrentAppVersion)")
                }
                
            }
        }
    }
    
    
    
    
    
    
    func Alert (Message: String){
        
        let alert = UIAlertController(title: "אין חיבור לאינטרנט!", message: Message, preferredStyle: UIAlertController.Style.alert)
        
        // Create the actions
        let updateAction = UIAlertAction(title: "תבדוק שוב", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            if !CheckInternet.Connection(){//User Still doesn't have internet connection
                self.Alert(Message: "המשכיר שלך לא מחובר לאינטרנט \n אנא התחבר לאינטרנט ותפעיל את האפלקציה מחדש!")
                self.present(alert, animated: true, completion: nil)
            }
            else{//User eventually has connected his internet
                self.viewDidLoad()
                self.viewDidAppear(true)
                //introduce the video after 0.2 sec for not to see previous video
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.gifLogoView.alpha = 1
                }
            }

            //Eeven if user has dissmised the Pop-UpAlert
            //Still This Alert will shown again Until The User Will change their App Version
            
        }
//        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(updateAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    //End - Change
    
    override func viewDidAppear(_ animated: Bool) {
    
       
        
        //If I need a transition just uncoment this part and in DispatchQueue
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromTop
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4){
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.gifLogoView.alpha = 0
            }, completion: nil)
            
        }
        
        print("from viewDidAppear")
       
        
        //first playing a animated logo and only then ,moving to desired screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2){
            //CheckForInternetConnection
            if !CheckInternet.Connection(){ //false if NO Internet connection
                
                self.Alert(Message: "המשכיר שלך לא מחובר לאינטרנט \n אנא התחבר לאינטרנט ותפעיל את האפלקציה מחדש!")
            }
            
            //Changes
            if CheckInternet.Connection(){//only if user have internet we will check the app version
                
                //This func will stop all AppManager At the start if version is't good
                self.checkCurrentAppVersionVSNewVersion()
                
            }
            
            //End - Changes
//            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            var newViewController:UIViewController

            
            if Auth.auth().currentUser != nil {
                print("login successfully")
                print("The current User is : \(Auth.auth().currentUser!)")
                newViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NavigationViewController") as? NavigationViewController)!
            } else {
                print("no user")
                newViewController = (self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController)!

            }

            self.navigationController?.pushViewController(newViewController, animated: true)
            
            
            
            
            
            
            
            
//            self.present(newViewController, animated: false, completion: nil)
        }
        
    }
    
    
    //Logo animation video mp4
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "car_crash270", ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.gifLogoView.bounds
        self.gifLogoView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
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
