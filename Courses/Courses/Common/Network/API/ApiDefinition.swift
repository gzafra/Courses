import Foundation

struct ApiDefinition {
    enum Endpoints {
        case home

        var path: String {
            switch self {
            case .home:
                return "/challenge/home.json"
            }
        }
    }

    let endpoint: Endpoints
    let baseURL: String = "http://placeHolderURL.com"
}
