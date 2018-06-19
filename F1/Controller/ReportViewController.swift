
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ChameleonFramework
import CoreLocation
import Vision

class ReportViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var senderName : String?
    var reportType : String?
    
    let TH = TimeHandler()
    
    let locationManager = CLLocationManager() // Used to start getting the users location
    
    var gpsLon = ""
    var gpsLat = ""
    
    
    let imagePicker = UIImagePickerController()
    
    var imagePickerController : UIImagePickerController! 
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var reportTypeImage: UIImageView!
    @IBOutlet weak var postButton: CustomButton!
    @IBOutlet weak var locationDescriptionTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() //Closes the keyboard at the end of text input (tap on screen)
        
        takeImageFromUserInit()
        
        locationManager.delegate = self //Set up the location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // Set location accuracy
        locationManager.requestWhenInUseAuthorization() // Authorization location request
        locationManager.startUpdatingLocation()
        
        
        pictureImageView.layer.borderWidth = 2
        pictureImageView.layer.borderColor = UIColor.white.cgColor
        
        switch reportType {
            
        case "Lights": 
            reportTypeImage.image = UIImage(named: "light")
            break
            
        case "Blocker":
            reportTypeImage.image = UIImage(named: "traffic-signal")
            break
            
        case "Policeman":
            reportTypeImage.image = UIImage(named: "people (1)")
            break
            
        default:
            reportTypeImage.image = UIImage(named: "error")
        }
        
        
        
    }
    
    
    func takeImageFromUserInit(){
        imagePicker.delegate = self
        //imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    
    
    func sendToDatabase(photoURL: String){
        
        let postsReference = Database.database().reference().child("posts")
        
        let newPostID = postsReference.childByAutoId().key
        
        let newPostReference = Database.database().reference().child("posts").child(newPostID)
        
        //let postKey = Auth.auth().currentUser?.uid
        
     
        //MARK: - Upload post Details to firebase database
        newPostReference.setValue(["Sender": senderName, "PhotoURL": photoURL,"ReportType": reportType, "GPS": gpsLat + "/" + gpsLon, "Time": TH.currentTimeString(), "CarNumber": carNumberTextField.text!, "LocationDescription": locationDescriptionTextField.text!, "Note": noteTextField.text!, "Key": newPostID], withCompletionBlock: {
            
            (error,ref) in
            
            if error != nil{
                print("We have error")
                return
            }
            
            print("Upload post Details Success!")
            
        })
        
    }
    
    
    func currentTimeString() -> String {
        
        //current time in String
        let date = Date()
        let calendar = Calendar.current
        let hour = String(calendar.component(.hour, from: date))
        let minutes = String(calendar.component(.minute, from: date))
        let seconds = String(calendar.component(.second, from: date))
        
        let time = (hour  + ":" + minutes + ":" + seconds)
        
        return time
        
    }
    
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
   
        //noteTextField.isEnabled = false
        
        
        
        
        let selectedImage = self.pictureImageView.image
        
        if let profileImg = selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
            
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: "gs://f1db-1b00c.appspot.com").child("images").child(photoIdString)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil{
                    return
                }
                
                let photoURL =  metadata?.downloadURL()?.absoluteString
                self.sendToDatabase(photoURL: photoURL!)
                
                self.navigationController?.popViewController(animated: true)
                
            })
            
        }
            
        else{
            
            print("ERROR, cant upload image")
        }
        
        //     noteTextField.endEditing(true)
        //     noteTextField.isEnabled = false
        //     postButton.isEnabled = false
        //
        //
        //    self.noteTextField.isEnabled = true
        //    self.noteTextField.text = ""
        //
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
    
    // MARK: - By clicking on the camera icon allows the user to take a picture , that picture replace the camera icon and upload to the server
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        
        print("cameraPressed")
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            pictureImageView.image = userPickedImage
            
            self.cameraButton.isHidden = true
            
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
}











////////////////////////////////////////////////////////////////////////////
//logoImageVIew.layer.cornerRadius = logoImageVIew.frame.height / 2.0
//        logoImageVIew.layer.masksToBounds = true
//        logoImageVIew.layer.borderWidth = 2
//        logoImageVIew.layer.borderColor = UIColor.white.cgColor
////////////////////////////////////////////////////////////////////////////






