//
//  HomeViewController.swift
//  NetomiSampleApp
//
//  Created by Akash Gupta on 14/11/24.
//

import UIKit
import Netomi

class HomeViewController: UIViewController {
    
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var drawerNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var drawerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var selectedBotNameLbl: UILabel!
    @IBOutlet weak var chatImg: UIImageView!
    @IBOutlet weak var chatBtn: UIButton!
    
    private var isDrawerOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupInitialState()
        setupBot()
    }
    
    private func setupInitialState() {
        nameLbl.text = Defaults.name
        drawerNameLbl.text = Defaults.name
        drawerLeadingConstraint.constant = -300
        overlayView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeDrawer))
        tapGesture.delegate = self
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    private func setupBot() {
        let botRefId = "Replace your botRefId here"
        let env: NCWEnvironment = .USProd /// Change it according to your bot environment
        NetomiChat.shared.initialize(botRefId: botRefId, env: env)
        // After initializing the SDK you should call the modifier functions if you want to set properties explicitly.
    }

    @IBAction func toggleDrawer(_ sender: UIButton) {
        if isDrawerOpen {
            closeDrawer()
        } else {
            openDrawer()
        }
    }
    
    @objc private func openDrawer() {
        isDrawerOpen = true
        overlayView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.drawerLeadingConstraint.constant = 0
            self.overlayView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func closeDrawer() {
        isDrawerOpen = false
        
        // Animate drawer closing
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.drawerLeadingConstraint.constant = -300
            self.overlayView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.overlayView.isHidden = true
        })
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        closeDrawer()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        Defaults.removeUnPreservedData()
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            let navigationController = UINavigationController(rootViewController: loginVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func tapChatBtn(_ sender: Any) {
        let jwtToken: String? = nil /// replace it with you jwt token
        NetomiChat.shared.launch(jwt: jwtToken, errorHandler: { [weak self] error in
            self?.showAlert(title: "Status Code \(error.statusCode ?? -1)" , message: error.statusMessage ?? "")
        })
        /// Or if you want to luanch the SDK with a specific query
        /*
        let searchQuery: String = "Your search query" /// replace it with you search query
        NetomiChat.shared.launchWithQuery(searchQuery, jwt: jwtToken, errorHandler: { [weak self] error in
            self?.showAlert(title: "Status Code \(error.statusCode ?? -1)" , message: error.statusMessage ?? "")
        })
         */
    }
}

extension HomeViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: drawerView) {
            return false
        }
        return true
    }
    
}

extension HomeViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: { _ in
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

/// Below extension contains the Netomi SDK's functions that are intended to modify/set the interface & properties. Also, it should be called before "launch" or "launchWithQuery" functions.
extension HomeViewController {
    
    /// To send custom parameters for attibutes
    func sendCustomParameter() {
        NetomiChat.shared.sendCustomParameter(name: "key", value: "Value")
    }
    
    /// To set/reset custom parameters for attibutes
    func setCustomParameter() {
        var dict: [String: String] = [:]
        dict["key"] = "value"
        dict["key1"] = "value1"
        NetomiChat.shared.setCustomParameter(dict)
    }
    
    /// To send external headers in the APIs
    func updateApiHeaderConfiguration() {
        var headers: [String: String] = [:]
        headers["header"] = "value"
        headers["header1"] = "value1"
        NetomiChat.shared.updateApiHeaderConfiguration(headers: headers)
    }
    
    /// To receive the notification related to SDK
    func setFCMToken() {
        let token: String = "" ///replace it with your push FCM token for notification
        NetomiChat.shared.setFCMToken(token)
    }
    
    /// This public function is used to update header configuration of the chat SDK.
    func updateHeaderConfiguration() {
        var config: NCWHeaderConfiguration = NCWHeaderConfiguration()
        config.backgroundColor = .red
        config.isGradientAppied = true
        config.isBackPressPopupEnabed = true
        config.navigationIcon = UIImage.logo
        /// and so on....
        NetomiChat.shared.updateHeaderConfiguration(config: config)
    }
    
    /// This public function is used to update footer configuration of the chat SDK.
    func updateFooterConfiguration() {
        var config: NCWFooterConfiguration = NCWFooterConfiguration()
        config.backgroundColor = .red
        config.inputBoxTextColor = .black
        config.isFooterHidden = false
        config.isNetomiBrandingEnabled = true
        /// and so on....
        NetomiChat.shared.updateFooterConfiguration(config: config)
    }
    
    /// This public function is used to update bot configuration of the chat SDK.
    func updateBotConfiguration() {
        var config: NCWBotConfiguration = NCWBotConfiguration()
        config.backgroundColor = .lightGray
        config.isFeedbackEnabled = true
        config.quickReplyBackgroundColor = .lightGray
        config.textColor = .black
        /// and so on....
        NetomiChat.shared.updateBotConfiguration(config: config)
    }
    
    /// This public function is used to update user configuration of the chat SDK.
    func updateUserConfiguration() {
        var config: NCWUserConfiguration = NCWUserConfiguration()
        config.backgroundColor = .darkGray
        config.retryColor = .red
        config.quickReplyBackgroundColor = .darkGray
        config.textColor = .white
        /// and so on....
        NetomiChat.shared.updateUserConfiguration(config: config)
    }
    
    /// This public function is used to update bubble configuration of the chat SDK.
    func updateBubbleConfiguration() {
        var config: NCWBubbleConfiguration = NCWBubbleConfiguration()
        config.borderRadius = 20
        config.timeStampColor = .gray
        NetomiChat.shared.updateBubbleConfiguration(config: config)
    }
    
    /// This public function is used to update chat window configuration of the chat SDK.
    func updateChatWindowConfiguration() {
        var config: NCWChatWindowConfiguration = NCWChatWindowConfiguration()
        config.chatWindowBackgroundColor = .white
        NetomiChat.shared.updateChatWindowConfiguration(config: config)
    }
    
    /// This public function is used to update other configuration of the chat SDK.
    func updateOtherConfiguration() {
        var config: NCWOtherConfiguration = NCWOtherConfiguration()
        config.backgroundColor = .white
        config.titleColor = .black
        config.descriptionColor = .black
        /// and so on....
        NetomiChat.shared.updateOtherConfiguration(config: config)
    }
}
