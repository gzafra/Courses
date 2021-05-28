import Foundation

struct HomeViewModel {
    private let sections: [[CourseViewModel]]

    init(sections: [[CourseViewModel]]) {
        self.sections = sections
    }
    
    var numberOfSections: Int { sections.count }
    
    func numberOfItems(inSection section: Int) -> Int {
        sections[section].count
    }

    func course(at indexPath: IndexPath) -> CourseViewModel {
        sections[indexPath.section][indexPath.row]
    }
}
