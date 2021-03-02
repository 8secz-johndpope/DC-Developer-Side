//
//  ShowCarsViewController.swift
//  DentCar
//
//  Created by Pavel Petrenko on 07/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout
import FirebaseDatabase
import SDWebImage
import GoogleMobileAds
import StoreKit

class ShowCarsViewController: UIViewController, GADBannerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    //set-up Banner Ads -> in the bottom of the screen will appear this banner
    var bannerView: GADBannerView!

    @IBOutlet weak var plateNumberLbl: UILabel!
    
    @IBOutlet weak var carCompanyNameLbl: UILabel!
    @IBOutlet weak var carDegemLbl: UILabel!
    @IBOutlet weak var carTatDegemLbl: UILabel!
    @IBOutlet weak var carCountryCreatorNameLbl: UILabel!
    @IBOutlet weak var carModelYearLbl: UILabel!
    @IBOutlet weak var carOwnershipTypeLbl: UILabel!
    

    var carCompanyName = ""
    var carDegem = ""
    var carTatDegem = ""
    var carCountryCreatorName = ""
    var carModelYear = ""
    var carOwnershipType = ""
    
    
    
    //LOCAL USE ONLY
    var plateNumber = ""
    
    //important the global size of current car Images -> how much images does this car have
    var amountOfImagesInExactCar = 0
    
    
    //in future if we want to add more than ONE feature into the Car Cell object
    var arrayOfAllCarImages : [CarCellBluePrint] = []
    
    
    var arrayOfAllCarUrlsImages : [String] = []
    
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    
    /// animator, clipToBounds, row, column
    private let animators: [(LayoutAttributesAnimator, Bool, Int, Int)] = [(ParallaxAttributesAnimator(), true, 1, 1),
                                                                           (ZoomInOutAttributesAnimator(), true, 1, 1),
                                                                           (RotateInOutAttributesAnimator(), true, 1, 1),
                                                                           (LinearCardAttributesAnimator(), false, 1, 1),
                                                                           (CubeAttributesAnimator(), true, 1, 1),
                                                                           (CrossFadeAttributesAnimator(), true, 1, 1),
                                                                           (PageAttributesAnimator(), true, 1, 1),
                                                                           (SnapInAttributesAnimator(), true, 2, 4)]
    var direction: UICollectionView.ScrollDirection = .horizontal

    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    //temporary
    let photos = ["1", "2", "3", "6", "4", "5"]
//    let photos = ["10","11","12","13"]
    
    override func viewWillAppear(_ animated: Bool) {
        
         spinner.hidesWhenStopped = true
    }
    
    //declerate activity indicator
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
        
        //Set-up All Labels
        carCompanyNameLbl.text = "יצרן: \(self.carCompanyName)"
        carDegemLbl.text = "דגם: \(self.carDegem)"
        carTatDegemLbl.text = "תת דגם: \(self.carTatDegem)"
        carCountryCreatorNameLbl.text = "תוצרת: \(self.carCountryCreatorName)"
        carModelYearLbl.text = "שנת ייצור: \(self.carModelYear)"
        carOwnershipTypeLbl.text = "בעלות נוכחית: \(self.carOwnershipType)"
        
        //DON'T USE IT HERE
        //setup activity indicator
        activityInd.center = self.view.center
        activityInd.hidesWhenStopped = true
        activityInd.style = .gray
        self.view.addSubview(activityInd)
        
        //setup plateNumberLbl
        plateNumberLbl.text = plateNumber
        
        print("plateNumber Now is \(plateNumber)")
        
        //casting plate number delete all "-" occurences
//            plateNumber = plateNumber.replacingOccurrences(of: "-", with: "")
        
        print("plateNumber Now is \(plateNumber)")
        
        self.getCarDataFromFireBaseAndDisplay()

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            print("FIRS ARRAY STRINGS \(self.arrayOfAllCarUrlsImages)")
            print("SECOND ARRAY UIIMAGES \(self.arrayOfCachedImages)")
            
            print("HEY IT WAS A LONG WAY TO FETCH THE PHOTO PIC")
            print("does it empty ? \(self.arrayOfAllCarUrlsImages.isEmpty)")
            
            //downloading all images of the car into the cache
