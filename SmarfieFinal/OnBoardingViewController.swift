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
    var pageControl = UIPageControl(frame:CGRect(x:0,y:UIScreen.main.bounds.maxY - 50,width:UIScreen.main.bounds.width,height:50))
    func configurePageControl(){
            pageControl.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        dataSource = self
        delegate = self
//       pageControl.backgroundColor = UIColor(rgb: 0x70BEC1)
        if let firstViewController = viewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        self.view.addSubview(pageControl)
            view.bringSubview(toFront: view)
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
        guard let firstViewController = viewControllers.first, let firstViewControllerIndex = self.viewControllers.index(of: firstViewController) else {return 0}
        if firstViewControllerIndex == 0 {pageControl.backgroundColor = UIColor(rgb: 0xBAE1E2)}
        return firstViewControllerIndex
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print ("hahaha")
        configurePageControl()
    }
    private func newViewController(_ index:Int)->UIViewController{
        return UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "ViewController\(index)")
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
