//
//  onBoardingViewController.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 25/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

class onBoardingViewController: UIPageViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate {
   override private (set) lazy var viewControllers:[UIViewController] = { return [newViewController(0),newViewController(1),newViewController(2),newViewController(3),newViewController(4)]}()
    
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        print ("view did load")
        
        if let firstViewController = viewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            print ("setting")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return (viewControllers.count)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        guard let index = viewControllers.index(of: viewController)else {return nil}
        guard index + 1 < 5 else{return nil}
        
        
        return viewControllers[index + 1]
    }
    
    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return .portrait
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController)else {return nil}
        
        
        guard index - 1 >= 0 else {return nil}
        return viewControllers[index - 1]
    }
    
    
    private func newViewController(_ index:Int)->UIViewController{
        return UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "ViewController\(index)")
    }
    
}
