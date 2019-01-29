//
//  BestSideViewController.swift
//  SmarfieFinal
//
//  Created by Michele De Sena on 25/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import AVFoundation

class BestSideViewController:UIViewController{
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
    

    @IBOutlet weak var takePhotoButton:UIButton!
    
    @IBAction func cameraButton(_ sender: Any) {
        photoSettings.flashMode = self.flashMode
        let uniCameraSetting = AVCapturePhotoSettings.init(from: photoSettings)
        ViewController.sessionState = .active
       
        photoOutput?.capturePhoto(with: uniCameraSetting, delegate: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        takePhotoButton.layer.borderWidth = 6
        takePhotoButton.layer.borderColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0).cgColor
        takePhotoButton.layer.cornerRadius = 37.5
    }

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
        
       
           if let frontCamera = self.frontCamera {
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!);print("Input added") }
            else { print ("cannot add front input")}
            
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(photoOutput!)
    }
    
    
    func setupPreviewLayer() {
       
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        print ("Layer set")
        
    }
    
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
}


extension BestSideViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let alert = UIAlertController(title: "OK!", message: "Your side has been choosen", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "GO", sender: self)
            })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
