//
//  CarsListOfExactCompanyViewControllerViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 02/01/2020.
//  Copyright © 2020 Pavel Petrenko. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds

class CarsListOfExactCompanyViewControllerViewController: UIViewController, GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //set-up Banner Ads -> in the bottom of the screen will appear this banner
    var bannerView: GADBannerView!
    
    var carDetailsArray : [CarDetails] = []
    var allPlateNumbersArray : [String] = []
    var syncAllCarsDictionary : [[String : String]] = []
    var synCarDetailsMessage : [String:String] = ["car_Image_Url" : "",
    "plate_Number" : ""]
    
    
    var numberOfRowsInCarList = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syncAllCarsDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var carDetails = carDetailsArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! CarTableViewCell
        
        cell.setCarCell(carDetails: carDetails)
                
        return cell
    }
    
    
    @IBOutlet weak var carCompanyNameLbl: UILabel!
    @IBOutlet weak var carListTableView: UITableView!
    
    
    var carCompanyName = ""
    var carDegem = ""
    var carTatDegem = ""
    var carCountryCreatorName = ""
    var carModelYear = ""
    var carOwnershipType = ""
    var carNumber = ""
    
    
     let activityInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
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
        
        
        
        //Fetching relevant data from FB
        setUpCarListFromFireBase()
        
        //setup activity indicator
        activityInd.center = self.view.center
        activityInd.hidesWhenStopped = true
        activityInd.style = .gray
        self.view.addSubview(activityInd)
        activityInd.startAnimating()
        //indicator - END HERE


        self.carCompanyNameLbl.text = carCompanyName
        
        
        
        
       
        
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
       
    
    func castCarInformationIntoCarDetailObject(){
        for i in 0..<syncAllCarsDictionary.count{
                  print("New 1 Car Element syncAllCarsDictionary[i][car_Image_Url]! ",syncAllCarsDictionary[i]["car_Image_Url"]!)
                  print("New 2 Car Element syncAllCarsDictionary[i][plate_Number]! ",syncAllCarsDictionary[i]["plate_Number"]!)
                  
                  let newCarElement = CarDetails(urlOfCarImage: syncAllCarsDictionary[i]["car_Image_Url"]!, plateNumberOfCar: syncAllCarsDictionary[i]["plate_Number"]!)
                  carDetailsArray.append(newCarElement)
              }
    }
    

    func setUpCarListFromFireBase(){//fetching all carPlatesNumbersFromDB
           
        
        //2.01.2020 fetching only cars that user wanted
             
        
        Database.database().reference().child("extras/allCarsCompaniesNames/\(self.carCompanyName)").observeSingleEvent(of: .value, with: { (snapshot) in
               
               if ( snapshot.value is NSNull ) {
                   
                    // all exact cars company WAS NOT FOUND
                   print("– – – all exact cars company WAS NOT FOUND – – –")
               }
               else{//we found all the exact license plate per EXACT Car Copmany Name
           
                   let allCarPlatesNumber = snapshot.value as? NSDictionary
                   print("value of allCarPlatesNumber ", allCarPlatesNumber)
                   print("the number of all cars that we have in our published DB", allCarPlatesNumber?.count)
                
                
//                let carDetails = CarDetails(urlOfCarImage: <#T##String#>, plateNumberOfCar: <#T##String#>)
//                self.carDetailsArray.append(carDetails)
                   
                if allCarPlatesNumber != nil{
                   self.numberOfRowsInCarList = allCarPlatesNumber!.count
                
                   for carPlateNumberSnapshot in snapshot.children{
                       print(" NEW ", carPlateNumberSnapshot)

                       let restDict = carPlateNumberSnapshot as! DataSnapshot
                       print("restDict ", restDict)

                       //all the keys of the divisions in Aguda
                       let key = restDict.key
                       print("I've Got the key -> ", key)
                    
                    self.allPlateNumbersArray.append(key)
                    

                    print("1 synCarDetailsMessage ",self.synCarDetailsMessage)
                    print("2 syncAllCarsDictionary ",self.syncAllCarsDictionary)
                    print("3 allPlateNumbersArryay ",self.allPlateNumbersArray)

                    
                }

                self.fetchOnlyExactCarsCompanyFromFB()
                
                }
                
               }
           })
       }
    
        //WORKING CHECK FIRST IF THERE ARE CAR DETAILS INSTEAD TO CHECK IF THERE ARE A PHOTOS OF A CAR
        //cheking if company name is correct insted to check if there are pictures
