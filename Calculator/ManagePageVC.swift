//
//  ManagePhotoPageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/14/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class ManagePageVC: UIPageViewController, UIPageViewControllerDataSource {
    
    var mediaType: String!
    var currentIndex: Int?
    let storageData = StorageData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
//        automaticallyAdjustsScrollViewInsets = false
        
        if let viewController = viewMediaController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
    func viewMediaController(_ index: Int) -> UIViewController? {
        
        if mediaType == "Photo" {
            if let storyboard = storyboard,
                let page = storyboard.instantiateViewController(withIdentifier: "photoVC") as? PhotoVC {
                page.currentIndex = index
                page.mediaType = "Photo"
                return page
            }
        } else {
            if let storyboard = storyboard,
                let page = storyboard.instantiateViewController(withIdentifier: "videoVC") as? VideoVC {
                page.currentIndex = index
                page.mediaType = "Video"
                return page
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if mediaType == "Photo" {
            if let viewController = viewController as? PhotoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound && index != 0 else { return nil }
                index! -= 1
                return viewMediaController(index!)
            }
        } else {
            if let viewController = viewController as? VideoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound && index != 0 else { return nil }
                index! -= 1
                return viewMediaController(index!)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if mediaType == "Photo" {
            if let viewController = viewController as? PhotoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound else { return nil }
                index! += 1
                guard index != storageData.photos.count else {return nil}
                return viewMediaController(index!)
            }
        } else {
            if let viewController = viewController as? VideoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound else { return nil }
                index! += 1
                guard index != storageData.videos.count else {return nil}
                
                return viewMediaController(index!)
            }
        }
        return nil
    }
}
