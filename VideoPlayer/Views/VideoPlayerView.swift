//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  Created by Muneer KK on 02/12/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class VideoPlayerView: UIView {

        //MARK: Outlets
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var playbackControlsViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var loaderView: PlaceHolderView!
    
    //MARK: Private Properties
       private var timer: Timer?
       private var playerLayer: AVPlayerLayer?
       private var player: AVPlayer?
       private enum Constants {
           static let nibName = "VideoPlayerView"
           static let rewindForwardDuration: Float64 = 10 //in seconds
       }
    
    //MARK: Internal Properties
    public var isMuted = true {
        didSet {
            self.player?.isMuted = self.isMuted
            self.volumeButton.isSelected = self.isMuted
        }
    }
    public var isToShowPlaybackControls = true {
        didSet {
            UIView.animate(withDuration: 0.5) {
                if !self.isToShowPlaybackControls {
                    self.playbackControlsViewHeightContraint.constant = 0.0
                    self.layoutIfNeeded()
                }else{
                    self.playbackControlsViewHeightContraint.constant = 40.0
                    self.layoutIfNeeded()
                }
            }
            
            
        }
    }
    
    
    //MARK: Lifecycle Methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.videoView.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
   
    
    //MARK: Public Methods
    public class func initialize(with frame: CGRect) -> VideoPlayerView? {
        let bundle = Bundle(for: VideoPlayerView.self)
        let view = bundle.loadNibNamed(Constants.nibName, owner: self, options: nil)?.first as? VideoPlayerView
        view?.frame = frame
        return view
    }
    
    public func loadVideos(with url: URL) {
        self.player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.videoView.layer.insertSublayer(self.playerLayer!, at: 0)
        
        //Add tap gesture to your view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleVideoTap))
        videoView.addGestureRecognizer(tap)
        isToShowPlaybackControls = false
        hideControlMenuWithDelay()

       
    }
    // GestureRecognizer
    @objc func handleVideoTap(gesture: UITapGestureRecognizer) -> Void {
        hideControlMenuWithDelay()
    }
    private func hideControlMenuWithDelay(){
        if !isToShowPlaybackControls {
            isToShowPlaybackControls = true
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {[weak self] (timer) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.isToShowPlaybackControls = false
                timer.invalidate()
            }
        }
    }
    
    public func playVideo() {
        self.player?.play()
        self.playPauseButton.isSelected = true
    }
    
    public func pauseVideo() {
        self.player?.pause()
        self.playPauseButton.isSelected = false
    }
    
    //MARK: Button Action Methods
    @IBAction private func onTapPlayPauseVideoButton(_ sender: UIButton) {
        if sender.isSelected {
            self.pauseVideo()
        } else {
            self.playVideo()
        }
        
    }
    
    @IBAction private func onTapExpandVideoButton(_ sender: UIButton) {
        self.pauseVideo()
        let controller = AVPlayerViewController()
        controller.player = player
//        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidDismiss), name: Notification.Name("avPlayerDidDismiss"), object: nil)
//        self.parentViewController().present(controller, animated: true) {[weak self] in
//            DispatchQueue.main.async {
//                self?.isMuted = false
//                self?.playVideo()
//            }
//        }
    }
    
    @IBAction private func onTapVolumeButton(_ sender: UIButton) {
        self.isMuted = !sender.isSelected
    }
    
    @IBAction private func onTapRewindButton(_ sender: UIButton) {
        if let currentTime = self.player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - Constants.rewindForwardDuration
            if newTime <= 0 {
                newTime = 0
            }
            self.player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @IBAction private func onTapForwardButton(_ sender: UIButton) {
        if let currentTime = self.player?.currentTime(), let duration = self.player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + Constants.rewindForwardDuration
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            self.player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
}
class PlaceHolderView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0 * 2 * 60.0
        rotationAnimation.duration = 200.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}
