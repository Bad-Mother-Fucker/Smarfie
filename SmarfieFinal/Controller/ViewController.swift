//
//  ViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 05/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
class ViewController: UIViewController {
    static var sessionState:SessionState = .active
    var currentCameraPosition: CameraPosition?
    var frontCameraInput:AVCaptureInput?
    var backCameraInput:AVCaptureInput?
    var captureSession = AVCaptureSession()
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoLayer:CGRect?
    var photoOutput: AVCapturePhotoOutput?
    var currentLayer:PhotoLayer = .rectangular
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    let photoSettings = AVCapturePhotoSettings()
    var flashMode = AVCaptureDevice.FlashMode.auto
    var image: UIImage?
    var rectangularFrame:CGRect?
    var squaredFrame:CGRect?
    let motionManager = CMMotionManager()
    let classifier = PhotoClassifier()
    let queue = DispatchQueue(label: "com.smarfie.CoreImageQueue", qos: .userInitiated)
    let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    //    MARK:- Outlets
    
    @IBOutlet weak var photoCounter: UILabel!

    @IBOutlet weak var counterView: UIView!
    
    
    @IBOutlet weak var flashButton: UIButton! {
        didSet{
            flashButton.setImage(#imageLiteral(resourceName: "FlashAuto"), for: .normal)
        }
    }
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        takePhotoButton.layer.borderWidth = 6
        takePhotoButton.layer.borderColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0).cgColor
        takePhotoButton.layer.cornerRadius = 37.5
        counterView.layer.cornerRadius = 5
        counterView.layer.opacity = 30
        counterView.layer.borderWidth = 1
        counterView.layer.borderColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0).cgColor
      
        hapticFeedback.prepare()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        photoCounter.text = "\(PhotoShared.shared.myPhotoSession?.count ?? 0)"
    }
    
    
    @IBAction func switchFrameRect(_ sender: UIButton) {
        self.currentLayer = .rectangular
        cameraPreviewLayer?.frame = rectangularFrame!
      
    }
    
    @IBAction func switchFrameSquare(_ sender: Any) {
        self.currentLayer = .squared
        cameraPreviewLayer?.frame = squaredFrame!
      
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
            if (device.isFocusModeSupported(.continuousAutoFocus)){
                device.focusMode = .continuousAutoFocus
            } else if (device.isFocusModeSupported(.autoFocus)){
                device.focusMode = .autoFocus
            }
            device.unlockForConfiguration()
        }
    }
    
    
    func setupInputOutput() {
        
        if let rearCamera = self.backCamera {
            self.backCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            
            if captureSession.canAddInput(self.backCameraInput!) { captureSession.addInput(self.backCameraInput!) }else {print ("Cannot add back input")}
            
            self.currentCameraPosition = .rear
            self.switchCameraButton.setImage(#imageLiteral(resourceName: "changecamera"), for: .normal)
            
        } else if let frontCamera = self.frontCamera {
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
            else { print ("cannot add front input")}
            
            self.currentCameraPosition = .front
            self.switchCameraButton.setImage(#imageLiteral(resourceName: "changecamera"), for: .normal)
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(photoOutput!)
    }
    
    
    func setupPreviewLayer() {
        squaredFrame = CGRect(x: 0, y:(view.bounds.height * 0.21889)-10, width: view.bounds.width, height: view.bounds.width)
        rectangularFrame = CGRect(x:0,y:(view.bounds.height*0.133433)-40,width:view.bounds.width, height:view.bounds.width / 0.75)
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
        ViewController.sessionState = .active
    }
    
    
    
    //    MARK: - buttons
    
    @IBAction func changeCamera(_ sender: Any) {
        try? self.switchCameras()
        switch self.currentCameraPosition{
        case .some(.front):
            switchCameraButton.setImage(#imageLiteral(resourceName: "changecamera"), for: .normal)
        case .some(.rear):
            switchCameraButton.setImage(#imageLiteral(resourceName: "changecamera"), for: .normal)
        case .none:
            return
        }
    }
    
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition else {print("Camera position error"); return}
        guard captureSession.isRunning else { print ("errore");return }
        
        captureSession.beginConfiguration()
        
        
        func switchToFrontCamera() {
            let inputs = captureSession.inputs as [AVCaptureInput]
            guard let rearCameraInput = self.backCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else {
                    print("Error3")
                    return}
            
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
                
            else {
                //
                print("Error4")
                return
            }
        }
        
        func switchToRearCamera() {
            let inputs = captureSession.inputs as [AVCaptureInput]
            guard let frontCameraInput = self.frontCameraInput else{print("no front camera input"); return}
            guard inputs.contains(frontCameraInput)else {print ("No contains"); return}
            guard let rearCamera = self.backCamera else {
                print("no back camera")
                return }
            
            self.backCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.backCameraInput!) {
                captureSession.addInput(self.backCameraInput!)
                
                self.currentCameraPosition = .rear
                
            } else {
                print("Error 2")
                return }
        }
        
        switch currentCameraPosition {
        case .front:
            switchToRearCamera()
        case .rear:
            switchToFrontCamera()
        }
        captureSession.commitConfiguration()
    }
    
    
    @IBAction func cameraButton(_ sender: Any) {
        photoSettings.flashMode = self.flashMode
        MotionManager.shared.gravità = motionManager.deviceMotion?.gravity.z
        photoOutput?.capturePhoto(with: AVCapturePhotoSettings.init(from: photoSettings), delegate: self)
        ViewController.sessionState = .active
        hapticFeedback.impactOccurred()
        hapticFeedback.prepare()
    }
    
    
    @IBAction func flashButton(_ sender: Any) {
        switch self.flashMode{
        case .on:
            self.flashMode = .off
            self.flashButton.setImage(#imageLiteral(resourceName: "FlashOff"), for: .normal)
        case .off :
            self.flashMode = .auto
            self.flashButton.setImage(nil, for: .normal)
            self.flashButton.setImage(#imageLiteral(resourceName: "FlashAuto"), for: .normal)
        case .auto:
            self.flashMode = .on
            self.flashButton.setTitle(nil, for: .normal)
            self.flashButton.setImage(#imageLiteral(resourceName: "FlashOn"), for: .normal)
        }
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        let alert = UIAlertController(title: "Attention", message: "This action will end your session", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.tabBarController?.selectedIndex = 0
            PhotoShared.shared.myPhotoSession = nil
            ViewController.sessionState = .closed
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ReloadCollectionViews"),object: nil))
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        if ViewController.sessionState == .active{
            self.present(alert, animated: true, completion: nil)
        }else{
              self.tabBarController?.selectedIndex = 0
        }
       
        
    }
    
    
    @IBAction func showPhoto(_ sender: UIButton) {
        
        
        if let _ = PhotoShared.shared.myPhotoSession {
            performSegue(withIdentifier: "mySegue", sender: self)
         NotificationCenter.default.post(name: NSNotification.Name("reloadCollection"), object: nil)
            
        } else {
            let alertController = UIAlertController(title: "No Photos", message: "Take at least one selfie", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



//MARK:- CAMERA POSITION ENUMERATION
public enum CameraPosition {
    case front
    case rear
}


//MARK:- Extension ViewController to take photo

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let _ = photo.fileDataRepresentation() {
            
            image = UIImage(data: photo.fileDataRepresentation()!)
            if currentLayer == .squared{
               image = image!.cropToBounds(width:  view.bounds.width, height:  view.bounds.width)
            }
            let myPhoto = PhotoScore(image: self.image!,gravity: MotionManager.shared.gravità!)
            
            queue.async {
                let result = self.classifier.calculateScore(image: myPhoto)
                myPhoto.score = result.0
                myPhoto.info = result.1
            }
                
                if let _ = PhotoShared.shared.myPhotoSession {
                    PhotoShared.shared.myPhotoSession!.append(myPhoto)
                } else {
                    PhotoShared.shared.myPhotoSession = [myPhoto]
                }
            photoCounter.text = "\(PhotoShared.shared.myPhotoSession!.count)"
        }
    }
}

// MARK:- Hidden TabBar and Nav bar

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is ViewController {
            viewController.tabBarController?.tabBar.isHidden = true
            viewController.navigationController?.navigationBar.isHidden = true
        } else {
            viewController.tabBarController?.tabBar.isHidden = false
            viewController.navigationController?.navigationBar.isHidden = false
        }
    }
}


public enum PhotoLayer{
    case squared
    case rectangular
}

extension UIImage{
    func cropToBounds(width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = self
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = width
        var cgheight: CGFloat = height
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = self.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
}
