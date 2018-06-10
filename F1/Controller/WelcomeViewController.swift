

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
  
    var dbReference: DatabaseReference? // firebase inits
    
    var dbHandle: DatabaseHandle? // firebase inits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        // Do any additional setup after loading the view, typically from a nib.
        
        dbReference = Database.database().reference() // firebase init
        
    }

}


//loginButton.isEnabled = true
//loginButton.isHighlighted = true
//
//registerButton.isEnabled = false
//registerButton.isHighlighted = false




