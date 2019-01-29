//
//  BestSideViewController.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 25/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class BestSideViewController: UIViewController {

    static var sessionState: SessionState = .active
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureInput?
    var backCameraInput: AVCaptureInput?
    var captureSession = AVCaptureSession()
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoLayer: CGRect?
    var photoOutput: AVCapturePhotoOutput?
    var currentLayer: PhotoLayer = .rectangular
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    let photoSettings = AVCapturePhotoSettings()
    var flashMode = AVCaptureDevice.FlashMode.auto
    var image: UIImage?
    var rectangularFrame: CGRect?
    var squaredFrame: CGRect?
    let motionManager = CMMotionManager()
    let classifier = PhotoClassifier()
    let queue = DispatchQueue(label: "com.smarfie.CoreImageQueue", qos: .userInitiated)
    let user = User()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    //    MARK:- Outlets

    @IBOutlet weak var takePhotoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        takePhotoButton.layer.borderWidth = 6
        takePhotoButton.layer.borderColor = UIColor(red: 0.17, green: 0.67, blue: 0.71, alpha: 1.0).cgColor
        takePhotoButton.layer.cornerRadius = 37.5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    //    MARK:- FUNCTIONS
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
            
            try? device.lockForConfiguration()
            if (device.isFocusModeSupported(.continuousAutoFocus)) {
                device.focusMode = .continuousAutoFocus
            } else if (device.isFocusModeSupported(.autoFocus)) {
                device.focusMode = .autoFocus
            }
            device.unlockForConfiguration()
        }
    }
    
    
    func setupInputOutput() {
        
        if let frontCamera = self.frontCamera {
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
            else { print ("cannot add front input") }
            
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(photoOutput!)
    }
    
    
    func setupPreviewLayer() {
        
        rectangularFrame = CGRect(x: 0,y: 0,width: view.bounds.width, height: view.bounds.height)
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = rectangularFrame!
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
        ViewController.sessionState = .active
    }
    

    
    @IBAction func cameraButton(_ sender: Any) {
        photoSettings.flashMode = self.flashMode
        let uniCameraSetting = AVCapturePhotoSettings.init(from: photoSettings)
        photoOutput?.capturePhoto(with: uniCameraSetting, delegate: self)

    }


    func detectBestSide(image: UIImage) -> Bool{
        let faces = self.classifier.detectFaces(image: image)
        if faces.first != nil {
            let x = (faces.first!.leftEyePosition.x + faces.first!.rightEyePosition.x) / 2
            let y = faces.first!.bounds.midX
            if x > y - 12 {
                User.shared.bestSide = .right
            } else if x < y + 12 {
                User.shared.bestSide = .left
            } else {
                User.shared.bestSide = .front
            }
            return true
        } else {
            return false
        }
    }

}


extension BestSideViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        var faceIsFound: Bool = false
        var alertTitle = "No face found"
        var alertMsg = "Try again"
        
        if let photoData = photo.fileDataRepresentation(){
            let newImage = UIImage(data: photoData)
            faceIsFound = detectBestSide(image: newImage!)
        }
        
        if faceIsFound{
            alertTitle = "Perfect!"
            alertMsg = "Your best side has been choosen"
        }
        

        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)


        func okAction(){
            print (faceIsFound)
            if faceIsFound{
                if let name = storyboard?.value(forKey: "name") as? String{
                    if name == "OnBoarding"{
                        self.performSegue(withIdentifier: "GO", sender: self)
                    } else {
                        self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.navigationBar.isHidden = false
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            okAction()
        })
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension BestSideViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is BestSideViewController {
            viewController.tabBarController?.tabBar.isHidden = true
            viewController.navigationController?.navigationBar.isHidden = true
        } else {
            
        }
    }
}
