//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Muneer KK on 29/11/19.
//  Copyright © 2019 Muneer KK. All rights reserved.
//

import UIKit
private typealias VideoListVCTableViewMethods = VideoListVC
private typealias Constants = VideoListVC
class VideoListVC: UIViewController {
    @IBOutlet weak var videoListTableView: UITableView!
    var videoListVM  = VideoListVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadVideoList()
    }
    private func loadVideoList() {
        guard let loadedList =  videoListVM.loadVideoList() else {
            return
        }
        videoListVM.videoList = loadedList
    }


}
//MARK: - Tableview Methods
extension VideoListVCTableViewMethods:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let videoCell =  videoListTableView.dequeueReusableCell(withIdentifier:TableViewCellIdentifier.videoCellID.rawValue) as! VideoListTableViewCell
        videoCell.configureCell(videoListVM.videoList[indexPath.row])
        return videoCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return videoListVM.videoList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
      
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let onboardingStoryboard : UIStoryboard = UIStoryboard(name:StoryboardName.main.rawValue, bundle: Bundle.main)
        let videoDetailVC  = onboardingStoryboard.instantiateViewController(withIdentifier: StoryboardIdentifier.videoDetailVCID.rawValue) as! VideoDetailVC
        videoListVM.selectedVideo = videoListVM.videoList[indexPath.row]
        videoDetailVC.videoListVM = videoListVM
        self.present(videoDetailVC, animated: true, completion: nil)
    }
    
}
//MARK: - Tableview Constants
extension Constants {
    struct Constants {
        static let rowHeight:CGFloat = 130.0
    }
}


