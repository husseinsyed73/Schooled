//
//  AnswersViewController.swift
//  Schooled
//
//  Created by Luong Luong on 7/14/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let photoPicker = UIImagePickerController()

    @IBOutlet weak var answerVIew: UIImageView!
    @IBAction func AddPhoto(_ sender: Any) {
        option();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func options(){
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        // add Camera action
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in self.camera()
            
        }))
        
        //add photo library action
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (alert:UIAlertAction!) -> Void in self.photolibrary()
            
        }))
        
        // add cancel action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func camera(){
        //Source type is camera
        photoPicker.sourceType = UIImagePickerController.SourceType.camera
        
        //Allow photo editing
        photoPicker.allowsEditing = true;
        
        //present image in this viewcontroller
        present(photoPicker, animated: true, completion: nil)
    }
    
    func photolibrary(){
        //Source type is photo library
        photoPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //Allow photo editing
        photoPicker.allowsEditing = true;
        
        //present image in this viewcontroller
        present(photoPicker, animated: true, completion: nil)
    }
    
    //function is called when users pick image of their choosing
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //check if image can be converted to image
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            answerView.image = image
        }
        
        //Dismiss view when pictures are chosen
        dismiss(animated: true, completion: nil)
    }
    
    
}
