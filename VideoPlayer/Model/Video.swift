//
//  VideoPlayer.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import Foundation
struct Video:Decodable {
    var name :String?
    var thumpUrl:String?
    var videoUrl:String?
    var description:String?
    var date:String?
    
    
    //MARK: Codingkey Swift will automatically use this as the key type. This therefore allows you to easily customise the keys that your properties are encoded/decoded with.
    
    enum CodingKeys: String, CodingKey {
           case name
           case thumpUrl     = "thumb_url"
           case videoUrl     = "video_url"
           case description
           case date         = "updatedOn"
      }
}
