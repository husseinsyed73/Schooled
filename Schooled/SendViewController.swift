//
//  SendViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/7/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit

class SendViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePic: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //This function adds a photo into the UIImageView to be sent
    @IBAction func addPhoto(_ sender: Any) {
        //if we can pick a picture then enter this
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            //print the button capture to indicate we will pick a picture
            print("Button capture")
            
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            //set the source of the pictures to the saved pictures on the users phone
            imagePicker.sourceType = .savedPhotosAlbum
            //we do not want to allow the user to edit the picture in this functio
            imagePicker.allowsEditing = false
            
            //present the imagePicker in this view controller
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //This function allows the user to pick the image and sets the image they picked to the image we want to use
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        //set the image to the image the user picks
        imageView.image = image
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
