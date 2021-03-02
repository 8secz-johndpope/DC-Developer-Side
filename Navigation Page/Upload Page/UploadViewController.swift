//
//  UploadViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 06/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import Photos
import SDWebImage
import FirebaseDatabase
import FirebaseStorage
import FirebaseFunctions
import SwiftyJSON
import GoogleMobileAds

class UploadViewController: UIViewController,GADBannerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    //set-up Banner Ads -> in the bottom of the screen will appear this banner
    var bannerView: GADBannerView!
    
    
   //set up back-end firebase functions
    lazy var functions = Functions.functions()
    
    var gCarPlateNumber = ""
    var gCarCompanyName = ""
    var gCarModelYear = ""
    var gCarDegemName = ""
    var gCarTatDegemName = ""
    var gCarCountryCreatorName = ""
    var gCarOwnershipType = ""
    
    //flag true If got Error From BackEnd Do Not Add Details to car Att All
    var flagGotErrorFromBackEnd = false
    
    //countryCarsDb
    func countryCarDB(){
        print("check the Plate - number that we didn't send into the back end ", plateNumberTxt.text)
        print("check the number that we send into the back end ", plateNumberForCountryDB)
        functions.httpsCallable("getCarInformation").call(["carNumber": "\(plateNumberForCountryDB)"]) { (result, error) in
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
                    
                    //...no companyName need to assign the default company name
                    //...no carModelYear need to assign the default company name
                    //...no carDegemName need to assign the default company name
                    
                    self.flagGotErrorFromBackEnd = true
                   
                    
                }
                // ...
            }
            //            if let text = (result?.data as? [String: Any])?["text"] as? String {
            //                self.resultField.text = text
            //            }
            if let text = (result?.data) {
                print("Succesfull call to BackEnd")
                print(text)  // WOULD EXPECT A PRINT OF THE CALLABLE FUNCTION HERE
                let json = JSON(text)
                print("json => \(json)")
                
                if json.isEmpty {
                    print("BASA EIN BE MAAGAR")
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
                
                
                
            }
            
        }
    }
    
    
    
    
    
    
    
    

    @IBOutlet weak var plateNumberTxt: UITextField!
    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var loadImgageThroughCamera: UIButton!
    @IBOutlet weak var loadImgageThroughGallery: UIButton!

    var stringUrl = ""
    //to up pic
    let imagePicker = UIImagePickerController()

    //declerate activity indicator
    let activityInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    //action sheet button
    private let showTitleDrawerButton = UIButton()
    
    
    //protocol of passing data from PopUpVC to display carPlateNumberOfScreen
    var gPassingPlateNumberFromPopUpVc = ""
    var flagThatShowThatDataWasPassedFromPopUpVc = false
    func passingPlateNumberFromPopUpVc(){
        plateNumberTxt.text = gPassingPlateNumberFromPopUpVc
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
        
        
        
        //setup activity indicator
        activityInd.center = self.view.center
        activityInd.hidesWhenStopped = true
        activityInd.style = .gray
        self.view.addSubview(activityInd)
        //indicator - END HERE
        
        
        imagePicker.delegate = self
        
        //hiding the upload buttons
        loadImgageThroughCamera.isHidden = true
        loadImgageThroughGallery.isHidden = true
        self.loadImgageThroughCamera.alpha = 0
        self.loadImgageThroughGallery.alpha = 0
        
        
        checkPermission()
    
        
        //passing data from the PopUpVC for display the carPlateNumber that user didn't find
        if flagThatShowThatDataWasPassedFromPopUpVc{//data was passed from popUpViewController
            print("DATA WAS PASSED SUCCESSFULY FROM PopUpVC -> UploadVC")
            passingPlateNumberFromPopUpVc()
            //number is displayed and it's valid number so we need to show buttons
            loadImgageThroughCamera.isHidden = false
            loadImgageThroughGallery.isHidden = false
            
            UIView.animate(withDuration: 1){
                self.loadImgageThroughCamera.alpha = 1
                self.loadImgageThroughGallery.alpha = 1
            }
        }
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
    
    func showAlert(){
        
        
        //alert is appear if photo is uploaded
        let alertController = UIAlertController(title: "התמונה עלתה לענן בהצלחה!", message: "תודה שאתה חלק מאיתנו,כרגע התמונה עוברת תהליך אימות בעזרת הטכנולוגיות המתקדמות שלנו ויוצג בזמן הקרוב. \n האם תרצה להוסיף עוד תמונה של אותו מספר רכב?", preferredStyle: .alert)
        
        // Create the actions
        let action = UIAlertAction.init(title: "כן", style: .default) { (UIAlertAction) in
            NSLog("OK Pressed")
            
            //enable the upload button
            self.loadImgageThroughCamera.isEnabled = true
            self.loadImgageThroughGallery.isEnabled = true
            //enable the plateNumberTxt
            self.plateNumberTxt.text = self.plateNumberTxt.text?.replacingOccurrences(of: "-", with: "")
            self.plateNumberTxt.isEnabled = true
        }
        
        let cancelAction = UIAlertAction.init(title: "לא", style: .cancel) { (UIAlertAction) in
            //enable the upload button
            self.loadImgageThroughCamera.isEnabled = true
            self.loadImgageThroughGallery.isEnabled = true
            //enable the plateNumberTxt
            self.plateNumberTxt.isEnabled = true
            //hiding the loadImgageThroughCamera
            self.loadImgageThroughCamera.isHidden = true
            self.loadImgageThroughGallery.isHidden = true
            
            self.imageShow!.sd_setImage(with: URL(string: ""), completed: nil)
            //cleaning the plateNumberTxt for another car
            self.plateNumberTxt.text = ""
        }
        
        
        
        // Add the actions
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    

    @IBAction func loadImageThroughGalleryIsPressed(_ sender: Any) {
        view.endEditing(true)


        //going to the countryDB
        //call Async to BackEnd to countryCarDB to fetch the data
        //assigning data into the GloabalVariables (var g.....)
        plateNumberForCountryDB = plateNumberTxt.text!
        countryCarDB()
        
        imagePicker.allowsEditing = false
        //load picture from the library
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)

    }
    
    
    @IBAction func loadImageThroughCameraIsPressed(_ sender: Any) {
        view.endEditing(true)
        
        //going to the countryDB
        //call Async to BackEnd to countryCarDB to fetch the data
        //assigning data into the GloabalVariables (var g.....)
        plateNumberForCountryDB = plateNumberTxt.text!
        countryCarDB()
        
        
        imagePicker.allowsEditing = false
        //load picture from the camera shoot
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    

    
    
    //get permission for uploading image from your local album
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        @unknown default:
            return
        }
    }
    
    //name of image ID to sync DB and Storage
    var globalImageIdTheName : Int64 = 0
    
    
    //new plateNumber with "-" sign
    var plateNumberWithMinusSign = ""
    
    //new plateNumber withou "-" sign
    var plateNumberForCountryDB = ""
    
    //from the moment I picked up Image from the album to the moment I post it to the FireBase Storage and grab the URL of this photo
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : AnyObject]){
        
        //disable button to touch after picking the image -> enable only after alert
        //to avoid multiple call to firebase (otherwise app crashing)
        loadImgageThroughCamera.isEnabled = false
        loadImgageThroughGallery.isEnabled = false
        //disable the plateNumberTxt
        self.plateNumberTxt.isEnabled = false
        
        picker.dismiss(animated: true, completion: nil)
        
        //picture is chosen
        //edit pic is info -> info[.editedImage]
        if var pickedImage = info[.originalImage] as? UIImage{
            
            
            //cleaning the image for another car
            self.imageShow!.sd_setImage(with: URL(string: ""), completed: nil)
            
            //picture is chosen now we will add "-" sign into the plateNumber
            if plateNumberTxt.text?.count == 8{//plate number is 8 digit
                plateNumberWithMinusSign = addMinusSignInPlateNum(numberOfDigit: 8)
            }
            else{//plateNumber is 7 digit
                 plateNumberWithMinusSign = addMinusSignInPlateNum(numberOfDigit: 7)
            }
            
            //checking the size before to know how much to compress
            //compressing value of 0.8 is beyond for an original Value
            var newData = pickedImage.jpegData(compressionQuality: 0.8)
            var image = UIImage(data: newData!)
            print("what is a size \(newData!.count)")
            
            //meta data is
            let metaDataForImage = StorageMetadata()
            
            //(1) png variant
//            metaDataForImage.contentType = "image/png"
            
            //(2) jpeg variant
            metaDataForImage.contentType = "image/jpg"
            
            //from this part we fetch the image Name to sycn the DB and the Storage (imageIdTheName) will contain the milliseconds from the 1970 ( the created time of photo)
            
            var imageIdTheName : Int64 = 0
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{//if creation date of photo is found and it's isn't nil
                print("imageIdTheName is created")
                let imageCreationDate = asset.creationDate
                //this name is based on UNIX time in miliseconds from 1970
                imageIdTheName = Int64(((imageCreationDate?.timeIntervalSince1970)! * 1000.0).rounded())
                globalImageIdTheName = imageIdTheName
                print("NO THIS IS THE NAME \(imageIdTheName)")
                print("-------- Creation Date of picture \(imageCreationDate)")
            }
            else{// imageIdTheName wasn't created
                print("imageIdTheName wasn't created")
                imageIdTheName = Int64(Int.random(in: 10000..<99999))
                 globalImageIdTheName = imageIdTheName
            }
           
            
            //I want to upload the photo to storage and save it in the database
            var data = Data()
        
//            data = pickedImage.pngData()!
             print("sss before compresing \(data.count)")
            
//            print("Original data \(pickedImage.)")
            
            
            //all sizes is from the png size
            if newData!.count > 0 && newData!.count < 1000000{
                print("between 0kb to 1Mb")
                //original photo 0.7
                data = pickedImage.jpegData(compressionQuality: CGFloat(0.7))!

            }
            else if newData!.count > 1000000 && newData!.count < 2000000{
                print("between 1Mb to 2Mb")
                //1.5Mb into 930Kb
                data = pickedImage.jpegData(compressionQuality: CGFloat(0.5))!
            }
            else if newData!.count > 2000000 && newData!.count < 3000000{
                print("between 2Mb to 3Mb")
                //2.02Mb into 519Kb
                 data = pickedImage.jpegData(compressionQuality: CGFloat(0.3))!
            }
            else if newData!.count > 3000000 && newData!.count < 4000000{
                print("between 3Mb to 4Mb")
                data = pickedImage.jpegData(compressionQuality: 0.1)!
            }
            else if newData!.count > 4000000 && newData!.count < 5000000{
                print("between 4Mb to 5Mb")
                data = pickedImage.jpegData(compressionQuality: 0.2)!
            }
            else if newData!.count > 5000000 && newData!.count < 6000000{
                print("between 5Mb to 6Mb")
                data = pickedImage.jpegData(compressionQuality: 0.2)!
            }
            else if newData!.count > 6000000 && newData!.count < 7000000{
                print("between 6Mb to 7Mb")
                data = pickedImage.jpegData(compressionQuality: 0.2)!
            }
//            else if newData!.count > 7000000 && newData!.count < 8000000{
//                print("between 7Mb to 8Mb")
//            }
//            else if newData!.count > 8000000 && newData!.count < 9000000{
//                print("between 8Mb to 9Mb")
//            }
            else{//if image origin size is biger then 7mb compress it as hard as we can
                data = pickedImage.jpegData(compressionQuality: 0.001)!
            }
            
            
            print("sss after compresing \(data.count)")

            //start loading animation (activity indicator)
            activityInd.startAnimating()
            
            
            // Create a reference to the file you want to upload
            let folderRef = Storage.storage().reference().child("Development/")
            let folderPlateNumber = folderRef.child("\((plateNumberWithMinusSign))")
            let imageRef = folderPlateNumber.child("\(String(imageIdTheName))")
            
            //Upload the file to the path "image/randomString"
            let uploadTask = imageRef.putData(data, metadata: metaDataForImage) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    
                    //aditing string to url - grabbing the url of the photo
                    self.stringUrl = "\(url!)"
                    
                    while(self.stringUrl == ""){
                        
                    }
                    
                    //Stop loading animation (activity indicator)
                    self.activityInd.stopAnimating()
                    
                    self.imageShow.sd_setImage(with: url!, completed: nil)
                    
                    //sending data into the FB DB imgName,imgUrl,plateNumber
                    self.addNewCarIntoDB(imageName: String(self.globalImageIdTheName), imageUrl: self.stringUrl, plateNumber: self.plateNumberWithMinusSign)
                    
                    // Present the alert 2 seconds after the image is shown on the screen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        self.showAlert()
                    }
                    
                    print("THI IS THE URL OF PIC THAT I JUST UPLOADED AND DOWNLOADED ", url)
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }
            print("HELLO YOU ALMOST UPLOAD YOUR IMAGE")
        }
        
    }
    
    
    //adding the minus "-" sign for more convenience save in DB
    func addMinusSignInPlateNum(numberOfDigit: Int) -> String{
        var newPlateWithMinus = ""
        if numberOfDigit == 8{//8 digit plate
            print("PLATE 8 DIGITS")
            print("!newPlateWithMinus before - \(newPlateWithMinus)")
            plateNumberTxt.text?.insert("-", at: (plateNumberTxt.text?.index((plateNumberTxt.text?.startIndex)!, offsetBy: 3))!)
            plateNumberTxt.text?.insert("-", at: (plateNumberTxt.text?.index((plateNumberTxt.text?.startIndex)!, offsetBy: 6))!)
            newPlateWithMinus = plateNumberTxt.text!
            print("!newPlateWithMinus after - \(newPlateWithMinus)")

        }
        else{//7 digit plate
            print("PLATE 7 DIGITS")
            print("!newPlateWithMinus before - \(newPlateWithMinus)")
            plateNumberTxt.text?.insert("-", at: (plateNumberTxt.text?.index((plateNumberTxt.text?.startIndex)!, offsetBy: 2))!)
            plateNumberTxt.text?.insert("-", at: (plateNumberTxt.text?.index((plateNumberTxt.text?.startIndex)!, offsetBy: 6))!)
            newPlateWithMinus = plateNumberTxt.text!
            print("!newPlateWithMinus after - \(newPlateWithMinus)")
        }
        //after inserting "-" sign into UIplateNumber for the DB need to clean it from the UI only we do not touch
        plateNumberTxt.text = plateNumberTxt.text?.replacingOccurrences(of: "-", with: "")
        return newPlateWithMinus
    }
   
    
    func addNewCarIntoDB(imageName : String, imageUrl : String, plateNumber : String){
        if(imageUrl != "" && plateNumber != ""){
            Database.database().reference().child("published/carPlate").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                //            let value = snapshot.value as? String
                //            print("value String ", value)
                if ( snapshot.value is NSNull ) {
                    
                    // DATA WAS NOT FOUND
                    print("– – – Data was not found – – –")
                    //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                    
                }
                else{// some data was found -> connection with DB is good
                
                    let allCarPlates = snapshot.value as? NSDictionary
                    print("value of allCarPlates 1 ", allCarPlates)
                    
                    

                    //figure out if we alredy have this plateNumber in our DB 
                    if allCarPlates!["\(plateNumber)"] != nil{
                        print("we found this current car , now we need to add an extra photo of it")
                        
    //******************** can comment from this moment ****************
                        //cheking how much photo does it has already
                        Database.database().reference().child("published/carPlate/\(plateNumber)").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            //            let value = snapshot.value as? String
                            //            print("value String ", value)
                            if ( snapshot.value is NSNull ) {
                                
                                // DATA WAS NOT FOUND
                                print("– – – Data was not found – – –")
                                print("----- No Photo found ------")
                                print("------An Empty License Plate Object ----")
                            }
                            let allPicturesOfExactCar = snapshot.value as? NSDictionary
                            print("value of allPicturesOfExactCar 1 ", allPicturesOfExactCar)
                            print("Amount of pictures of this particular car \(allPicturesOfExactCar!.count)")
                            var nextPhotoNumber = allPicturesOfExactCar!.count + 1
                            print("nextPhotNumber will be \(nextPhotoNumber)")
                            
        //******************* This call NOT TO COMMENT
                            //now we able to add an extra photo of particular car
                            
                            //no matter what kind of backEnd Error do we have, we still adding the photo that we picked
                        Database.database().reference().child("published/carPlate/\(plateNumber)/images/\(imageName)").setValue("\(self.stringUrl)")
                            
                            if self.flagGotErrorFromBackEnd != true { //if we don't have an error from BackEnd we would not delete Car details
                                
                                //now we able to add an extra info of particular car
                                //carCompanyName
                                 Database.database().reference().child("published/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")
                                //carDegemName
                                Database.database().reference().child("published/carPlate/\(plateNumber)/details/degemName").setValue("\(self.gCarDegemName)")
                                //carModelYear
                                 Database.database().reference().child("published/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarModelYear)")
                                
                                //carTatDegemName
                                 Database.database().reference().child("published/carPlate/\(plateNumber)/details/tatDegemName").setValue("\(self.gCarTatDegemName)")
                                
                                 //carCountryCreatorName
                                 Database.database().reference().child("published/carPlate/\(plateNumber)/details/countryCreatorName").setValue("\(self.gCarCountryCreatorName)")
                                 
                                 //carOwnershipType
                                 Database.database().reference().child("published/carPlate/\(plateNumber)/details/ownershipType").setValue("\(self.gCarOwnershipType)")
                                
                                

                                    //add into extras -> allCarsCompanies
                                
                                    //2.01.20 change add to DB plate number per exact carCompany
                                Database.database().reference().child("extras/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberWithMinusSign)").setValue("\(self.plateNumberWithMinusSign)")
                                
                                Database.database().reference().child("extras/allCarsModelsYears/\(self.gCarModelYear)").setValue("\(self.gCarModelYear)")
                            
                            
                                //turning the flag into false condition for the next BackEnd Call
                                self.flagGotErrorFromBackEnd = false
                            }
                            
                            
                        })
        //******************** until this moment can comment
//                        self.stringUrl = ""

                    }
                    else{//curent car plate not found -> it's goona be a new car object
                            print("this car not found in our unchecked DB folder")
                            print("will add it immediately")
                            //no matter what kind of backEnd Error do we have, we still adding the photo that we picked
                        Database.database().reference().child("published/carPlate/\(plateNumber)/images/\(imageName)").setValue("\(self.stringUrl)")
                        
                         if self.flagGotErrorFromBackEnd != true { //if we don't have an error from BackEnd we would not delete Car details
                        
                          
                            //now we able to add an extra info of particular car -> details
                            //carCompanyName
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")
                            //carDegemName
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/degemName").setValue("\(self.gCarDegemName)")
                            //carModelYear
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarModelYear)")
                            
                            //carTatDegemName
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/tatDegemName").setValue("\(self.gCarTatDegemName)")
                           
                            //carCountryCreatorName
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/countryCreatorName").setValue("\(self.gCarCountryCreatorName)")
                            
                            //carOwnershipType
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/ownershipType").setValue("\(self.gCarOwnershipType)")
                            
                            
                            //add into extras -> allCarsCompanies
                            //2.01.20 change add to DB plate number per exact carCompany
                            Database.database().reference().child("extras/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberWithMinusSign)").setValue("\(self.plateNumberWithMinusSign)")
                           
                 
                            
                            //add into extras -> allCarsModelYears
                            Database.database().reference().child("extras/allCarsModelsYears/\(self.gCarModelYear)").setValue("\(self.gCarModelYear)")
                            
                            //turning the flag into false condition for the next BackEnd Call
                            self.flagGotErrorFromBackEnd = false
                            
                        }
                    }
                }
            })
        }
    }
    
    //allow us to upload photos without fear that two photos would be with the same name
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    //THE END OF UPLOAD PICTURE - TO THIS MOMENT
    
    
    //hide the keyboard if touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }

    
    var limitPreviousStr = ""
    @IBAction func textFieldDidChange(_ sender: Any) {
        //checking if there are not empty plate number
        if(plateNumberTxt.text! != ""){
            //limiting the plate number of being 8 number
            if(plateNumberTxt.text!.count > 8){
                plateNumberTxt.text! = limitPreviousStr
                return
            }
            limitPreviousStr = plateNumberTxt.text!
            print("Prev number is \(limitPreviousStr)")
        }
        //checking if number is 7-n or 8 digit number
        if (plateNumberTxt.text!.count > 6 && plateNumberTxt.text!.count < 9 ){
            print("perfect size of number now can show the button")
            
            //showing the upload button if the number is correct
            UIView.animate(withDuration: 0.4, animations: {
//                self.view.layoutIfNeeded()
                self.loadImgageThroughCamera.isHidden = false
                self.loadImgageThroughGallery.isHidden = false
              
                self.loadImgageThroughCamera.alpha = 1
                self.loadImgageThroughGallery.alpha = 1
            })
            
           
            return
        }
        else{
            UIView.animate(withDuration: 0.4, animations: {
                //hiding the upload button if the number isn't correct
                self.loadImgageThroughCamera.alpha = 0
                self.loadImgageThroughGallery.alpha = 0
            })
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                self.loadImgageThroughCamera.isHidden = true
//                self.loadImgageThroughGallery.isHidden = true
//            }
        }
        
    }
    
    
    //DELETE AFTER
    //artificial method to insert all details After Alex will upload a new cars
    @IBAction func inserDetailsIntoDBPressed(_ sender: Any) {
        plateNumberForCountryDB = plateNumberTxt.text!
        countryCarDB()
        if plateNumberTxt.text?.count == 8{//plate number is 8 digit
            plateNumberWithMinusSign = addMinusSignInPlateNum(numberOfDigit: 8)
        }
        else{//plateNumber is 7 digit
             plateNumberWithMinusSign = addMinusSignInPlateNum(numberOfDigit: 7)
        }
        print("TEST PLATE WITH MINUS CHECK " , self.plateNumberWithMinusSign)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.insertOnlyDetailsToDB(plateNumber: self.plateNumberWithMinusSign)
        }
    }
    
    func insertOnlyDetailsToDB (plateNumber : String){
        if(plateNumber != ""){
                    Database.database().reference().child("published/carPlate").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        //            let value = snapshot.value as? String
                        //            print("value String ", value)
                        if ( snapshot.value is NSNull ) {
                            
                            // DATA WAS NOT FOUND
                            print("– – – Data was not found – – –")
                            //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                            
                        }
                        else{// some data was found -> connection with DB is good
                        
                            let allCarPlates = snapshot.value as? NSDictionary
                            print("value of allCarPlates 1 ", allCarPlates)
                            
                            

                            //figure out if we alredy have this plateNumber in our DB
                            if allCarPlates!["\(plateNumber)"] != nil{
                                print("we found this current car , now we need to add an extra photo of it")
                                
            //******************** can comment from this moment ****************
                                //cheking how much photo does it has already
                                Database.database().reference().child("published/carPlate/\(plateNumber)").observeSingleEvent(of: .value, with: { (snapshot) in
                                    // Get user value
                                    //            let value = snapshot.value as? String
                                    //            print("value String ", value)
                                    if ( snapshot.value is NSNull ) {
                                        
                                        // DATA WAS NOT FOUND
                                        print("– – – Data was not found – – –")
                                        print("----- No Photo found ------")
                                        print("------An Empty License Plate Object ----")
                                    }
                                    let allPicturesOfExactCar = snapshot.value as? NSDictionary
                                    print("value of allPicturesOfExactCar 1 ", allPicturesOfExactCar)
                                    print("Amount of pictures of this particular car \(allPicturesOfExactCar!.count)")
                                    var nextPhotoNumber = allPicturesOfExactCar!.count + 1
                                    print("nextPhotNumber will be \(nextPhotoNumber)")
                                    
                //******************* This call NOT TO COMMENT
                                    //now we able to add an extra photo of particular car
                                    
                                    //no matter what kind of backEnd Error do we have, we still adding the photo that we picked
                                
                                    
                                    if self.flagGotErrorFromBackEnd != true { //if we don't have an error from BackEnd we would not delete Car details
                                        
                                        //now we able to add an extra info of particular car
                                        //carCompanyName
                                        Database.database().reference().child("published/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")
                                        
                                        
                                        //carDegemName
                                        Database.database().reference().child("published/carPlate/\(plateNumber)/details/degemName").setValue("\(self.gCarDegemName)")
                                        //carModelYear
                                        Database.database().reference().child("published/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarModelYear)")
                                        
                                        //carTatDegemName
                                        Database.database().reference().child("published/carPlate/\(plateNumber)/details/tatDegemName").setValue("\(self.gCarTatDegemName)")
                                        
                                        //carCountryCreatorName
                                        Database.database().reference().child("published/carPlate/\(plateNumber)/details/countryCreatorName").setValue("\(self.gCarCountryCreatorName)")
                                        
                                        //carOwnershipType
                                        Database.database().reference().child("published/carPlate/\(plateNumber)/details/ownershipType").setValue("\(self.gCarOwnershipType)")
                                        
                                        
                                        
                                        //add into extras -> allCarsCompanies
                                        //2.01.20 change add to DB plate number per exact carCompany
                                        Database.database().reference().child("extras/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberWithMinusSign)").setValue("\(self.plateNumberWithMinusSign)")
                                        
                                        
                                        
                                        Database.database().reference().child("extras/allCarsModelsYears/\(self.gCarModelYear)").setValue("\(self.gCarModelYear)")
                                        
                                        
                                        //turning the flag into false condition for the next BackEnd Call
                                        self.flagGotErrorFromBackEnd = false
                                    }
                                    
                                    
                                })
                //******************** until this moment can comment
        //                        self.stringUrl = ""

                            }
                            else{//curent car plate not found -> it's goona be a new car object
                                    print("this car not found in our unchecked DB folder")
                                    print("will add it immediately")
                         
                                
                                 if self.flagGotErrorFromBackEnd != true { //if we don't have an error from BackEnd we would not delete Car details
                                
                                  
                                    //now we able to add an extra info of particular car -> details
                                    //carCompanyName
                                    
                            Database.database().reference().child("published/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")
                                    
                           
                                    //carDegemName
                                    Database.database().reference().child("published/carPlate/\(plateNumber)/details/degemName").setValue("\(self.gCarDegemName)")
                                    //carModelYear
                                    Database.database().reference().child("published/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarModelYear)")
                                    
                                    //carTatDegemName
                                    Database.database().reference().child("published/carPlate/\(plateNumber)/details/tatDegemName").setValue("\(self.gCarTatDegemName)")
                                   
                                    //carCountryCreatorName
                                    Database.database().reference().child("published/carPlate/\(plateNumber)/details/countryCreatorName").setValue("\(self.gCarCountryCreatorName)")
                                    
                                    //carOwnershipType
                                    Database.database().reference().child("published/carPlate/\(plateNumber)/details/ownershipType").setValue("\(self.gCarOwnershipType)")
                                    
                                    
                                       //2.01.20 change add to DB plate number per exact carCompany
                                Database.database().reference().child("extras/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberWithMinusSign)").setValue("\(self.plateNumberWithMinusSign)")
                                   
                         
                                    
                                    //add into extras -> allCarsModelYears
                                    Database.database().reference().child("extras/allCarsModelsYears/\(self.gCarModelYear)").setValue("\(self.gCarModelYear)")
                                    
                                    //turning the flag into false condition for the next BackEnd Call
                                    self.flagGotErrorFromBackEnd = false
                                    
                                }
                            }
                        }
                    })
                }
    }
    

}

//compressing the upload images - at this moment not useable
extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        return resizingImage
    }
}
extension UIImage {
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        let image = UIImage()
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = image.jpegData(compressionQuality: 0.50){
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }

        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
//extension Date {
//
//    var millisecondsSince1970:Int64 {
//        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds:Int64) {
//        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
//    }
//}

