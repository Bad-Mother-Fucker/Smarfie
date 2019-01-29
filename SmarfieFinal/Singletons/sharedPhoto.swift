//
//  sharedPhoto.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 06/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import UIKit
//import CoreData

// MARK: TRASH

class PhotoScore:Hashable{
    var hashValue: Int = 0
    var image: UIImage
    var score: Double?
    var gravity: Double
    var info:String?
    
    
    static func ==(lhs: PhotoScore, rhs: PhotoScore) -> Bool {
        return lhs.image == rhs.image
    }
    
    init (image:UIImage,gravity:Double){
        self.image = image
        self.gravity = gravity

    }

}

class PhotoShared{

    static let shared = PhotoShared()
//    let fetchRequest: NSFetchRequest<BestPhotos> = BestPhotos.fetchRequest()
//    var best = [BestPhotos]()

    var myPhotoSession: [PhotoScore]?
    
    
    var bestPhotos:[UIImage]{
        
        get{
            var images:[UIImage] = []
            if let _ = setOfBest{
                for x in setOfBest!{
                    images.append(x)
                }
                
                return images
            }else{
                return []
                }
          
            }
        
        set {
            if let _ = setOfBest{
                for x in newValue{
                    setOfBest!.insert(x)
                }
            }else{
                setOfBest = Set(newValue)
            }
        }
    }
    
    
    
    var favourites: [UIImage]{
        get{
            var images:[UIImage] = []
            if let _ = setOfFavourites{
                for x in setOfFavourites!{
                    images.append(x)
                }
                return images
            }else{
                return []
             }
            
           }
        
        set {
            if let _ = setOfFavourites{
                for x in newValue{
                    setOfFavourites!.insert(x)
                }
            }else{
                setOfFavourites = Set(newValue)
            }
          
        }
    
    }
    
    
    var setOfBest:Set<UIImage>?

    var setOfFavourites:Set<UIImage>?
}
