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
    //MARK: Controller visibility flag
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
    //MARK: Load Video Player
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
    //MARK:- Custom player control menu hide after 10.0 seconds
    private func hideControlMenuWithDelay(){
        if !isToShowPlaybackControls {
            isToShowPlaybackControls = true
            Timer.scheduledTimer(withTimeInterval: VideoPlayerConstants.customControlTimeout, repeats: false) {[weak self] (timer) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.isToShowPlaybackControls = false
                timer.invalidate()
            }
        }
    }
    //MARK: Play Method
    public func playVideo() {
        self.player?.play()
        self.playPauseButton.isSelected = true
    }
    //MARK: Pause Method
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
    //MARK: Fullscreen method
    @IBAction private func onTapExpandVideoButton(_ sender: UIButton) {
        self.pauseVideo()
        let controller = AVPlayerViewController()
        controller.player = player
        self.parentViewController()?.present(controller, animated: true)
            DispatchQueue.main.async {
                self.isMuted = false
                self.playVideo()
           }
    }
    //MARK: Volume control
    @IBAction private func onTapVolumeButton(_ sender: UIButton) {
        self.isMuted = !sender.isSelected
    }
    //MARK: Forward video
    @IBAction private func onTapRewindButton(_ sender: UIButton) {
        if let currentTime = self.player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - Constants.rewindForwardDuration
            if newTime <= 0 {
                newTime = 0
            }
            self.player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    //MARK: Backward video
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
extension UIView
{
    //MARK:- This method return the parent UIViewController of a UIView
    //MARK: - : parent controller of UIView (i.e. self)
    func parentViewController() -> UIViewController? {
        return self.traverseResponderChainForUIViewController() as? UIViewController
    }
    
    private func traverseResponderChainForUIViewController() -> AnyObject? {
        if let nextResponder = self.next {
            if nextResponder is UIViewController {
                return nextResponder
            } else if nextResponder is UIView {
                return (nextResponder as! UIView).traverseResponderChainForUIViewController()
            } else {
                return nil
            }
        }
        return nil
    }
}
