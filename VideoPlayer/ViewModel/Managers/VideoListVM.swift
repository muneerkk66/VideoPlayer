//
//  VideoPlayerVM.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import Foundation
class VideoListVM: NSObject {
    var videoList = [Video]()
    var selectedVideo = Video()
    var dataHandler = VideoPlayerDataHandler()
    func loadVideoList()->[Video]?{
        self.dataHandler.getVideoList()
    }
    func playVideoPlayer(player:VideoPlayerView,video:Video){
        if let player = VideoPlayerView.initialize(with: player.bounds) {
            player.isToShowPlaybackControls = true
            player.addSubview(player)
            let url = URL(string: video.videoUrl!)
            player.loadVideos(with: url!)
            player.playVideo()
        }
    }
}
