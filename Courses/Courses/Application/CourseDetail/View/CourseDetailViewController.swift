import UIKit
import SnapKit

class CourseDetailViewController: UIViewController {

    private enum Constants {
        enum Layout {
            static let previewHeight: CGFloat = 220
            static let margins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            static let itemSpacing: CGFloat = 9
            static let groupSpacing: CGFloat = 20
        }
    }

    // MARK: IBOutlets
    private let playerView: PlayerView = {
        let view = PlayerView()
        return view
    }()

    private let scrollView = UIScrollView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Constants.Layout.itemSpacing
        stackView.distribution = .fill
        stackView.layoutMargins = Constants.Layout.margins
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = Colors.primaryFont.color
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = Colors.secondaryFont.color
        label.numberOfLines = 0
        return label
    }()

    private let teacherProfile = TeacherProfileView()

    private let hairline: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.hairline.color
        view.alpha = 0.3
        return view
    }()

    private let detailItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.itemSpacing
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: Private
    private let presenter: CourseDetailPresenter

    init(presenter: CourseDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        setup()
        configureNavigationBar()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.stop()
    }

    private func setup() {
        view.backgroundColor = .white
        setupStackViewContent()

        view.addSubview(playerView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        playerView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.right.equalTo(view)
            make.height.equalTo(Constants.Layout.previewHeight)
        }

        scrollView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(playerView.snp.bottom)
            make.width.equalTo(stackView)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
        }

        hairline.snp.makeConstraints { (make) in
            make.height.equalTo((1.0 / UIScreen.main.scale) * 2.0)
        }
    }

    private func setupStackViewContent() {
        [titleLabel, descriptionLabel, teacherProfile, hairline, detailItemsStackView].forEach { stackView.addArrangedSubview($0) }
    }

    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: Images.Icons.back.image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem  = backButton

        let shareItem = UIBarButtonItem(image: Images.Icons.share.image,
                                        style: .plain,
                                        target: self,
                                        action: #selector(shareButtonTapped))
        shareItem.tintColor = .black
        navigationItem.rightBarButtonItem = shareItem
    }

    @objc private func shareButtonTapped() {
        // TODO: Present share dialog
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CourseDetailViewController: CourseDetailView {
    func configure(with viewModel: CourseDetailViewModel) {
        playerView.setup(withPreviewUrl: viewModel.thumbnailUrl,
                         videoUrl: viewModel.previewUrl)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description

        teacherProfile.setup(withName: viewModel.teacherName,
                             location: viewModel.teacherLocation,
                             avatarUrl: viewModel.teacherAvatarUrl)

        detailItemsStackView.removeArrangedSubviews()
        viewModel.detailItems.forEach { viewModel in
            let courseItem = CourseItemView()
            courseItem.setup(with: viewModel)
            detailItemsStackView.addArrangedSubview(courseItem)
        }
    }

    func startVideo() {
        playerView.play()
    }
}
