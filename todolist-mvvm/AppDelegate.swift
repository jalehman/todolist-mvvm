//
//  AppDelegate.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ViewModelServicesDelegate {

    var window: UIWindow?
    var services: ViewModelServicesProtocol?
    
    var presenting: UIViewController? {
        return navigationStack.peekAtStack()
    }
    
    private var navigationStack: [UIViewController] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Window, services, root VC
        window = UIWindow(frame: UIScreen.mainScreen().bounds)        
        
        // Root view controller
        services = ViewModelServices(delegate: self)
        let vm = TodoTableViewModel(services: services!)
        services?.push(vm)
        
        let rootNavigationController = UINavigationController()
        navigationStack.push(rootNavigationController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: ViewModelServicesDelegate

    func services(services: ViewModelServicesProtocol, navigate: NavigationEvent) {
        dispatch_async(dispatch_get_main_queue()) {
            switch navigate {
            case .Push(let vc, let style):
                switch style {
                case .Push:
                    if let top = self.presenting as? UINavigationController {
                        top.pushViewController(vc, animated: true)
                    }
                case .Modal:
                    if let top = self.presenting {
                        let navc = self.wrapNavigation(vc)
                        self.navigationStack.push(navc)
                        top.presentViewController(navc, animated: true, completion: nil)
                    }
                }
            case .Pop:
                if let navc = self.presenting as? UINavigationController {
                    if navc.viewControllers.count > 1 {
                        navc.popViewControllerAnimated(true)
                    } else if self.navigationStack.count > 1 {
                        // There's only one VC in the navigation controller and we're not popping the root, so we must be looking at a modal. Pop the modal.
                        self.navigationStack.pop()?.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    // Not a navigation controller at top of stack, so cannot be root.
                    self.navigationStack.pop()?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    private func wrapNavigation(vc: UIViewController) -> UINavigationController {
        let navc = UINavigationController(rootViewController: vc)
        navc.navigationBar.translucent = false
        return navc
    }

}

