//
//  StorageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVFoundation

enum MediaType: String {
    case photo = "Photo"
    case video = "Video"
    case camera = "Camera"
    case addPhoto = "Add Photo"
}

class StorageVC: UIViewController {
    
    @IBOutlet weak var mainMenuTableView: UITableView!
    @IBOutlet weak var addMenuTableView: UITableView!
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var addMenuView: UIView!
//    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var addMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var addMenuHeightConstraint: NSLayoutConstraint!
    
    
    var isMainMenuShowing = false
    var isAddMenuShowing = false
    let addMenuItems = [MediaType.camera, MediaType.addPhoto]
    let mainMenuItems = [MediaType.photo, MediaType.video]
    
    let cellHeight: CGFloat = 50
    
    let mediaPerRow: CGFloat = 2
    let cellGap = CGFloat(2)
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    let storageData = StorageData()
    
    private var _titleName: String?
    var titleName: String? {
        get {
            return _titleName
        } set {
            _titleName = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        setNeedsStatusBarAppearanceUpdate()
        addNavBarIcons()
        addLayoutConstraints()
        
        title = titleName
        
//        addMenuHeight.constant = cellHeight * CGFloat(addMenuItems.count)
//        addMenuHeightConstraint.constant = cellHeight * CGFloat(addMenuItems.count * -1)
        
//        mainMenuTableView.delegate = self
//        mainMenuTableView.dataSource = self
//
//        addMenuTableView.delegate = self
//        addMenuTableView.dataSource = self
//
//        collectionView.delegate = self
//        collectionView.dataSource = self

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(swipeUp)
    }
    
    @objc func handleSwipeGesture(gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
        switch swipeGesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            showMainMenu()
            showBlackView()
        case UISwipeGestureRecognizer.Direction.left:
            hideMainMenu()
            hideBlackView()
        case UISwipeGestureRecognizer.Direction.up:
            hideAddMenu()
            hideBlackView()
        default:
            break
        }
    }
    
    @IBAction func addMenuTapped(_ sender: Any) {
        if isAddMenuShowing {
            hideAddMenu()
            hideBlackView()
        } else if !isAddMenuShowing && isMainMenuShowing {
            hideMainMenu()
            showAddMenu()
        } else {
            showAddMenu()
            showBlackView()
        }
    }
    
    @IBAction func mainMenuTapped(_ sender: Any) {
        if isMainMenuShowing {
            hideMainMenu()
            hideBlackView()
        } else if !isMainMenuShowing && isAddMenuShowing{
            showMainMenu()
            hideAddMenu()
        } else {
            showMainMenu()
            showBlackView()
        }
    }
    
    private func showBlackView() {
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideBlackView)))
        blackView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
        })
    }
    
    @objc func hideBlackView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.hideAddMenu()
            self.hideMainMenu()
        }, completion: { finish in
            self.blackView.isHidden = true
        })
    }
    
    private func showAddMenu() {
        if !isAddMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let x = collectionView.frame.width - addMenuView.frame.width
                let yFinal = window.frame.height - collectionView.frame.height
                let yInit = yFinal - addMenuView.frame.height
                addMenuView.frame = CGRect(x: x, y: yInit, width: addMenuView.frame.width, height: addMenuView.frame.height)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.addMenuView.frame = CGRect(x: x, y: yFinal, width: self.addMenuView.frame.width, height: self.addMenuView.frame.height)
                })
                isAddMenuShowing = !isAddMenuShowing
            }
        }
    }
    
    private func hideAddMenu() {
        if isAddMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let x = collectionView.frame.width - addMenuView.frame.width
                let yInit = window.frame.height - collectionView.frame.height - addMenuView.frame.height
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.addMenuView.frame = CGRect(x: x, y: yInit, width: self.addMenuView.frame.width, height: self.addMenuView.frame.height)
                })
                isAddMenuShowing = !isAddMenuShowing
            }
        }
    }
    
    private func showMainMenu() {
        if !isMainMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let y = window.frame.height - collectionView.frame.height
                let xInit = mainMenuView.frame.width * -1
                mainMenuView.frame = CGRect(x: xInit, y: y, width: mainMenuView.frame.width, height: mainMenuView.frame.height)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.mainMenuView.frame = CGRect(x: 0, y: y, width: self.mainMenuView.frame.width, height: self.mainMenuView.frame.height)
                })
                isMainMenuShowing = !isMainMenuShowing
            }
        }
    }
    
    private func hideMainMenu() {
        if isMainMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let y = window.frame.height - collectionView.frame.height
                let xInit = mainMenuView.frame.width * -1
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.mainMenuView.frame = CGRect(x: xInit, y: y, width: self.mainMenuView.frame.width, height: self.mainMenuView.frame.height)
                })
                isMainMenuShowing = !isMainMenuShowing
            }
        }
    }
    
    // Load Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.layer.borderColor = UIColor.purple.cgColor
        cv.layer.borderWidth = 5
        cv.dataSource = self
        cv.delegate = self
        cv.register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.reuseIdentifier)
        return cv
    }()
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private func addLayoutConstraints() {
        view.addSubviews(collectionView, blackView)
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("H:|[v0]|", views: blackView)
        view.addConstraintsWithFormat("V:|[v0]|", views: blackView)
    }
    
    private func addNavBarIcons() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().backgroundColor = .gray
        //        UINavigationBar.appearance().barTintColor = UIColor(red: 24, green: 24, blue: 24) // Hexcolor 242424
        //        UINavigationBar.appearance().backgroundColor = UIColor(red: 24, green: 24, blue: 24)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
}

extension StorageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainMenuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainMenuCell") as! MenuCell
            cell.configCell(mainMenuItems[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addMenuCell") as! MenuCell
            cell.configCell(addMenuItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainMenuTableView {
            return mainMenuItems.count
        } else {
            return addMenuItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMainMenu()
        hideBlackView()
        
        let currentCell = tableView.cellForRow(at: indexPath) as! MenuCell
        let cellText = currentCell.menuLabel.text
        
        if cellText == title {
            hideMainMenu()
            return
        } else if cellText == MediaType.video.rawValue {
            title = MediaType.video.rawValue
        } else if cellText == MediaType.photo.rawValue {
            title = MediaType.photo.rawValue
        } else if cellText == "Contacts" {
            performSegue(withIdentifier: "contactVC", sender: nil)
        }
        
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension StorageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "managePageVC") as? ManagePageVC {
            vc.mediaType = title
            vc.currentIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch title {
        case MediaType.photo.rawValue:
            return storageData.photos.count
        case MediaType.video.rawValue:
            return storageData.videos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCell.reuseIdentifier, for: indexPath) as? MediaCell else { return UICollectionViewCell() }
        
        if title == "Photo" {
            cell.configPhotoCell(url: self.storageData.photos[indexPath.row].path, cellSize: collectionView.layoutAttributesForItem(at: indexPath)?.size)
        } else if title == "Video" {
            cell.configVideoCell(url: self.storageData.videos[indexPath.row], cellSize: collectionView.layoutAttributesForItem(at: indexPath)?.size)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (mediaPerRow - 1) * cellGap
        let widthPerItem = (view.frame.width - paddingSpace) / mediaPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellGap
    }

}
