import UIKit

class CourseItemView: UIView {

    private enum Constants {
        static let iconSize: CGFloat = 16
        static let margins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        static let itemSpacing: CGFloat = 6
        static let badgeHeight: CGFloat = 16
    }

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.spacing = Constants.itemSpacing
        view.layoutMargins = Constants.margins
        view.alignment = .center
        view.distribution = .fill
        return view
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .gray
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        return label
    }()

    private lazy var badge: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.badgeHeight / 2
        view.clipsToBounds = true
        view.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6))
        }
        return view
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(stackView)
        [iconView, titleLabel, badge, UIView()].forEach { stackView.addArrangedSubview($0) }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.iconSize)
        }

        badge.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.badgeHeight)
        }
        badge.isHidden = true
    }

    func setup(with viewModel: DetailItemViewModel) {
        iconView.image = viewModel.icon
        titleLabel.text = viewModel.title

        if let badgeModel = viewModel.badge {
            badge.isHidden = false
            badge.backgroundColor = badgeModel.color
            badgeLabel.text = badgeModel.title
        } else {
            badge.isHidden = true
        }
    }
}
