import UIKit.UIImage
import VideoToolbox
import Vision

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }

        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break

        default:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break

        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break

        default:
            break
        }

        let ctx = CGContext(data: nil,
                            width: Int(self.size.width),
                            height: Int(self.size.height),
                            bitsPerComponent: self.cgImage!.bitsPerComponent,
                            bytesPerRow: 0,
                            space: self.cgImage!.colorSpace!,
                            bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)

        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!,
                      in: CGRect(x: .zero,
                                 y: .zero,
                                 width: CGFloat(self.size.height),
                                 height: CGFloat(self.size.width)))
            break

        default:
            ctx?.draw(self.cgImage!,
                      in: CGRect(x: .zero,
                                 y: .zero,
                                 width: CGFloat(self.size.width),
                                 height: CGFloat(self.size.height)))
            break
        }

        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)

        return img
    }
}

extension VNImageRequestHandler {
    convenience init?(uiImage: UIImage, options: [VNImageOption: Any] = [:]) {
        if let cgImage = uiImage.cgImage {
            self.init(cgImage: cgImage, options: options)
        } else if let ciImage = uiImage.ciImage {
            self.init(ciImage: ciImage, options: options)
        } else {
            return nil
        }
    }
}
