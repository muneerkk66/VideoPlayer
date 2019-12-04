//
//  VideoPlayerDataHandler.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import Foundation
import AVKit
class VideoPlayerDataHandler: BaseDataHandler {
    // MARK: Method to load the Json data from file then decode to video object -
    func getVideoList()->[Video]?{
        guard let url = Bundle.main.url(forResource:VideoPlayerConstants.dataFile, withExtension: VideoPlayerConstants.dataFileExtension) else { return nil}
        guard let data = try? Data(contentsOf: url) else { return nil }
        do {
            let videoList = try? JSONDecoder().decode([Video].self, from: data)
            return videoList
         }
        
    }
    func getThumbnailImageFromVideoUrl(url: String, _ onCompletion:@escaping DataHandlerDataCompletionBlock) {
            DispatchQueue.global().async {
                if let url = URL(string: url) {
                   let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                       if data != nil {
                           onCompletion(UIImage(data:data!),nil)
                       }else{
                           onCompletion(nil,nil)
                       }

                }
                onCompletion(nil,nil)

            }
    }
    
}
