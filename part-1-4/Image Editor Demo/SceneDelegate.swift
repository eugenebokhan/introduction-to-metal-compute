import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene),
              let device = MTLCreateSystemDefaultDevice(),
              let vc = try? ViewController(device: device)
        else { return }

        self.window = .init(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = vc.wrappedInNavigation()
        self.window?.makeKeyAndVisible()
    }
    
}

