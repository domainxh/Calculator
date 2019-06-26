//
//  StorageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVFoundation

class StorageVC: UIViewController {
    
    convenience init() {
        self.init(title: "")
    }
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isMainMenuShowing = false
    private var isAddMenuShowing = false
    
    private let mediaPerRow: CGFloat = 2
    private let cellGap = CGFloat(2)
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private var navBarHeight = 0
    
    private let storageData = StorageData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        navBarHeight = Int(navigationController?.navigationBar.frame.height ?? 0)
        setNeedsStatusBarAppearanceUpdate()
        addNavBarIcons()
        addLayoutConstraints()
    
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        view.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        view.addGestureRecognizer(swipeLeft)
//
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
//        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
//        view.addGestureRecognizer(swipeUp)
    }
    
//    @objc func handleSwipeGesture(gesture: UIGestureRecognizer) {
//        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
//        switch swipeGesture.direction {
//        case UISwipeGestureRecognizer.Direction.right:
//            showMainMenu()
//            showBlackView()
//        case UISwipeGestureRecognizer.Direction.left:
//            hideMainMenu()
//            hideBlackView()
//        case UISwipeGestureRecognizer.Direction.up:
//            hideAddMenu()
//            hideBlackView()
//        default:
//            break
//        }
//    }
    
    // Load Views
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.layer.borderColor = UIColor.purple.cgColor
        cv.layer.borderWidth = 5
        cv.dataSource = self
        cv.delegate = self
        cv.register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.reuseIdentifier)
        return cv
    }()
    
    private lazy var mainMenuTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseIdentifierMainMenu)
        return tv
    }()
    
    private lazy var addMenuTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseIdentifierAddMenu)
        return tv
    }()
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()
    
    private lazy var mainMenu: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var addMenu: UIView = {
        let view = UIView()
        return view
    }()
    
    @objc private func hideBlackView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.hideAddMenu()
            self.hideMainMenu()
        }, completion: { finish in
            self.blackView.isHidden = true
        })
    }
    
    private func showBlackView() {
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideBlackView)))
        blackView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.blackView.alpha = 1
        })
    }
    
    private func hideMainMenu() {
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.mainMenu.transform = CGAffineTransform(translationX: self.mainMenu.frame.width * -1, y: 0)
            self.isMainMenuShowing = false
        })
    }
    
    private func showMainMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            self.mainMenu.transform = CGAffineTransform(translationX: self.mainMenu.frame.width, y: 0)
            self.isMainMenuShowing = true
        })
    }
    
    private func hideAddMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.addMenu.transform = CGAffineTransform(translationX: 0, y: 0)
            self.isAddMenuShowing = false
        })
    }

    private func showAddMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self else { return }
            self.addMenu.transform = CGAffineTransform(translationX: 0, y: AddMenu.height)
            self.isAddMenuShowing = true
        })
    }
    
    @objc private func menuButtonPressed() {
        if isMainMenuShowing {
            hideMainMenu()
            hideBlackView()
        } else if !isMainMenuShowing && isAddMenuShowing {
            showMainMenu()
            hideAddMenu()
        } else {
            showMainMenu()
            showBlackView()
        }
    }

    @objc private func addButtonPressed() {
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

    private func addLayoutConstraints() {
        let barHeight = navBarHeight + Int(statusBarHeight)
        view.addSubviews(collectionView, blackView, mainMenu, addMenu)
        
        mainMenu.addSubview(mainMenuTableView)
        mainMenu.addConstraintsWithFormat("H:|[v0]|", views: mainMenuTableView)
        mainMenu.addConstraintsWithFormat("V:|[v0]|", views: mainMenuTableView)
        
        addMenu.addSubview(addMenuTableView)
        addMenu.addConstraintsWithFormat("H:|[v0]|", views: addMenuTableView)
        addMenu.addConstraintsWithFormat("V:|[v0]|", views: addMenuTableView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|-\(barHeight)-[v0]|", views: collectionView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: blackView)
        view.addConstraintsWithFormat("V:|-\(barHeight)-[v0]|", views: blackView)
        
        view.addConstraintsWithFormat("H:[v0(\(MainMenu.cellWidth))]-\(screenSize.width)-|", views: mainMenu)
        view.addConstraintsWithFormat("V:|-\(barHeight)-[v0]|", views: mainMenu)

        view.addConstraintsWithFormat("H:[v0(\(AddMenu.cellWidth))]|", views: addMenu)
        view.addConstraintsWithFormat("V:[v0(\(AddMenu.height))]-\(screenSize.height - CGFloat(barHeight))-|", views: addMenu)
    }

    private func addNavBarIcons() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().backgroundColor = .gray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let menuImage = UIImage(named: "menubutton")
        let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuButtonPressed))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
}

extension StorageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainMenuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifierMainMenu) as! MenuCell
            cell.configCell(MainMenu.items[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifierAddMenu) as! MenuCell
            cell.configCell(AddMenu.items[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainMenuTableView {
            return MainMenu.items.count
        } else {
            return AddMenu.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMainMenu()
        hideBlackView()
        
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuCell else { return }
        switch cell.menuLabel.text {
        case title:
            hideMainMenu()
            return
        case MediaType.video:
            title = MediaType.video
        case MediaType.photo:
            title = MediaType.photo
        case MediaType.contact:
            performSegue(withIdentifier: "contactVC", sender: nil)
        case MediaType.addPhoto:
            hideAddMenu()
        case MediaType.camera:
            hideAddMenu()
        default:
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainMenu.cellHeight
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
        case MediaType.photo:
            return storageData.photos.count
        case MediaType.video:
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
