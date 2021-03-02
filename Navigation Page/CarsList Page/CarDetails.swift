//
//  File.swift
//  DentCar
//
//  Created by Pavel Petrenko on 02/01/2020.
//  Copyright © 2020 Pavel Petrenko. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class CarDetails{//event is's class that represent the posts on the main screen
    
    var plateNumberOfCar : String
    var urlOfCarImage : String
    
    init(urlOfCarImage: String, plateNumberOfCar: String) {
        
        self.plateNumberOfCar = plateNumberOfCar
        self.urlOfCarImage = urlOfCarImage
      
    }
    
}
