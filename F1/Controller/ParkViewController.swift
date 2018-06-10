

import UIKit
import CoreLocation


class ParkViewController: UIViewController, CLLocationManagerDelegate {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Park.Plist")
    
    var parkArray = [Park]()
    
    let TH = TimeHandler()
    
    let LH = LocationHandler()
    
    
    @IBOutlet weak var durationFrame: UIImageView!
    
    @IBOutlet weak var locationDescriptionTextField: UITextField!
    
    @IBOutlet weak var durationDisplays: UILabel!
    
    
    @IBOutlet weak var durationPicker: UISlider!
    
    
    let locationManager = CLLocationManager() // Used to start getting the users location
    
    var gpsLat  = ""    //????????????????
    var gpsLon  = ""
    var date = ""
    var duration = 2     //????????????????
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() //Closes the keyboard at the end of text input (tap on screen)
        loadUser()
        
        
        locationManager.delegate = self //Set up the location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // Set location accuracy
        locationManager.requestWhenInUseAuthorization() // Authorization location request
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        gpsLat  = String(location.coordinate.latitude)
        gpsLon  = String(location.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // TODO: output to the UI
    }
    
    
    @IBAction func sliderWasChanged(_ sender: UISlider) {
        
        duration = Int(sender.value)
        
        durationDisplays.text = String(" \(duration/60) hours and \(duration%60) minutes")
        
    }
    
    
    
    @IBAction func parkButtonPressed(_ sender: UIButton) {
        
        
        let parkPark = Park.singletonPark
        
        date = String(describing: Date())
        
        
        parkPark.locationDescription = locationDescriptionTextField.text!
        parkPark.time = TH.currentTimeString()
        parkPark.locationGPS = gpsLat + "/" + gpsLon
        parkPark.duration = duration
        
        //park.toString()
        
        parkArray.append(parkPark)
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(parkArray)
            try data.write(to: dataFilePath!)
            
            print("--------------success en-coding-----------------")
        }
            
        catch{
            print("--------Error en-coding userArray \(error)-----")
            
        }
        
        loadUser()
    
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func loadUser(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                print("------------success de-coding---------------")
                parkArray = try decoder.decode([Park].self, from: data)
                
                
                //firstLabel.text = userArray.last?.firstName
                
            }
            catch{
                print("----------Error de-coding userArray \(error)--------")
            }
        }
        
    }
    
}





//
//func park() throws {
//
//    let email = emailTextFiald.text!
//    let password = passwordTextFiald.text!
//
//    // set up a new user on our Firebase database
//    Auth.auth().createUser(withEmail: emailTextFiald.text!, password: passwordTextFiald.text!) { (user, error) in
//    }
//
//
//    if email.isEmpty || password.isEmpty {
//        throw registerError.incompleteForm
//    }
//
//
//    else{
//
//        print("park successeful!")
//
//        self.performSegue(withIdentifier: "registerToHome", sender: self)
//
//    }
//
//}
//

