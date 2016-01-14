//
//  HidingNavInternalViewController.swift
//  HidingNavigationBarSample
//
//  Created by felipowsky on 1/12/16.
//  Copyright © 2016 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavInternalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let identifier = "cell"
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        view.addSubview(tableView)
        
        hidingNavigationBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
    }
    
    // MARK: UITableViewDelegate
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavigationBarManager?.shouldScrollToTop()
        
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "row \(indexPath.row)"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}
