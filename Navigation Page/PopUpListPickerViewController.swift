//
//  PopUpListPickerViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 02/01/2020.
//  Copyright © 2020 Pavel Petrenko. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PopUpListPickerViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var numberOfRowsInUiPickerView = 0
    //setting up numberOfRowsInComponent in each Picker View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return numberOfRowsInUiPickerView
    }
    //setting up titles of each Picker View
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var tempTitleOfRow : String = ""
        tempTitleOfRow = allCarCompanyNamesArray[row]
        return tempTitleOfRow
    }
    
    
    var companyNameThatWasPickedUp = ""
    //setting up what should happen when we select some row on each Picker View
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            companyNameThatWasPickedUp = allCarCompanyNamesArray[row]
               print("NOW THIS DATA WAS PICKED UP WHEN SELECT THE ROW ", companyNameThatWasPickedUp)
            //passing the companyNameThatWasPickedUp to the TableViewVC to show particular car Company List

       }
       //THE END FOR SETTING UP THE PICKER VIEWS
    
    
   

    func setUpUIPickerTitleOfRowFromFirebase(){
        
        Database.database().reference().child("extras/allCarsCompaniesNames").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if ( snapshot.value is NSNull ) {
                
                 // all Cars Companies Names WAS NOT FOUND
                print("– – – all Cars Companies Names WAS NOT FOUND – – –")
            }
            else{
        
                let allCarCompanyNames = snapshot.value as? NSDictionary
                print("value of allCarCompanyNames ", allCarCompanyNames)
                print("the number of companies that our DB have ", allCarCompanyNames!.count)
                
                self.numberOfRowsInUiPickerView = allCarCompanyNames!.count
                
                for carCompanyNameSnapshot in snapshot.children{
                    print(" NEW ", carCompanyNameSnapshot)
                    
                    let restDict = carCompanyNameSnapshot as! DataSnapshot
                    print("restDict ", restDict)
                    
                    //all the keys of the divisions in Aguda
                    let key = restDict.key
                    print("I've Got the key -> ", key)
                    
                    self.allCarCompanyNamesArray.append(key)
                    
                }
                
                //Set-Up pickerView
                //after fetching all car company names
                //we showing it on our UIPickerView
                self.uiPickerOfCarsCompanies.delegate = self
                self.uiPickerOfCarsCompanies.dataSource = self
                
                
                
            }
        })
    }
    
        
    @IBOutlet weak var uiPickerOfCarsCompanies: UIPickerView!
    
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
    
    
    var allCarCompanyNamesArray : [String] = []
    
    
  
        
        override func viewDidLoad() {
            super.viewDidLoad()
          //fetching data of all Car Company names for uiPickerView
          setUpUIPickerTitleOfRowFromFirebase()
            
            
            //setup ImageView and UIView
            popUpView.layer.cornerRadius = 10
//            backGroundImage.layer.cornerRadius = 10
//            uploadBtn.clipsToBounds = true
//            uploadBtn.layer.cornerRadius = 10
//            carNumberLbl.text = carNumber
//            closePopUpBtn.clipsToBounds = true
//            closePopUpBtn.layer.cornerRadius = 10
            
            
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            
//            popUpCarCompanyName.text = "יצרן: \(self.carCompanyName)"
//            popUpCarDegem.text = "דגם: \(self.carDegem)"
//            popUpCarTatDegem.text = "תת דגם: \(self.carTatDegem)"
//            popUpCarCountryCreatorName.text = "תוצרת: \(self.carCountryCreatorName)"
//            popUpCarModelYear.text = "שנת ייצור: \(self.carModelYear)"
//            popUpCarOwnershipType.text = "בעלות: \(self.carOwnershipType)"
            
           
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
        
        @IBAction func goToListBtnIsPressed(_ sender: Any) {
            removeAnimate()
            if carNumber != ""{
                //needToRemoveMinusSigns
                print("REMOVING MINUS SIGN IN POP UP PLATE FOR FEAUTURE UPLOADING")
                carNumber = carNumber.replacingOccurrences(of: "-", with: "")
            }
            
            //segue to the CarsListOfExactCompanyViewControllerViewController
            
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CarsListOfExactCompanyViewControllerViewController") as? CarsListOfExactCompanyViewControllerViewController)!
            if companyNameThatWasPickedUp == ""{
                companyNameThatWasPickedUp = allCarCompanyNamesArray[0]
            }
            if companyNameThatWasPickedUp != ""{
                print("trying to pass companyNameThatWasPickedUp From PopUpListPickerViewController into CarsListOfExactCompanyViewControllerVC")
                vc.carCompanyName = companyNameThatWasPickedUp
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
