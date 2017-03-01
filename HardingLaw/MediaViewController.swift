//
//  HowToUseAppViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 21..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit

import youtube_ios_player_helper

class MediaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var playerView:YTPlayerView!
    @IBOutlet var tableView:UITableView!
    
    let titleArray = ["What if I don't have medical insurance?", "Hourly vs. Contingency Fee", "How to get the most money on your injury case - Part 2", "Denver injury lawyer tells you how to get the most money from your claim", "Settling Cases Colorado personal injury lawyer settle case for money", "Will I make more money hiring an attorney, even after fees?"]
    let videoIDArary = ["FwQhozLo1mM", "DlKSXzSW3kM", "I0vw-KX1-24", "tOe6k8FGPx0", "V5STWrEdqLs", "Fu--VdUlZic"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //playerView.load(withVideoId: "M7lc1UVf-VE")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
        
        cell.backgroundColor = UIColor.clear
        let videoTitle:UILabel = cell.viewWithTag(10) as! UILabel
        let ytbPlayer:YTPlayerView = cell.viewWithTag(11) as! YTPlayerView
        videoTitle.text = titleArray[indexPath.row]
        videoTitle.textColor = UIColor.white
        videoTitle.font = UIFont.init(name: "Courier", size: 18)
        ytbPlayer.load(withVideoId: videoIDArary[indexPath.row])
        return cell
    }
}
