
import SwiftUI
import UIKit
import Lottie
import SnapKit

final class StartViewController: UIViewController, URLSessionDelegate {
    
    
    private lazy var bgColor: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var bgImage: UIView = {
        let img = UIView()
        img.backgroundColor = .black
        return img
    }()
    
    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let bundleIdentifier = Bundle.main.bundleIdentifier
    var idUserNumber = ""
    var pathIdentifier = ""
    
    var progressValue : Float = 0
    var animationView = Lottie.LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        animationView.animation = .named("lottieAnim")
        animationView.loopMode = .loop
        let horizontalPadding: CGFloat = 160.0
        
        let screenSize = UIScreen.main.bounds.size
        let animationWidth = screenSize.width - 2 * horizontalPadding
        
        animationView.frame = CGRect(x: horizontalPadding, y: -10, width: animationWidth, height: screenSize.height)
        animationView.contentMode = .scaleAspectFit
        view.addSubview(bgColor)
        view.addSubview(bgImage)
        view.addSubview(animationView)
        bgColor.snp.makeConstraints{ $0.edges.equalToSuperview() }
        bgImage.snp.makeConstraints{ $0.edges.equalToSuperview() }
        animationView.play()
    }
    
    override var shouldAutorotate: Bool { true }
    
    override var prefersStatusBarHidden: Bool { true }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }
    
    func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.pathIdentifier == "" ? self.sendToRequest() : ()
        }
    }
    
    func Apps() {
        let preland = Helper()
        preland.sourceData = pathIdentifier
        addChild(preland)
        
        preland.view.alpha = 0
        view.addSubview(preland.view)
        preland.view.snp.makeConstraints {  $0.edges.equalToSuperview() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            AppUtility.lockOrientation(.all)
            self.animationView.isHidden = true
            self.bgImage.alpha = 0
            self.bgColor.alpha = 1
            preland.view.alpha = 1
            self.animationView.stop()
        }
    }
    
    func MainView() {
        let vc = UIHostingController(rootView: MainTabView())
        view.window?.rootViewController = vc
    }
    
    func sendToRequest() {
        let url = URL(string: "https://OneHub-FriendsBattle.site/starting")
        let dictionariData: [String: Any?] = ["facebook-deeplink" : appDelegate?.deepLinkParameterFB, "push-token" : appDelegate?.tokenPushNotification, "appsflyer" : appDelegate?.oldAndNotWorkingNames, "deep_link_sub2" : appDelegate?.subject2, "deepLinkStr": appDelegate?.oneLinkDeepLink, "timezone-geo": appDelegate?.geographicalNameTimeZone, "timezome-gmt" : appDelegate?.abbreviationTimeZone, "apps-flyer-id": appDelegate!.uniqueIdentifierAppsFlyer, "attribution-data" : appDelegate?.dataAttribution, "deep_link_sub1" : appDelegate?.subject1, "deep_link_sub3" : appDelegate?.subject3, "deep_link_sub4" : appDelegate?.subject4, "deep_link_sub5" : appDelegate?.subject5]
        
        print(dictionariData)
        var request = URLRequest(url: url!)
        request.httpBody = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpMethod = "POST"
        request.addValue(bundleIdentifier!, forHTTPHeaderField: "PackageName")
        request.addValue(appDelegate!.identifierAdvertising, forHTTPHeaderField: "GID")
        request.addValue(appDelegate!.uniqueIdentifierAppsFlyer, forHTTPHeaderField: "ID")
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { self.MainView() }
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let result = responseJSON["result"] as? String else { return }
                self.pathIdentifier = result
                
                let user = responseJSON["userID"]
                guard let strUser = user else { return }
                self.idUserNumber = "\(strUser)"
                print(responseJSON)
            }
            if let response = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    switch response.statusCode {
                    case 200:
                        self.MainView()
                    case 302 where self.pathIdentifier != "":
                        self.Apps()
                    default: break
                    }
                }
            }
            return
        }
        task.resume()
    }
}
