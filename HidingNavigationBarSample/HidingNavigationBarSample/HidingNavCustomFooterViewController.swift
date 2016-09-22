//
//  HidingNavCustomFooterViewController.swift
//  HidingNavigationBarSample
//
//  Created by Jake on 28/06/16.
//  Copyright © 2016 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavCustomFooterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let identifier = "cell"
    var hidingNavBarManager: HidingNavigationBarManager?
    var tableView: UITableView!
    var toolbar: UIToolbar!
    var customFooter: UIView!
    var hasFooterVisibleBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        view.addSubview(tableView)
        
        customFooter = UIView()
        customFooter.backgroundColor = .orange
        customFooter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customFooter)
        
        let label = UILabel()
        label.textColor = .white
        label.text = "Custom footer view"
        label.translatesAutoresizingMaskIntoConstraints = false
        customFooter.addSubview(label)
        
        var constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: customFooter, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: customFooter, attribute: .centerY, multiplier: 1, constant: 0)
        ]
        
        if hasFooterVisibleBar {
            let visibleBar = UILabel()
            visibleBar.translatesAutoresizingMaskIntoConstraints = false
            visibleBar.textColor = .white
            visibleBar.text = "Always visible"
            visibleBar.textAlignment = .center
            visibleBar.backgroundColor = .brown
            customFooter.addSubview(visibleBar)
            
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[bar]|", options: [], metrics: nil, views: ["bar": visibleBar])
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[bar(==30)]", options: [], metrics: nil, views: ["bar": visibleBar])
            constraints.append(NSLayoutConstraint(item: visibleBar, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        }

        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[footer]|", options: [], metrics: nil, views: ["footer": customFooter])
        let bottomEdgeConstraint = NSLayoutConstraint(item: customFooter, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        constraints.append(bottomEdgeConstraint)
        bottomEdgeConstraint.priority = 500
        constraints.append(NSLayoutConstraint(item: customFooter, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100))
        NSLayoutConstraint.activate(constraints)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.manageBottomBar(customFooter, constraint: bottomEdgeConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    // MARK: UITableViewDelegate
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "row \(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
}
