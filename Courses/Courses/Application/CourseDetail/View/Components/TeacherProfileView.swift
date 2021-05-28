import UIKit
import Kingfisher

class TeacherProfileView: UIView {

    private enum Constants {
        static let avatarSize: CGFloat = 44
        static let insets = UIEdgeInsets(top: 6, left: 0, bottom: 20, right: 0)
        static let itemVerticalSpacing: CGFloat = 12
        static let itemHorizontalSpacing: CGFloat = 9
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.primaryFont.color
        label.numberOfLines = 2
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = Colors.secondaryFont.color
        label.numberOfLines = 1
        return label
    }()

    private let avatarIcon: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.avatarSize / 2
        view.clipsToBounds = true
        return view
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(avatarIcon)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self).inset(Constants.insets.left)
            make.top.equalTo(self).inset(Constants.insets.top)
        }

        locationLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self).inset(Constants.insets.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.itemVerticalSpacing)
            make.bottom.equalTo(self).inset(Constants.insets.bottom)
        }

        avatarIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(Constants.insets.right)
            make.size.equalTo(Constants.avatarSize)
        }
    }

    func setup(withName name: String, location: String, avatarUrl: URL?) {
        nameLabel.text = name
        locationLabel.text = location
        avatarIcon.kf.setImage(with: avatarUrl)
    }
}
