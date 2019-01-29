//
//  BestPhotos+CoreDataProperties.swift
//  SmarfieFinal
//
//  Created by Antonio Cerqua on 23/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//
//

import Foundation
import CoreData

// MARK: TRASH

extension BestPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BestPhotos> {
        return NSFetchRequest<BestPhotos>(entityName: "BestPhotos")
    }

    @NSManaged public var image: NSData?

}
