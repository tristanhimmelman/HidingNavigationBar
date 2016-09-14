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
	
	func styleNavigationController(_ navigationController: UINavigationController){
		navigationController.navigationBar.isTranslucent = true
		navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		navigationController.navigationBar.tintColor = UIColor.white
		navigationController.navigationBar.barTintColor = UIColor(red: 41/255, green: 141/255, blue: 250/255, alpha: 1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rows.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
		
		cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
		cell.textLabel?.text = rows[(indexPath as NSIndexPath).row]
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if (indexPath as NSIndexPath).row == 0 {
			let controller = HidingNavViewController()
			navigationController?.pushViewController(controller, animated: true)
		} else if (indexPath as NSIndexPath).row == 1 {
			let controller = HidingNavExtensionViewController()
			navigationController?.pushViewController(controller, animated: true)
		} else if (indexPath as NSIndexPath).row == 2 {
			let controller = HidingNavToolbarViewController()
			navigationController?.pushViewController(controller, animated: true)
		} else {
			let controller1 = HidingNavTabViewController()
			let navController1 = UINavigationController(rootViewController: controller1)
			navController1.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
			styleNavigationController(navController1)
			let controller2 = HidingNavTabViewController()
			let navController2 = UINavigationController(rootViewController: controller2)
			navController2.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
			styleNavigationController(navController2)
			
			let tabBarController = UITabBarController()
			tabBarController.viewControllers = [navController1, navController2]
			navigationController?.present(tabBarController, animated: true, completion: nil)
		}
		

	}
}

