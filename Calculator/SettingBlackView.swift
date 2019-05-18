////
////  SettingBlackView.swift
////  CustomizableCalculator
////
////  Created by Xiaoheng Pan on 2/18/17.
////  Copyright © 2017 Xiaoheng Pan. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class SettingBlackView: NSObject {
//    
//    var blackView: UIView?
//    
//    init(blackView: UIView) {
//        self.blackView = blackView
//    }
//    
//    func showSettings() {
//        //show menu
//        
//        if let blackView = blackView {
//            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            
//            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//            
//            window.addSubview(blackView)
//            
//            window.addSubview(collectionView)
//            
//            let height: CGFloat = CGFloat(settings.count) * cellHeight
//            let y = window.frame.height - height
//            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
//            
//            blackView.frame = window.frame
//            blackView.alpha = 0
//            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                
//                self.blackView.alpha = 1
//                
//                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//                
//            }, completion: nil)
//        }
//    }
//    
//    func handleDismiss(_ setting: Setting) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            
//            self.blackView.alpha = 0
//            
//            if let window = UIApplication.shared.keyWindow {
//                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//            }
//            
//        }) { (completed: Bool) in
//            if setting.name != .Cancel {
//                self.homeController?.showControllerForSetting(setting)
//            }
//        }
//    }
//
//    
//}
