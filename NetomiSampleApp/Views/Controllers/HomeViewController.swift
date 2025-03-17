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
        Task {
            NetomiChat.shared.launch()
        }
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