//    func fetchOnlyExactCarsCompanyFromFB(){
//        for i in 0..<allPlateNumbersArray.count{//checking for us what do we have inside the array of desired car company name
//            print("THIS IS THE allCarPlatesNumber?[\(i)] ", allPlateNumbersArray[i] )
//        }
//
//        for i in 0..<allPlateNumbersArray.count{ Database.database().reference().child("published/carPlate/\(allPlateNumbersArray[i])/details").observeSingleEvent(of: .value, with: { (snapshot) in
//
//        if ( snapshot.value is NSNull ) {
//
//             // exact carDetails WAS NOT FOUND
//            print("– – – exact carDetails WAS NOT FOUND – – –")
//        }
//        else{//the car details are found
//
//            let allCarDetails = snapshot.value as? NSDictionary
//            print("value of carCompany ", allCarDetails)
//
//            //Bug 05.01.20 allCarDetails! not found one of details
//            let carCompanyNameFromFB = allCarDetails!["companyName"] as? String
//
//            //Bug only show cars on list if there are a companyName instead if there are a images
//            if carCompanyNameFromFB != nil{
//                print("carCompanyNameFromFB ",carCompanyNameFromFB!)
//
//
//                        if carCompanyNameFromFB! == self.carCompanyName{//if we found the exact company name that user want we need to get it's imageUrl and append it to the syncAllCarsDictionary
//
//                           //now we know that exact this number on index i is a desired companyCar
//                            Database.database().reference().child("published/carPlate/\(self.allPlateNumbersArray[i])/images").observeSingleEvent(of: .value, with: { (snapshot) in
//
//                            if ( snapshot.value is NSNull ) {
//
//                                 // all CarPlates WAS NOT FOUND
//                                print("– – – all CarPlates WAS NOT FOUND – – –")
//                            }
//                            else{
//
//
//                                let allExactCarImages = snapshot.value as? NSDictionary
//                                print("value of allExactCarImages ", allExactCarImages)
//
//
//                                //NOW WE NEED TO FETCH ONLY THE ONE PHOTO OF THIS PARTICULAR CAR TO PRESENT IT ON THE UIImageView like a presentor of this car
//
//                                    //Need To Change I'm hanging over all images and I need only first one
//                                    for carPlateNumberSnapshot in snapshot.children{
//                                        let urlOfCarImagesFBSnaphot = carPlateNumberSnapshot as! DataSnapshot
//
//                                        let firstImageKey = urlOfCarImagesFBSnaphot.key
//                                         print("I've Got the first ImageKey -> ", firstImageKey)
//
//                                        let urlImage = allExactCarImages!["\(firstImageKey)"] as? String
//
//                                        self.synCarDetailsMessage.updateValue(urlImage!, forKey: "car_Image_Url")
//                                     self.synCarDetailsMessage.updateValue(self.allPlateNumbersArray[i], forKey: "plate_Number")
//
//                                        self.syncAllCarsDictionary.append(self.synCarDetailsMessage)
//                                        print("2 syncAllCarsDictionary ",self.syncAllCarsDictionary)
//
//                                        //runing only once here beacause that we need only the first photo of this particular car
//                                        break
//
//                                    }
//
//
//
//
//                            }
//                            })
//
//
//
//
//                        }
//
//
//            }
//
//
//
//        }
//            })
//
//      }
//
//        //Need to change
//        //we have an empty CarDetailsArray need to handle it
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//
//            //transfer data from sync Dictionary into CarDetailObject
//            self.castCarInformationIntoCarDetailObject()
//
//
//            //Set-Up pickerView
//            //after fetching all car company names
//            //we showing it on our UIPickerView
//            self.carListTableView.delegate = self
//            self.carListTableView.dataSource = self
//
////            self.carListTableView.reloadData()
////            self.animateTable()
//            self.animateTableFromLeftToRight()
//
//            //stop the animation indicator
//            self.activityInd.stopAnimating()
//
//        }
//
//
//    }
    
    
    
    func fetchOnlyExactCarsCompanyFromFB(){
            for i in 0..<allPlateNumbersArray.count{//checking for us what do we have inside the array of desired car company name
                print("THIS IS THE allCarPlatesNumber?[\(i)] ", allPlateNumbersArray[i] )
            }
           
            for i in 0..<allPlateNumbersArray.count{
                
                //if there are images then we will display them
                Database.database().reference().child("published/carPlate/\(self.allPlateNumbersArray[i])/images").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                    if ( snapshot.value is NSNull ) {
                                    
                        // all CarPlates WAS NOT FOUND
                        print("– – – all CarPlates WAS NOT FOUND – – –")
                    }
                    else{
                    
                        let allExactCarImages = snapshot.value as? NSDictionary
                        print("value of allExactCarImages ", allExactCarImages)
                                    
                                    
                        //NOW WE NEED TO FETCH ONLY THE ONE PHOTO OF THIS PARTICULAR CAR TO PRESENT IT ON THE UIImageView like a presentor of this car
                                        
                        //Need To Change I'm hanging over all images and I need only first one
                        for carPlateNumberSnapshot in snapshot.children{
                            let urlOfCarImagesFBSnaphot = carPlateNumberSnapshot as! DataSnapshot
                            let firstImageKey = urlOfCarImagesFBSnaphot.key
                            print("I've Got the first ImageKey -> ", firstImageKey)
                                            
                            let urlImage = allExactCarImages!["\(firstImageKey)"] as? String
                                            
                            self.synCarDetailsMessage.updateValue(urlImage!, forKey: "car_Image_Url")
                            self.synCarDetailsMessage.updateValue(self.allPlateNumbersArray[i], forKey: "plate_Number")
                                            
                            self.syncAllCarsDictionary.append(self.synCarDetailsMessage)
                            print("2 syncAllCarsDictionary ",self.syncAllCarsDictionary)
                                            
                            //runing only once here beacause that we need only the first photo of this particular car
                            break
                                            
                        }
                                        
                                       
                                    
                                    
                    }
                })
                
    }
            
            //Need to change
            //we have an empty CarDetailsArray need to handle it
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                //transfer data from sync Dictionary into CarDetailObject
                self.castCarInformationIntoCarDetailObject()
                
                
                //Set-Up pickerView
                //after fetching all car company names
                //we showing it on our UIPickerView
                self.carListTableView.delegate = self
                self.carListTableView.dataSource = self
                
    //            self.carListTableView.reloadData()
    //            self.animateTable()
                self.animateTableFromLeftToRight()
                
                //stop the animation indicator
                self.activityInd.stopAnimating()
                                    
            }
            
            
        }
    
    
    
    
    
    
    
   //animate table view appearence from down to up
    func animateTable() {
        self.carListTableView.reloadData()
        
        let cells = carListTableView.visibleCells
        let tableHeight: CGFloat = carListTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            self.carListTableView.isHidden = false
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.04 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    //animate table view from left to right
    func animateTableFromLeftToRight() {
         self.carListTableView.reloadData()
         
         let cells = carListTableView.visibleCells
        let tableWidth: CGFloat = -(carListTableView.bounds.size.width)
         
         for i in cells {
             let cell: UITableViewCell = i as UITableViewCell
             cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
         }
         
         var index = 0
         
         for a in cells {
             self.carListTableView.isHidden = false
             let cell: UITableViewCell = a as UITableViewCell
            //speed of animation and deleay of animation
             UIView.animate(withDuration: 1.5, delay: 0.1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
                 cell.transform = CGAffineTransform(translationX: 0, y: 0);
             }, completion: nil)
             
             index += 1
         }
     }
    
    //dissapearing animation of table view
    func dissapearingAnimateTableFromRightToLeft(){
        
         let cells = carListTableView.visibleCells
        let tableWidth: CGFloat = -(carListTableView.bounds.size.width)
         
         for i in cells {
             let cell: UITableViewCell = i as UITableViewCell
             cell.transform = CGAffineTransform(translationX: 0, y: 0)
         }
         
         var index = 0
         
         for a in cells {
             self.carListTableView.isHidden = false
             let cell: UITableViewCell = a as UITableViewCell
            //speed of animation and deleay of animation
            UIView.animate(withDuration: 0.7, delay: 0.04 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
                 cell.transform = CGAffineTransform(translationX: -tableWidth, y: 0);
             }, completion: nil)
             
             index += 1
         }
        
        
        
    }
    
    
    //pop Current ViewController
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dissapearingAnimateTableFromRightToLeft()
           
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.navigationController?.popViewController(animated: true)
        }
       
       }
    
    func getCarDetailsFromFireBaseAndDisplay(plateNumber : String){
        
        print("In Cars list before calling to DB func")
                print("number that we would check now in our DB ", plateNumber)
                print("!!! ",plateNumber)
                    //looking in published
        Database.database().reference().child("published/carPlate/\(plateNumber)/details").observeSingleEvent(of: .value, with: { (snapshot) in
                    print("looking for car details")
                        if ( snapshot.value is NSNull ) {
                            print("NOT FOUND IMAGES AND DETAILS EITHER ABOUT CAR")
                            print("WE CAN'T SHOW POPUPVC FROM DB")
                        }
                        else{//found some car details now we will introduce it here
                            print("found some car details now we will introduce it here")
                            let allDetailsInExactCar = snapshot.value as? NSDictionary
                            print("value of allDetailsInExactCar ", allDetailsInExactCar)
                            
                            self.carCompanyName = allDetailsInExactCar?["companyName"] as? String ?? "כללי"
                            self.carCountryCreatorName = allDetailsInExactCar?["countryCreatorName"] as? String ?? "כללי"
                            self.carDegem = allDetailsInExactCar?["degemName"] as? String ?? "כללי"
                            self.carModelYear = allDetailsInExactCar?["modelYear"] as? String ?? "כללי"
                            self.carOwnershipType = allDetailsInExactCar?["ownershipType"] as? String ?? "כללי"
                            self.carTatDegem = allDetailsInExactCar?["tatDegemName"] as? String ?? "כללי"
                            
                        }
                    
                    })
        
    }

    
        //after screen loading we still doesn't see anything so we need to tap so
        //this func will do fakeTap on the table we for display all the loading screen
        func fakeTapOnTableView (){
         
            
            let indexPath = IndexPath(row: 0, section: 0)  // change row and section according to you
            self.carListTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.carListTableView.delegate?.tableView?(self.carListTableView, didSelectRowAt: indexPath)
         
            
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityInd.startAnimating()
        //after user chose on car he cannot chose multiple cars
        tableView.isUserInteractionEnabled = false

        let cell = tableView.cellForRow(at: indexPath) as? CarTableViewCell
        print(cell?.carPlateNumberLbl?.text)
        
        getCarDetailsFromFireBaseAndDisplay(plateNumber: cell!.carPlateNumberLbl!.text!)
        
        
        //Need to Change how can I not to use the seconds what can I use instead
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "ShowCarsViewController") as? ShowCarsViewController)!
        if cell != nil{
            vc.plateNumber = cell!.carPlateNumberLbl!.text!
            
            
            //flag that says that we got this data from the carsList and we need to implement DB Call for display car details
            vc.carCompanyName = self.carCompanyName
            vc.carDegem = self.carDegem
            vc.carModelYear = self.carModelYear
            vc.carCountryCreatorName = self.carCountryCreatorName
            vc.carTatDegem = self.carTatDegem
            vc.carOwnershipType = self.carOwnershipType
            print("carCompanyName ",self.carCompanyName)
            print("carDegem ",self.carDegem)
            print("carModelYear ",self.carModelYear)
            print("carCountryCreatorName ",self.carCountryCreatorName)
            print("carTatDegem ",self.carTatDegem)
            print("carCompanyName ",self.carCompanyName)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            //after user chose on car he cannot chose multiple cars
            tableView.isUserInteractionEnabled = true
            //stop the loading animation
            self.activityInd.stopAnimating()
            
        }
        }
    }
    
}
