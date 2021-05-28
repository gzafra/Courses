import UIKit

class HeaderView: UICollectionReusableView {

    static let reuseIdentifier = "UICollectionViewCell.HeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setup() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        }
    }

    func setup(with title: String) {
        titleLabel.text = title
    }
}
