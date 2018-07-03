

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("User.Plist") //Path to internal storage
    
    var userArray = [User]()
    
    let registerUser = UserC.singletonUser
    
    enum registerError: Error {
        case incompleteForm
        case incorrectPasswordLength
    }
    
    @IBOutlet weak var emailTextFiald: UITextField!
    @IBOutlet weak var passwordTextFiald: UITextField!
    @IBOutlet weak var carNumberTextFiald: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() //Closes the keyboard at the end of text input (tap on screen)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        register()
        
//        registerUser.name = userNameTextField.text!
//        registerUser.carNumber = carNumberTextFiald.text!
        
        
        
    }
    
    //////////////////////////////////////////////////////////////

    func register(){
    
        let email = emailTextFiald.text!
        let password = passwordTextFiald.text!
        let carNumber = carNumberTextFiald.text!
        let name = userNameTextField.text!
        
        SVProgressHUD.show() // show Progress HUD animation
        
        if email.isEmpty || password.isEmpty || carNumber.isEmpty || name.isEmpty {
            
            SVProgressHUD.dismiss()// hide Progress HUD animation
            Alert.showBasic(title: "Incomplete Form", message: "Please fill out all the the fields we need them for later", vc: self)
            
        }
            
        else{
            
            if password.characters.count < 6 {
                
                SVProgressHUD.dismiss()// hide Progress HUD animation
                Alert.showBasic(title: "The password is too short", message: "Password should be at least 6 characters", vc: self)
                
            }
            
             //set up a new user on our Firebase database
            
                    Auth.auth().createUser(withEmail: emailTextFiald.text!, password: passwordTextFiald.text!) { (user, error) in
            
                if error != nil{
                    
                    let errorCode = (error! as NSError).code
                    let errorDomain = (error! as NSError).domain
                    
                    print("error code = \(errorCode)")
                    print("error domain = \(errorDomain)")
                    
                    switch errorCode {
                        
                    case 17008://Invalid mail
                        print("Invalid mail")
                        SVProgressHUD.dismiss()
                        Alert.showBasic(title: "Invalid mail!", message: "", vc: self)
                        
                    case 17007://Email already in use
                        print("Email already in use")
                        SVProgressHUD.dismiss()
                        Alert.showBasic(title: "Email already in use", message: "", vc: self)


                    default:
                        print("other case")
                    }
                    
                }
                    
                else{
                    self.saveUserDetailsToFirebase(email: email, carNumber: carNumber, name: name)
                    print("Registeretion successeful!")
                    self.performSegue(withIdentifier: "registerToFeed", sender: self)
                    SVProgressHUD.dismiss()
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    //////////////////////////////////////////////////////////////
    
    func saveUserDetailsToFirebase(email: String , carNumber: String, name : String){
        
        let userReference = Database.database().reference().child("users")
        
        //let newUserID = userReference.childByAutoId().key
        
        let newUserID = Auth.auth().currentUser!.uid
        
        let newUserReference = Database.database().reference().child("users").child(newUserID)
        
        newUserReference.setValue(["Name": name, "Email": email, "CarNumber": carNumber, "Key": newUserID], withCompletionBlock: {
            
            (error,ref) in
            
            if error != nil{
                print("We have error")
                return
            }
            
            print("saveUserDetailsToFirebase Success!")
            
        })
        
    }

}











//        userArray.append(registerUser)
        
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(userArray)
//            try data.write(to: dataFilePath!)
//
//            print("--------------success en-coding-----------------")
//        }
//
//        catch{
//            print("--------Error en-coding userArray \(error)-----")
//
//        }

//        loadUser()
        
        
        
//        do {
//            try register()
//            // Transition to next screen
//
//        } catch registerError.incompleteForm {
//
//            Alert.showBasic(title: "Incomplete Form", message: "Please fill out both email and password fields", vc: self)
//        }
//        catch registerError.incorrectPasswordLength {
//
//            Alert.showBasic(title: "Password Too Short", message: "Password should be at least 6 characters", vc: self)
//
//        } catch {
//
//            Alert.showBasic(title: "Unable To Login", message: "There was an error when attempting to login", vc: self)
//        }
        
        
//    }
    
//    func register() throws {
//
//        let email = emailTextFiald.text!
//        let password = passwordTextFiald.text!
//
//        // set up a new user on our Firebase database
//        Auth.auth().createUser(withEmail: emailTextFiald.text!, password: passwordTextFiald.text!) { (user, error) in
//
//
//
//        }
//
//
//
//            if email.isEmpty || password.isEmpty {
//                throw registerError.incompleteForm
//            }
//
//            if password.characters.count < 6 {
//                throw registerError.incorrectPasswordLength
//            }
//
//            if self.carNumberTextFiald.text == ""{
//
//                Alert.showBasic(title: "Eror", message: "Please enter your car number", vc: self)
//
//            }
//
//            else{
//
//                print("Registeretion successeful!")
//
//                self.performSegue(withIdentifier: "registerToHome", sender: self)
//
//            }
//
//
//
//    }
//
    
//    func loadUser(){
//
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                print("------------success de-coding---------------")
//                userArray = try decoder.decode([User].self, from: data)
//
//
//                //firstLabel.text = userArray.last?.firstName
//
//
//            }
//            catch{
//                print("----------Error de-coding userArray \(error)--------")
//            }
//        }
//
//    }
    







//extension AuthErrorCode {
//    var errorMessage: String {
//        switch self {
//        case .emailAlreadyInUse:
//            return "The email is already in use with another account"
//        case .userNotFound:
//            return "Account not found for the specified user. Please check and try again"
//        case .userDisabled:
//            return "Your account has been disabled. Please contact support."
//        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
//            return "Please enter a valid email"
//        case .networkError:
//            return "Network error. Please try again."
//        case .weakPassword:
//            return "Your password is too weak. The password must be 6 characters long or more."
//        case .wrongPassword:
//            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
//        default:
//            return "Unknown error occurred"
//        }
//    }
//}



