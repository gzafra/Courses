import UIKit

extension UIAlertController {
    static func show(title: String?, message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(OKAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
