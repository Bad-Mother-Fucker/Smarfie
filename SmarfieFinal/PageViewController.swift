//
//  PageViewController.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 25/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

// MARK: TRASH

class PageViewController: UIViewController {
    let pages = [#imageLiteral(resourceName: "1 Prima schermata"),#imageLiteral(resourceName: "2 Seconda schermata"),#imageLiteral(resourceName: "3 Terza schermata"),#imageLiteral(resourceName: "4 Quarta schermata"),#imageLiteral(resourceName: "5 Quinta schermata")]
    
  
    
    @IBOutlet weak var background: UIImageView!
   
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func starAgain(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if pageIndex != 4 {finishButton.isHidden = true}
//        if pageIndex < 5{
//        background.image = pages[pageIndex]
//        }
    }

}
