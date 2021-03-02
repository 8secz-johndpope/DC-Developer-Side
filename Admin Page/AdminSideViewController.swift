//
//  AdminSideViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 06/01/2020.
//  Copyright © 2020 Pavel Petrenko. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import FirebaseDatabase
import FirebaseFunctions
import FirebaseStorage
import SwiftyJSON
import SDWebImage
import AVKit

class AdminSideViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    //setUpCounters
    //Cars Counter IN LIVE
    
    @IBOutlet weak var thsousandsLiveLbl: UILabel!
    @IBOutlet weak var hunderdsLiveLbl: UILabel!
    @IBOutlet weak var dozensLiveLbl: UILabel!
    @IBOutlet weak var unitsLiveLbl: UILabel!
    //Cars Counter IN UPLOADS
    @IBOutlet weak var hundredsUploadLbl: UILabel!
    @IBOutlet weak var dozensUploadLbl: UILabel!
    @IBOutlet weak var unitsUploadLbl: UILabel!
    
    
    
    
    
    //MENU BUTTONS AND OTHER MENU DETAILS
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    
    
    @IBAction func menuButtonIsPressed(_ sender: Any) {
     print("menu button is pressed")
           
        UIView.animate(withDuration: 0.3) {
            //identity remember the start button position
            if self.menuBtn.transform == .identity{
                //if button is open set the button to spinning
                self.menuBtn.transform = CGAffineTransform(rotationAngle: 45 * (.pi/180))
                //if button is pressed open up the menuView
                self.menuView.transform = .identity
                    
            }
            else{
                //if button is closed set it to the start position
                self.menuBtn.transform = .identity
                //if button is closed set the menuView to little scale
                self.menuView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                
               
                //hiding the carCompanyTextField Only if was displayed on the screen
                if self.carDetailsEditBtn.transform == .identity{
                    print("doing nothing cause menu button is closed but carCompanyTextField wasn't displayed")

                }
                else{
                    print("hiding the carCompanyTextField cause menu button is closed")
                    UIView.animate(withDuration: 0.3){
                        self.carCompanyFromRight.constant += self.view.bounds.width
                        //cancel the pressed carDetailsEditBtn to avoid twice disappeared the carCompanyTextField
                        self.carDetailsEditBtn.transform = .identity
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    

    
    //into menu (inside the menuView)
    

    @IBOutlet weak var carDetailsEditBtn: UIButton!
 
    //details of car -> carCompanyTextField
    @IBOutlet weak var carCompanyTextField: UITextField!
    @IBOutlet weak var carCompanyFromRight: NSLayoutConstraint!
    
    
    @IBAction func carDetailsEditButtonIsPressed(_ sender: UIButton) {
        
      
        //show and hide the carCompanyTextField
        if self.carDetailsEditBtn.transform == .identity{
            //button bouncing
            UIView.animate(withDuration: 0.3){
                self.carDetailsEditBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                UIView.animate(withDuration: 0.4, delay: 0.3, animations: {
                    self.carDetailsEditBtn.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                }, completion: nil)
            }
            print("show")
            //showing the carCompanyTextField
            UIView.animate(withDuration: 0.3){
                self.carCompanyFromRight.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }
        }
        else{
            UIView.animate(withDuration: 0.3){
                //button bouncing
                self.carDetailsEditBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                UIView.animate(withDuration: 0.4, delay: 0.3, animations: {
                    self.carDetailsEditBtn.transform = .identity
                }, completion: nil)
                //hiding the carCompanyTextField
                print("hide")
                UIView.animate(withDuration: 0.3){
                    self.carCompanyFromRight.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                }
            }
        }
        
    }
    
    
    @IBOutlet weak var skipToNextAd: UIButton!
    
    @IBAction func skipToNextAdButtonIsPressed(_ sender: UIButton) {
        
        self.skipToTheNextAd()
        
        //zoom in the button (skipToNextAd)
        UIView.animate(withDuration: 0.3) {
            self.skipToNextAd.transform = CGAffineTransform(scaleX: 2.7, y: 2.7)
        }
        //rotating and returning button into it's start condition (skipToNextAd)
        UIView.animate(withDuration: 0.5){
            self.skipToNextAd.transform = CGAffineTransform(rotationAngle: 180 * (.pi/180))
            //return to the start position for next time pressing it will spinning again
            self.skipToNextAd.transform = .identity
        }
        //closing the menu automatically
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: 0.3) {
                self.menuView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                 self.menuView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: nil)

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                 //will close the menuView
                 self.menuButtonIsPressed(self)
            }
        }
        
    }
    
    
    
    @IBOutlet weak var reloadBtn: UIButton!
    
    @IBAction func reloadButtonIsPressed(_ sender: UIButton) {
        //restart all page
        self.reloadPage()
        
        //zoom in the button (reloadBtn)
        UIView.animate(withDuration: 0.3) {
            self.reloadBtn.transform = CGAffineTransform(scaleX: 2.7, y: 2.7)
        }
        //rotating and returning button into it's start condition (reloadBtn)
        UIView.animate(withDuration: 0.5) {
            self.reloadBtn.transform = CGAffineTransform(rotationAngle: 180 * (.pi/180))
            //return to the start position for next time pressing it will spinning again
            self.reloadBtn.transform = .identity
        }
        
        //closing the menu automatically
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            UIView.animate(withDuration: 0.3) {
                self.menuView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                 self.menuView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: nil)

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                 //will close the menuView
                 self.menuButtonIsPressed(self)
            }
        }
          
        
        
    }
    
    //INITILIZING OF ALL VARIABLES
    
    //flag true If got Error From BackEnd Do Not Add Details to car Att All
    var flagGotErrorFromBackEnd = false
    
    @IBOutlet weak var plateNumberLbl: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var imageInfoLabel: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var carCompanyNameLbl: UILabel!
    @IBOutlet weak var carDegemLbl: UILabel!
    @IBOutlet weak var carTatDegemLbl: UILabel!
    @IBOutlet weak var carCountryCreatorNameLbl: UILabel!
    @IBOutlet weak var carModelYearLbl: UILabel!
    @IBOutlet weak var carOwnershipTypeLbl: UILabel!
    
    
    
    var gCarCompanyName = ""
    var gCarModelYear = ""
    var gCarDateNumber = ""
    var gCarDegemName = ""
    var gCarTatDegemName = ""
    var gCarCountryCreatorName = ""
    var gCarOwnershipType = ""
    var gCarPlateNumber = ""
    
    //set up back-end firebase functions
    lazy var functions = Functions.functions()


    var allCarsPlatesNumbers : [String] = []
    var arrayOfAllCarUrlsImages: [String] = []
    var amountOfImagesInExactCar = 0
    //important cache downloading function for saving the images into the Cached array FOR ZOOMING
    var arrayOfCachedImages:[UIImage] = []
    
    var arrayOfBlackListImages : [String] = []
    
    var arrayOfAllDictionariesImages : [[String : String]] = []
    var arrayOfAllDictionariesOfBlackListImages : [[String : String]] = []
    var dictKeyValueImage : [String : String] = ["key" : "", "imageUrl" : ""]
    
    
    //index of label that show
    var indexOfImage = 1

    @IBOutlet weak var nextPictureBtn: UIButton!
    @IBOutlet weak var previousPictureBtn: UIButton!
    
    @IBOutlet weak var deletePictureBtn: UIButton!
    @IBOutlet weak var rejectAd: UIButton!
    @IBOutlet weak var acceptAd: UIButton!
    
    
   //delete picture Container UIView
    @IBOutlet weak var deleteButtonContainer: UIView!
    @IBOutlet weak var imageInsideDeleteContainer: UIImageView!
    
    //ads Container UIView
    @IBOutlet weak var adsButtonsContainer: UIView!
    
    //layout constraints
    @IBOutlet weak var adsButtonsContainerFromDown: NSLayoutConstraint!
    @IBOutlet weak var deletePictureButtonContainerFromDown: NSLayoutConstraint!
    
    //Global carPlateIndex
    var globalCarPlateIndex = 0
    
    //activity indicator appears between reloading the next car from upload
    let activityInd : UIActivityIndicatorView = UIActivityIndicatorView()
    
    func reloadPage(){
        print("in reload")
        //timely disable all buttons while the next car is loading
        self.nextPictureBtn.isEnabled = false
        self.previousPictureBtn.isEnabled = false
        self.rejectAd.isEnabled = false
        self.acceptAd.isEnabled = false
        self.deletePictureBtn.isEnabled = false
        
        //reset the imageInfoLabel
        self.imageInfoLabel.text = "1   of   ∞"
        
        //reset the car image index
        self.gCarIndex = 0
        self.indexOfImage = 1
        self.updatedImageAmount = 0
        self.gAmountOfDeletedImages = 0
        
        //clean the carImage before displaying the next car
        self.carImage.sd_setImage(with: nil, completed: nil)
        self.carImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.carImage.sd_imageIndicator?.startAnimatingIndicator()
        
        print("previous car was")
        print(gCarDegemName,gCarCompanyName,gCarModelYear)
        print(gCarTatDegemName,gCarCountryCreatorName,gCarOwnershipType)
        
        
        
        print("the arrayOfAllDictionariesOfBlackListImages is empty before the reloading ?",self.arrayOfAllDictionariesOfBlackListImages.isEmpty)
        print("the arrayOfAllDictionariesImages is empty before the reloading ?",self.arrayOfAllDictionariesImages.isEmpty)
    
        
        //Deleting all previous imagesData from White List And Black List And CachedImages
        self.arrayOfAllDictionariesImages.removeAll()
        self.arrayOfAllDictionariesOfBlackListImages.removeAll()
        self.arrayOfCachedImages.removeAll()
        self.arrayOfAllCarUrlsImages.removeAll()
        //if we want that reloadButton will not affect to delete pictures just remove the next code otherwise...
        //if we by mistake delete some photo we always can refresh it by pressing the reloadButton and all "Temorary Deleted Photos " will appear again
        self.arrayOfBlackListImages.removeAll()
        
        
        print("the arrayOfAllDictionariesOfBlackListImages is empty after the reloading ?",self.arrayOfAllDictionariesOfBlackListImages.isEmpty)
        print("the arrayOfAllDictionariesImages is empty after the reloading ?",self.arrayOfAllDictionariesImages.isEmpty)
        
        //fetching the new data
        if !self.allCarsPlatesNumbers.isEmpty{
            self.plateNumberLbl.text = self.allCarsPlatesNumbers[self.globalCarPlateIndex]
            self.fetchAllImagesOfTheExactCarPlateFromDB(carAtIndex: self.globalCarPlateIndex)
            self.getDataFromCountryCarDBAndDisplayOnPopUpView(carAtIndex: self.globalCarPlateIndex)
        }
        //dispalying infos on screen of the first image of next car that we fetch
         DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.imageInfoLabel.text = "1   of   \(self.arrayOfAllCarUrlsImages.count)"
           
            print("current car now")
            print(self.gCarDegemName,self.gCarCompanyName,self.gCarModelYear)
            print(self.gCarTatDegemName,self.gCarCountryCreatorName,self.gCarOwnershipType)
            //checking if we have a picture inside before display it
            if !self.arrayOfAllCarUrlsImages.isEmpty {
                self.carImage.sd_setImage(with: URL(string: self.arrayOfAllCarUrlsImages[0]), completed: nil)
            }
            //enable all buttons while the next car is loaded
            self.nextPictureBtn.isEnabled = true
            self.previousPictureBtn.isEnabled = true
            self.rejectAd.isEnabled = true
            self.acceptAd.isEnabled = true
            self.deletePictureBtn.isEnabled = true
            
            //disable the next and previous photo buttons if there are no images at all
            if self.imageInfoLabel.text == "1   of   0"{
                //display image that show that there are no moere cars in DB (into Uploads)
                self.carImage.image = UIImage(named: "noMoreCarsImage")
                self.carImage.sd_imageIndicator?.stopAnimatingIndicator()
                self.nextPictureBtn.isEnabled = false
                self.previousPictureBtn.isEnabled = false
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //making the carCompanyTextField be delegate of this current VC for hiding the keyboard when user pressed return (on keyboard)
        self.carCompanyTextField.delegate = self
        
        //set up the menu UIView
        self.menuView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.menuView.layer.cornerRadius = 200
        self.menuView.layer.shadowColor = UIColor.black.cgColor
        self.menuView.layer.shadowOpacity = 1
        self.menuView.layer.shadowOffset = .zero
        self.menuView.layer.shadowRadius = 5
        
        
//        //testing manually tnrasfer to the next cat in Upload
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.globalCarPlateIndex += 1
//            self.reloadPage()
//        }
        
        print("!!! VIEW DID LOAD !!! ")
        print("the arrayOfAllDictionariesOfBlackListImages is empty ?",self.arrayOfAllDictionariesOfBlackListImages.isEmpty)
        print("the arrayOfAllDictionariesImages is empty ?",self.arrayOfAllDictionariesImages.isEmpty)
        
        
        
        //setup all buttons
        nextPictureBtn.alpha = 0
        nextPictureBtn.layer.cornerRadius = 10
        
        previousPictureBtn.alpha = 0
        previousPictureBtn.layer.cornerRadius = 10
        
        deletePictureBtn.alpha = 0
        deletePictureBtn.layer.cornerRadius = 10
        
        rejectAd.alpha = 0
        rejectAd.layer.cornerRadius = 10
        
        acceptAd.alpha = 0
        acceptAd.layer.cornerRadius = 10
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)

        self.view.addSubview(scrollView)


        //FETCHING ALL PLATES NUMBERS THAT WE DIDN'T CHECK YET
        //assign it into array allCarsPlatesNumbers[]
        self.fetchAllPlatesNumbersFromDB()
        
        //checking amount of cars in LiveDB currently it's publishedTemp (only to inform admin FROM "Cars In Live" lbl
        self.fetchAllCarsFromLiveDB()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                           
                self.nextPictureBtn.alpha = 1
                self.previousPictureBtn.alpha = 1
                self.deletePictureBtn.alpha = 1
                self.rejectAd.alpha = 1
                self.acceptAd.alpha = 1
                
                
            }, completion: nil)
            
            print("LENGTH of self.allCarsPlatesNumbers.count ", self.allCarsPlatesNumbers.count)
            
            if !self.allCarsPlatesNumbers.isEmpty{
                
                self.plateNumberLbl.text = self.allCarsPlatesNumbers[self.globalCarPlateIndex]
                self.fetchAllImagesOfTheExactCarPlateFromDB(carAtIndex: self.globalCarPlateIndex)
                self.getDataFromCountryCarDBAndDisplayOnPopUpView(carAtIndex: self.globalCarPlateIndex)
            }
            else{//something wrong with connection can't fetch self.allCarsPlatesNumbers[0] data from DB
                print("something wrong with connection can't fetch self.allCarsPlatesNumbers[0] data from DB")
                self.noExtraCarsInUploadAlert()
            }
            
            
            
            //dispalying infos on screen of the first car that we fetch
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                // uncheck must to contain at least one carPlate
                if !self.arrayOfAllCarUrlsImages.isEmpty {
                    self.imageInfoLabel.text = "1   of   \(self.arrayOfAllCarUrlsImages.count)"
                    self.carImage.sd_setImage(with: URL(string: self.arrayOfAllCarUrlsImages[0]), completed: nil)
                }
            }
            
            //12/01/2020 this func add create and initializate carViews being a zero 0
