//
//  BestSaved.swift
//  SmarfieFinal
//
//  Created by Antonio Cerqua on 25/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK: TRASH

class BestSelfie {
    static let shared = BestSelfie()
    //var savedInData = [UIImage]()
    let fetchRequest: NSFetchRequest<BestPhotos> = BestPhotos.fetchRequest()
    let fetchRequestFav: NSFetchRequest<FavouritesPhotos> = FavouritesPhotos.fetchRequest()
    var best = [BestPhotos]()
    var favourites = [FavouritesPhotos]()
    var countBest = 0
    var countFav = 0
    var selfies:[UIImage] = []
    
    
    func retrieveBest(){
        print("aggiorno...")
        let bestSelfie = try? PersistenceService.context.fetch(fetchRequest)
        guard let best = bestSelfie else {return}
        for selfie in best {
            let selfie = UIImage(data: selfie.image! as Data)
            if let _ = PhotoShared.shared.setOfBest {
                PhotoShared.shared.setOfBest!.insert(selfie!)

            }else{
                PhotoShared.shared.setOfBest = Set([selfie!])
            }
        }
    }
    
    
    func retrieveFav(){
        let favorite = try? PersistenceService.context.fetch(fetchRequestFav)
        guard let favourites = favorite else {return}
        for selfie in favourites {
            let selfie = UIImage(data: selfie.image! as Data)
            if let _ = PhotoShared.shared.setOfFavourites {
                PhotoShared.shared.setOfFavourites!.insert(selfie!)

            }else{
                PhotoShared.shared.setOfFavourites = Set([selfie!])

            }
        }
    }
    
    func removeBest(selfie:UIImage){
        let image = selfie.fixOrientation()
        let pngImg = UIImagePNGRepresentation(image)
        let result = try? PersistenceService.context.fetch(fetchRequest)
        for x in result!{
            if x.image == pngImg! as NSData{
                PersistenceService.context.delete(x)
                print ("Immagine eliminata")
            }
        }
    }
    
    func removeFav(selfie:UIImage){
        let image = selfie.fixOrientation()
        let pngImg = UIImagePNGRepresentation(image)
        let result = try? PersistenceService.context.fetch(fetchRequestFav)
        for x in result!{
            if x.image == pngImg! as NSData{
                PersistenceService.context.delete(x)
                print ("Immagine eliminata")
            }
        }
       
    }
    
    
//    func updateBest() {
//        do{
//            print("aggiorno...")
//            let bestSelfie = try PersistenceService.context.fetch(fetchRequest)
//            self.best = bestSelfie
//            self.countBest = best.count
//        }catch {}
//
//
//    }
//
//    func updateFav() {
//        do{
//            print("aggiorno...")
//            let favorite = try PersistenceService.context.fetch(fetchRequestFav)
//            self.favourites = favorite
//            self.countFav = favourites.count
//        }catch {}
//
//
//    }
//
    
}
