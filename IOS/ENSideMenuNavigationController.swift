

import UIKit

public class ENSideMenuNavigationController: UINavigationController, ENSideMenuProtocol {
    
    public var sideMenu : ENSideMenu?
    public var sideMenuAnimationType : ENSideMenuAnimation = .Default
    
    
    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init( menuViewController: UIViewController, contentViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        if (contentViewController != nil) {
            self.viewControllers = [contentViewController!]
        }

        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menuViewController, menuPosition:.Left)
        view.bringSubviewToFront(navigationBar)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    // MARK: - Navigation
    public func setContentViewController(contentViewController: UIViewController) {
        self.sideMenu?.toggleMenu()
        switch sideMenuAnimationType {
        case .None:
            //self.viewControllers = [contentViewController]
            self.viewControllers.removeAll()
            self.pushViewController(contentViewController, animated: true)
            break
        default:
            if(contentViewController.restorationIdentifier == "HomeViewController"){
            
                self.popToRootViewControllerAnimated(true)
            }
            else{
            var viewControllerTemp: [AnyObject] = self.viewControllers
            var newViewControllerTemp: [UIViewController] = [UIViewController]()
            newViewControllerTemp.append(viewControllerTemp[0] as! UIViewController )
                let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = item
            newViewControllerTemp.append(contentViewController)
           self.navigationItem.backBarButtonItem?.title = "Back"
            self.setViewControllers(newViewControllerTemp, animated: true)
            }
            break
        }
        
    }

}
