import UIKit

extension UIViewController {
    func wrappedInNavigation() -> UINavigationController {
        let navigationController = UINavigationController(navigationBarClass: ViewController.NavigationBar.self,
                                                          toolbarClass: nil)
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.pushViewController(self, animated: false)
        return navigationController
    }
}
