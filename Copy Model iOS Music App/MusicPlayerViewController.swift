//
//  MusicPlayerViewController.swift
//  Copy Model iOS Music App
//
//  Created by on 2023/3/24.
//

import UIKit
import AVFoundation //為了使用 AVPlayer 播放音樂，必須先加入 AVFoundation。



class MusicPlayerViewController: UIViewController {

    
    @IBOutlet weak var albumPhotoImageView: UIImageView!    //照片UIImage
    @IBOutlet weak var songNameLabel: UILabel!              //歌曲UILabel
    @IBOutlet weak var singerNameLabel: UILabel!            //歌手UILabel
    @IBOutlet weak var runTimerSlider: UISlider!            //歌曲時間條
    @IBOutlet weak var startLabel: UILabel!                 //歌曲開始時間
    @IBOutlet weak var endLabel: UILabel!                   //歌曲目前時間
    
    
    var songs = ["後會無期歌曲", "City of Stars歌曲", "小宇歌曲"]   //mp3檔案Array
    var index: Int = 0                                         //index要讀取Array
    var singer = ["張碧辰", "Ryan Gosling", "張震嶽"]            //歌手Array
    var songNameArray = ["後會無期", "City of Stars", "小宇"]    //歌曲Array
    var timer: Timer?               //Timer 類別表示了一個計時器，變數timer可以存儲一個計時器

    
    //歌曲 歌手文字顯示尺寸
    let fullScreenSize = UIScreen.main.bounds.size
    
    //生成播放音樂的 AVPlayer 物件。
    let player = AVPlayer()
    
    
    //初始畫面
    override func viewDidLoad() {
        super.viewDidLoad()
        firstOpen()
    }
    

    //一開始登入畫面，初始畫面不要寫這麼雜，拉出來一個函式
    func firstOpen() {
        //歌曲名、歌手Label
        songNameLabel.text = songNameArray[index]
        singerNameLabel.text = singer[index]
        //歌曲名尺寸螢幕位置
        songNameLabel.frame = CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.6, height: 50)
        songNameLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        songNameLabel.textAlignment = .center
        //歌手名尺寸螢幕位置
        singerNameLabel.frame = CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.6, height: 50)
        singerNameLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.57)
        singerNameLabel.textAlignment = .center
        //音樂進度0
        runTimerSlider.value = 0
        //時間先隱藏
        startLabel.isHidden = true
        endLabel.isHidden = true
        
        //App背景顏色
        view.backgroundColor = UIColor(red: 46/255, green: 52/255, blue: 61/255, alpha: 1)
    }
    
    
    //播音樂
    func playMusic() {
        
        startLabel.isHidden = false
        endLabel.isHidden = false
        
        //播音樂
        //產生音樂在 App 裡路徑的 URL。
        //                 呼叫 function url(forResource:withExtension:)
        //參數 forResource 傳入檔名，參數 withExtension 傳入附檔名
        let url = Bundle.main.url(forResource: songs[index], withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)             //利用 AVPlayerItem 生成要播放的音樂
        player.replaceCurrentItem(with: playerItem)         //設定 player 要播放的 AVPlayerItem
        

        player.play()  //開始播放音樂
        
        //換照片
        albumPhotoImageView.image = UIImage(named: songNameArray[index])
        
        //換歌曲文字
        songNameLabel.text = songNameArray[index]
        songNameLabel.frame = CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.6, height: 50)
        songNameLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        songNameLabel.textColor = UIColor(red: 216/255, green: 210/255, blue: 200/255, alpha: 1)
        songNameLabel.textAlignment = .center
        
        //換歌手文字
        singerNameLabel.text = singer[index]
        singerNameLabel.frame = CGRect(x: 0, y: 0, width: fullScreenSize.width * 0.6, height: 50)
        singerNameLabel.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.57)
        singerNameLabel.textAlignment = .center
        
        
        //###########總時間標籤
        //總長度
        let duration = Int(playerItem.asset.duration.seconds ?? 0)
        //把長度變成＿分＿秒
        let musicLength = (duration.quotientAndRemainder(dividingBy: 60))
        //加入右側總時間文字標籤
        endLabel.text = String(("\(musicLength.quotient):\(musicLength.remainder)"))
        
        
        //使用Timer並呼叫updateTime函式，把左邊開始時間一直紀錄
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.updateTime()
        })
        
        //音樂bar最長等於時間長度
        runTimerSlider.maximumValue = Float(duration)
    }
    
    
    //顯示追蹤時間
    func updateTime() {
        //###########累計時間標籤
        //取得目前秒數Int(player.currentTime().seconds)
        //把  目前秒數換為＿分＿秒
        let nowTime = Int(player.currentTime().seconds).quotientAndRemainder(dividingBy: 60)
        //打印出目前時間
        print("這是目前時間\(nowTime)")
        //加入左側總時間文字標籤
        startLabel.text = String("\(nowTime.quotient):\(nowTime.remainder)")
        
        //音樂進度條跟著時間走
        runTimerSlider.value = Float(player.currentTime().seconds)
    }
    
    
    //下一首
    @IBAction func playNext(_ sender: Any) {
        index = (index+1) % songs.count
        playMusic()
    }
    
    //上一首
    @IBAction func playback(_ sender: Any) {
        //0 + 3-1 % 3  等於2 % 3 = 2
        //2 + 3-1 % 3  等於4 % 3 = 1
        //1 + 3-1 % 3  等於3 % 3 = 0
        //一直循環
        index = (index + songs.count-1) % songs.count
        playMusic()
    }
    
    //切換 暫停 或是 開始
    @IBAction func playPause(_ sender: Any) {
        
        //用switch來判斷
        switch player.timeControlStatus {
        
        case .playing : //如果有.playing就改成暫停
                player.pause()
                print(player.timeControlStatus)
        case .paused :    //一開始沒播放音樂，點擊才開始播放
            player.play()
        
        default:        //預設是播放
                playMusic() //呼叫playMusic函式，播音樂
        }
    }
    
    //隨機播放
    @IBAction func playRandom(_ sender: Any) {
        index = Int.random(in: 0...2)
        playMusic()
    }
    
    //單曲重播 目前是點擊跳重新播放，尚未完成單曲一直循環
    @IBAction func playRepeatOneTime(_ sender: Any) {
        //let check = 0
        let temp = index
        index = temp
        playMusic()
        
//        while check == 0 {
//            playMusic()
//        }
    }
    
    
    //聲音控制
    @IBAction func changeVolumeSlider(_ sender: UISlider) {
        player.volume = sender.value
        //print(sender.value)   //sender.value介於0～1之間
    }
    
    
    //歌曲時間控制
    //調整歌曲播放的區段(SEEK)
    //利用 seek 控制歌曲播放的區段。
    //從第 runTimerSlider.value 秒開始播放。
    @IBAction func changeTimeProgressSlider(_ sender: UISlider) {
        let time = CMTime(value: Int64(runTimerSlider.value), timescale: 1)
        player.seek(to: time)
    }
}
