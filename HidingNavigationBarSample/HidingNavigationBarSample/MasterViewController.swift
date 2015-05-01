//
//  MasterViewController.swift
//  HidingNavigationBarSample
//
//  Created by Tristan Himmelman on 2015-05-01.
//  Copyright (c) 2015 Tristan Himmelman. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	
	let rows = ["Hiding Nav Bar", "Hiding Nav Bar + Extension View", "Hiding Nav Bar + Toolbar", "Hiding Nav Bar + TabBar"]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		if let navController = navigationController {
			styleNavigationController(navController)
		}
	}
	
	func styleNavigationController(navigationController: UINavigationController){
		navigationController.navigationBar.translucent = true
		navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		navigationController.navigationBar.tintColor = UIColor.whiteColor()
		navigationController.navigationBar.barTintColor = UIColor(red: 41/255, green: 141/255, blue: 250/255, alpha: 1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rows.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
		
		cell.textLabel?.font = UIFont.systemFontOfSize(16)
		cell.textLabel?.text = rows[indexPath.row]
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.row == 0 {
			let controller = HidingNavViewController()
			navigationController?.pushViewController(controller, animated: true)
		} else if indexPath.row == 1 {
			let controller = HidingNavExtensionViewController()
			navigationController?.pushViewController(controller, animated: true)
		} else if indexPath.row == 2 {
			let controller = HidingNavToolbarViewController()
			navigationController?.pushViewController(controller, animated: true)
		} else {
			let controller1 = HidingNavTabViewController()
			let navController1 = UINavigationController(rootViewController: controller1)
			navController1.tabBarItem = UITabBarItem(tabBarSystemItem: .MostRecent, tag: 0)
			styleNavigationController(navController1)
			let controller2 = HidingNavTabViewController()
			let navController2 = UINavigationController(rootViewController: controller2)
			navController2.tabBarItem = UITabBarItem(tabBarSystemItem: .Favorites, tag: 1)
			styleNavigationController(navController2)
			
			let tabBarController = UITabBarController()
			tabBarController.viewControllers = [navController1, navController2]
			navigationController?.presentViewController(tabBarController, animated: true, completion: nil)
		}
		

	}
}

