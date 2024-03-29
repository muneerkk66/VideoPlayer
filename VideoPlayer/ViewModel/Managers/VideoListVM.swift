//
//  VideoPlayerVM.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//
import UIKit
import Foundation
class VideoListVM: BaseVM {
    var videoList = [Video]()
    var selectedVideo = Video()
    var dataHandler = VideoPlayerDataHandler()
    
    // MARK: Method to get video list
    func loadVideoList()->[Video]?{
        self.dataHandler.getVideoList()
    }
    // MARK: Method to load the vide from video url.VideoPlayerView is the responsible class to play the video
    // MARK: VideoPlayerView inititlaize with URL string
    func playVideoPlayer(player:VideoPlayerView,video:Video){
        if let player = VideoPlayerView.initialize(with: player.bounds) {
            player.isToShowPlaybackControls = true
            player.addSubview(player)
            // MARK: handling force unwrapping
            guard let urlString = video.videoUrl, let url = URL(string: urlString) else {
                return
            }
            player.loadVideos(with: url)
            player.isToShowPlaybackControls = false
            player.isMuted = true
            player.playVideo()
        }
    }
    func getThumbImage(_ url:String, _ onCompletion:@escaping VMDataCompletionBlock){
        self.dataHandler.getThumbnailImageFromVideoUrl(url: url) { (image, error) in
            onCompletion(image,error)
        }
    }
}
