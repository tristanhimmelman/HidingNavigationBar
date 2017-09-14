//
//  HidingNavigationBarManager.swift
//  Optimus
//
//  Created by Tristan Himmelman on 2015-03-17.
//  Copyright (c) 2015 Hearst TV. All rights reserved.
//

import UIKit

public protocol HidingNavigationBarManagerDelegate: class {
    func hidingNavigationBarManager(_ manager: HidingNavigationBarManager, shouldUpdateScrollViewInsetsTo insets: UIEdgeInsets) -> Bool
    func hidingNavigationBarManager(_ manager: HidingNavigationBarManager, didUpdateScrollViewInsetsTo insets: UIEdgeInsets)
	func hidingNavigationBarManager(_ manager: HidingNavigationBarManager, didChangeStateTo state: HidingNavigationBarState)
}

public enum HidingNavigationBarState: String {
	case closed
	case contracting
	case expanding
	case open
}

public enum HidingNavigationForegroundAction {
	case `default`
	case show
	case hide
}

public protocol RefreshableControl {
    var isRefreshing: Bool { get }
}

extension UIRefreshControl: RefreshableControl { }

open class HidingNavigationBarManager: NSObject, UIScrollViewDelegate, UIGestureRecognizerDelegate {
	// The view controller that is part of the navigation stack
	unowned var viewController: UIViewController
	
	// The scrollView that will drive the contraction/expansion
	unowned var scrollView: UIScrollView
	
	// The extension view to be shown beneath the navbar
	weak var extensionView: UIView?
	
	// Control the resistance when scrolling up/down before the navbar expands/contracts again.
	open var expansionResistance: CGFloat = 0
	open var contractionResistance: CGFloat = 0
	
	weak open var delegate: HidingNavigationBarManagerDelegate?
	
	open var refreshControl: RefreshableControl?
	
	fileprivate var navBarController: HidingViewController
	fileprivate var extensionController: HidingViewController
	fileprivate var tabBarController: HidingViewController?
	
	// Scroll calculation values
	fileprivate var topInset: CGFloat = 0
	fileprivate var previousYOffset = CGFloat.nan
	fileprivate var resistanceConsumed: CGFloat = 0
	fileprivate var isUpdatingValues = false
	
	// Hiding navigation bar state
	fileprivate var currentState = HidingNavigationBarState.open
	fileprivate var previousState = HidingNavigationBarState.open

	//Options
	open var onForegroundAction = HidingNavigationForegroundAction.default
	
	public init(viewController: UIViewController, scrollView: UIScrollView){
		if viewController.navigationController == nil || viewController.navigationController?.navigationBar == nil {
			fatalError("ViewController must be within a UINavigationController")
		}
        
        viewController.extendedLayoutIncludesOpaqueBars = true
        
		self.viewController = viewController
		self.scrollView = scrollView
		
		// Create extensionController
		extensionController = HidingViewController()
		viewController.view.addSubview(extensionController.view)
		
		let navBar = viewController.navigationController!.navigationBar
		navBarController = HidingViewController(view: navBar)
		navBarController.child = extensionController
		navBarController.alphaFadeEnabled = true
		
		super.init()
		
		// track panning on scroll view
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
		panGesture.delegate = self
		scrollView.addGestureRecognizer(panGesture)
		
		navBarController.expandedCenter = {[weak self] (view: UIView) -> CGPoint in
			return CGPoint(x: view.bounds.midX, y: view.bounds.midY + (self?.statusBarHeight() ?? 0))
		}
		
		extensionController.expandedCenter = {[weak self] (view: UIView) -> CGPoint in
			let topOffset = (self?.navBarController.contractionAmountValue() ?? 0) + (self?.statusBarHeight() ?? 0)
			let point = CGPoint(x: view.bounds.midX, y: view.bounds.midY + topOffset)
			
			return point
		}
		
		updateContentInsets()
		
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground),
                                               name: .UIApplicationDidBecomeActive, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	//MARK: Public methods

	open func manageBottomBar(_ view: UIView, constraint: NSLayoutConstraint? = nil){
		tabBarController = HidingViewController(view: view, constraint: constraint)
		if constraint == nil {
            tabBarController?.contractsUpwards = false
        }
		tabBarController?.expandedCenter = {[weak self] (view: UIView) -> CGPoint in
			let height = self?.viewController.view.frame.size.height ?? 0
			let point = CGPoint(x: view.bounds.midX, y: height - view.bounds.midY)
			
			return point
		}
	}
	
