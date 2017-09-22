HidingNavigationBar
==============
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/HidingNavigationBar.svg)](https://github.com/tristanhimmelman/HidingNavigationBar)

An easy to use library (written in Swift) that manages hiding and showing a navigation bar as a user scrolls.
- [Features](#features)
- [Usage](#usage)
- [Customization](#customization)
- [Installation](#installation)

# Features

HidingNavigationBar supports hiding/showing of the following view elements:
- UINavigationBar
- UINavigationBar and an extension UIView
- UINavigationBar and a UIToolbar
- UINavigationBar and a UITabBar

### UINavigationBar
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNav.gif)
### UINavigationBar and an extension UIView
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavExtension.gif)
### UINavigationBar and a UIToolbar
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavToolbar.gif)
### A UINavigationBar and a UITabBar
![Screenshot](https://raw.githubusercontent.com/tristanhimmelman/HidingNavigationBar/master/screenshots/hidingNavTabBar.gif)

# Usage

1. Import HidingNavigationBar
2. Include a member variable of type `HidingNavigationBarManager` in your `UIViewController` subclass.
3. Initialize the variable in `viewDidLoad` function, passing in the `UIViewController` instance and the `UIScrollView` instance that will control the hiding/showing of the navigation bar.
4. Relay the following `UIViewController` lifecycle functions to the `HidingNavigationBarManager` variable:
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
import HidingNavigationBar

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

# Customization

### Add an extension view to the UINavigationBar
```swift
let extensionView = // load your a UIView to use as an extension
hidingNavBarManager?.addExtensionView(extensionView)
```
### Hide and show a UITabBar or UIToolbar
```swift
if let tabBar = navigationController?.tabBarController?.tabBar {
	hidingNavBarManager?.manageBottomBar(tabBar)
}
```

### Hide/Show/Do Nothing when App is Foregrounded
```swift
	hidingNavBarManager?.onForegroundAction = .Default	//Do nothing, state of bars will remain the same as when backgrounded
	hidingNavBarManager?.onForegroundAction = .Hide		//Always hide on foreground
	hidingNavBarManager?.onForegroundAction = .Show 	//Always show on foreground
```

### Expansion Resistance
When the navigation bar is hidden, you can some 'resitance' which adds a delay before the navigation bar starts to expand when scrolling. The resistance value is the distance that the user needs to scroll before the navigation bar starts to expand.
```swift
hidingNavBarManager?.expansionResistance = 150
```

### UIRefreshControl

If you are using a UIRefreshControl with your scroll view, it is important to let the `HidingNavigationBarManager` know about it:
```swift
hidingNavBarManager?.refreshControl = refreshControl
```

# Installation

If your using [Carthage](https://github.com/Carthage/Carthage), add the following line to your Cartfile:
```
github "tristanhimmelman/HidingNavigationBar" ~> 2.0
```

(for Swift 3, use `github "tristanhimmelman/HidingNavigationBar" ~> 1.0` instead)

If you are using [CocoaPods](https://cocoapods.org/), add the following line to your Podfile:

`pod 'HidingNavigationBar', '~> 2.0'`

(for Swift 3, use `pod 'HidingNavigationBar', '~> 1.0'` instead)

Otherwise, include the following files directly to your project:
- HidingNavigationBarManager.swift
- HidingViewController.swift
