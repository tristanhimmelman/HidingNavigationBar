//
//  TableViewController.swift
//  HidingNavigationBarSample
//
//  Created by Tristan Himmelman on 2015-05-01.
//  Copyright (c) 2015 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HidingNavigationBarManagerDelegate {

	let identifier = "cell"
	var hidingNavBarManager: HidingNavigationBarManager?
	var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
		view.addSubview(tableView)

		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.delegate = self
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
	
    // MARK: - UITableViewDataSource

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
    
    // MARK: - HidingNavigationBarManagerDelegate
    
    func hidingNavigationBarManagerDidChangeState(_ manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
        
    }
    
    func hidingNavigationBarManagerDidUpdateScrollViewInsets(_ manager: HidingNavigationBarManager) {
        
    }
}
