import UIKit

class FooterPagingView: UICollectionReusableView {

    static let reuseIdentifier = "FooterPagingView.HeaderView"

    private var pageControl: UIPageControl = {
        let control = UIPageControl(frame: .zero)
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setup() {
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
        }
        layer.zPosition = 20
    }

    func setup(_ currentPage: Int, totalPages: Int) {
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = currentPage
    }
}
