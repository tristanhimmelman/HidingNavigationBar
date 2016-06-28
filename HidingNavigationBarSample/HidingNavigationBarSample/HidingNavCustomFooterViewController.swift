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
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        view.addSubview(tableView)
        
        customFooter = UIView()
        customFooter.backgroundColor = .orangeColor()
        customFooter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customFooter)
        
        let label = UILabel()
        label.textColor = .whiteColor()
        label.text = "Custom footer view"
        label.translatesAutoresizingMaskIntoConstraints = false
        customFooter.addSubview(label)
        
        var constraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: customFooter, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: customFooter, attribute: .CenterY, multiplier: 1, constant: 0)
        ]
        
        if hasFooterVisibleBar {
            let visibleBar = UILabel()
            visibleBar.translatesAutoresizingMaskIntoConstraints = false
            visibleBar.textColor = .whiteColor()
            visibleBar.text = "Always visible"
            visibleBar.textAlignment = .Center
            visibleBar.backgroundColor = .brownColor()
            customFooter.addSubview(visibleBar)
            
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[bar]|", options: [], metrics: nil, views: ["bar": visibleBar])
            constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[bar(==30)]", options: [], metrics: nil, views: ["bar": visibleBar])
            constraints.append(NSLayoutConstraint(item: visibleBar, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        }

        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[footer]|", options: [], metrics: nil, views: ["footer": customFooter])
        let bottomEdgeConstraint = NSLayoutConstraint(item: customFooter, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        constraints.append(bottomEdgeConstraint)
        bottomEdgeConstraint.priority = 500
        constraints.append(NSLayoutConstraint(item: customFooter, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        NSLayoutConstraint.activateConstraints(constraints)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.manageBottomBar(customFooter, constraint: bottomEdgeConstraint)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    // MARK: UITableViewDelegate
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = "row \(indexPath.row)"
        cell.selectionStyle = .None
        return cell
    }
}
