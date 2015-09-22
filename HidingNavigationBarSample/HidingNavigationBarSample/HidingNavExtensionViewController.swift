//
//  TableViewController.swift
//  HidingNavigationBarSample
//
//  Created by Tristan Himmelman on 2015-05-01.
//  Copyright (c) 2015 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavExtensionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let identifier = "cell"
	var hidingNavBarManager: HidingNavigationBarManager?
	var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
		view.addSubview(tableView)

		let extensionView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 40))
		extensionView.layer.borderColor = UIColor.lightGrayColor().CGColor
		extensionView.layer.borderWidth = 1
		extensionView.backgroundColor = UIColor(white: 230/255, alpha: 1)
		let label = UILabel(frame: extensionView.frame)
		label.text = "Extension View"
		label.textAlignment = NSTextAlignment.Center
		extensionView.addSubview(label)
		
		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
		hidingNavBarManager?.addExtensionView(extensionView)
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