	open func addExtensionView(_ view: UIView) {
		extensionView?.removeFromSuperview()
		extensionView = view
		
		var bounds = view.frame
		bounds.origin = CGPoint.zero
		
		extensionView?.frame = bounds
		extensionController.view.frame = bounds
		extensionController.view.addSubview(view)
		_ = extensionController.expand()
		
		extensionController.view.superview?.bringSubview(toFront: extensionController.view)
		updateContentInsets()
	}
	
	open func viewWillAppear(_ animated: Bool) {
		expand()
	}
	
	open func viewDidLayoutSubviews() {
        navBarController.updateContractsUpwardsIfNeeded()
        extensionController.updateContractsUpwardsIfNeeded()
        tabBarController?.updateContractsUpwardsIfNeeded()
		updateContentInsets()
	}
	
	open func viewWillDisappear(_ animated: Bool) {
		expand()
	}
	
	open func updateValues()	{
		isUpdatingValues = true
		
		var scrolledToTop = false
		
		if scrollViewContentInset.top == -scrollView.contentOffset.y {
			scrolledToTop = true
		}
		
		if let extensionView = extensionView {
			var frame = extensionController.view.frame
			frame.size.width = extensionView.bounds.size.width
			frame.size.height = extensionView.bounds.size.height
			extensionController.view.frame = frame
		}

        updateContentInsets()

		if scrolledToTop {
			var offset = scrollView.contentOffset
			offset.y = -scrollViewContentInset.top
			scrollView.contentOffset = offset
		}
		
		isUpdatingValues = false
	}
	
