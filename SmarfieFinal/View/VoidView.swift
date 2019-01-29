//
//  VoidView.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 24/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import UIKit

class EmptyView:UIView{
    var shouldSetUpConstraints = true
    let viewController = ViewController()
    var image:UIImageView!
    let screenSize = UIScreen.main.bounds
    override init(frame: CGRect) {
        super.init(frame:frame)
        image = UIImageView()
        image.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: (screenSize.height - 113))
        image.image = #imageLiteral(resourceName: "group")
        image.contentMode = .scaleAspectFit
        self.addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func updateConstraints() {
        if shouldSetUpConstraints{
            //AutoLayout
            shouldSetUpConstraints = false
        }
        super.updateConstraints()
    }
    
    
    



}