//            self.insertNewObjIntoExactCar()
        }

        // Do any additional setup after loading the view.
    }
    
    func skipToTheNextAd(){
     DispatchQueue.main.asyncAfter(deadline: .now()) {
          //reload data for the next carPlate
         if self.globalCarPlateIndex + 1 < self.allCarsPlatesNumbers.count{//if we have an extra plate in Upload we doing the next step
             print("We have an Extra car in Upload")
             self.globalCarPlateIndex += 1
             print("now loading... the new screen")
             self.reloadPage()
         }
         else{
             self.noExtraCarsInUploadAlert()
         }
     }
    }
   
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = carImage.frame.size.height / scale
        zoomRect.size.width  = carImage.frame.size.width  / scale
        let newCenter = carImage.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.carImage
    }

    
    //MARK: 1.) NEXT AND PREVIOUS PHOTO
    
    var gCarIndex = 0
        //MARK: 1.1) NEXT PHOTO
    @IBAction func nextPhotoButtonIsPressed(_ sender: Any) {
        updateArrayOfUrlImages()
        if self.arrayOfAllDictionariesOfBlackListImages.isEmpty {
            print("Black List is Empty ",self.arrayOfAllDictionariesOfBlackListImages.isEmpty)
        }
        else{
            print("Black List is Empty ",self.arrayOfAllDictionariesOfBlackListImages.isEmpty)
        }
        self.updatedImageAmount = self.arrayOfAllCarUrlsImages.count
        //firstly ZoomOut before introduce the next Photo
        self.scrollView.zoomScale = 1.0
        
        print("gCarIndex was ", gCarIndex)
        if indexOfImage != updatedImageAmount{
            //for label
            indexOfImage += 1
            //for the arrayOfAllCarUrlsImages range
            gCarIndex += 1
            self.imageInfoLabel.text = "\(indexOfImage)   of   \(updatedImageAmount)"
        }
        
        
        if gCarIndex != updatedImageAmount{
         
        }
        else{
            print("MAX IMAGE RANGE NOT MATTER HOW MUCH WILL PRESS NEXT IT'S THE LAST RANGE")
        }
        print("gCarIndex now ", gCarIndex)

        if gCarIndex < updatedImageAmount{
            print("next photo will show now")
            
            self.carImage.sd_setImage(with: URL(string: self.arrayOfAllCarUrlsImages[gCarIndex]), completed: nil)
            
        }
    }
    
    func updateArrayOfUrlImages(){
        var tempArrayOfAllImagesUrl : [String] = []
        if !arrayOfBlackListImages.isEmpty{
            print("NOW IN BLACK LIST \(self.arrayOfBlackListImages.count) URLS")
            print(arrayOfBlackListImages)
            print("NOW IN WHOLE CAR URLS LIST BEFORE DELETING \(self.arrayOfAllCarUrlsImages.count) URLS")
            print("into ARRAY OF ALL DICTIONARIES OF BLACK list Before UPDATE SIZE IS \(self.arrayOfAllDictionariesOfBlackListImages.count) Images")
            print(self.arrayOfAllDictionariesOfBlackListImages)
            print(arrayOfAllCarUrlsImages)
            
            
            print("BEFORE UPDATE BLACKLISTDIC SIZE IS \(self.arrayOfAllDictionariesOfBlackListImages.count) AND BLACKLISTARRAY SIZE IS \(self.arrayOfBlackListImages.count)")
            //if we have things to update into arrayOfAllDictionariesOfBlackListImages
            if arrayOfBlackListImages.count != arrayOfAllDictionariesOfBlackListImages.count{
                print("NOW WE WILL UPDATE THE BLACK LIST AND THE (WHITE LIST) CAUSE THE SIZE OF BLACK LISTS ISNT MATCH EACH OTHER")
                for i in 0..<self.arrayOfBlackListImages.count{
                    for j in 0..<self.arrayOfAllDictionariesImages.count{
                        
                        //if we found url of the image that deleted we must to find deleted image name TOO
                        if self.arrayOfAllDictionariesImages[j]["imageUrl"] == self.arrayOfBlackListImages[i]{
                            self.dictKeyValueImage.updateValue(self.arrayOfAllDictionariesImages[j]["key"]!, forKey: "key")
                            self.dictKeyValueImage.updateValue(self.arrayOfAllDictionariesImages[j]["imageUrl"]!, forKey: "imageUrl")
                            self.arrayOfAllDictionariesOfBlackListImages.append(self.dictKeyValueImage)
                            
                            //after we update our Array of Dictionaries Black List we need to delete this image and name from the array Of all Dictionaries Images
                            self.arrayOfAllDictionariesImages.remove(at: j)
                            break
                            
                        }
                        
                    }
                }
                
                print("AFTER UPDATE BLACKLISTDIC SIZE IS \(self.arrayOfAllDictionariesOfBlackListImages.count) AND BLACKLISTARRAY SIZE IS \(self.arrayOfBlackListImages.count)")
                print("into ARRAY OF ALL DICTIONARIES OF BLACK list AFTER UPDATE. SIZE IS \(self.arrayOfAllDictionariesOfBlackListImages.count) Images")
                print(self.arrayOfAllDictionariesOfBlackListImages)
                
            }
            for i in 0..<self.arrayOfBlackListImages.count{
                print("index number in arrayOfBlackListImages ", i)
                for j in 0..<self.arrayOfAllCarUrlsImages.count{
                    print("index number in arrayOfAllCarUrlsImages ", j)
                    
                    //only if a picture in black list remove it from
                    if self.arrayOfAllCarUrlsImages[j] == self.arrayOfBlackListImages[i]{
                        self.arrayOfAllCarUrlsImages.remove(at: j)
                        
                        break
                    }
                 
                }
            }
//            //clearing all array
//            self.arrayOfAllCarUrlsImages.removeAll()
//            //updating arrayOfAllCarUrlsImages
//
//            for k in 0..<tempArrayOfAllImagesUrl.count{
//                self.arrayOfAllCarUrlsImages.append(tempArrayOfAllImagesUrl[k])
//            }
            print("new size of arrayOfAllCarUrlsImages ",self.arrayOfAllCarUrlsImages.count)
            print("NOW IN WHOLE CAR URLS LIST AFTER DELETING \(self.arrayOfAllCarUrlsImages.count) URLS")
            print(arrayOfAllCarUrlsImages)
            
            print("IN (BLACK LIST) ARRAY OF ALL BLACK LIST DICTIONARIES After UPDATING (SIZE) \(self.arrayOfAllDictionariesOfBlackListImages.count)")
            print(self.arrayOfAllDictionariesOfBlackListImages)
            print("IN (WHITE LIST) ARRAY OF ALL DICTIONARIES After DELETING (SIZE) \(self.arrayOfAllDictionariesImages.count)")
            print(self.arrayOfAllDictionariesImages)
            
            
            
            
        }
        
    }
    
        //MARK: 1.2) PREVIOUS PHOTO
    @IBAction func previousPhotoButtonIsPressed(_ sender: Any) {
        updateArrayOfUrlImages()
        self.updatedImageAmount = self.arrayOfAllCarUrlsImages.count
        //firstly ZoomOut before introduce the next Photo
        self.scrollView.zoomScale = 1.0
        
        print("gCarIndex was ", gCarIndex)
        
        if indexOfImage != 1{
            //for label
            indexOfImage -= 1
            self.imageInfoLabel.text = "\(indexOfImage)   of   \(updatedImageAmount)"
        }
        
        if gCarIndex != 0{
            //for the arrayOfAllCarUrlsImages range
            gCarIndex -= 1
        }
        else{
            print("MIN IMAGE RANGE NOT MATTER HOW MUCH WILL PRESS PREVIOUS IT'S THE LAST RANGE")
        }
            print("gCarIndex now ", gCarIndex)

        if gCarIndex < updatedImageAmount{
            print("previous photo will show now")
                   
            self.carImage.sd_setImage(with: URL(string: self.arrayOfAllCarUrlsImages[gCarIndex]), completed: nil)
                   
        }
    }
    //MARK: END -> NEXT AND PREVIOUS PHOTO
    
    
    
    var gAmountOfDeletedImages : Int = 0
    var updatedImageAmount : Int = 0
    
     //MARK: DELETE OR ACCEPT EXACT PHOTO

    @IBAction func deleteExactPhotoButtonIsPressed(_ sender: Any) {
        //we just delete the reference of the exact photo in uncheked or just we can remove it to 'Our arrayOfBlackListImages[] to avoid this image being transfer into publish
        if updatedImageAmount == 1{
            print("you delete all of the photos now just choose accept this ad or reject ")
            let alert = UIAlertController(title: "תמונה אחרונה", message: "מחקת הכל תאשר את כל המודעה או תמחק את המודעה לגמרי", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "אוקיי", style: UIAlertAction.Style.default) { (UIAlertAction) in
                NSLog("inforamtion that remain last picture is understandable")
                return
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
       
        let alert = UIAlertController(title: "למחוק תמונה?", message: "אתה עומד למחוק את התמונה אתה בטוח בזה?", preferredStyle: .alert)
              
              let yesAction = UIAlertAction(title: "כן,תמחק", style: UIAlertAction.Style.default) { (UIAlertAction) in
                  NSLog("yesDelete this Pic")
                
                if self.indexOfImage == self.updatedImageAmount{//if we delete the last picture on list it's must to update the pic to previous by itself
                    
                    
                    //new version
                    print("into last picture")
                    print("you stay at index of picture ", self.indexOfImage)
                    print("Really index of this picture ", self.gCarIndex)
                    self.arrayOfBlackListImages.append(self.arrayOfAllCarUrlsImages[self.gCarIndex])
                    //fake tap on previous button
                    self.previousPhotoButtonIsPressed((Any).self)
                    self.updatedImageAmount = self.arrayOfAllCarUrlsImages.count
                    self.imageInfoLabel.text = "\(self.indexOfImage)   of   \(self.updatedImageAmount)"
                    
                    
                }
                //self.updatedImageAmount - indexOfImage == 1 like -> (4 of 5 : -> 5 - 4 = 1  or 6 of 7 : -> 7 - 6 = 1)
                else if self.updatedImageAmount - self.indexOfImage == 1{//the last picture before the last like (4 of 5) or (3 of 2)
                    print("into 1 before last")
                        
                    
                    //new version
                    print("you stay at index of picture ", self.indexOfImage)
                    print("Really index of this picture ", self.gCarIndex)
                    self.arrayOfBlackListImages.append(self.arrayOfAllCarUrlsImages[self.gCarIndex])
                    self.nextPhotoButtonIsPressed((Any).self)
                    self.imageInfoLabel.text = "\(self.indexOfImage)   of   \(self.updatedImageAmount)"
                    
                        
                }
                else if self.indexOfImage < self.updatedImageAmount{//picture in middle (not the last before the last) like (4 of 5) or (3 of 2)
                    
                    
                    
                    //dorabotat' doljno progat na next photo a ne cherez odnu
                    //new version
                    print("in middle case")
                    print("you stay at index of picture ", self.indexOfImage)
                    print("Really index of this picture ", self.gCarIndex)
                    self.arrayOfBlackListImages.append(self.arrayOfAllCarUrlsImages[self.gCarIndex])
                    self.nextPhotoButtonIsPressed((Any).self)
                    self.imageInfoLabel.text = "\(self.indexOfImage)   of   \(self.updatedImageAmount)"
                }
              }
              
              let cancelAction = UIAlertAction(title: "לא", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                  NSLog("cancelDelete this Pic")
                  
                  
                  
              }

        alert.addAction(yesAction)
        alert.addAction(cancelAction)
              
        self.present(alert, animated: true)
        
    }






    //MARK: DELETE OR ACCEPT WHOLE AD
    @IBAction func rejectAdButtonIsPressed(_ sender: Any) {
     //if rejectAd pressed we need to delete this carPlate Reference from our DB

        let alert = UIAlertController(title: "שים לב!!!", message: "אתה עומד למחוק את כל המודעה מ-DB ?", preferredStyle: .alert)
                      
            let yesAction = UIAlertAction(title: "תמחק מודעה זו", style: UIAlertAction.Style.default) { (UIAlertAction) in
                NSLog("yesDelete this WHOLE announcement")
                //implement the gl
                
                //in this case reject button is pressed so we need to delete all photos that we have IN WHITE LIST and In BLACK LIST how to
                if !self.allCarsPlatesNumbers.isEmpty{
                    self.deleteAllImagesFromStorage(plateNumber: self.allCarsPlatesNumbers[self.globalCarPlateIndex])
                }
                //removing whole carPlate obj from Upload DB
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if !self.allCarsPlatesNumbers.isEmpty{
                        self.removeCarObjectFromTheUploads(plateNumber: self.allCarsPlatesNumbers[self.globalCarPlateIndex])
                    }
                }
                
                
                //displaying the current amounts of cars in label of the UPLOADS
                self.gCounterOfCarsInUploads -= 1
                if self.gCounterOfCarsInUploads <= 0 {
                    self.gCounterOfCarsInUploads = 0
                }
                else{
                    //will dispaly a new value on the counter label
                    self.setUpTheAmountOfCarsInUploads(amount: self.gCounterOfCarsInUploads)
                }
                
                //this seconds are very important if the will be less then now (4) it's will go to the delete by mistake nextCar instead this one
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                   //implement reloading data on the screen next car plate if exist
                    if self.globalCarPlateIndex + 1 < self.allCarsPlatesNumbers.count{//if we have an extra plate in Upload we doing the next step
                        print("We have an Extra car in Upload")
                        self.globalCarPlateIndex += 1
                        print("now loading... the new screen")
                        self.reloadPage()
                        
                    }
                    else{
                        self.noExtraCarsInUploadAlert()
                    }
                }
            }
                      
            let cancelAction = UIAlertAction(title: "לא", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                NSLog("cancelDelete this WHOLE announcement")
                          
                          
                return
            }

            alert.addAction(yesAction)
            alert.addAction(cancelAction)
                      
            self.present(alert, animated: true)
        
    }
    
    
    
    
    func noExtraCarsInUploadAlert(){
        self.unitsUploadLbl.text = "0"
        self.carImage.image = UIImage(named: "noMoreCarsImage")
        
          let alert = UIAlertController(title: "סיימת", message: "אין עוד מכוניות ב-UPLOADS", preferredStyle: .alert)
                              
            let yesAction = UIAlertAction(title: "אוקיי", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    NSLog("No more cars in Uploads")
                    
                //20.01.20 show picture noMoreDATA Come BackSoon
                    return
            }
                              
            alert.addAction(yesAction)
            self.present(alert, animated: true)
        
    }
    
    
    
    func deleteAllImagesFromStorage(plateNumber: String){//delete all images from white list and black list because was pressing total reject Ad (whole ad need to be deleted
        print("In deleteAllImagesFromStorage")
           let storage = Storage.storage()
           var storageRef = storage.reference()
      
        // Create a reference to the file we want to delete from White List
        //DELETING ALL IMAGES FROM White List IF EXIST
        if !arrayOfAllDictionariesOfBlackListImages.isEmpty{
            for i in 0..<self.arrayOfAllDictionariesImages.count{
                storageRef = storage.reference(forURL: self.arrayOfAllDictionariesImages[i]["imageUrl"]!)
               
                //from the storage url we get the exact(unique) imageName in storage
                let downloadTask = storageRef.getMetadata(completion: { (metadata, error) in
                    if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // metadata -> we fetch the exact name of the image from storage
                    print("11 ", metadata!.name)
                    
                    var imgName = (metadata!.name!)
                 
                    //now we know the unique name in storage so we can delete it from the Storage itself
                    let storageRef = storage.reference().child("Development/\(plateNumber)/\(imgName)")
                        
                        //Removes image from storage
                        storageRef.delete { error in
                        if let error = error {
                            //need to display the alert that will print the error state for inform the admin what's wrong
                            print(error)
                        } else {
                            print("File deleted successfully")
                            //need to display the alert that will print that all images are successfuly deleted
                                           
                            // File deleted successfully
                                           
                            }
                        }
                    
                    print("image name in WHITE LIST succesfully downloaded \(imgName)")
                    }
                })
            }
        }
        // Create a reference to the file we want to delete from White List
        //DELETING ALL IMAGES FROM BLACK LIST IF EXIST
        if !arrayOfAllDictionariesOfBlackListImages.isEmpty{
            for i in 0..<self.arrayOfAllDictionariesOfBlackListImages.count{
                storageRef = storage.reference(forURL: self.arrayOfAllDictionariesOfBlackListImages[i]["imageUrl"]!)
               
                //from the storage url we get the exact(unique) imageName in storage
                let downloadTask = storageRef.getMetadata(completion: { (metadata, error) in
                    if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // metadata -> we fetch the exact name of the image from storage
                    print("11 ", metadata!.name)
                    
                    var imgName = (metadata!.name!)
                 
                    //now we know the unique name in storage so we can delete it from the Storage itself
                    let storageRef = storage.reference().child("Development/\(plateNumber)/\(imgName)")
                        
                        //Removes image from storage
                        storageRef.delete { error in
                        if let error = error {
                            //need to display the alert that will print the error state for inform the admin what's wrong
                            print(error)
                        } else {
                            print("File deleted successfully")
                            //need to display the alert that will print that all images are successfuly deleted
                                           
                            // File deleted successfully
                                           
                            }
                        }
                    
                    print("image name IN BLACK LIST succesfully downloaded \(imgName)")
                    }
                })
            }
        }
        
    }


    @IBAction func acceptAdButtonIsPressed(_ sender: Any) {
       
        
        let alert = UIAlertController(title: "שים לב!!!", message: "אתה עומד לאשר את כל המודעה ולהעביר אותה ל-LIVE ?", preferredStyle: .alert)
                              
        let yesAction = UIAlertAction(title: "תאשר מודעה זו", style: UIAlertAction.Style.default) { (UIAlertAction) in
            NSLog("Accept this WHOLE announcement")
            //if acceptAd pressed we need transfer it from upload -> publishedTemp
            //1.) Create a new one in publishedTemp with ALL data that was in uploads and even more details if it's still not in uploads
            if !self.allCarsPlatesNumbers.isEmpty {
                self.transferCarObjFromUploadToPublishedTempDB(plateNumber: self.allCarsPlatesNumbers[self.globalCarPlateIndex])
            }
            
            //2.) delete images only if we have images into Black List
            if !self.arrayOfAllDictionariesOfBlackListImages.isEmpty {
                self.deleteImageFromStorage(plateNumber: self.allCarsPlatesNumbers[self.globalCarPlateIndex])
            }
   
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //3.) Delete this carPlate Reference from our DB
                if !self.allCarsPlatesNumbers.isEmpty{
                    self.removeCarObjectFromTheUploads(plateNumber: self.allCarsPlatesNumbers[self.globalCarPlateIndex])
                }
                print("in index ", self.globalCarPlateIndex)
                    
            }
            
            
            //displaying the current amounts of cars in label of the LIVE
            if self.gCounterOfCarsInUploads > 0{
                self.gCounterOfCarsInLive += 1
            }
            
            //will dispaly a new value on the counter label of LIVE
            self.setUpTheAmountOfCarsInUploads(amount: self.gCounterOfCarsInUploads)
            //displaying the current amounts of cars in label of the UPLOADS
            self.gCounterOfCarsInUploads -= 1
            if self.gCounterOfCarsInUploads <= 0 {
                self.gCounterOfCarsInUploads = 0
            
            }
            //will dispaly a new value on the counter label
            self.setUpTheAmountOfCarsInUploads(amount: self.gCounterOfCarsInUploads)
            self.setUpTheAmountOfCarsInLiveDB(amount: self.gCounterOfCarsInLive)
            
            
            
            //this seconds are very important if the will be less then now (4) it's will go to the delete by mistake nextCar instead this one
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                 //reload data for the next carPlate
                if self.globalCarPlateIndex + 1 < self.allCarsPlatesNumbers.count{//if we have an extra plate in Upload we doing the next step
                    print("We have an Extra car in Upload")
                    self.globalCarPlateIndex += 1
                    print("now loading... the new screen")
                    self.reloadPage()
                    
                    
                }
                else{
                    self.noExtraCarsInUploadAlert()
                }
            }
        }
                              
        let cancelAction = UIAlertAction(title: "לא", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            NSLog("cancel Acception for this WHOLE announcement")
                                  
                                  
            return
        }

        alert.addAction(yesAction)
        alert.addAction(cancelAction)
                              
        self.present(alert, animated: true)

    }
    func removeCarObjectFromTheUploads(plateNumber : String){//deleting the car object from the Temporary DB (From Uploads)
        print(" in removeCarObjectFromTheUploads ")
        print("removing car obeject the plate number is ", plateNumber)
        if plateNumber != nil{
            Database.database().reference().child("uploads/carPlate/\(plateNumber)").setValue(nil)
        }
    }
    func deleteImageFromStorage(plateNumber : String) {//important to us! it's able to us to get the name of the image in STORAGE
        print("In downloadImageFromStorage")
           let storage = Storage.storage()
           var storageRef = storage.reference()
           
           // Create a reference to the file we want to delete

        for i in 0..<self.arrayOfAllDictionariesOfBlackListImages.count{
            storageRef = storage.reference(forURL: self.arrayOfAllDictionariesOfBlackListImages[i]["imageUrl"]!)
           
            //from the storage url we get the exact(unique) imageName in storage
            let downloadTask = storageRef.getMetadata(completion: { (metadata, error) in
                if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // metadata -> we fetch the exact name of the image from storage
                print("11 ", metadata!.name)
                
                var imgName = (metadata!.name!)
             
                //now we know the unique name in storage so we can delete it from the Storage itself
                let storageRef = storage.reference().child("Development/\(plateNumber)/\(imgName)")
                    
                    //Removes image from storage
                    storageRef.delete { error in
                    if let error = error {
                        //need to display the alert that will print the error state for inform the admin what's wrong
                        print(error)
                    } else {
                        print("File deleted successfully")
                        //need to display the alert that will print that all images are successfuly deleted
                                       
                        // File deleted successfully
                                       
                        }
                    }
                
                print("image name succesfully downloaded \(imgName)")
                }
            })
        }
        
    }

    func transferCarObjFromUploadToPublishedTempDB(plateNumber : String){
        print("We currently transfering this car to the Published temp")
            if(plateNumber != ""){
                print("Plate number is good and it's a ", plateNumber)
                //published - unchecked
                Database.database().reference().child("publishedTemp/carPlate").observeSingleEvent(of: .value, with: { (snapshot) in
                
                    if ( snapshot.value is NSNull ) {
                        
                        // DATA WAS NOT FOUND
                        print("– – – Data was not found at all ERROR – – –")
                        //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                        
                    }
                    else{// some cars was found -> connection with DB is good
                    
                        let allCarPlates = snapshot.value as? NSDictionary
                        print("value of allCarPlates 1 ", allCarPlates)
                        
                        

                        //figure out if we alredy have this plateNumber in our DB
                        if allCarPlates!["\(plateNumber)"] != nil{
                            print("we found this current car , now we need to add an extra photo of it")
                            
                            //cheking if in current car we have a views (if upload was from Android it would not have views if from IOS IT'S DOES)
                            Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/plateExtras").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            //            let value = snapshot.value as? String
                            //            print("value String ", value)
                            if ( snapshot.value is NSNull ) {
                                
                                // DATA WAS NOT FOUND
                                print("– – – Data was not found – – –")
                                print("----- No Photo found ------")
                                print("------An Empty License Plate Object ----")
                            }
                               
                            let allExactPlateExtras = snapshot.value as? NSDictionary
                            print("value of allExactPlateExtras ", allExactPlateExtras)
                            
                                        
                                     
                                if allExactPlateExtras != nil{//this plate already contain the views we do not need do nothing to change
                                    print("THIS CAR Already has Views we do not set it ")
                                }
                                else{
                                    print("Car already EXIST but it's isn't contain the Views So we need to add Views ")
                                    //This is exist car but it's doesn't contain carViews so now we can initialize the carViews to be zero 0
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/plateExtras/carViews").setValue("0")
                                }
                                
                            })
              
                                
                            //******************* This call NOT TO COMMENT
                                //now we able to add an extra photo of particular car
                                
                            //from this moment we adding the new images of this car
                            for i in 0..<self.arrayOfAllDictionariesImages.count{
                                //no matter what kind of backEnd Error do we have, we still adding the photo that we picked
                       
                                    //adding only images that stands in the "WHITE LIST" -> self.arrayOfAllDictionariesImages
                                Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/images/\(self.arrayOfAllDictionariesImages[i]["key"]!)").setValue("\(self.arrayOfAllDictionariesImages[i]["imageUrl"]!)")
                                
                              
                                //if we got error from BackEnd only then it's seem to us that we didn't get the carCompany and we can edit it to insert it into the extrasTemp for present it in future into carsList
                                if self.flagGotErrorFromBackEnd && self.carCompanyNameLbl.text != "יצרן: אין מידע" {
                                    
                                    //carCompanyName
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")

                                    //add into extras -> allCarsCompanies
                                        //2.01.20 change add to DB plate number per exact carCompany
                                    Database.database().reference().child("extrasTemp/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberLbl.text!)").setValue("\(self.plateNumberLbl.text!)")
                                    
                                }
                                
                                if self.flagGotErrorFromBackEnd != true { //if we don't have an error from BackEnd we would not delete Car details
                                    
                                    //now we able to add an extra info of particular car
                                    //carCompanyName
                                     Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")
                                    //carDegemName
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/degemName").setValue("\(self.gCarDegemName)")
                                    //carModelYear
                                    if self.gCarModelYear != "כללי"{
                                        Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarModelYear)")
                                    }
                                    else{
                                        Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarDateNumber)")
                                    }
                                    
                                    //carTatDegemName
                                     Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/tatDegemName").setValue("\(self.gCarTatDegemName)")
                                    
                                     //carCountryCreatorName
                                     Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/countryCreatorName").setValue("\(self.gCarCountryCreatorName)")
                                     
                                     //carOwnershipType
                                     Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/ownershipType").setValue("\(self.gCarOwnershipType)")
                                    
                                    

                                    //add into extras -> allCarsCompanies
                                    
                                    //2.01.20 change add to DB plate number per exact carCompany
                                    Database.database().reference().child("extrasTemp/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberLbl.text!)").setValue("\(self.plateNumberLbl.text!)")
                                    
                                   if self.gCarModelYear != "כללי"{ Database.database().reference().child("extrasTemp/allCarsModelsYears/\(self.gCarModelYear)").setValue("\(self.gCarModelYear)")
                                    }
                                   else{
                                    Database.database().reference().child("extrasTemp/allCarsModelsYears/\(self.gCarDateNumber)").setValue("\(self.gCarDateNumber)")
                                    }
                                
                                
                                  
                                }
                                //turning the flag into false condition for the next BackEnd Call
                                self.flagGotErrorFromBackEnd = false
                                
                           
                                //******************** until this moment can comment
   
                            }
                            
                            //transfer car from Upload to PublishedTemp is Successfull
                        }
                        else{//curent car plate not found -> it's goona be a new car object
                            
                            //if we got error from BackEnd only then it's seem to us that we didn't get the carCompany and we can edit it to insert it into the extrasTemp for present it in future into carsList
                            if self.flagGotErrorFromBackEnd && self.carCompanyNameLbl.text != "יצרן: אין מידע" {
                                
                                //carCompanyName
                                Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")

                                //add into extras -> allCarsCompanies
                                    //2.01.20 change add to DB plate number per exact carCompany
                                Database.database().reference().child("extrasTemp/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberLbl.text!)").setValue("\(self.plateNumberLbl.text!)")
                                
                            }
                            
                                print("this car not found in our unchecked DB folder")
                                print("will add it immediately")
                            for i in 0..<self.arrayOfAllDictionariesImages.count{
                                    //no matter what kind of backEnd Error do we have, we still adding the photo that we picked
                               
                                //adding only images that stands in the "WHITE LIST" -> self.arrayOfAllDictionariesImages
                            Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/images/\(self.arrayOfAllDictionariesImages[i]["key"]!)").setValue("\(self.arrayOfAllDictionariesImages[i]["imageUrl"]!)")
                                
                                    //13.01.20
                                    //This gonna be a new car and now we can attach it a carViews to be zero 0
                                Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/plateExtras/carViews").setValue("0")
                                
                                 if self.flagGotErrorFromBackEnd != true { //if we don't have an error from BackEnd we would not delete Car details
                                
                                  
                                    //now we able to add an extra info of particular car -> details
                                    //carCompanyName
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/companyName").setValue("\(self.gCarCompanyName)")
                                    //carDegemName
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/degemName").setValue("\(self.gCarDegemName)")
                                    //carModelYear
                                   if self.gCarModelYear != "כללי"{ Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarModelYear)")
                                    }
                                   else{
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/modelYear").setValue("\(self.gCarDateNumber)")
                                    }
                                    
                                    //carTatDegemName
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/tatDegemName").setValue("\(self.gCarTatDegemName)")
                                   
                                    //carCountryCreatorName
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/countryCreatorName").setValue("\(self.gCarCountryCreatorName)")
                                    
                                    //carOwnershipType
                                    Database.database().reference().child("publishedTemp/carPlate/\(plateNumber)/details/ownershipType").setValue("\(self.gCarOwnershipType)")
                                    
                                    
                                    //add into extras -> allCarsCompanies
                                    //2.01.20 change add to DB plate number per exact carCompany
                                Database.database().reference().child("extrasTemp/allCarsCompaniesNames/\(self.gCarCompanyName)").child("\(self.plateNumberLbl.text!)").setValue("\(self.plateNumberLbl.text!)")
                                   
                         
                                    
                                    //add into extras -> allCarsModelYears
                                    if self.gCarModelYear != "כללי"{ Database.database().reference().child("extrasTemp/allCarsModelsYears/\(self.gCarModelYear)").setValue("\(self.gCarModelYear)")
                                    }
                                    else{
                                    Database.database().reference().child("extrasTemp/allCarsModelsYears/\(self.gCarDateNumber)").setValue("\(self.gCarDateNumber)")
                                    }
                                    
                                }
                                //turning the flag into false condition for the next BackEnd Call
                                self.flagGotErrorFromBackEnd = false
                            }
                            
                            
                            //transfer car from Upload to PublishedTemp is Successfull
                        }
                    }
                })
            }
        }

    var gCounterOfCarsInUploads = 0
    func setUpTheAmountOfCarsInUploads(amount : Int){
        print("in set up Uploads Car (amount) before ", self.gCounterOfCarsInUploads)
        self.gCounterOfCarsInUploads = amount
        print("in set up Uploads Car (amount) after ", self.gCounterOfCarsInUploads)
    
        //extreme case if amount of cars in upload is 0 it's doesn't insert to the loop below because the count deprecate it
        if amount == 0{
            self.unitsUploadLbl.text = String(amount)
        }
        
        var tempAmount = amount
        var temp = amount
            var count = 0
            while tempAmount != 0 {
                tempAmount = tempAmount / 10
                count += 1
            }
        print("how much digits ",count)
        for i in 0..<count{
            let digit = abs(temp % 10)
            if i == 0{//units
                print("in units ",digit)
                self.unitsUploadLbl.text = String(digit)
            }
            else if i == 1{//dozens
                self.dozensUploadLbl.text = String(digit)
            }
            else{//hundreds
                self.hundredsUploadLbl.text = String(digit)
            }
            temp = temp / 10
        }
        
    }
    
    //MARK: FETCHING ALL PLATES NUMBERS IN LIVE DB ONLY FOR COUNTER LBL
    
    var gCounterOfCarsInLive = 0
    
    func setUpTheAmountOfCarsInLiveDB(amount : Int){//currently it's publishedTemp
        print("in set up Live Car (amount) before ", self.gCounterOfCarsInLive)
        self.gCounterOfCarsInLive = amount
        print("in set up Live Car (amount) after ", self.gCounterOfCarsInLive)
        
        var tempAmount = amount
        var temp = amount
        var count = 0
        while tempAmount != 0 {
            tempAmount = tempAmount / 10
            count += 1
        }
        print("how much digits ",count)
        
        for i in 0..<count{
            let digit = abs(temp % 10)
            if i == 0{//units
                print("in units ",digit)
                self.unitsLiveLbl.text = String(digit)
            }
            else if i == 1{//dozens
                self.dozensLiveLbl.text = String(digit)
            }
            else if i == 2{//hundreds
                self.hunderdsLiveLbl.text = String(digit)
            }
            else{//thsousands
                self.thsousandsLiveLbl.text = String(digit)
            }
            temp = temp / 10
        }
        
    }
    
    
    func fetchAllCarsFromLiveDB(){
        //published -> unchecked
                Database.database().reference().child("publishedTemp/carPlate").observeSingleEvent(of: .value, with: { (snapshot) in
                  
                    if ( snapshot.value is NSNull ) {

                        // DATA WAS NOT FOUND
                        print("– – – Data was not found (all car Plates) – – –")
                         //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                    }
                    else{// some data was found -> connection with DB is good

                        let allCarPlates = snapshot.value as? NSDictionary
                        print("value of allCarPlates 1 ", allCarPlates)

                        print("ALL CARS IN OUR DB ", allCarPlates?.count)
                        
                        if allCarPlates?.count != nil{
                            print("was send amount of cars ",allCarPlates!.count)
                                 self.setUpTheAmountOfCarsInLiveDB(amount : allCarPlates!.count)
                            
                        }

            }
        })
    }

    //MARK: FETCHING ALL PLATES NUMBERS THAT WE DIDN'T CHECK YET

    func fetchAllPlatesNumbersFromDB(){
        //published -> unchecked
                Database.database().reference().child("uploads/carPlate").observeSingleEvent(of: .value, with: { (snapshot) in
                  
                    if ( snapshot.value is NSNull ) {

                        // DATA WAS NOT FOUND
                        print("– – – Data was not found (all car Plates) – – –")
                         //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
                    }
                    else{// some data was found -> connection with DB is good

                        let allCarPlates = snapshot.value as? NSDictionary
                        print("value of allCarPlates 1 ", allCarPlates)

                        print("ALL CARS IN OUR DB ", allCarPlates?.count)
                        
                        if allCarPlates?.count != nil{
                            print("was send amount of cars ",allCarPlates!.count)
                            self.setUpTheAmountOfCarsInUploads(amount : allCarPlates!.count)
                        }

                        for allCarPlates in snapshot.children{
                            print(" NEW ", allCarPlates)

                            let restDict = allCarPlates as! DataSnapshot
                            print("restDict ", restDict)

                            //all the keys of the divisions in Aguda
                            let key = restDict.key
                            print("I've Got the key -> ", key)

                            self.allCarsPlatesNumbers.append(key)

                        }

                    }
                })
    }
   //automatic func creating and initializatins all carViews to zero 0
    func insertNewObjIntoExactCar(){

        //published -> unchecked
        //unchecked
        
        for i in 0..<self.allCarsPlatesNumbers.count{ Database.database().reference().child("published/carPlate/\(self.allCarsPlatesNumbers[i])").observeSingleEvent(of: .value, with: { (snapshot) in
                if ( snapshot.value is NSNull ) {

                    // THIS CAR PLATE NOT FOUND
                    print("– – – THIS CAR PLATE NOT FOUND – – –")
                    //******************* if data was not found at all (maybe connection with DB is lost at all)
                }
                else{// some Images were found -> connection with DB is good

                    let carPlateObject = snapshot.value as? NSDictionary
                    print("value of carPlateObject ", carPlateObject)

                    Database.database().reference().child("published/carPlate/\(self.allCarsPlatesNumbers[i])/plateExtras/carViews").setValue("0")

            

              }
            })


            { (error) in
                print(error.localizedDescription)
            }
        }
    }

    
    
    
    //MARK: fetch all String(urls) into Array from the Firebase.Database of the exact carPlate that stands in allCarsPlatesNumbers[] Do NOT DELETE THE LAST ONE IN UNCHECKED Otherwise it will crash (it's will delete DB in uncheked )

    func fetchAllImagesOfTheExactCarPlateFromDB(carAtIndex : Int){

        //published -> unchecked
        if carAtIndex < allCarsPlatesNumbers.count{
           print("INTO IF")
            print("carAtIndex ",carAtIndex)
           
            //unchecked
            Database.database().reference().child("uploads/carPlate/\(self.allCarsPlatesNumbers[carAtIndex])/images").observeSingleEvent(of: .value, with: { (snapshot) in
                if ( snapshot.value is NSNull ) {

                    // THIS CAR PLATE NOT FOUND
                    print("– – – THIS CAR PLATE NOT FOUND – – –")
                    //******************* if data was not found at all (maybe connection with DB is lost at all)
                }
                else{// some Images were found -> connection with DB is good

                    let allImagesOfExactCar = snapshot.value as? NSDictionary
                    print("value of allImagesOfExactCar ", allImagesOfExactCar)

                    //assign the amount of images of exact car
                    self.amountOfImagesInExactCar = allImagesOfExactCar!.count

                    //assign the EXACT Amount of images into the FUTURE (still not created array of ZOOM IMages)
                    self.arrayOfCachedImages = Array.init(repeating: UIImage(named: "loadImageForZoom")!, count: self.amountOfImagesInExactCar)

                    for i in 0..<Int(allImagesOfExactCar!.count){
                        print("this is how much photos inside")
               //       self.arrayOfAllCarImages.append(allImagesOfExactCar.)
                    }
                    for imageSSnapshot in snapshot.children{

                        //key - value
                        let urlOFImageSnapshot = imageSSnapshot as! DataSnapshot
                        let url = urlOFImageSnapshot.value as! String

                        print("THE urlOFImageSnapshot ",urlOFImageSnapshot)
                        print("THE URLS ", url)

                        print("into sync func")
                        
                        //key -> the unique name of the image
                        let key = urlOFImageSnapshot.key
                        print("I've Got the key -> name of the image ", key)
                        
                        self.dictKeyValueImage.updateValue(key, forKey: "key")
                        self.dictKeyValueImage.updateValue(url, forKey: "imageUrl")
                        self.arrayOfAllDictionariesImages.append(self.dictKeyValueImage)
                        
                        
                        
                        self.arrayOfAllCarUrlsImages.append(url)

                        //sending into sync queue for match the little photo and the zoom photo in the same indexes

//                        for i in 0..<self.arrayOfAllCarUrlsImages.count{
//                            if url == self.arrayOfAllCarUrlsImages[i]{
//                                self.downloadIntoCacheImage(particularUrl: url, particularIndexOfUrl: i)
//                            }
//                        }
                        
                        print("self.arrayOfAllCarUrlsImages ", self.arrayOfAllCarUrlsImages)


                   }
                    
                    self.updatedImageAmount = self.arrayOfAllCarUrlsImages.count
              }
            })


            { (error) in
                print(error.localizedDescription)
            }
        }
    }



    func downloadIntoCacheImage(particularUrl : String, particularIndexOfUrl : Int){
            print("download Image to cache")
                //cast string into Url
                let url = URL(string: particularUrl)
                if url != nil{
                    ImageService.getImage(withURL: url!) { image in
                        if image != nil{
                            self.arrayOfCachedImages[particularIndexOfUrl] = image!
                        }
                    }
                }
    }




    //MARK: Cast all Strings into Urls Array

    //MARK: Cashed all Images into Cashed Array for zooming the image




    //countryCarsDb
    func getDataFromCountryCarDBAndDisplayOnPopUpView(carAtIndex : Int){


        var plateNumberWithoutMinusSign : String = ""

        if allCarsPlatesNumbers[carAtIndex] != ""{
            //needToRemoveMinusSigns
            print("REMOVING MINUS SIGN ")
            plateNumberWithoutMinusSign = allCarsPlatesNumbers[carAtIndex].replacingOccurrences(of: "-", with: "")
        }



        guard let plateNumber = Int(plateNumberWithoutMinusSign) else { return }
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

//                    self.plateNumberLbl.text = "NO DATA"
                    
                    self.flagGotErrorFromBackEnd = true
                    
                    //Set-up All Labels
                    self.carCompanyNameLbl.text = "יצרן: אין מידע"
                    self.carDegemLbl.text = "דגם: אין מידע"
                    self.carTatDegemLbl.text = "תת דגם: אין מידע"
                    self.carCountryCreatorNameLbl.text = "תוצרת: אין מידע"
                    self.carModelYearLbl.text = "שנת ייצור: אין מידע"
                    self.carOwnershipTypeLbl.text = "בעלות: אין מידע"
   
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
                    if let carModelNumber = json["שנת עלייה לכביש"].string{
                        self.gCarModelYear = carModelNumber
                        print("carModelNumber \(carModelNumber)")
                    }
                    else{//car model is empty
                        print("...no carModelYear need to assign the default company name")
                        //...no carModelNumber need to assign the default gCarModelYear name
                        self.gCarModelYear = "כללי"
                        print("gCarModelYear ", self.gCarModelYear)
                    }
                    //if yavo ishi other method will show as year model
                    if let carPersonalImp  = json["יבוא אישי"].string{
                        //inside yavo ishi model year shows different
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
                    }
                   
                    //only if there are a car date number
                    if let carDateNumber = json["תאריך עלייה לכביש"].string{
                        self.gCarDateNumber = carDateNumber
                        print("carDateNumber \(carDateNumber)")
                    }
                    else{//car date is empty
                        print("...no carDateNumber need to assign the default company name")
                        //...no carDateNumber need to assign the default gCarDateNumber name
                        self.gCarDateNumber = "כללי"
                        print("carDateNumber ", self.gCarDateNumber)
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

                  //Set-up All Labels and display it on the screen
                    self.carCompanyNameLbl.text = "יצרן: \(self.gCarCompanyName)"
                    self.carDegemLbl.text = "דגם: \(self.gCarDegemName)"
                    self.carTatDegemLbl.text = "תת דגם: \(self.gCarTatDegemName)"
                    self.carCountryCreatorNameLbl.text = "תוצרת: \(self.gCarCountryCreatorName)"
                    if self.gCarModelYear != "כללי"{
                        self.carModelYearLbl.text = "שנת ייצור: \(self.gCarModelYear)"
                    }
                    else{
                        self.carModelYearLbl.text = "שנת ייצור: \(self.gCarDateNumber)"
                    }
                    self.carOwnershipTypeLbl.text = "בעלות: \(self.gCarOwnershipType)"

                }

            }

        }
    }
   
  
    //---------------------- LOGO ANIMATION -------------------------
    var gifLogoView = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        //set up the carCompanyTextField
        self.carCompanyFromRight.constant += self.view.bounds.width
        
        //set up corner radiu to the deleteButtonContainer
        self.deleteButtonContainer.layer.cornerRadius = 10
        self.imageInsideDeleteContainer.layer.cornerRadius = 10
        
        //set up Shadow to the adsButtonsContainer
        self.adsButtonsContainer.layer.shadowColor = UIColor.black.cgColor
        self.adsButtonsContainer.layer.shadowOpacity = 1
        self.adsButtonsContainer.layer.shadowOffset = .zero
        self.adsButtonsContainer.layer.shadowRadius = 5
    
        //set up Shadow to the deleteButtonContainer
        self.deleteButtonContainer.layer.shadowColor = UIColor.black.cgColor
        self.deleteButtonContainer.layer.shadowOpacity = 1
        self.deleteButtonContainer.layer.shadowOffset = .zero
        self.deleteButtonContainer.layer.shadowRadius = 5
           
        self.adsButtonsContainerFromDown.constant += view.bounds.height
        self.deletePictureButtonContainerFromDown.constant += view.bounds.height
       }
   
    override func viewDidAppear(_ animated: Bool) {
        //setUp Logo Animation
        showLogoAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.9){
            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
                    
                    self.gifLogoView.alpha = 0
                }, completion: nil)
            

            UIView.animate(withDuration: 1, delay: 1.8, options: .curveEaseOut, animations: {
                
                self.adsButtonsContainerFromDown.constant -= self.view.bounds.height
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            UIView.animate(withDuration: 1.6, delay: 1.8, options: .transitionCurlUp, animations: {
                self.deletePictureButtonContainerFromDown.constant -= self.view.bounds.height
               
                self.view.layoutIfNeeded()
            }, completion: nil)
            
                
        }
    }
    
    func showLogoAnimation(){
           gifLogoView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
           gifLogoView.backgroundColor = UIColor.white     //give color to the view
           gifLogoView.center = self.view.center
           self.view.addSubview(gifLogoView)
           self.gifLogoView.alpha = 1
           playVideo()
        
        
        //set up UILabel on the screen
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.center = CGPoint(x: 210, y: 284)
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 45.0)
        label.text = "Developer Side"
        label.alpha = 0
        self.gifLogoView.addSubview(label)

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            UIView.animate(withDuration: 2) {
                label.alpha = 1
            }
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
    
    //hide the keyboard if touches anyway on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        //if we want to approve all details changing of carCompanyTextField by tapping on the screen just uncomment code below
//        //if user pressed on the screen and string wasn't empty
//             //we will attach it to the global gCarCompanyName and display it on UIViewLabel (carCompanyName)
//             if self.carCompanyTextField.text != ""{
//                 //we attach it to the global gCarCompanyName to upload it to the DB
//                 self.gCarCompanyName = self.carCompanyTextField.text!
//                 //and also to display a new value on the screen to the user
//                 self.carCompanyNameLbl.text = "יצרן: \(self.gCarCompanyName)"
//             }
//             //now closing all the menu automatically
//             self.menuButtonIsPressed(self)
          
    }
    
   //hide the keyboard if user pressing on the return key on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //if user pressed on the return button on the keyboard and string wasn't empty
        //we will attach it to the global gCarCompanyName and display it on UIViewLabel (carCompanyName)
        if self.carCompanyTextField.text != ""{
            //we attach it to the global gCarCompanyName to upload it to the DB
            self.gCarCompanyName = self.carCompanyTextField.text!
            //and also to display a new value on the screen to the user
            self.carCompanyNameLbl.text = "יצרן: \(self.gCarCompanyName)"
        }
        //now closing all the menu automatically
        self.menuButtonIsPressed(self)
        
        return true
    }

}
