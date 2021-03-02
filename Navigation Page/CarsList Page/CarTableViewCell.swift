//
//  CarTableViewCell.swift
//  DentCar
//
//  Created by Pavel Petrenko on 02/01/2020.
//  Copyright © 2020 Pavel Petrenko. All rights reserved.
//

import UIKit
import SDWebImage

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carPlateNumberLbl: UILabel!
    @IBOutlet weak var activityIndicatorImage: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.activityIndicatorImage.startAnimating()
    }

    func setCarCell(carDetails: CarDetails){
        self.carImage.sd_setImage(with: URL(string: carDetails.urlOfCarImage)!, completed: nil)
        self.activityIndicatorImage.hidesWhenStopped = true
        self.activityIndicatorImage.stopAnimating()
        self.carPlateNumberLbl.text = carDetails.plateNumberOfCar
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
