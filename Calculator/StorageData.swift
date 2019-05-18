//
//  StorageData.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/17/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//


import Foundation
import UIKit

private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
private var allFilesInDirectory: [URL] {
    return try! FileManager.default.contentsOfDirectory(at: documentDirectory!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
}

class StorageData: NSObject {
    
    var photos = allFilesInDirectory.filter({ photo in
        photo.pathExtension.lowercased() == "jpg" ||
            photo.pathExtension.lowercased() == "png" ||
            photo.pathExtension.lowercased() == "gif" ||
            photo.pathExtension.lowercased() == "jpeg" ||
            photo.pathExtension.lowercased() == "tiff" })
    
    var videos = allFilesInDirectory.filter({ video in
        video.pathExtension.lowercased() == "avi" ||
            video.pathExtension.lowercased() == "mov" ||
            video.pathExtension.lowercased() == "mp4" ||
            video.pathExtension.lowercased() == "m4v" ||
            video.pathExtension.lowercased() == "vob" ||
            video.pathExtension.lowercased() == "mpg" ||
            video.pathExtension.lowercased() == "mpeg" })
}


