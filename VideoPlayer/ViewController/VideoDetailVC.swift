//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import UIKit

class VideoDetailVC: UIViewController {
    
    var videoListVM  = VideoListVM()
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrpLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Set UI element Values using selected video Object
        customizeUI()
        
        guard let urlsString = videoListVM.selectedVideo.videoUrl else {
            return
        }
        // MARK: - Load Video Player using selected video Object
        loadVideoPlayer(with: urlsString)
       
    }
    // MARK: - Method to initialize and start video player using video view object
    private func loadVideoPlayer(with urlString:String){
        guard let url = URL(string: urlString) else {
            return
        }
        videoPlayerView.loadVideos(with: url)
    }
    // MARK: - Set UI element Values using selected video Object
    private func customizeUI() {
        navLabel.text  = videoListVM.selectedVideo.name
        titleLabel.text  = videoListVM.selectedVideo.name
        descrpLabel.text = videoListVM.selectedVideo.description
        dateLabel.text   = videoListVM.selectedVideo.date
        
    }
    // MARK: - Dismiss the view
     @IBAction private func onTapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}

