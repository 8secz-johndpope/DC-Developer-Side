//
//  HomePage.swift
//  DentCar
//
//  Created by Pavel Petrenko on 30/11/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFunctions
import SwiftyJSON
import GoogleMobileAds

class HomePageViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    
    //set-up Interstitial Ads -> whole screen after user will press a search button
    var interstitial: GADInterstitial!
    //set-up Banner Ads -> in the bottom of the screen will appear this banner
    var bannerView: GADBannerView!

    

    //set up back-end firebase functions
    lazy var functions = Functions.functions()
    
    @IBOutlet weak var plateNumberTxt: UITextField!
    
    //variables for the textFieldDidCgange
    //extreme case if the limit of the plate increased to 9 digits we remember the previous 8 digits
    var limitPreviousStr = ""
    
    //need for the string indexes
    var newOffset = 0
    
    var gFirstTimeAlphaWillNotChange = true
    var gPlateStillNotWasSevenDigit = true
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        print("something changed")
        
        var number = ""
        var startSliceStr = ""
        var midSliceStr = ""
        var endSliceStr = ""
        var strTemp = "-"
        var startIndex = 2, endIndex = 7

        //(cleaning of every sign "-" )from the String
         plateNumberTxt.text = plateNumberTxt.text?.replacingOccurrences(of: "-", with: "")
        if (plateNumberTxt.text!.count > 8){
            print("return!!!!!")
            plateNumberTxt.text! = limitPreviousStr
            return
        }
        
        if(plateNumberTxt.text?.count == 8){
            startIndex += 1//3
            endIndex += 1//8
        }
        
        //prefix number slice
        startSliceStr = String(plateNumberTxt.text?.prefix(startIndex) ?? "") // 12 or 123
        print("111 \(startSliceStr)")
        number = startSliceStr
        print("NUMBER NOW \(number)")
        
        //midlle number slice
        if((plateNumberTxt.text?.count)! >= 3){
            print("new offset with 7 digits \(newOffset)")
            if((plateNumberTxt.text?.count)! == 6){
                //the plate number under 7 digit -> search button is disabled
                //to avoid button disable twice
                if gFirstTimeAlphaWillNotChange || gPlateStillNotWasSevenDigit{
                    self.searchBtn.backgroundColor = UIColor(red: 215/255, green: 122/255, blue: 26/255, alpha: 1.0)
                    gFirstTimeAlphaWillNotChange = false
                }
                else{
                    self.searchBtn.backgroundColor = UIColor(red: 215/255, green: 122/255, blue: 26/255, alpha: 0.5)
                }
               
                self.searchBtn.isEnabled = false
                newOffset = -1
            }
            else if((plateNumberTxt.text?.count)! == 7){
                print("** PLATE NUMBER IS 7 DIGIT NOW")
                gPlateStillNotWasSevenDigit = false
                self.searchBtn.alpha = 1
                self.searchBtn.backgroundColor = UIColor(red: 51/255, green: 173/255, blue: 30/255, alpha: 1.0)
                self.searchBtn.isEnabled = true
                newOffset = -2
            }
            else if(endIndex == 8){
                print("** PLATE NUMBER IS 8 DIGIT NOW")
                self.searchBtn.alpha = 1
                self.searchBtn.backgroundColor = UIColor(red: 51/255, green: 173/255, blue: 30/255, alpha: 1.0)
                self.searchBtn.isEnabled = true
                newOffset = -3
                print("new offset with 8 digits \(newOffset)")
            }
            else{
                newOffset = 0
            }
            var rangeMid = plateNumberTxt.text!.index(plateNumberTxt.text!.startIndex, offsetBy: startIndex)..<plateNumberTxt.text!.index(plateNumberTxt.text!.endIndex, offsetBy: newOffset)
            midSliceStr = String(plateNumberTxt.text![rangeMid]) // 345 or 45
            print("222 \(midSliceStr)")
        }
        
        //end number slice
        if((plateNumberTxt.text?.count)! >= 6){
            var rangEnd = plateNumberTxt.text!.index(plateNumberTxt.text!.startIndex, offsetBy: 5)..<plateNumberTxt.text!.index(plateNumberTxt.text!.endIndex, offsetBy: 0)
            endSliceStr = String(plateNumberTxt.text![rangEnd]) // 67 or 678
            print("333 \(endSliceStr)")
        }
        
        //print states
        if (endSliceStr != "") {
            print("into endSliceStr")
            number = "\(startSliceStr)\(strTemp)\(midSliceStr)\(strTemp)\(endSliceStr)"
           
            //save the limit for the extreme case
            limitPreviousStr = number
            print("number is \(number)")
            plateNumberTxt.text! = "\(number)"
        }
        else if (midSliceStr != ""){
            print("into MidSliceStr")
            number = "\(startSliceStr)\(strTemp)\(midSliceStr)"
            print("number is on mid \(number)")
            plateNumberTxt.text! = "\(number)"
            
        }
        else{
            number = "\(startSliceStr)"
            plateNumberTxt.text! = number
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //call to adMob func to setUp the add and load it when this screen will loaded
        interstitial = createAndLoadInterstitial()
        //set-up Banner pop-up AdMob
        // Set-up adMob In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)
        
        //when will go online will use this adUnitID ca-app-pub-8605484252684137/8134667744
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        
        self.searchBtn.alpha = 0.5
        self.searchBtn.layer.cornerRadius = 10
        self.searchBtn.isEnabled = false
        
      //  self.navigationController?.navigationBar.isHidden = ture
        
//        setUpSearchBtn()
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //hide the keyboard if touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        
    }
    
    @IBOutlet weak var searchBtn: UIButton!
    func setUpSearchBtn(){
        searchBtn.layer.cornerRadius = 5
        searchBtn.layer.borderWidth = 10
    
        
    }
    
    
    //setup ads ->AdMob every cycle is ready
    func createAndLoadInterstitial() -> GADInterstitial {
      // setup - adMob need to change ca-app-pub-8605484252684137/2554203859
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    //load the ad from the adMob
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }
    //AdMob SetUp END
    
    
    var adCounter : Int!
    
    func addOneAdCounterIntoDB(){
        Database.database().reference().child("extras/adCounter").observeSingleEvent(of: .value, with: { (snapshot) in
        if ( snapshot.value is NSNull ) {
            
            // DATA WAS NOT FOUND
            print("– – – adCounter not found – – –")
            //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
            
            
        }
        else{// some data was found -> connection with DB is good
        
            var counterFromDb = snapshot.value as? String
            print("value of counterFromDb ", counterFromDb)
            
            
            
            self.adCounter = Int(counterFromDb!)! + 1
            print("NOW ADD COUNTER IS ", self.adCounter!)
            Database.database().reference().child("extras/adCounter").setValue("\(self.adCounter!)")
            
            //CHOOSE ADD COUNTER AFTER 3 Seconds just insure the good DB CONNECTION?
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//                self.adCounter = Int(counterFromDb!)! + 1
//                print("NOW ADD COUNTER IS ", self.adCounter!)
//
//                            Database.database().reference().child("extras/adCounter").setValue("\(self.adCounter!)")
//
//            }
            
        }
        })
    }
    
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        //additing one ad into gloabal adCounter into DB
        addOneAdCounterIntoDB()
        
        //show the adMob when search button is pressed
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        
        //button disabled
      //  self.searchBtn.isEnabled = false
        
        getCarDataFromFireBaseAndDisplayOnPopUpView()
        
        //we will pop up this view only if we didn't find
        //1.)find carplate in ourDB but didn't find any images (creepy case) (message: car details) (BUTTON "Daveah")
        //2.)didn't find data in ourDB but find it on BackEnd (message:car details) (BUTTON "Daveah")
        //3.)din't find data in ourDB and in BackEnd either (message: car not in OurDB) (BUTTON "Daveah")
        
        //1.) Case -> look  into getCarDataFromFireBaseAndDisplayOnPopUpView()
        //2.) Case -> look  into getCarDataFromFireBaseAndDisplayOnPopUpView()
        //2.) Case -> look  into getCarDataFromFireBaseAndDisplayOnPopUpView()
        
        //29.12.2019 uncomment
        //when click on the button on the HomePage will perfrom segue
