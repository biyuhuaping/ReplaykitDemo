//
//  ViewController.swift
//  ReplaykitDemo
//
//  Created by 苏金劲 on 2021/6/14.
//

import UIKit
import SKReplaykit
import AVKit

class ViewController: UIViewController {
    
    var processor: SKRMainProcessor?
    
    let info = SKRSharedInfo(bundleId: "com.yes.GanodermaDiagnosis")
    let player = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.processor = SKRMainProcessor(info: info)
        self.processor?.extname = "ReplaykitExt"
        self.processor?.needMicrophone = true
        
        guard let btn = self.processor?.startButton() else {
            fatalError("Cant create replay kit start button!")
        }
        
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.center = self.view.center
        self.view.addSubview(btn)
        

        let playBtn = UIButton(type: .system)
        playBtn.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        playBtn.center.x = btn.center.x
        playBtn.center.y = btn.center.y + 100
        
        playBtn.setTitle("播放第一个视频", for: .normal)
        playBtn.addTarget(self, action: #selector(onPlayClicked), for: .touchUpInside)
        self.view.addSubview(playBtn)
    }
    
    @objc func onPlayClicked() {
        if let dir = info.videoWriteUrl(),
           var res = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []) {
            print(res)
            // 稍微排序一下，保证每次都播放最新录制的一个视频
            res.sort { (url1, url2) -> Bool in
                return url1.path > url2.path
            }
            // 取第一个，也就是最新的那个视频
            if let videoURL = res.first {
                print(videoURL)
//                let playerItem = AVPlayerItem(url: videoURL)
//                playerItem.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
                
                player.player = AVPlayer(url: videoURL)
//                player.player?.addObserver(self, forKeyPath: "error", options: [.old, .new], context: nil)
                
                self.present(player, animated: true) {
                    self.player.player?.play()
                    if let err = self.player.player?.error {
                        print("Play error: \(err)")
                    }
                }
            }
        } else {
            print("No dir: \(String(describing: info.videoWriteUrl))")
        }
    }
    
    // 观察 AVPlayerItem 的状态变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let statusNumber = change?[.newKey] as? NSNumber,
                let status = AVPlayerItem.Status(rawValue: statusNumber.intValue) {
                switch status {
                case .unknown:
                    print("Player item status unknown")
                case .readyToPlay:
                    print("Player item status ready to play")
                    // 开始播放
                case .failed:
                    print("Player item status failed")
                @unknown default:
                    print("Player item status unknown default")
                }
            }
        }
    }
    
}

