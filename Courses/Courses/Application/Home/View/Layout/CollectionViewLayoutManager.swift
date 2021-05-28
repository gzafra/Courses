import UIKit

protocol HomeCollectionViewLayoutManagerDelegate: class {
    func didChangeToPage(_ page: Int)
    func safeAreaInsets() -> UIEdgeInsets
}

protocol CollectionViewLayoutManager {
    var layout: UICollectionViewCompositionalLayout { get }
    var delegate: HomeCollectionViewLayoutManagerDelegate? { get set }
}

class HomeCollectionViewLayoutManager: CollectionViewLayoutManager {
    private enum Constants {
        enum FeaturedSection {
            static let fractionalHeight: CGFloat = 0.5
        }

        enum BottomSection {
            static let fractionalHeight: CGFloat = 0.35
            static let fractionalWidth: CGFloat = 0.7
            static let insets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        }

        static let interSectionsSpacing: CGFloat = 0
    }

    lazy var layout: UICollectionViewCompositionalLayout = {
        return setupLayout()
    }()
    weak var delegate: HomeCollectionViewLayoutManagerDelegate?

    private func setupLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            let section = HomeViewController.Sections(rawValue: sectionIndex)
            switch section {
            case .featured:
                return self.createFeaturedSection()
            default:
                return self.createBottomSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.interSectionsSpacing
        layout.configuration = config
        return layout
    }

    private func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let safeAreaInset = delegate?.safeAreaInsets() ?? .zero
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: -safeAreaInset.top, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(Constants.FeaturedSection.fractionalHeight))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        layoutSection.boundarySupplementaryItems = [createPagingFooter()]
        layoutSection.visibleItemsInvalidationHandler = { [weak self] items, contentOffset, environment in
            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            self?.delegate?.didChangeToPage(currentPage)
        }
        return layoutSection
    }

    private func createBottomSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = Constants.BottomSection.insets

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constants.BottomSection.fractionalWidth),
            heightDimension: .fractionalHeight(Constants.BottomSection.fractionalHeight))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(40))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }

    private func createPagingFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.50),
            heightDimension: .estimated(40))
        let layoutSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom, absoluteOffset: CGPoint(x: 0, y: -40))
        return layoutSectionFooter
    }
}
