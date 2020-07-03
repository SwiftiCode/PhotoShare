//
//  ViewController.swift
//  PhotoShare
//
//  Created by Thomas.Tay.sg on 27/2/16.
//  Copyright © 2016 Thomas.Tay.sg. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var myPhotoView: UIImageView!
    
    // MARK: Default Template
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        myPhotoView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: IBAction
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        
        let myPhotoTaker = UIImagePickerController()
        myPhotoTaker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let myPhotoAlert = UIAlertController(title: "Photo Source", message: "Choose photo source:", preferredStyle: .actionSheet)
            let useCamera = UIAlertAction(title: "Camera", style: .default) { action -> Void in
                myPhotoTaker.sourceType = .camera
               
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    
                    myPhotoTaker.cameraDevice = .rear
                    
                } else {
                    
                    myPhotoTaker.cameraDevice = .front
                    
                }
                
                self.present(myPhotoTaker, animated: true, completion: nil)
            }
            
            let usePhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
                myPhotoTaker.sourceType = .photoLibrary
                self.present(myPhotoTaker, animated: true, completion: nil)
            }
            
            myPhotoAlert.addAction(useCamera)
            myPhotoAlert.addAction(usePhotoLibrary)
            
            present(myPhotoAlert, animated: true, completion: nil)
            
            
            
            
        } else {
            
            myPhotoTaker.sourceType = .photoLibrary
            present(myPhotoTaker, animated: true, completion: nil)
            
        }
        
        //present(myPhotoTaker, animated: true, completion: nil)
        
    }
    
    @IBAction func sharePhoto(_ sender: UIBarButtonItem) {
        
        let isFacebookServiceAvailable = SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)
        let isTwitterServiceAvailable = SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        var mySocialShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        if isFacebookServiceAvailable || isTwitterServiceAvailable {
            
            if isFacebookServiceAvailable && isTwitterServiceAvailable {
                
                let myChoiceAlert = UIAlertController(title: "Choose Social Service", message: "Choose which service to share:", preferredStyle: .actionSheet)
                let myChoiceAlertActionFacebook = UIAlertAction(title: "Facebook", style: .default) { action -> Void in
                    mySocialShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    mySocialShare.add(self.myPhotoView.image)
                    self.present(mySocialShare, animated: true, completion: nil)
                }
                let myChoiceAlertActionTwitter = UIAlertAction(title: "Twitter", style: .default) { action -> Void in
                    mySocialShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    mySocialShare.add(self.myPhotoView.image)
                    self.present(mySocialShare, animated: true, completion: nil)
                }
                
                myChoiceAlert.addAction(myChoiceAlertActionFacebook)
                myChoiceAlert.addAction(myChoiceAlertActionTwitter)
                
                present(myChoiceAlert, animated: true, completion: nil)
            }
            
            if isFacebookServiceAvailable && !isTwitterServiceAvailable {
                
                mySocialShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                mySocialShare.add(self.myPhotoView.image)
                    
                
                present(mySocialShare, animated: true, completion: nil)
            }
            
            if !isFacebookServiceAvailable && isTwitterServiceAvailable {
                
                mySocialShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                mySocialShare.add(self.myPhotoView.image)
                    
                present(mySocialShare, animated: true, completion: nil)
            }


            
        } else {
            
            let myAlert = UIAlertController(title: "Alert!", message: "No Facebook or Twitter Setup", preferredStyle: .alert)
            let myAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            myAlert.addAction(myAlertAction)
            
            present(myAlert, animated: true, completion: nil)
        }
        
        
    }
    
}

