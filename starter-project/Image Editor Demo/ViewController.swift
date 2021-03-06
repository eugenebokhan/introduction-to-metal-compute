import UIKit
import SnapKit
import SettingsViewController

class ViewController: UIViewController {

    // MARK: - Properties
    
    private let picker = UIImagePickerController()
    private let settings = SettingsTableViewController()
    private let imageView: UIImageView

    // MARK: - Init

    init() {
        self.imageView = .init()
        super.init(nibName: nil, bundle: nil)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.picker.delegate = self
        self.view.backgroundColor = .systemBackground
        
        self.title = "image editor demo"
        self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .camera,
                                                      target: self,
                                                      action: #selector(self.pickImage))
        self.navigationItem.rightBarButtonItems = [
            .init(barButtonSystemItem: .action,
                  target: self,
                  action: #selector(self.share))
        ]

        // settings

        self.settings.settings = [
            FloatSetting(name: "Temperature",
                         defaultValue: .zero,
                         min: -1,
                         max: 1) { _ in },
            FloatSetting(name: "Tint",
                         defaultValue: .zero,
                         min: -1,
                         max: 1) { _ in }
        ]
        
        guard let settingsView = self.settings.view
        else { return }
        self.settings.tableView.isScrollEnabled = false
        self.addChild(self.settings)
        self.view.addSubview(settingsView)
        settingsView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(self.settings.contentHeight)
        }
        
        // image view

        self.imageView.contentMode = .scaleAspectFit
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true
        self.view.addSubview(self.imageView)
        self.imageView.backgroundColor = .tertiarySystemFill
        self.imageView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(settingsView.snp.top).inset(-20)
        }
    }

    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Actions

    @objc
    private func share() {
        guard let image = self.imageView.image
        else { return }

        let vc = UIActivityViewController(activityItems: [image],
                                          applicationActivities: nil)
        self.present(vc, animated: true)
    }

    @objc
    private func pickImage() {
        let alert = UIAlertController(title: "Select source",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Camera", style: .default) { _ in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true)
        })
        alert.addAction(.init(title: "Library", style: .default) { _ in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true)
        })
        alert.addAction(.init(title: "Cancel",
                              style: .destructive) { _ in })
        self.present(alert, animated: true)
    }

    func handlePickedImage(image: UIImage) {
        guard let cgImage = image.cgImage
        else { return }
        self.imageView.image = .init(cgImage: cgImage)
    }
}
