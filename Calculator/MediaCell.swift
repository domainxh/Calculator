//
//  mediaCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import Photos

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var videoDurationLabel: UILabel!
    
//    var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    func configPhotoCell(url: String, cellSize: CGSize?) {
        cellImage.image = nil
        cellImage.contentMode = .scaleAspectFill
        videoDurationLabel.isHidden = true
        
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            let image = UIImage(contentsOfFile: url)

//            if let imageSize = cellSize?.width {
//                UIGraphicsBeginImageContext(CGSize(width: imageSize, height: imageSize))
//            }
//
//            image?.draw(at: .zero)
//            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                self.cellImage.image = image
            }
        }
        
    }
    
    func configVideoCell(url: URL, cellSize: CGSize?) {
        cellImage.image = nil
        cellImage.contentMode = .scaleAspectFill
        videoDurationLabel.isHidden = false
        
        let asset = AVURLAsset(url: url , options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        if let imageSize = cellSize?.width {
            imgGenerator.maximumSize = CGSize(width: imageSize * 2, height: imageSize * 2)
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let image = UIImage(cgImage: cgImage!)
            let durationLabel = self.getMediaDuration(url: url as NSURL)

            DispatchQueue.main.async {
                self.cellImage.image = image
                self.videoDurationLabel.text = durationLabel
            }
        }

    }
    
    func getMediaDuration(url: NSURL!) -> String{
        let asset : AVURLAsset = AVURLAsset(url: url as URL) as AVURLAsset
        let duration : CMTime = asset.duration
        
        let durationSeconds = CMTimeGetSeconds(duration);
        let secondsString = String(format: "%02d", Int(durationSeconds.truncatingRemainder(dividingBy: 60)))
        let minutesString = String(format: "%02d", Int(durationSeconds / 60))
        
        return "\(minutesString):\(secondsString)"
    }
    
}

