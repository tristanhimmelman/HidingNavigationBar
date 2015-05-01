HidingNavigationBar
==============

An easy to use library (written in Swift) that manages hiding and showing a navigation bar as a user scrolls.

#Features 

HidingNavigationBar supports hiding/showing of the following view elements:
- UINavigationBar
- An extension view placed below the navigation bar
- UIToolbar
- UITabBar 

![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNav.gif)
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavExtension.gif)
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavToolbar.gif)
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavTabBar.gif)

#Usage

`HidingNavigationBarManager` is the class that you need to interface with to make the magic happen. 

The first step is to add a `HidingNavigationBarManager` member variable to your view controller. Initialize the variable in `viewDidLoad` function, passing in the view controller instance and the UIScrollView instance that will control the hiding/showing of the navigation bar.

Then you need to relay the following UIViewController lifecycle functions to the `HidingNavigationBarManager` instance:

```swift
override func viewWillAppear(animated: Bool)
```
```swift
override func viewDidLayoutSubviews()
```
```swift
override func viewWillDisappear(animated: Bool)
```

Below is a sample of everything put together:
```swift 
class HidingNavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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

<!--#Installation-->

<!--ZoomTransition can be easily added to your project using [Cocoapods](https://cocoapods.org/) by adding the following to your Podfile:-->

<!--`pod 'HidingNavigationBar', '~> 0.1'`-->

<!--Otherwise you can include the following files directly to your project:-->
<!--- HidingNavigationBarManager.swift-->
<!--- HidingViewController.swift-->


<!-- 
#Implementation Notes

- method swizzling
- tab bar support -->



