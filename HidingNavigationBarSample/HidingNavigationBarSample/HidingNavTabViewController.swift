//
//  TableViewController.swift
//  HidingNavigationBarSample
//
//  Created by Tristan Himmelman on 2015-05-01.
//  Copyright (c) 2015 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let identifier = "cell"
	var hidingNavBarManager: HidingNavigationBarManager?
	var tableView: UITableView!
	var toolbar: UIToolbar!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
		view.addSubview(tableView)
		
		let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(HidingNavTabViewController.cancelButtonTouched))
		navigationItem.leftBarButtonItem = cancelButton
		
		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
		if let tabBar = navigationController?.tabBarController?.tabBar {
			hidingNavBarManager?.manageBottomBar(tabBar)
			tabBar.barTintColor = UIColor(white: 230/255, alpha: 1)
		}
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
	
	func cancelButtonTouched(){
		navigationController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: UITableViewDelegate
	
	func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
		hidingNavBarManager?.shouldScrollToTop()
		
		return true
	}

    // MARK: - Table view data source

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
