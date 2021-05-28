import UIKit
import AVFoundation
import AVKit
import Kingfisher

class PlayerView: UIView {

    enum State {
        case stopped
        case playing
        case paused
    }

    private enum Constants {
        enum Layout {
            static let controlIconSize: CGFloat = 44
            static let spacing: CGFloat = 20
        }
    }

    // MARK: - Properties
    private var state: State = .stopped
    private let playerViewController = AVPlayerViewController()
    private var showingControls = false

    // MARK: - IBOutlets
    private let playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerView = UIView()

    private let preview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var prevButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(Images.Icons.replay.image, for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(fastRewind), for: .touchUpInside)
        return button
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(Images.Icons.forward.image, for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(fastForward), for: .touchUpInside)
        return button
    }()

    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(Images.Icons.play.image, for: .normal)
        button.setImage(Images.Icons.pause.image, for: .selected)
        button.tintColor = UIColor.white.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(playButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(playerView)
        addSubview(preview)
        addSubview(playButton)
        addSubview(nextButton)
        addSubview(prevButton)

        playerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        preview.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        playButton.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.Layout.controlIconSize)
            make.center.equalTo(self)
        }

        prevButton.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.Layout.controlIconSize)
            make.centerY.equalTo(self)
            make.right.equalTo(playButton.snp.left).inset(-Constants.Layout.spacing)
        }

        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.Layout.controlIconSize)
            make.centerY.equalTo(self)
            make.left.equalTo(playButton.snp.right).offset(Constants.Layout.spacing)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    // MARK: - Private

    private func setPreview(_ previewUrl: URL?) {
        preview.kf.indicatorType = .activity
        preview.kf.setImage(
            with: previewUrl,
            placeholder: nil,
            options: [
                .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
        ])
    }

    private func set(state: State) {
        switch state {
        case .stopped:
            [playerView, nextButton, prevButton].forEach { $0.isHidden = true }
            [playButton, preview].forEach { $0.isHidden = false }
        case .playing:
            playerView.isHidden = false
            [playButton, nextButton, prevButton, preview].forEach { $0.isHidden = true }
        case .paused:
            [nextButton, prevButton, preview].forEach { $0.isHidden = true }
            [playButton, playerView].forEach { $0.isHidden = false }
        }
    }

    // MARK: - Public

    func setup(withPreviewUrl previewUrl: URL?, videoUrl: URL?) {
        setPreview(previewUrl)
        guard let videoUrl = videoUrl else { return }
        player = AVPlayer(url: videoUrl)

        playerLayer.player = player
        playerView.layer.addSublayer(playerLayer)
        set(state: .stopped)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPlayer))
        addGestureRecognizer(tapRecognizer)
    }

    func play() {
        player?.play()
        playButton.isSelected = true
        set(state: .playing)
    }

    func pause() {
        player?.pause()
        playButton.isSelected = false
        set(state: .paused)
    }

    func stop() {
        player?.pause()
        playButton.isSelected = false
        player = nil
    }

    // MARK: - Actions

    @objc private func didTapPlayer() {
        [playButton, nextButton, prevButton].forEach { $0.isHidden = !$0.isHidden }
    }

    @objc private func playButtonTapped(sender: UIButton) {
        if player?.timeControlStatus == .playing {
            pause()
        } else {
            play()
        }
    }

    @objc private func fastForward() {
        guard let player = player else { return }
        player.seek(to: CMTime(seconds: player.currentTime().seconds + 10, preferredTimescale: 1000))
    }

    @objc private func fastRewind() {
        guard let player = player else { return }
        player.seek(to: CMTime(seconds: player.currentTime().seconds - 10, preferredTimescale: 1000))
    }
}
