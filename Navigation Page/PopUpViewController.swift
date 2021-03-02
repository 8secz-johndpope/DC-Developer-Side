//
//  PopUpViewController.swift
//  PopUp
//
//  Created by Andrew Seeley on 6/06/2016.
//  Copyright © 2016 Seemu. All rights reserved.
//

import UIKit

//Successfully Found Data Message
class PopUpViewController: UIViewController {

    
    @IBOutlet weak var popUpCarCompanyName: UILabel!
    @IBOutlet weak var popUpCarDegem: UILabel!
    @IBOutlet weak var popUpCarTatDegem: UILabel!
    @IBOutlet weak var popUpCarCountryCreatorName: UILabel!
    @IBOutlet weak var popUpCarModelYear: UILabel!
    @IBOutlet weak var popUpCarOwnershipType: UILabel!
    
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var tagFolderImg: UIImageView!
    @IBOutlet weak var carNumberLbl: UILabel!
    
    @IBOutlet weak var closePopUpBtn: UIButton!
    
    var carCompanyName = ""
    var carDegem = ""
    var carTatDegem = ""
    var carCountryCreatorName = ""
    var carModelYear = ""
    var carOwnershipType = ""
    var carNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup ImageView and UIView
        popUpView.layer.cornerRadius = 10
        backGroundImage.layer.cornerRadius = 10
        uploadBtn.clipsToBounds = true
        uploadBtn.layer.cornerRadius = 10
        carNumberLbl.text = carNumber
        closePopUpBtn.clipsToBounds = true
        closePopUpBtn.layer.cornerRadius = 10
        
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        popUpCarCompanyName.text = "יצרן: \(self.carCompanyName)"
        popUpCarDegem.text = "דגם: \(self.carDegem)"
        popUpCarTatDegem.text = "תת דגם: \(self.carTatDegem)"
        popUpCarCountryCreatorName.text = "תוצרת: \(self.carCountryCreatorName)"
        popUpCarModelYear.text = "שנת ייצור: \(self.carModelYear)"
        popUpCarOwnershipType.text = "בעלות: \(self.carOwnershipType)"
        
       
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
