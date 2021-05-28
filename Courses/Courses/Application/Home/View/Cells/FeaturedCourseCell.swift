import UIKit
import Kingfisher

class FeaturedCourseCell: UICollectionViewCell {

    private enum Constants {
        enum Layout {
            static let insets = UIEdgeInsets(top: 0, left: 24, bottom: 50, right: 24)
            static let buttonWidth: CGFloat = 120
            static let buttonHeight: CGFloat = 40
            static let labelToButtonSpace: CGFloat = 20
        }

        enum Strings {
            static let buttonTitle = "Watch"
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var watchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Strings.buttonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(didTapWatchButton), for: .touchUpInside)
        return button
    }()

    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.contentsRect = CGRect(x: 0.25, y: 0, width: 0.75, height: 1.0)
        return view
    }()

    private var tapAction: CourseCellAction?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(watchButton)

        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.leading.greaterThanOrEqualTo(contentView).offset(Constants.Layout.insets.left)
            make.trailing.greaterThanOrEqualTo(contentView).inset(Constants.Layout.insets.right)
        }

        watchButton.snp.makeConstraints { (make) in
            make.width.equalTo(Constants.Layout.buttonWidth)
            make.height.equalTo(Constants.Layout.buttonHeight)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).inset(Constants.Layout.insets.bottom)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.Layout.labelToButtonSpace)
        }
    }

    @objc private func didTapWatchButton() {
        tapAction?()
    }
}

extension FeaturedCourseCell: CourseCell {
    func configure(with course: CourseViewModel, action: @escaping CourseCellAction) {
        self.tapAction = action
        titleLabel.text = course.title
        let downsampleProcessor = DownsamplingImageProcessor(size: CGSize(width: contentView.bounds.size.width,
                                                                          height: contentView.bounds.size.height))
        let cropProcessor = CroppingImageProcessor(size: contentView.bounds.size, anchor: CGPoint(x: 0.75, y: 0))
        let processor = downsampleProcessor |> cropProcessor
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(
            with: course.thumbnailUrl,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
        ])
    }
}
