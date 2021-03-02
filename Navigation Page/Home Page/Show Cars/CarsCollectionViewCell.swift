//
//  CarsCollectionViewCell.swift
//  DentCar
//
//  Created by Pavel Petrenko on 08/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit

class CarsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    
    var carCellsInfoArr : [CarCellBluePrint] = []
    
    //// WORKS PERFECTLY LOCALY NEED TO UNCOMENT
//    func setCell(imageName:String) {
//
//        carImageView.image = UIImage(named: imageName)
//
//    }
    
    
    
    func setCell(carCell : String) {
        
        
        self.carImageView.sd_setImage(with: URL(string: carCell), completed: nil)
        
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        carImageView.layoutIfNeeded()
        
        backgroundColor = .clear
    }
    
    func bind(color: String, imageName: String) {
//        contentView.backgroundColor = color.hexColor
    }
}
