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
    var dataHandler = VideoPlayerDataHandler()
    func loadVideoList()->[Video]?{
        self.dataHandler.getVideoList()
    }
}