//
//        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "ShowCarsViewController") as? ShowCarsViewController)!
//        vc.plateNumber = plateNumberTxt.text!
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //Bug Fixed -> now the App doesn't have segues instead it's has Navigation
    //prepare sending data from HomePage to ShowPage
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue is "SendDataForwardPlateNumber" then implement this:
        if segue.identifier == "SendDataForwardPlateNumber"{
            print("going to ShowCars")
            
            let destinationVC = segue.destination as! ShowCarsViewController
            //passing data to the variable on the "ShowCarsViewController"
            destinationVC.plateNumber = plateNumberTxt.text!
            
        }
    }
    

    //getting car from firebase and passing data into a PopUpViewController
    func getCarDataFromFireBaseAndDisplayOnPopUpView(){

        print("In getInfo from DB func")
        print("number that we would check now in our DB ", String(self.plateNumberTxt.text!))
        guard let plateNumber = self.plateNumberTxt?.text else { return }
        print("!!! ",plateNumber)
            //looking in published
            Database.database().reference().child("published/carPlate").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                //            let value = snapshot.value as? String
                //            print("value String ", value)
                if ( snapshot.value is NSNull ) {

                    // DATA WAS NOT FOUND
                    print("– – – Data was not found – – –")
                    print("We actually don't have any data on this car")
                    
                    //*** Done currently our DB isn't answer we will check in BackEnd DB
                    print("checking countryDB cause we didn't find any car in our DB")
                    self.getDataFromCountryCarDBAndDisplayOnPopUpView()
                    
                    
                     //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                }
                else{// some data was found -> connection with DB is good

                    let allCarPlates = snapshot.value as? NSDictionary
                    print("value of allCarPlates 1 ", allCarPlates)
                    





                     //figure out if we alredy have this plateNumber if our DB
                    if allCarPlates!["\(plateNumber)"] != nil{
                        print("we found this current car , now we need to get all photos from it")

                        //published
                        Database.database().reference().child("published/carPlate/\(plateNumber)/images").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            //            let value = snapshot.value as? String
                            //            print("value String ", value)
                            
                            if ( snapshot.value is NSNull ) {
                        
                               

                                // IMAGES WAS NOT FOUND
                                //THIS CAR IS NOT IN OUR PUBLISH DB
                                print("– – – Images was not found – – –")
                                print("THIS CAR IS NOT IN OUR PUBLISH DB ")
                                print("not found images of the car in our DB")
                                //NO Images -> now we need to fetch some details about this car
                           
                               //creating variable for future assigment on the popUpVC message
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
                                        
                                        self.gCarCompanyName = allDetailsInExactCar?["companyName"] as? String ?? "כללי"
                                        self.gCarCountryCreatorName = allDetailsInExactCar?["countryCreatorName"] as? String ?? "כללי"
                                        self.gCarDegemName = allDetailsInExactCar?["degemName"] as? String ?? "כללי"
                                        self.gCarModelYear = allDetailsInExactCar?["modelYear"] as? String ?? "כללי"
                                        self.gCarOwnershipType = allDetailsInExactCar?["ownershipType"] as? String ?? "כללי"
                                        self.gCarTatDegemName = allDetailsInExactCar?["tatDegemName"] as? String ?? "כללי"
                                        
                                        
                                        //1.) Case -> find carplate in ourDB but didn't find any images (creepy case) (message: car details) (BUTTON "Daveah")
                                        
                                        //after fetching the details we able to show PopUpVC
                                        //showing pop up if there are now Images in our DB only Car details
                                        //Weird case almost impossible
                                        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
                                        popOverVC.carCompanyName = self.gCarCompanyName
                                        popOverVC.carDegem = self.gCarDegemName
                                        popOverVC.carTatDegem = self.gCarTatDegemName
                                        popOverVC.carCountryCreatorName = self.gCarCountryCreatorName
                                        popOverVC.carModelYear = self.gCarModelYear
                                        popOverVC.carOwnershipType = self.gCarOwnershipType
                                        //sending also carPlateNumber in case if user would like to ledaveah and we will pass it from PopUpVC into UploadVC
                                        popOverVC.carNumber = self.plateNumberTxt.text!
                                                                     
                                        self.addChild(popOverVC)
                                        popOverVC.view.frame = self.view.frame
                                        self.view.addSubview(popOverVC.view)
                                        popOverVC.didMove(toParent: self)
                                    }
                                
                                })
                                //*** Done NO IMAGES if not found images but found a some car details need to pass data into popUpViewController
                                
                             
                                
                                
                                
                                
                                
                                
                                
                                //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                            }
                            else{// some Images were found  connection with DB is good
                                
                                
                                //After Find some Car Images we need to fetch the car Details
                                //for past it to the ShowCarsVC
                                //fetching relevant details of the car too
                                Database.database().reference().child("published/carPlate/\(plateNumber)/details").observeSingleEvent(of: .value, with: { (snapshot) in
                                print("looking for car details")
                                    //found some car details now we will introduce it here
                                        print("found some car details now we will introduce it here")
                                        let allDetailsInExactCar = snapshot.value as? NSDictionary
                                        print("value of allDetailsInExactCar ", allDetailsInExactCar)
                                        
                                        self.gCarCompanyName = allDetailsInExactCar?["companyName"] as? String ?? "כללי"
                                     print("self.gCarCompanyName", self.gCarCompanyName)
                                    
                                        self.gCarCountryCreatorName = allDetailsInExactCar?["countryCreatorName"] as? String ?? "כללי"
                                        self.gCarDegemName = allDetailsInExactCar?["degemName"] as? String ?? "כללי"
                                        self.gCarModelYear = allDetailsInExactCar?["modelYear"] as? String ?? "כללי"
                                        self.gCarOwnershipType = allDetailsInExactCar?["ownershipType"] as? String ?? "כללי"
                                        self.gCarTatDegemName = allDetailsInExactCar?["tatDegemName"] as? String ?? "כללי"
                                

                                //UNCOMMENT IF SOMETHING WILL NOT WORK
//                                let allImagesOfExactCar = snapshot.value as? NSDictionary
//                                print("value of allImagesOfExactCar ", allImagesOfExactCar)
                                
                                //*** Done found the images now need just to perform pushViewController to the showViewController

                                 //when click on the button on the HomePage will perfrom segue
                                
                                
                                print("PPP WE ARE SENDING THE NEXT DATA")
                                print("self.gCarCompanyName", self.gCarCompanyName)
                                print("self.gCarDegemName", self.gCarDegemName)
                                print("self.gCarTatDegemName", self.gCarTatDegemName)
                                print("self.gCarCountryCreatorName", self.gCarCountryCreatorName)
                                print("self.gCarModelYear", self.gCarModelYear)
                                print("self.gCarOwnershipType", self.gCarOwnershipType)
                                
                                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "ShowCarsViewController") as? ShowCarsViewController)!
                                vc.plateNumber = self.plateNumberTxt.text!
                                //passing data into labels
                                vc.carCompanyName = self.gCarCompanyName
                                vc.carDegem = self.gCarDegemName
                                vc.carTatDegem = self.gCarTatDegemName
                                vc.carCountryCreatorName = self.gCarCountryCreatorName
                                vc.carModelYear = self.gCarModelYear
                                vc.carOwnershipType = self.gCarOwnershipType

                                self.navigationController?.pushViewController(vc, animated: true)

                                    })
                                }

                        })
                    }
                    else{//not found the exact car in our DB
                        print("not found the exact car in our DB")
                        //*** Done if not found we need in our DB should try in BackEnd DB
                        
                        self.getDataFromCountryCarDBAndDisplayOnPopUpView()
                    }

                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    
    
    var gCarCompanyName = ""
    var gCarModelYear = ""
    var gCarDegemName = ""
    var gCarTatDegemName = ""
    var gCarCountryCreatorName = ""
    var gCarOwnershipType = ""
    var gCarPlateNumber = ""
    
    
    
    //countryCarsDb
    func getDataFromCountryCarDBAndDisplayOnPopUpView(){
        
        guard let plateNumber = self.plateNumberTxt?.text else { return }
        print("??? ",plateNumber)
        print("check the number that we send into the back end ", plateNumber)
        
        functions.httpsCallable("getCarInformation").call(["carNumber": "\(plateNumber)"]) { (result, error) in
            if let error = error as NSError? {
                print("Error is o ccured wile callable a getCarInfo from FB")
                if error.domain == FunctionsErrorDomain {
                    //Car not found at all
                    
                    //neeed to implement some pop-up
                    //meida al rehev ze lyo nimca bemaagarey misrad harishuy. ana bdok et tkinut shel hamispar ve nase shenit
                    
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("code -> \(code.debugDescription)")
                    print("message -> \(message.description)")
                    print("details -> \(details.debugDescription))")
                    
                    print("ON ERROR STAGE UNSUCCESFUL CONECTION WITH SERVER")
                    print("(ERROR)...no companyName need to assign the default company name")
                    print("(ERROR)...no carModelYear need to assign the default company name")
                    print("(ERROR)...no carDegemName need to assign the default company name")
                    
                    //3.) CASE -> din't find data in ourDB and in BackEnd either (message: car not in OurDB) (BUTTON "Daveah")
                    let popNoDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpNotFoundViewController") as! PopUpNotFoundViewController
                    //sending also carPlateNumber in case if user would like to ledaveah and we will pass it from PopUpVC into UploadVC
                    popNoDataVC.carNumber = self.plateNumberTxt.text!
                    self.addChild(popNoDataVC)
                    popNoDataVC.view.frame = self.view.frame
                    self.view.addSubview(popNoDataVC.view)
                    popNoDataVC.didMove(toParent: self)
                    
                    //...no companyName need to assign the default company name
                    //...no carModelYear need to assign the default company name
                    //...no carDegemName need to assign the default company name
                    
                    //*** Done we do not have any car info in DB at all show the popUpViewController with a this specific message
                    
                    
                }
            }
            
            if let text = (result?.data) {
                print("Succesfull call to BackEnd")
                print(text)  // WOULD EXPECT A PRINT OF THE CALLABLE FUNCTION HERE
                let json = JSON(text)
                print("json => \(json)")
                
                if json.isEmpty {
                    print("BASA EIN BE MAAGAR")
                    //*** Done we do not have any car info in DB at all show the popUpViewController with a this specific message
                    
                    //3.) CASE -> din't find data in ourDB and in BackEnd either (message: car not in OurDB) (BUTTON "Daveah")
                    let popNoDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpNotFoundViewController") as! PopUpNotFoundViewController
                    //sending also carPlateNumber in case if user would like to ledaveah and we will pass it from PopUpVC into UploadVC
                    popNoDataVC.carNumber = self.gCarPlateNumber
                    self.addChild(popNoDataVC)
                    popNoDataVC.view.frame = self.view.frame
                    self.view.addSubview(popNoDataVC.view)
                    popNoDataVC.didMove(toParent: self)
                    
                }
                else{//we found some data about the car in BackEnd
                
                    //only if there are a carPlateNumber
                    if let carPlateNumber = json["מספר רכב"].string{
                        self.gCarPlateNumber = carPlateNumber
                        print("carPlateNumber \(carPlateNumber)")
                    }
                    else{//car plate number is empty
                        print("...no carPlateNumber need to assign the default company name")
                        //...no carPlateNumber need to assign the default gCarPlateNumber name
                        self.gCarPlateNumber = "כללי"
                        print("gCarPlateNumber ", self.gCarPlateNumber)
                    }
    
                    //only if there are a company name
                    if let carCompanyName = json["יצרן"].string{
                        self.gCarCompanyName = carCompanyName
                        print("carCompanyName \(carCompanyName)")
                    }
                    else{//car name is empty
                        print("...no companyName need to assign the default company name")
                        //...no companyName need to assign the default gCarCompanyName name
                        self.gCarCompanyName = "כללי"
                        print("gCarCompanyName ", self.gCarCompanyName)
                    }
                    //only if there are a car model year
                    if let carModelNumber = json["שנת ייצור"].string{
                        self.gCarModelYear = carModelNumber
                        print("carModelNumber \(carModelNumber)")
                    }
                    else{//car model is empty
                        print("...no carModelYear need to assign the default company name")
                        //...no carModelNumber need to assign the default gCarModelYear name
                        self.gCarModelYear = "כללי"
                        print("gCarModelYear ", self.gCarModelYear)
                    }
                    
                    //only if there are a car degem
                    if let carDegem = json["דגם"].string{
                        self.gCarDegemName = carDegem
                        print("carDegem \(carDegem)")
                    }
                    else{//car degem is empty
                        print("...no carDegemName need to assign the default company name")
                        //...no carDegemName need to assign the default gCarDegemName name
                        self.gCarDegemName = "כללי"
                        print("gCarDegemName ", self.gCarDegemName)
                        
                    }
                    
                    //only if there are tat degem of a car
                    if let carTatDegemName = json["תת דגם"].string{
                        self.gCarTatDegemName = carTatDegemName
                        print("carTatDegem \(carTatDegemName)")
                    }
                    else{//car tatDegem name is empty
                        print("...no carTatDegemName need to assign the default company name")
                        //...no carTatDegemName need to assign the default gCarTatDegemName name
                        self.gCarTatDegemName = "כללי"
                        print("gCarTatDegemName ", self.gCarTatDegemName)
                        
                    }
                    //only if there are country creator of a car
                    if let carCountryCreatorName = json["תוצרת"].string{
                        self.gCarCountryCreatorName = carCountryCreatorName
                        print("carCountryCreatorName \(carCountryCreatorName)")
                    }
                    else{//car carCountryCreatorName name is empty
                        print("...no carCountryCreatorName need to assign the default company name")
                        //...no carCountryCreatorName need to assign the default gCarCountryCreatorName name
                        self.gCarCountryCreatorName = "כללי"
                        print("gCarCountryCreatorName ", self.gCarCountryCreatorName)
                    }
                    //only if there are ownership of a car
                    if let carOwnershipType = json["בעלות נוכחית"].string{
                        self.gCarOwnershipType = carOwnershipType
                        print("carOwnershipType \(carOwnershipType)")
                    }
                    else{//car carOwnershipType name is empty
                        print("...no carOwnershipType need to assign the default company name")
                        //...no carOwnershipType need to assign the default company name
                        self.gCarOwnershipType = "כללי"
                        print("gCarOwnershipType ", self.gCarOwnershipType)
                    }
                    
                    //*** Done we found some data about the car in BackEnd just need to pass data into popUpViewController
                    
                    //2.) CASE -> didn't find data in ourDB but find it on BackEnd (message:car details) (BUTTON "Daveah")
                    
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
                    popOverVC.carCompanyName = self.gCarCompanyName
                    popOverVC.carDegem = self.gCarDegemName
                    popOverVC.carTatDegem = self.gCarTatDegemName
                    popOverVC.carCountryCreatorName = self.gCarCountryCreatorName
                    popOverVC.carModelYear = self.gCarModelYear
                    popOverVC.carOwnershipType = self.gCarOwnershipType
                    //sending also carPlateNumber in case if user would like to ledaveah and we will pass it from PopUpVC into UploadVC
                    popOverVC.carNumber = self.gCarPlateNumber
                    
                    self.addChild(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                
                }
                
            }
            
        }
    }


}

