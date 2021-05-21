import UIKit

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            (info[.originalImage] as? UIImage).flatMap {
                self.handlePickedImage(image: $0.fixOrientation())
            }
        }
    }

}
