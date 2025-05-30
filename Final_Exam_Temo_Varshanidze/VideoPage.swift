import UIKit
import AVKit

class LaunchVideoViewController: UIViewController {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        playIntroVideo()
    }

    private func playIntroVideo() {
        guard let path = Bundle.main.path(forResource: "BeforeApp", ofType: "mp4") else {
            print("Video not found")
            goToMainApp()
            return
        }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspectFill

        if let layer = playerLayer {
            view.layer.addSublayer(layer)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidFinish),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)

        player?.play()
    }

    @objc private func videoDidFinish() {
        goToMainApp()
    }

    private func goToMainApp() {
        // გამოიყენე შენი მთავარი VC აქ
        let homeVC = TabBarVC()
        homeVC.modalPresentationStyle = .fullScreen
        //navigationController?.pushViewController(homeVC, animated: true)
        present(homeVC, animated: true, completion: nil)
    }
}
