//
//  HidingNavCustomBarItemViewController.swift
//  HidingNavigationBarSample
//
//  Created by asaake on 2017/03/02.
//  Copyright (c) 2017 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavChangeBarItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	let identifier = "cell"
	var hidingNavBarManager: HidingNavigationBarManager?
	var tableView: UITableView!
	var barButtonItem1: UIBarButtonItem!
	var barButtonItem2: UIBarButtonItem!
	var timer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
		view.addSubview(tableView)
		
		barButtonItem1 = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
		barButtonItem2 = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
		
		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if timer == nil {
			timer = Timer.scheduledTimer(timeInterval: 3.0,
			                             target: self,
			                             selector: #selector(updateBarButtonItem),
			                             userInfo: nil, repeats: true)
			timer?.fire()
		}
		
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
	
	override func viewDidDisappear(_ animated: Bool) {
		timer?.invalidate()
		timer = nil
	}
	
	func updateBarButtonItem() {
		hidingNavBarManager?.updateNavigationBarItem {
			if self.navigationItem.rightBarButtonItem != self.barButtonItem1 {
				self.navigationItem.rightBarButtonItem = self.barButtonItem1
			} else {
				self.navigationItem.rightBarButtonItem = self.barButtonItem2
			}
		}
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
	
}
