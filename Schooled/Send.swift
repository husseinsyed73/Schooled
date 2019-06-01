//
//  Send.swift
//  Schooled
//
//  Created by Omar Dadabhoy on 5/29/19.
//  Copyright © 2019 Hussein  Syed. All rights reserved.
//

import Foundation
import PhotosUI
class Send {
    
    private var image: UIImage
    private var phoneNumber: Int
    private var email: String
    
    //initializer forces you to pass in an image a phone number and an email which will
    //be used to send the image to the phonenumber and the email
    init(image: UIImage, phoneNumber: Int, email: String) {
        self.image = image
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    //This method sends the photo as an sms text to the person
    func sendToPhone() {
        
    }
    
    //This method sends the photo to the email of the user
    func sendToEmail(){
        
    }
}
