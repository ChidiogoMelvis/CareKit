//
//  HomeViewController.swift
//  CareKit
//
//  Created by Mac on 07/05/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    let sidebarWidth: CGFloat = 250
    var sidebarShowing = false
    var sidebarViewController = SideBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        let sidebarButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(toggleSidebar))
        sidebarButton.tintColor = .black
        navigationItem.leftBarButtonItem = sidebarButton
    }
    
    @objc func toggleSidebar() {
        if sidebarShowing {
            hideSidebar()
        } else {
            showSidebar()
        }
    }
    
    func showSidebar() {
        //MARK: -  Create a sidebar view controller and add it as a child view controller
        sidebarViewController = SideBarViewController()
        addChild(sidebarViewController)
        view.addSubview(sidebarViewController.view)
        
        //MARK: - Position the sidebar off screen
        sidebarViewController.view.frame = CGRect(x: -sidebarWidth, y: 0, width: sidebarWidth, height: view.frame.height)
        
        //MARK: - Animate the sidebar onto the screen
        UIView.animate(withDuration: 0.3) {
            self.sidebarViewController.view.frame = CGRect(x: 0, y: 0, width: self.sidebarWidth, height: self.view.frame.height)
        }
        
        sidebarShowing = true
    }
    
    func hideSidebar() {
        //MARK: - Animate the sidebar off screen
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarViewController.view.frame = CGRect(x: CGFloat(-self.sidebarWidth), y: 0, width: self.sidebarWidth, height: self.view.frame.height)
        }) { (completed) in
            //MARK: - Remove the sidebar view controller from the parent view controller
            self.sidebarViewController.view.removeFromSuperview()
            self.sidebarViewController.removeFromParent()
            //MARK: - self.sidebarViewController = nil
        }
        
        sidebarShowing = false
    }
    
}
