import UIKit

class CellStyleButton: UIButton {

    private enum Constants {
        static let iconSize: CGFloat = 16
        static let insets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
    }

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let disclosureIcon: UIImageView = {
        let view = UIImageView()
        view.image = Images.Icons.chevron.image
        view.tintColor = .gray
        return view
    }()

    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(label)
        addSubview(disclosureIcon)

        disclosureIcon.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.iconSize)
            make.right.equalTo(self).inset(Constants.insets.right)
            make.centerY.equalTo(self.snp.centerY)
        }

        label.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(Constants.insets.left)
            make.centerY.equalTo(self.snp.centerY)
            make.top.greaterThanOrEqualTo(self.snp.top).offset(Constants.insets.top)
            make.bottom.greaterThanOrEqualTo(self.snp.bottom).inset(Constants.insets.bottom)
        }
    }
}
