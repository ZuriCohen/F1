

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //Closes the keyboard at the end of text input (tap on screen)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        login()
        
    }
    
    // MARK: - login - Email and password validation
    
    func login(){  
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SVProgressHUD.show() // show Progress HUD animation
        
        if email.isEmpty || password.isEmpty {
            
            SVProgressHUD.dismiss()// hide Progress HUD animation
            Alert.showBasic(title: "Incomplete Form", message: "Please fill out both email and password fields", vc: self)
            
        }
            
        else{
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil{
                    
                    let errorCode = (error! as NSError).code
                    
                    print("error code = \(errorCode)")
                    
                    switch errorCode {
                        
                    case 17009://Incorrect password
                        print("Incorrect password")
                        SVProgressHUD.dismiss()
                        Alert.showBasic(title: "Incorrect password!", message: "", vc: self)
                        
                    case 17011://User does not exist
                        print("User does not exist")
                        SVProgressHUD.dismiss()
                        Alert.showBasic(title: "User does not exist!", message: "", vc: self)
                        
                    case 17008://Invalid mail
                        print("Invalid mail")
                        SVProgressHUD.dismiss()
                        Alert.showBasic(title: "Invalid mail!", message: "", vc: self)
                        
                    default:
                        print("other case")
                    }
                    
                }
                    
                else{
                    
                    self.performSegue(withIdentifier: "loginToFeed", sender: self)
                    print("Log-in successeful!")
                    SVProgressHUD.dismiss()
                    
                }
                
            }
            
        }
        
    }
    
}

// MARK: - Closes the keyboard at the end of text input (tap on screen)

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}








