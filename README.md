HidingNavigationBar
==============

An easy to use library (written in Swift) that manages hiding and showing a navigation bar as a user scrolls.
- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)

#Features 

HidingNavigationBar supports hiding/showing of the following view elements:
- UINavigationBar
- UINavigationBar and an extension UIView 
- UINavigationBar and a UIToolbar
- UINavigationBar and a UITabBar 

###UINavigationBar
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNav.gif)
###UINavigationBar and an extension UIView
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavExtension.gif)
###UINavigationBar and a UIToolbar
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavToolbar.gif)
###A UINavigationBar and a UITabBar
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavTabBar.gif)

#Usage

1. Include a member variable of type `HidingNavigationBarManager` in your `UIViewController` subclass.
2. Initialize the variable in `viewDidLoad` function, passing in the `UIViewController` instance and the `UIScrollView` instance that will control the hiding/showing of the navigation bar.
3. Relay the following `UIViewController` lifecycle functions to the `HidingNavigationBarManager` variable:
```swift
override func viewWillAppear(animated: Bool)
override func viewWillDisappear(animated: Bool)
override func viewDidLayoutSubviews() //Only necessary when adding the extension view
```
And finally relay the following `UIScrollViewDelegate` function:
```swift
func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool
```

Below is an example of how your UIViewController subclass should look:
```swift 
class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	var hidingNavBarManager: HidingNavigationBarManager?
	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

		hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
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

	//// TableView datasoure and delegate 

	func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
		hidingNavBarManager?.shouldScrollToTop()
		
		return true
	}
	
	...
}
```

Note: HidingNavigationBar only works with UINavigationBars that have translucent set to true.

#Installation

If you are using [Cocoapods](https://cocoapods.org/), add the following line to your Podfile:

`pod 'HidingNavigationBar', '~> 0.1'`

Otherwise, include the following files directly to your project:
- HidingNavigationBarManager.swift
- HidingViewController.swift


<!-- 
#Implementation Notes

- method swizzling
- tab bar support -->



