//
//  HiddenNavViewController.swift
//  HidingNavigationBarSample
//
//  Created by asaake on 2017/02/27.
//  Copyright (c) 2017 Tristan Himmelman. All rights reserved.
//

import UIKit

class HiddenNavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	let identifier = "cell"
	var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView = UITableView(frame: view.bounds)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
		view.addSubview(tableView)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	// MARK: UITableViewDelegate
	
	func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			dismiss(animated: true, completion: nil)
		} else {
			let controller = HidingNavShowsNavViewController()
			navigationController?.pushViewController(controller, animated: true)
		}
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
		if indexPath.row == 0 {
			cell.textLabel?.text = "close controller";
			cell.selectionStyle = UITableViewCellSelectionStyle.none
		} else {
			cell.textLabel?.text = "row \((indexPath as NSIndexPath).row)"
			cell.selectionStyle = UITableViewCellSelectionStyle.none
		}
		return cell
	}
	
}
