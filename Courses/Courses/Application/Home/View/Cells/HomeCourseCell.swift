import UIKit
import Kingfisher

class HomeCourseCell: UICollectionViewCell {

    private enum Constants {
        enum Layout {
            static let insets = UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20)
            static let buttonHeight: CGFloat = 40
            static let buttonHeightMin: CGFloat = 20
            static let thumbnailHeight: CGFloat = 150
            static let courseInfoHeight: CGFloat = 60
            static let groupSpacing: CGFloat = 12
            static let itemSpacing: CGFloat = 6
            static let courseInfoMargins = UIEdgeInsets(top: groupSpacing, left: 20, bottom: groupSpacing, right: 20)
            static let cardCornerRadius: CGFloat = 5
        }

        enum Strings {
            static let buttonTitle = "Ver curso"
        }
    }

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.Layout.cardCornerRadius
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let courseInfoView: UIStackView = {
        let view = UIStackView()
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = Constants.Layout.itemSpacing
        view.layoutMargins = Constants.Layout.courseInfoMargins
        view.axis = .vertical
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Colors.primaryFont.color
        label.numberOfLines = 2
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = Colors.secondaryFont.color
        label.numberOfLines = 1
        return label
    }()

    private let hairline: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.hairline.color
        view.alpha = 0.3
        return view
    }()

    private lazy var navigationButton: CellStyleButton = {
        let button = CellStyleButton()
        button.title = Constants.Strings.buttonTitle
        button.addTarget(self, action: #selector(didTapNavigationButton), for: .touchUpInside)
        return button
    }()

    private var tapAction: CourseCellAction?
    private var identifier: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        setupShadow()
        setupCourseInfo()
        addSubview(containerView)
        containerView.addSubview(stackView)
        [thumbnailImageView, courseInfoView, hairline, navigationButton].forEach { stackView.addArrangedSubview($0) }

        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }

        thumbnailImageView.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.Layout.thumbnailHeight).priority(.low)
        }
        thumbnailImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        courseInfoView.snp.makeConstraints { (make) in
            //            make.height.greaterThanOrEqualTo(Constants.Layout.courseInfoHeight).priority(.low)
        }

        hairline.snp.makeConstraints { (make) in
            make.height.equalTo((1.0 / UIScreen.main.scale) * 2.0)
        }

        navigationButton.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.Layout.buttonHeight).priority(.low)
            make.height.greaterThanOrEqualTo(Constants.Layout.buttonHeightMin)
        }
    }

    private func setupCourseInfo() {
        [titleLabel, subtitleLabel, UIView()].forEach { courseInfoView.addArrangedSubview($0) }

//        titleLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(courseInfoView).inset(Constants.Layout.groupSpacing)
//            make.leading.equalTo(courseInfoView).offset(Constants.Layout.insets.left)
//            make.trailing.equalTo(courseInfoView).inset(Constants.Layout.insets.right)
//        }
//
//        subtitleLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(titleLabel.snp.bottom)//.offset(Constants.Layout.itemSpacing)
//            make.leading.equalTo(courseInfoView).offset(Constants.Layout.insets.left)
//            make.trailing.equalTo(courseInfoView).inset(Constants.Layout.insets.right)
//            make.bottom.greaterThanOrEqualTo(courseInfoView).inset(Constants.Layout.groupSpacing)
//        }
    }

    private func setupShadow() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5
    }

    @objc private func didTapNavigationButton() {
        tapAction?()
    }
}

extension HomeCourseCell: CourseCell {
    func configure(with course: CourseViewModel, action: @escaping CourseCellAction) {
        self.tapAction = action
        self.identifier = course.id
        titleLabel.text = course.title
        subtitleLabel.text = course.subtitle
        let processor = DownsamplingImageProcessor(size: CGSize(width: Constants.Layout.thumbnailHeight,
                                                                height: Constants.Layout.thumbnailHeight))
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(
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
