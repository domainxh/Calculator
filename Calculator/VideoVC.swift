//
//  VideoVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/15/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoVC: UIViewController {

    let storageData = StorageData()
    var mediaType: String?
    var currentIndex: Int!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        player = AVPlayer(url: storageData.videos[currentIndex])
        let av = AVPlayerViewController()
        av.player = player
        av.view.frame = self.view.frame
        self.addChild(av)
        self.view.addSubview(av.view)
        av.didMove(toParent: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        player.pause()
    }
}

//    let avPlayer = AVPlayer()
//    var avPlayerLayer: AVPlayerLayer!
//    let invisibleButton = UIButton()
//    var timeObserver: AnyObject!
//    let timeRemainingLabel = UILabel()
//    let seekSlider = UISlider()
//    var playerRateBeforeSeek: Float = 0
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // An AVPlayerLayer is a CALayer instance to which the AVPlayer can
//        // direct its visual output. Without it, the user will see nothing.
//        avPlayerLayer = AVPlayerLayer(player: avPlayer)
//        view.layer.insertSublayer(avPlayerLayer, at: 0)
//        view.addSubview(invisibleButton)
//        invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped), for: .touchUpInside)
//        
//        let playerItem = AVPlayerItem(url: videoList[currentIndex])
//        avPlayer.replaceCurrentItem(with: playerItem)
//        
//        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
//        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
//            // print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
//            self.observeTime(elapsedTime: elapsedTime)
//        } as AnyObject!
//        
//        timeRemainingLabel.textColor = .white
//        view.addSubview(timeRemainingLabel)
//        
//        view.addSubview(seekSlider)
//        seekSlider.addTarget(self, action: #selector(sliderBeganTracking),
//                             for: .touchDown)
//        seekSlider.addTarget(self, action: #selector(sliderEndedTracking),
//                             for: [.touchUpInside, .touchUpOutside])
//        seekSlider.addTarget(self, action: #selector(sliderValueChanged),
//                             for: .valueChanged)
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        avPlayer.play() // Start the playback
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        // Layout subviews manually
//        avPlayerLayer.frame = view.bounds
//        invisibleButton.frame = view.bounds
//        
//        let controlsHeight: CGFloat = 30
//        let controlsY: CGFloat = view.bounds.size.height - controlsHeight
//        timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
//        
//        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width,
//                                  y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
//    }
//    
//    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
//        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
//        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
//    }
//    
//    private func observeTime(elapsedTime: CMTime) {
//        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
////        if isFinite(duration) {
//            let elapsedTime = CMTimeGetSeconds(elapsedTime)
//            updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
////        }
//    }
//    
//    func invisibleButtonTapped(sender: UIButton) {
//        let playerIsPlaying = avPlayer.rate > 0
//        if playerIsPlaying {
//            avPlayer.pause()
//        } else {
//            avPlayer.play()
//        }
//    }
//    
//    deinit {
//        avPlayer.removeTimeObserver(timeObserver)
//    }
//    
//    func sliderBeganTracking(slider: UISlider) {
//        playerRateBeforeSeek = avPlayer.rate
//        avPlayer.pause()
//    }
//    
//    func sliderEndedTracking(slider: UISlider) {
//        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
//        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
//        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
//        
//        avPlayer.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
//            if self.playerRateBeforeSeek > 0 {
//                self.avPlayer.play()
//            }
//        }
//    }
//    
//    func sliderValueChanged(slider: UISlider) {
//        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
//        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
//        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        view.backgroundColor = .red
////        let videoPlayerView = VideoPlayerView()
//        
//        let height = view.frame.size.height
//        let videoPlayerFrame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
//        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
//        view.addSubview(videoPlayerView)
//        
//    }
//
//    
//}
//
//class VideoPlayerView: UIView {
//    
//    let activityIndicatorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        aiv.translatesAutoresizingMaskIntoConstraints = false
//        aiv.startAnimating()
//        return aiv
//    }()
//    
//    lazy var pausePlayButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: "pauseButton")
//        button.setImage(image, for: UIControlState())
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = .white
//        button.isHidden = true
//        
//        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
//        
//        return button
//    }()
//    
//    var isPlaying = false
//    
//    func handlePause() {
//        if isPlaying {
//            player?.pause()
//            pausePlayButton.setImage(UIImage(named: "playButton"), for: UIControlState())
//        } else {
//            player?.play()
//            pausePlayButton.setImage(UIImage(named: "pauseButton"), for: UIControlState())
//        }
//        
//        isPlaying = !isPlaying
//    }
//    
//    let controlsContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(white: 0, alpha: 1)
//        return view
//    }()
//    
//    let videoLengthLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "00:00"
//        label.textColor = .white
//        label.font = UIFont(name: "Avenir Next", size: 13)
//        label.textAlignment = .right
//        return label
//    }()
//    
//    let currentTimeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "00:00"
//        label.textColor = .white
//        label.font = UIFont(name: "Avenir Next", size: 13)
//        return label
//    }()
//    
//    lazy var videoSlider: UISlider = {
//        let slider = UISlider()
//        slider.translatesAutoresizingMaskIntoConstraints = false
////        slider.minimumTrackTintColor = .darkGray
//        slider.maximumTrackTintColor = .white
////        slider.setThumbImage(UIImage(named: "thumb"), for: UIControlState())
//        
//        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
//        
//        return slider
//    }()
//    
//    func handleSliderChange() {
//        print(videoSlider.value)
//        
//        if let duration = player?.currentItem?.duration {
//            let totalSeconds = CMTimeGetSeconds(duration)
//            
//            let value = Float64(videoSlider.value) * totalSeconds
//            
//            let seekTime = CMTime(value: Int64(value), timescale: 1)
//            
//            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
//                //perhaps do something later here
//            })
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setupPlayerView()
//        
//        setupGradientLayer()
//        
//        controlsContainerView.frame = frame
//        addSubview(controlsContainerView)
//        
//        controlsContainerView.addSubview(activityIndicatorView)
//        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        
//        controlsContainerView.addSubview(pausePlayButton)
//        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        controlsContainerView.addSubview(videoLengthLabel)
//        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
//        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
//        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        
//        controlsContainerView.addSubview(currentTimeLabel)
//        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
//        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        
//        controlsContainerView.addSubview(videoSlider)
//        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
//        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
//        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        backgroundColor = .black
//    }
//    
//    var player: AVPlayer?
//    
//    fileprivate func setupPlayerView() {
//        //warning: use your own video url here, the bandwidth for google firebase storage will run out as more and more people use this file
//        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
//        if let url = URL(string: urlString) {
//            player = AVPlayer(url: url)
//            
//            let playerLayer = AVPlayerLayer(player: player)
//            self.layer.addSublayer(playerLayer)
//            playerLayer.frame = self.frame
//            
//            player?.play()
//            
//            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//            
//            //track player progress
//            
//            let interval = CMTime(value: 1, timescale: 2)
//            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
//                
//                let seconds = CMTimeGetSeconds(progressTime)
//                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
//                let minutesString = String(format: "%02d", Int(seconds / 60))
//                
//                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
//                
//                //lets move the slider thumb
//                if let duration = self.player?.currentItem?.duration {
//                    let durationSeconds = CMTimeGetSeconds(duration)
//                    
//                    self.videoSlider.value = Float(seconds / durationSeconds)
//                    
//                }
//                
//            })
//        }
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        //this is when the player is ready and rendering frames
//        if keyPath == "currentItem.loadedTimeRanges" {
//            activityIndicatorView.stopAnimating()
//            controlsContainerView.backgroundColor = .clear
//            pausePlayButton.isHidden = false
//            isPlaying = true
//            
//            if let duration = player?.currentItem?.duration {
//                let seconds = CMTimeGetSeconds(duration)
//                
//                let secondsText = Int(seconds) % 60
//                let minutesText = String(format: "%02d", Int(seconds) / 60)
//                videoLengthLabel.text = "\(minutesText):\(secondsText)"
//            }
//        }
//    }
//    
//    fileprivate func setupGradientLayer() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradientLayer.locations = [0.7, 1.2]
//        controlsContainerView.layer.addSublayer(gradientLayer)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//class VideoLauncher: NSObject {
//
//    func showVideoPlayer() {
//        print("Showing video player animation....")
//
//        if let keyWindow = UIApplication.shared.keyWindow {
//            let view = UIView(frame: keyWindow.frame)
//            view.backgroundColor = UIColor.white
//
//            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
//
//            //16 x 9 is the aspect ratio of all HD videos
//            let height = keyWindow.frame.width * 9 / 16
//            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
//            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
//            view.addSubview(videoPlayerView)
//
//            keyWindow.addSubview(view)
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//                view.frame = keyWindow.frame
//
//                }, completion: { (completedAnimation) in
//                    //maybe we'll do something here later...
//                    UIApplication.shared.setStatusBarHidden(true, with: .fade)
//            })
//        }
//    }
//}