    @discardableResult
	open func shouldScrollToTop() -> Bool{
		// update content Inset
		let top = statusBarHeight() + navBarController.totalHeight()
		updateScrollContentInsetTop(top)

		_ = navBarController.snap(false, completion: nil)
		_ = tabBarController?.snap(false, completion: nil)
        
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -top), animated: true)   // update scroll offset manually
        return false    // disable iOS default behaviour
	}
	
	open func contract(){
		_ = navBarController.contract()
		_ = tabBarController?.contract()
		
		previousYOffset = CGFloat.nan
		
		handleScrolling()
	}
	
	open func expand() {
		_ = navBarController.expand()
		_ = tabBarController?.expand()
		
		previousYOffset = CGFloat.nan
		
		handleScrolling()
	}
	
	//MARK: NSNotification
	
	@objc func applicationWillEnterForeground() {
		switch onForegroundAction {
		case .show:
			_ = navBarController.expand()
			_ = tabBarController?.expand()
		case .hide:
			_ = navBarController.contract()
			_ = tabBarController?.contract()
		default:
			break;
		}
		handleScrolling()
	}
	
	//MARK: Private methods
	
	fileprivate func isViewControllerVisible() -> Bool {
		return viewController.isViewLoaded && viewController.view.window != nil
	}
	
	fileprivate func statusBarHeight() -> CGFloat {
		if UIApplication.shared.isStatusBarHidden {
			return 0
		}
		
		let statusBarSize = UIApplication.shared.statusBarFrame.size
		return min(statusBarSize.width, statusBarSize.height)
	}
	
	fileprivate func shouldHandleScrolling() -> Bool {
		// if scrolling down past top
		if scrollView.contentOffset.y <= -scrollViewContentInset.top && currentState == .open {
			return false
		}
		
		// if refreshing
		if refreshControl?.isRefreshing == true {
			return false
		}
		
		let scrollFrame = UIEdgeInsetsInsetRect(scrollView.bounds, scrollViewContentInset)
		let scrollableAmount: CGFloat = scrollView.contentSize.height - scrollFrame.height
		let scrollViewIsSuffecientlyLong: Bool = scrollableAmount > navBarController.totalHeight() * 3
		
		return isViewControllerVisible() && scrollViewIsSuffecientlyLong && !isUpdatingValues
	}
	
	fileprivate func handleScrolling(){
		if shouldHandleScrolling() == false {
			return
		}
		
		if previousYOffset.isNaN == false {
			// 1 - Calculate the delta
			var deltaY = previousYOffset - scrollView.contentOffset.y
			
			// 2 - Ignore any scrollOffset beyond the bounds
			let start = -topInset
			if previousYOffset < start {
				deltaY = min(0, deltaY - previousYOffset - start)
			}
			
			/* rounding to resolve a dumb issue with the contentOffset value */
			let end = floor(scrollView.contentSize.height - scrollView.bounds.height + scrollViewContentInset.bottom - 0.5)
			if previousYOffset > end {
				deltaY = max(0, deltaY - previousYOffset + end)
			}
			
			// 3 - Update contracting variable
			if Float(fabs(deltaY)) > .ulpOfOne {
				if deltaY < 0 {
					currentState = .contracting
				} else {
					currentState = .expanding
				}
			}
			
			// 4 - Check if contracting state changed, and do stuff if so
			if currentState != previousState {
				previousState = currentState
				resistanceConsumed = 0
			}
			
			// 5 - Apply resistance
			if currentState == .contracting {
				let availableResistance = contractionResistance - resistanceConsumed
				resistanceConsumed = min(contractionResistance, resistanceConsumed - deltaY)
				
				deltaY = min(0, availableResistance + deltaY)
			} else if scrollView.contentOffset.y > -statusBarHeight() {
				let availableResistance = expansionResistance - resistanceConsumed
				resistanceConsumed = min(expansionResistance, resistanceConsumed + deltaY)
				
				deltaY = max(0, deltaY - availableResistance)
			}
			
			// 6 - Update the shyViewController
			_ = navBarController.updateYOffset(deltaY)
			_ = tabBarController?.updateYOffset(deltaY)
		}
		
		// update content Inset
		updateContentInsets()
		
		previousYOffset = scrollView.contentOffset.y
		
		// update the visible state
		let state = currentState
        if navBarController.view.center        == navBarController.expandedCenterValue()
            && extensionController.view.center == extensionController.expandedCenterValue()
            && tabBarController?.isExpanded ?? true {
			currentState = .open
        } else if navBarController.view.center == navBarController.contractedCenterValue()
            && extensionController.view.center == extensionController.contractedCenterValue()
            && tabBarController?.isContracted ?? true {
			currentState = .closed
		}
        
		if state != currentState {
            delegate?.hidingNavigationBarManager(self, didChangeStateTo: currentState)
		}
	}
	
	fileprivate func updateContentInsets() {
		let navBarBottomY = navBarController.view.frame.origin.y + navBarController.view.frame.size.height
        let top: CGFloat = !extensionController.isContracted
            ? extensionController.view.frame.origin.y + extensionController.view.bounds.size.height
            : navBarBottomY
        let bottom: (CGFloat, Bool) = {
            if let tabView = tabBarController?.view, viewController.view.contains(subview: tabView) {
                return (viewController.view.frame.height - tabView.frame.minY, true)
            }
            return (scrollView.contentInset.bottom, false)
        }()
        
        let contentInset = UIEdgeInsets(top: top, left: scrollView.contentInset.left, bottom: bottom.0, right: scrollView.contentInset.right)
        if delegate?.hidingNavigationBarManager(self, shouldUpdateScrollViewInsetsTo: contentInset) == false {
            return
        }
        
        updateScrollContentInsetTop(top, delegateCallback: false)
        if bottom.1 {
            updateScrollContentInsetBottom(bottom.0, delegateCallback: false)
        }
        
        delegate?.hidingNavigationBarManager(self, didUpdateScrollViewInsetsTo: contentInset)
	}
	
	fileprivate func updateScrollContentInsetTop(_ top: CGFloat, delegateCallback: Bool = true) {
        let contentInset = adjustInset(UIEdgeInsets(top: top, left: scrollViewContentInset.left, bottom: scrollViewContentInset.bottom, right: scrollViewContentInset.right))
        if delegateCallback && (delegate?.hidingNavigationBarManager(self, shouldUpdateScrollViewInsetsTo: contentInset) == false) {
            return
        }
        
        if viewController.automaticallyAdjustsScrollViewInsets {
            scrollView.contentInset = contentInset
        }
        var scrollInsets = scrollView.scrollIndicatorInsets
        scrollInsets.top = top
        scrollView.scrollIndicatorInsets = scrollInsets
        if delegateCallback {
            delegate?.hidingNavigationBarManager(self, didUpdateScrollViewInsetsTo: contentInset)
        }
	}
    
    fileprivate func updateScrollContentInsetBottom(_ bottom: CGFloat, delegateCallback: Bool = true) {
        let contentInset = adjustInset(UIEdgeInsets(top: scrollViewContentInset.top, left: scrollViewContentInset.left, bottom: bottom, right: scrollViewContentInset.right))
        if delegateCallback && (delegate?.hidingNavigationBarManager(self, shouldUpdateScrollViewInsetsTo: contentInset) == false) {
            return
        }
        if viewController.automaticallyAdjustsScrollViewInsets {
            scrollView.contentInset.bottom = bottom
        }
        scrollView.scrollIndicatorInsets.bottom = bottom
        if delegateCallback {
            delegate?.hidingNavigationBarManager(self, didUpdateScrollViewInsetsTo: contentInset)
        }
    }
	
	fileprivate func handleScrollingEnded(_ velocity: CGFloat) {
		let minVelocity: CGFloat = 500.0
		if isViewControllerVisible() == false || (navBarController.isContracted && (tabBarController?.isContracted ?? true) && velocity < minVelocity) {
			return
		}
		
		resistanceConsumed = 0
		if currentState == .contracting || currentState == .expanding || velocity > minVelocity {
			var contracting: Bool = currentState == .contracting

			if velocity > minVelocity { // if velocity is greater than minVelocity we expand
				contracting = false
			}
            
            if let extensionView = extensionView, !contracting && extensionController.view.center == extensionController.contractedCenterValue() {
                extensionView.frame.origin.y -= navBarController.expandedCenterValue().y - navBarController.view.center.y
            }
			
			UIView.animate(withDuration: 0.2, animations: {
                let deltaY = self.navBarController.snap(contracting, animated: false, completion: nil)
                let tabBarShouldContract = deltaY < 0 || self.navBarController.isContracted
                _ = self.tabBarController?.snap(tabBarShouldContract, animated: false, completion: nil)
                
                var newContentOffset = self.scrollView.contentOffset
                newContentOffset.y -= deltaY
                
                let contentInset = self.scrollViewContentInset
                let top = contentInset.top + deltaY
                
                if let tabView = self.tabBarController?.view, self.viewController.view.contains(subview: tabView) {
                    self.updateScrollContentInsetBottom(self.viewController.view.frame.height - tabView.frame.minY, delegateCallback: false)
                }
                
				self.updateScrollContentInsetTop(top)
				self.scrollView.contentOffset = newContentOffset
                
                if let _ = self.tabBarController?.deltaConstraint {
                    self.viewController.view.layoutIfNeeded()
                }
                if let extensionView = self.extensionView, !contracting {
                    extensionView.frame.origin.y = 0
                }
			})
            
            previousYOffset = CGFloat.nan
		}
	}
	
	//MARK: Scroll handling
	
	@objc func handlePanGesture(_ gesture: UIPanGestureRecognizer){
		switch gesture.state {
		case .began:
			topInset = navBarController.view.frame.size.height + extensionController.view.bounds.size.height + statusBarHeight()
			handleScrolling()
		case .changed:
			handleScrolling()
		default:
			let velocity = gesture.velocity(in: scrollView).y
			handleScrollingEnded(velocity)
		}
	}
	
	//MARK: UIGestureRecognizerDelegate
	
	@objc open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

    //MARK: iOS 11 handling (adjustedContentInset, safeAreaInsets)
    
    var scrollViewContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return scrollView.adjustedContentInset
        } else {
            return scrollView.contentInset
        }
    }
    
    fileprivate func adjustInset(_ inset: UIEdgeInsets) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIEdgeInsets(
                top: inset.top - scrollView.safeAreaInsets.top,
                left: inset.left - scrollView.safeAreaInsets.left,
                bottom: inset.bottom - scrollView.safeAreaInsets.bottom,
                right: inset.right - scrollView.safeAreaInsets.right)
        }
        return inset
    }
}

private extension UIView {
    func contains(subview: UIView) -> Bool {
        for view in subviews {
            if view === subview {
                return true
            }
            if view.contains(subview: subview) {
                return true
            }
        }
        return false
    }
}
