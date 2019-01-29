//
//  PhotoClassifier.swift
//  Smarfie
//
//  Created by Michele De Sena on 20/02/2018.
//  Copyright © 2018 Michele De Sena. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreMotion



class PhotoClassifier{
    let motionManager = CMMotionManager()
    var faceSide:FaceSide?
    
    var angle:Double{
        get{
            return self.motionManager.deviceMotion!.gravity.z
        }
    }
    
    var isInBestSide:Bool{
        get{
            if let _ = faceSide{
                return faceSide == User.shared.bestSide
            }else{
                return false
            }
        }
    }
    var shutEyes:Bool = false
    var smile:Bool  = false
    var faceAngleScore:Double = 0
    var bscore:Double = 0
    
    
    var score:Double = 0
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func detectFaces(image:UIImage)->[CIFaceFeature]{
        let myImage = self.resizeImage(image: image, newWidth: 1000)
        let newImage = CIImage(image:myImage)!
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in:newImage, options: [CIDetectorSmile:true])
        return faces as! [CIFaceFeature]
    }
    
    
    func getBrightness(image:UIImage)->Double{
        return (image.brightness)
    }
    
    
    func calculateScore(image:UIImage)->Double{
        
        let brightness = getBrightness(image: image)
        
        let faces = self.detectFaces(image: image)
        
        for face in faces{
            self.smile = face.hasSmile
            self.shutEyes = !face.leftEyeClosed && !face.rightEyeClosed
            if face.faceAngle > -15 || face.faceAngle < 15 {
                self.faceAngleScore = abs(Double(face.faceAngle) / 15)
                self.faceAngleScore = 1 - self.faceAngleScore
                
            }
            
            if faces.count == 1{
                let x = (face.leftEyePosition.x + face.rightEyePosition.x) / 2
                let y = face.bounds.midX
                if x < y - 12 {
                    faceSide = .right
                } else if x > y + 12 {
                    faceSide = .left
                } else {
                    faceSide = .front
                }
            }
        }
        
    
        
       
        if brightness > 34 || brightness < 227 {
            bscore = (brightness - 131) / 96
            bscore = 1 - bscore
        }
        
        if smile{
            score += 1.0
        }
        
        if shutEyes{
            score += 1.0
        }
        
        if isInBestSide {
            score += 1.0
        }
        
        var totalScore = score + bscore + faceAngleScore
        
        if faces.count == 1 {
            totalScore = totalScore/6
        }else{
            totalScore = totalScore/5
        }
        
        return totalScore
    }
    
}




extension CGImage {
    var brightness: Double {
        get {
            let imageData = self.dataProvider?.data
            let ptr = CFDataGetBytePtr(imageData)
            var x = 0
            var result: Double = 0
            for _ in 0..<self.height {
                for _ in 0..<self.width {
                    let r = ptr![0]
                    let g = ptr![1]
                    let b = ptr![2]
                    result += (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                    x += 1
                }
            }
            let bright = result / Double (x)
            return bright
        }
    }
}
extension UIImage {
    var brightness: Double {
        get {
            return (self.cgImage?.brightness)!
        }
    }
}

public enum FaceSide{
    case right
    case left
    case front
}
