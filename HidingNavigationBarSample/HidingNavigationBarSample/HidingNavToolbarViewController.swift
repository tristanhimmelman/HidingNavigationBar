//
//  TableViewController.swift
//  HidingNavigationBarSample
//
//  Created by Tristan Himmelman on 2015-05-01.
//  Copyright (c) 2015 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavToolbarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let identifier = "cell"
	var hidingNavBarManager: HidingNavigationBarManager?
	var tableView: UITableView!
	var toolbar: UIToolbar!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
		view.addSubview(tableView)
		
		toolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.size.height - 44, width: view.bounds.width, height: 44))
		toolbar.barTintColor = UIColor(white: 230/255, alpha: 1)
		view.addSubview(toolbar)
		
		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
		hidingNavBarManager?.manageBottomBar(toolbar)
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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 100
    }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) 

        // Configure the cell...
		cell.textLabel?.text = "row \((indexPath as NSIndexPath).row)"
		cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }

}
