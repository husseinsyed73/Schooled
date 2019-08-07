// sign up class

import Foundation
import AWSCognitoIdentityProvider
import AWSDynamoDB
import AWSCore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    var useralerted = false;
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        username.delegate = self
        password.delegate = self
        phone.delegate = self
        email.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signUpConfirmationViewController = segue.destination as? ConfirmSignUpViewController {
            signUpConfirmationViewController.sentTo = self.sentTo
            signUpConfirmationViewController.user = self.pool?.getUser(self.username.text!)
            // passing on the rest of the user data
            signUpConfirmationViewController.email = self.email.text!
            
            if(self.phone.text! == ""){
                signUpConfirmationViewController.phoneNumber = "123"
            } else {
                signUpConfirmationViewController.phoneNumber = self.phone.text!
            }
        }
    }
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        guard let userNameValue = self.username.text, !userNameValue.isEmpty,
            let passwordValue = self.password.text, !passwordValue.isEmpty else {
                let alertController = UIAlertController(title: "Missing Required Fields",
                                                        message: "Username / Password are required for registration.",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:  nil)
                return
        }
        if(self.email.text==""){
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Email is required for registration",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        if let phoneValue = self.phone.text, !phoneValue.isEmpty {
            let phone = AWSCognitoIdentityUserAttributeType()
            phone?.name = "phone_number"
            phone?.value = phoneValue
            attributes.append(phone!)
        } 
        
        if let emailValue = self.email.text, !emailValue.isEmpty {
            let email = AWSCognitoIdentityUserAttributeType()
            email?.name = "email"
            email?.value = emailValue
            attributes.append(email!)
        }
        if(self.phone.text == "" && !self.useralerted ){
        let alertController = UIAlertController(title: "Warning",
                                                message: "if you do not enter a phone number you will not receive text updates",
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case.default:
                self.useralerted = true
                return
            case.cancel:
                return
                
            case.destructive:
                return
                
                
            }}))
        
        self.present(alertController, animated: true, completion:  nil)
            return
        }
        
        //sign up the user
        self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        
                        
                        strongSelf.performSegue(withIdentifier: "confirmSignUpSegue", sender:sender)
                        
                    } else {
                        let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            })
            return nil
        }
        
}
    
    //disables the keyboard after hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
