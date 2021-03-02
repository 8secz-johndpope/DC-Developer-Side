//
//  SegueFromLeft.swift
//  DentCar
//
//  Created by Pavel Petrenko on 21/12/2019.
//  Copyright © 2019 Pavel Petrenko. All rights reserved.
//

import UIKit
class SegueFromRight: UIStoryboardSegue {
//    override func perform() {
//        let src = self.source
//        let dst = self.destination
//
//        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
//        dst.view.transform = CGAffineTransform(translationX: +src.view.frame.size.width, y: 0)
//
//        //duration 0.25
//        UIView.animate(withDuration: 0.25,
//                       delay: 0.0,
//                       options: .curveEaseInOut,
//                       animations: {
//                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
//        },
//                       completion: { finished in
//                        src.present(dst, animated: false, completion: nil)
//        }
//        )
//    }
    
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: +src.view.frame.size.width, y: 0)
        
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        dst.view.window!.layer.add(transition, forKey: kCATransition)
        
        src.present(dst, animated: false, completion: nil)
        

    }
    
    
}
