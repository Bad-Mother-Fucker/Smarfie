//
//  SettingsViewController.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 01/03/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

// MARK: TRASH

class SettingsViewController: UITableViewController,UIGestureRecognizerDelegate{
    let newBestSideController = BestSideViewController()
    let tapRec = UITapGestureRecognizer(target: self, action: #selector (tapHandler(_:)))
    
    @IBAction func tapOnCell(_ sender: Any) {
         navigationController?.present(newBestSideController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tapRec.delegate = self
        tapRec.numberOfTapsRequired = 1
        tapRec.numberOfTouchesRequired = 1
        tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.contentView.addGestureRecognizer(tapRec)
        tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.contentView.isUserInteractionEnabled = true
        
    }
    
    
    @objc func tapHandler(_ sender:UITapGestureRecognizer){
        navigationController?.present(newBestSideController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var onBoardingSwitch: UISwitch!{
        didSet{
            onBoardingSwitch.isOn = false
        }
    }
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        if  UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag"){
            UserDefaults.standard.removeObject(forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            let alert = UIAlertController(title: "OK", message: "Relaunch application and onBoarding tutorial will be shown again", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {_ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}

extension SettingsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is SettingsViewController {
            print("true")
            viewController.tabBarController?.tabBar.isHidden = false
            viewController.navigationController?.navigationBar.isHidden = false
            self.view.bringSubview(toFront: self.tabBarController!.tabBar)
        } 
    }
}
