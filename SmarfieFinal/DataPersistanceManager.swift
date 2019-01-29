//
//  DataPersistanceManager.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 23/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

//import Foundation
//import UIKit
//class DataPersistanceManager{
//    static let shared = DataPersistanceManager()
//    
//    
//    func createDataArray(images:[UIImage])->[NSData]{
//        var dataArray:[NSData]=[]
//        
//        for image in images{
//            dataArray.append(UIImagePNGRepresentation(image)! as NSData)
//        }
//        return dataArray
//    }
//    
//    func savePhotos(_ photos: [UIImage], named name: String){
//            print ("Saving photos")
//            UserDefaults.standard.set(nil, forKey: name)
//            UserDefaults.standard.set(self.createDataArray(images: photos), forKey: name)
//        
//    }
//    
//    func createImageArray(dataArray:[NSData])->[UIImage]{
//        var imageArray:[UIImage] = []
//        
//        for data in dataArray{
//            imageArray.append(UIImage(data: data as Data)!)
//        }
//        return imageArray
//    }
//    
//    func retrievePhotos(named name:String)->[UIImage]{
//        guard let _ = UserDefaults.standard.object(forKey: name) else {return []}
//        let dataArray =  UserDefaults.standard.object(forKey: name) as! [NSData]
//        return createImageArray(dataArray: dataArray)
//    }
//    
//}

