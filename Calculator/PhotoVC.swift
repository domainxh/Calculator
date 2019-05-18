//
//  PhotoVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/14/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mediaType: String?
    var currentIndex: Int?
    let storageData = StorageData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        scrollView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        imageView.contentMode = .scaleAspectFit
        imageView.center = scrollView.center;
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        
        imageView.image = UIImage(contentsOfFile: storageData.photos[currentIndex!].path)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return imageView }
    
}
