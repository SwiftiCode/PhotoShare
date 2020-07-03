//
//  ViewController.swift
//  PhotoShare
//
//  Created by Thomas.Tay.sg on 27/2/16.
//  Copyright © 2016 Thomas.Tay.sg. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookShare

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SharingDelegate {
    
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
    
    // MARK: Share delegate
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("share ok")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("share error")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
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
        
        // prepare for FB share
        let fbPhoto = SharePhoto()
        fbPhoto.image = myPhotoView.image
        fbPhoto.isUserGenerated = true
        
        // FB Content
        let content = SharePhotoContent()
        content.photos = [fbPhoto]
        
        // FB Dialog
        let dialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        dialog.mode = .native
        if dialog.canShow {
            dialog.show()
        } else {
            print("error show dialog")
        }
        
        
    }
    
}

