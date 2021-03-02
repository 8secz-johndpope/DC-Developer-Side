//
//  PopUpViewController.swift
//  PopUp
//
//  Created by Andrew Seeley on 6/06/2016.
//  Copyright © 2016 Seemu. All rights reserved.
//

import UIKit

//Data wasn't found at all
class PopUpNotFoundViewController: UIViewController {


    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpBacroundImg: UIImageView!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    var carNumber = ""
      
    
   override func viewDidLoad() {
          super.viewDidLoad()
          popUpView.layer.cornerRadius = 10
    popUpBacroundImg.layer.cornerRadius = 10
    uploadBtn.layer.cornerRadius = 10
          
          self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
          
          
         
          self.showAnimate()
          
          // Do any additional setup after loading the view.
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        removeAnimate()
        if carNumber != ""{
            //needToRemoveMinusSigns
            print("REMOVING MINUS SIGN IN POP UP PLATE FOR FEAUTURE UPLOADING")
            carNumber = carNumber.replacingOccurrences(of: "-", with: "")
        }
        
        //segue to the uploadViewController
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController)!
        if carNumber != ""{
            print("trying to pass carNumber From PopUpViewController into UploadVC")
            vc.gPassingPlateNumberFromPopUpVc = carNumber
            //flag indicates start passing data on viewDidLoad on UploadVC
            vc.flagThatShowThatDataWasPassedFromPopUpVc = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
        
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }

}
