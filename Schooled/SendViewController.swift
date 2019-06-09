//
//  SendViewController.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 6/7/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

//This class is connected to the ViewController that controls the sending and adding of photos

import UIKit

class SendViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePic: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    //This function adds a photo into the UIImageView to be sent
    @IBAction func addPhoto(_ sender: Any) {
        //if we can pick a picture then enter this
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            //print the button capture to indicate we will pick a picture
            print("Button capture")
            //set the source of the pictures to the saved pictures on the users phone
            imagePicker.sourceType = .photoLibrary
            //we do not want to allow the user to edit the picture in this functio
            imagePicker.allowsEditing = true

            //present the imagePicker in this view controller
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //This function puts the image in the imageView to display for the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //if the image is an UIImage then display it into the imageView
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
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
