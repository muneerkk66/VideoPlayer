//
//  VideoPlayerDataHandler.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import Foundation
class VideoPlayerDataHandler: BaseDataHandler {
    func getVideoList()->[Video]?{
        guard let url = Bundle.main.url(forResource:VideoPlayerConstants.dataFile, withExtension: VideoPlayerConstants.dataFileExtension) else { return nil}
        guard let data = try? Data(contentsOf: url) else { return nil }
        do {
            let videoList = try? JSONDecoder().decode([Video].self, from: data)
            return videoList
        } catch { print(error) }
        return nil
    }
    
}
