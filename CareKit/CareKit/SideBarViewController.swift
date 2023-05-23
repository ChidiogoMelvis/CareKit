//
//  SideBarViewController.swift
//  CareKit
//
//  Created by Mac on 07/05/2023.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let items = ["Item 1", "Item 2", "Item 3"]
    var didSelectItem: ((String) -> Void)?
    
    //MARK: - Create and configure the table view
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.backgroundColor = .red
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Call the completion block with the selected item
        let selectedItem = items[indexPath.row]
        didSelectItem?(selectedItem)
    }
    
}


