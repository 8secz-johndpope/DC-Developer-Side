//
//  AlertService.swift
//  DentCar
//
//  Created by Pavel Petrenko on 30/11/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    static let shared = AlertService()
    
    func successMessage(with code: String) -> UIAlertController {
        let alert = UIAlertController(title: "Success", message: "You have successfully logged in with code: \(code)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(action)
        return alert
    }
    func unSuccessMessage(with code: String) -> UIAlertController {
        let alert = UIAlertController(title: "Unsuccess", message: "Your code : \(code) isn't right please check it again ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(action)
        return alert
    }
}
