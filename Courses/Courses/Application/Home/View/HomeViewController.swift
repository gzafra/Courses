import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private enum Constants {
        enum Strings {
            static let bottomSectionTitle = "Popular"
        }

        enum Layout {
            static let brandButtonSize: CGFloat = 50
            static let searchButtonSize: CGFloat = 80
            static let topMargin: CGFloat = 24
            static let leftMargin: CGFloat = 20
            static let rightMargin: CGFloat = 4
        }
    }

    enum Sections: Int {
        case featured
        case carousel
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Outlets
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: collectionViewLayoutManager.layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    lazy var brandButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(Images.Icons.brand.image, for: .normal)
        return button
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.Icons.search.image, for: .normal)
        return button
    }()

    let loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.tintColor = .black
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: Private
    private let presenter: HomePresenter
    private var viewModel: HomeViewModel?
    private var collectionViewLayoutManager: CollectionViewLayoutManager

    init(presenter: HomePresenter,
         collectionViewLayoutManager: CollectionViewLayoutManager) {
        self.presenter = presenter
        self.collectionViewLayoutManager = collectionViewLayoutManager
        super.init(nibName: nil, bundle: nil)
        self.collectionViewLayoutManager.delegate = self
        presenter.view = self
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func setup() {
        setupTopCollectionView()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(brandButton)
        view.addSubview(searchButton)
        view.addSubview(loader)

        brandButton.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.Layout.brandButtonSize)
            make.left.equalTo(view).offset(Constants.Layout.leftMargin)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.Layout.topMargin)
        }

        searchButton.snp.makeConstraints { (make) in
            make.size.equalTo(Constants.Layout.searchButtonSize)
            make.right.equalTo(view).inset(Constants.Layout.rightMargin)
            make.centerY.equalTo(brandButton)
        }

        loader.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.size.equalTo(100)
        }
    }

    private func setupTopCollectionView() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeaturedCourseCell.self, forCellWithReuseIdentifier: FeaturedCourseCell.reuseIdentifier)
        collectionView.register(HomeCourseCell.self, forCellWithReuseIdentifier: HomeCourseCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(FooterPagingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterPagingView.reuseIdentifier)
    }

    private func configureNavigationBar() {
        let navigationBarAppearence = UINavigationBarAppearance()
        navigationBarAppearence.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearence
        navigationController?.navigationBar.standardAppearance = navigationBarAppearence
        navigationController?.navigationBar.compactAppearance = navigationBarAppearence
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension HomeViewController: HomeView {
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }

    func displayError(message: String) {
        UIAlertController.show(title: nil, message: message, in: self)
    }

    func setIsLoading(loading: Bool) {
        loading ? loader.startAnimating() : loader.stopAnimating()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(inSection: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let course = viewModel?.course(at: indexPath) else { return UICollectionViewCell() }
        let section = HomeViewController.Sections(rawValue: indexPath.section)
        switch section {
        case .featured:
            return configure(FeaturedCourseCell.self, with: course, for: indexPath)
        default:
            return configure(HomeCourseCell.self, with: course, for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = HomeViewController.Sections(rawValue: indexPath.section)

        switch section {
        case .featured:
            return configurePagingFooter(for: indexPath)
        default:
            return configureHeader(for: indexPath)
        }
    }

    private func configurePagingFooter(for indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterPagingView.reuseIdentifier,
            for: indexPath
        ) as! FooterPagingView
        return footer
    }

    private func configureHeader(for indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath
        ) as! HeaderView
        header.setup(with: Constants.Strings.bottomSectionTitle)
        return header
    }

    private func configure<T: CourseCell>(_ cellType: T.Type, with viewModel: CourseViewModel, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }

        cell.configure(with: viewModel, action: { [weak self] in
            guard let self = self, let course = self.viewModel?.course(at: indexPath) else { return}
            self.presenter.didTapCourse(with: course.id)
        })
        return cell
    }
}

extension HomeViewController: HomeCollectionViewLayoutManagerDelegate {
    
    func didChangeToPage(_ page: Int) {
        guard let totalFeaturedItems = viewModel?.numberOfItems(inSection: 0),
            let footer = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(row: 0, section: 0)) as? FooterPagingView else { return }
        footer.setup(page, totalPages: totalFeaturedItems)
    }

    func safeAreaInsets() -> UIEdgeInsets {
        view.safeAreaInsets
    }
}
