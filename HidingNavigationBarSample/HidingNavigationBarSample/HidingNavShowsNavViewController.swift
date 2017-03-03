//
//  HidingNavShowsNavViewController.swift
//  HidingNavigationBarSample
//
//  Created by asaake on 2017/02/27.
//  Copyright (c) 2017 Tristan Himmelman. All rights reserved.
//

import UIKit

class HidingNavShowsNavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
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
		
		let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(HidingNavShowsNavViewController.backButtonTouched))
		navigationItem.leftBarButtonItem = backButton
		
		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
		tableView.panGestureRecognizer.require(toFail: navigationController!.interactivePopGestureRecognizer!)
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
	
	func backButtonTouched(){
		_ = navigationController?.popViewController(animated: true)
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
