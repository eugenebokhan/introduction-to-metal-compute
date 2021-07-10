import UIKit

extension ViewController {

    class NavigationBar: UINavigationBar {

        // MARK: Lifecycle

        override init(frame: CGRect) {
            super.init(frame: .zero)
            self.setupUI()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setupUI()
        }

        // MARK: Private

        private func setupUI() {
            self.barTintColor = .systemBackground
            self.tintColor = .systemBlue
            self.shadowImage = UIImage()
            self.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17, weight: .heavy),
                                        .foregroundColor: UIColor.label]
            self.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 32, weight: .heavy),
                                             .foregroundColor: UIColor.label]
        }
        
    }

}
