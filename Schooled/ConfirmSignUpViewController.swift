// confirm signup class
import AWSDynamoDB
import Foundation
import AWSCognitoIdentityProvider

class ConfirmSignUpViewController : UIViewController {
    
   
    
    // variables be set upon segue
    var sentTo: String?
    var user: AWSCognitoIdentityUser?
    var email = "dddddddd"
    var phoneNumber = "dddd"
    
    
    @IBOutlet weak var sentToLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.text = self.user!.username;
        self.sentToLabel.text = "Code sent to: \(self.sentTo!)"
    }
    
    // MARK: IBActions
    
    // handle confirm sign up
    @IBAction func confirm(_ sender: AnyObject) {
        
        guard let confirmationCodeValue = self.code.text, !confirmationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Confirmation code missing.",
                                                    message: "Please enter a valid confirmation code.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        self.user?.confirmSignUp(self.code.text!, forceAliasCreation: true).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    strongSelf.present(alertController, animated: true, completion:  nil)
                } else {
                    // after the user gets confirmed we can add them to the database
                    // its okay to do user name since no dublicates
                    // add the email and phone number attributes
                    
                    let addingUser = UserDataModel()
                    // adding the user name to the data
                    addingUser?._userId = self?.user!.username
                    
                    addingUser?._questions = 3 as NSNumber
                    addingUser?._email = self?.email
                    addingUser?._phoneNumber = self?.phoneNumber 
                    
                    
                    
                    // defining the client side object mapping
                    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
                    
                    dynamoDBObjectMapper.save(addingUser!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                        // taking it off the main ui thread
                        
                        
                        if let error = task.error as NSError? {
                            print("The request failed. Error: \(error)")
                        } else {
                            // Do something with task.result or perform other operations.
                        }
                        
                        return nil
                    })
                    let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            })
            return nil
        }
    }
    
    // handle code resend action
    @IBAction func resend(_ sender: AnyObject) {
        self.user?.resendConfirmationCode().continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let _ = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result {
                    let alertController = UIAlertController(title: "Code Resent",
                                                            message: "Code resent to \(result.codeDeliveryDetails?.destination! ?? " no message")",
                        preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            })
            return nil
        }
    }
    
}
