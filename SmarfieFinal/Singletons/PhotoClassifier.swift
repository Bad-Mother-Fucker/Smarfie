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

class PhotoClassifier {
    
    var faceSide: FaceSide?
    var isInBestSide: Bool{
        if faceSide != nil{
            return faceSide == User.shared.bestSide
        } else {
            return false
        }
    }

    var shutEyes: Bool = false
    var smile: Bool  = false
    var faceAngleScore: Double = 0.0
    var bscore: Double = 0.0
    var totalScore = 0.0
    var faceScore = 0.0
    var score: Double = 0.0
    
    var goodPhotoInfo = "Wow! "

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func detectFaces(image: UIImage) -> [CIFaceFeature] {
        let myImage = self.resizeImage(image: image, newWidth: 300)
        let newImage = CIImage(image: myImage)!
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let options = [CIDetectorSmile: true, CIDetectorEyeBlink: true, CIDetectorFocalLength: true]
        if let faces = faceDetector?.features(in: newImage, options: options) as? [CIFaceFeature]{
            return faces
        } else { return [] }
    }
    
    
    
    
    
    func calculateScore(image: PhotoScore) -> (Double, String){
        totalScore = 0.0
        bscore = 0.0
        faceScore = 0.0
        score = 0.0
        var photoInfo = "Hint: "
        goodPhotoInfo = "Wow! "
        var perfect = true
        
        let brightness = image.image.brightness
        
        let faces = self.detectFaces(image: image.image)
        
        guard faces.count > 0 else { return (0, "No face found") }
        guard image.gravity > -0.45 else { return (0.1, photoInfo+"try to raise the camera up") }

        for face in faces{
            self.smile = face.hasSmile
            self.shutEyes = !face.leftEyeClosed && !face.rightEyeClosed
            
            if face.faceAngle > -15 && face.faceAngle < 15 {
                self.faceAngleScore = abs(Double(face.faceAngle) / 15)
                //                    self.faceAngleScore = 1 - self.faceAngleScore
                faceScore += self.faceAngleScore
                
            } else {
                photoInfo += "straighten up your head! \n"
                perfect = false
            }
            
            if smile{
                faceScore += 1.0
                goodPhotoInfo += "What a great smile!"
            } else {
                photoInfo += "Smile more!\n"
                perfect = false
            }
            
            if shutEyes{
                faceScore += 1.0
                goodPhotoInfo += "Your eyes are beautiful\n"
            } else {
                photoInfo += "Open your eyes! \n"
                perfect = false
            }
        }

        if faces.count == 1{
            let x = (faces.first!.leftEyePosition.x + faces.first!.rightEyePosition.x) / 2
            let y = faces.first!.bounds.midX
            if x > y - 12 {
                faceSide = .right
            } else if x < y + 12 {
                faceSide = .left
            } else {
                faceSide = .front
            }
    
            if isInBestSide {
                faceScore += 1.0
                goodPhotoInfo += "you're on your best side\n"
            } else {
                //photoInfo += "try to turn on your best side \n"
                perfect = false
            }
        }
        
        faceScore /= Double(faces.count)
        
        if brightness > 34 && brightness < 227 {
            bscore = (brightness - 131) / 96
           
        } else if brightness < 30 {
            photoInfo += "Increase brightness\n"
            perfect = false
        } else if brightness > 230 {
            photoInfo += " Decrease brightness \n "
            perfect = false
        }

        if image.gravity > -0.20 && image.gravity <= 0.20  {
            score += 0.35
            photoInfo += "go a little bit higher! \n"
            perfect = false
        } else if image.gravity > 0.20 {
            score += 1.0
            goodPhotoInfo += "and this selfie is from a perfect angle!"
        }
        
        totalScore = (score + bscore + faceScore)
        
        if faces.count == 1 {
            totalScore /= 6
        } else {
            totalScore /= 5
        }
        
        if perfect{
            photoInfo = goodPhotoInfo
        }
        
        if faces.count >= 3{
            photoInfo = "You're too much guys, I can't give you any hint but i'm pretty shure you're really really beautiful"
        }
        
        print (photoInfo)
        return (totalScore, photoInfo)
    }
}

extension CGImage {
    var brightness: Double {

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

extension UIImage {
    var brightness: Double {
        return (self.cgImage?.brightness)!
    }
}

public enum FaceSide{
    case right
    case left
    case front
}

public enum SessionState{
    case active
    case closed
}
