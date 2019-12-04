//
//  VideoListTableViewCell.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var videoDesLabel: UILabel!
    @IBOutlet weak var videoDateLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    var videListVM = VideoListVM()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- Set the Video componets using the Video object
    func configureCell(_ video:Video){
        videoNameLabel.text = video.name
        videoDesLabel.text = video.description
        videoDateLabel.text = video.date
        guard let thumbUrl = video.thumpUrl else{
            return
        }
        videListVM.getThumbImage(thumbUrl, { (image, error) in
            DispatchQueue.main.async(execute: { [weak self]() -> Void in
                guard let weakSelf = self else {
                    return
                }
                if let thumpImage = image as? UIImage{
                    weakSelf.videoImageView.image = thumpImage
                }else{
                    weakSelf.videoImageView.image = UIImage(named: "placeholder")
                }
            })
            
        })

    }
}