//            self.downloadIntoCacheImage()
            
        
        //configure the collectionView
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        // Turn on the paging mode for auto snaping support.
            self.collectionView?.isPagingEnabled = true
        //
        let layout = AnimatedCollectionViewLayout()
        //choosing animation from the list of animations
        layout.animator = LinearCardAttributesAnimator()
        //1
//        layout.animator = ParallaxAttributesAnimator()
        //2 --
//        layout.animator = ZoomInOutAttributesAnimator()
        //3
//        layout.animator = CubeAttributesAnimator()
        //4 -- ploho rabotaet
//          layout.animator = CrossFadeAttributesAnimator()
        //5+
//        layout.animator = PageAttributesAnimator()
        //6 -- ploho rabotaet MAYBE?
//          layout.animator = SnapInAttributesAnimator()


            self.collectionView.collectionViewLayout = layout
        
            layout.scrollDirection = self.direction
        
        }
        // Do any additional setup after loading the view.
        
        
        
        //loading the app rate request
        DispatchQueue.main.asyncAfter(deadline: .now() + 8){
            SKStoreReviewController.requestReview()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
     func getCarDataFromFireBaseAndDisplay(){
        
        //published -> unchecked
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
                
                
                
                
                
                 //figure out if we alredy have this plateNumber if our DB
                if allCarPlates!["\(self.plateNumber)"] != nil{
                    print("we found this current car , now we need to get all photos from it")
                    
                    //published -> unchecked
                    Database.database().reference().child("published/carPlate/\(self.plateNumber)/images").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        //            let value = snapshot.value as? String
                        //            print("value String ", value)
                        if ( snapshot.value is NSNull ) {
                            
                            // DATA WAS NOT FOUND
                            print("– – – Data was not found – – –")
                            //******************* if data was not found at all (maybe connection with DB is lost at all) I think need to return?
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
//                                self.arrayOfAllCarImages.append(allImagesOfExactCar.)
                            }
                           for imageSSnapshot in snapshot.children{
                            
                            //key - value
                            let urlOFImageSnapshot = imageSSnapshot as! DataSnapshot
                            let url = urlOFImageSnapshot.value as! String
                            
                            print("THE urlOFImageSnapshot ",urlOFImageSnapshot)
                            print("THE URLS ", url)
                            
                           
                            


                                print("into sync func")
                            
                                self.arrayOfAllCarUrlsImages.append(url)
                            
                             //sending into sync queue for match the little photo and the zoom photo in the same indexes
                            for i in 0..<self.arrayOfAllCarUrlsImages.count{
                                
                                if url == self.arrayOfAllCarUrlsImages[i]{
                                    self.downloadIntoCacheImage(particularUrl: url, particularIndexOfUrl: i)
                                }
                            }
                            
                            
                            }
                            
                        }
                        
                        
                        
                    })
                }
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
        
    
//important cache downloading function for saving the images into the Cached array FOR ZOOMING
    var arrayOfCachedImages:[UIImage] = []
    
    
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
    
    
 
    
}

extension ShowCarsViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //For Loacal Use Only
//        return photos.count
        return arrayOfAllCarUrlsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var carCell = arrayOfAllCarUrlsImages[arrayOfAllCarUrlsImages.count - (indexPath.row + 1)]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath) as! CarsCollectionViewCell
        
        //WORKS PERFECTLY LOCALY NEED TO UNCOMENT THE SET CELL INTO CarsCollectionViewCell
        cell.setCell(carCell: arrayOfAllCarUrlsImages[indexPath.row])
        

//        !!!UNCOMENT
        cell.clipsToBounds = animator?.1 ?? true
        
        //Clear baground Cell
        self.collectionView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let animator = animator else { return view.bounds.size }
        return CGSize(width: view.bounds.width / CGFloat(animator.2), height: view.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    //Zooming while selecting the Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if !arrayOfCachedImages.isEmpty{
        print("arrayOfCachedImages.count \(arrayOfCachedImages.count)")
        //enter to this if only when all images will be loaded into cache
        if arrayOfCachedImages.count == amountOfImagesInExactCar{
            let imageInfo = GSImageInfo(image: arrayOfCachedImages[indexPath.row], imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: collectionView)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            imageViewer.dismissCompletion = {
                print("dismiss called")
            }
            present(imageViewer, animated: true)
        }
    }
//    let scrollView : UIScrollView
    

    
    //zooming
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return
//    }
}




