//
//  FavouritesPhotos+CoreDataProperties.swift
//  SmarfieFinal
//
//  Created by Antonio Cerqua on 26/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//
//

import Foundation
import CoreData

// MARK: TRASH

extension FavouritesPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritesPhotos> {
        return NSFetchRequest<FavouritesPhotos>(entityName: "FavouritesPhotos")
    }

    @NSManaged public var image: NSData?

}
