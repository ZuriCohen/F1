

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ChameleonFramework
import UserNotifications

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var reportImageButton: UIButton!
    
    @IBOutlet weak var feedTableView: UITableView!
    
    
    let customCellNib = UINib(nibName: "CustomPostCell", bundle: nil)//>>
    let reuseIdentifier = "postCell"//>>
    
  
    var currentUser =  User(ID: "", Name: "", Email: "", CarNumber: "000")
    var reportType = ""
    var postsArray = [Post]()
    var usersArray = [User]()
    
    
    enum ReportTypes: String {
        case Lights
        case Blocker
        case Policeman
    }
    
    
    @IBAction func tempForTestButtonPreesd(_ sender: UIButton) {
        
        print("test start ==================================================")
        for i in 0...postsArray.count-1 {
            
            print("post key = \(postsArray[i].key) post index =  \(i)")
            
            for j in 0...postsArray[i].seemsByArray.count-1 {
                
                print("email = \(postsArray[i].seemsByArray[j]) email index =  \(j)")
    
            }
        }
        print("test end ==================================================")
    }
    
    // MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.dataSource = self // Initializing feed table view
        feedTableView.delegate = self // Initializing feed table view
        
        feedTableView.rowHeight = UITableViewAutomaticDimension //>>
        feedTableView.register(customCellNib, forCellReuseIdentifier: reuseIdentifier)//>>
        
       
        loadUsers()  // Load users from firebase database to local array
        loadPosts()  // Load posts from firebase database to local array
        loadPostSeemsBy()
   
    }
    
    // MARK: -
    
    func currentUserInit(user: User){
        
        print("currentUserInit()")
        print(usersArray.count)

            if  Auth.auth().currentUser?.email == user.email{

                currentUser = user
                print(" IF \(currentUser.carNumber)")

            }
            else{
                print("ELSE")
            }
    }
    
    
    
    

    
    // MARK: - Load posts from firebase database to local array
    
    func loadPosts(){
        
        let postsReference = Database.database().reference().child("posts")
        postsReference.observe(.childAdded){(snapshot) in
            
            if let snapshotValue = snapshot.value as? [String: Any]{
                
                let photoURL = snapshotValue["PhotoURL"] as! String
                let postType = snapshotValue["ReportType"] as! String
                let sender = snapshotValue["Sender"] as! String
                let gps = snapshotValue["GPS"] as! String
                let time = snapshotValue["Time"] as! String
                let carNumber = snapshotValue["CarNumber"] as! String
                let locationDescription = snapshotValue["LocationDescription"] as! String
                let note = snapshotValue["Note"] as! String
                let key = snapshotValue["Key"] as! String
                
                
                
                
//                let post = Post(Url: photoURL, Sender: sender, Note: note, Time: time, LocationDescription: locationDescription, LocationGPS: gps, CarNumber: carNumber, Type: postType, Key: key,SeemsByArray: ["xxxx"])
                
                let post = Post(Url: photoURL, Sender: sender, Note: note, Time: time, LocationDescription: locationDescription, LocationGPS: gps, CarNumber: carNumber, Type: postType, Key: key)//,SeemsByArray:SeemsBy)
                
                
                
                self.postsArray.append(post)
                
                self.feedTableView.reloadData()
                
                ////////////////////////
                
                self.loadPostSeemsBy()
                
                var userEmail = Auth.auth().currentUser!.email
                
                if post.seemsByArray.contains(userEmail!){
                    
                    
                }
                else{
                    
                    self.reportsClassifier(newPost: post)
                    
                }
              ///////////////////////////////
            }
            
        }
        
    }
    
    // MARK: - Load users from firebase database to local array
    
    func loadUsers(){
        
        print("loadUsers()")
        
        let userReference = Database.database().reference().child("users")
        userReference.observe(.childAdded){(snapshot) in
            
            if let snapshotValue = snapshot.value as? [String: Any]{
                
                
                let id = snapshotValue["Key"] as! String
                let name = snapshotValue["Name"] as! String
                let email = snapshotValue["Email"] as! String
                let carNumber = snapshotValue["CarNumber"] as! String
                
                let user = User(ID: id, Name: name, Email: email, CarNumber: carNumber)
                
                self.usersArray.append(user)
                
                print(self.usersArray.count)
                
                self.currentUserInit(user: user)
   
            }
            
        }
        
    }
    
    ///////////////////////////////////////////////////////////////////  posts and checks for a new "see post user" add
    
    func loadPostSeemsBy(){
        
        // for post in postsArray {
        
        if postsArray.isEmpty{
            
        }
        else{
            for i in 0...postsArray.count-1  {
                
                let postsReference = Database.database().reference().child("posts").child(postsArray[i].key).child("How see this post")
                //child(postsArray[i].key).child("How see this post")
                
                postsReference.observe(.childAdded){(snapshot) in
                    
                    if let snapshotValue = snapshot.value as? [String: Any]{
                        
                        let newSeePostUserEmail = snapshotValue["Email"] as! String
                        
                        //post.seemsByArray.append(newSeePostUserEmail)
                        //self.postsArray[i].seemsByArray.append(newSeePostUserEmail)
                        
                        self.postsArray[i].seemsByArray.append(newSeePostUserEmail)
                        
                    }
                    
                }
            }
        }
        
    }
    
    ///////////////////////////////////////////////////////////////////////

    
    // MARK: - Reports Classifier
    
    func reportsClassifier(newPost: Post){
        
        //////////////////////////////////////////////////////////Check if the currentUser already see thes post(in the array)
        
//        var userEmail = Auth.auth().currentUser!.email
//
//        if newPost.seemsByArray.contains(userEmail!){
//
//            print("yes")
//        }
//
//        else{
//
//            print("no")
//
//        }
        
        
        ////////////////////////////////////////////////////////// add to firebase that currentUser see the post
        
        
 
       let Reference = Database.database().reference().child("posts").child(newPost.key).child("How see this post").childByAutoId()
        
            Reference.setValue(["Email": currentUser.email], withCompletionBlock: {
                
                (error,ref) in
                
                if error != nil{
                    print("We have error")
                    return
                }
                
                print("saveUserDetailsToFirebase Success!")
                
            })
        
        loadPostSeemsBy()
    
        /////////////////////////////////////////////////////////
        
        
        // TODO: delete temp - [my home 32.111255/35.033274] [yael's home 32.087586/34.888388]  [oranit 32.131003/34.991366] [elkana 32.109910/35.035463]
        //reportsArray[0].locationGPS  myPark.locationGPS
        //var distance = LH.stringLocationToIntLonLat(reportLocation: "32.111255/35.033274" , parkLocation: "32.109910/35.035463")//Returns the  distance in K.M
        
        print("--------------------Classifier start----------------------")
        
        //In case of a report on leaving lights on or vehicle blocking
        //Checks if the vehicle number reported matches the vehicle number of the user
        
        newPost.setChecked(checkedMode: true)
        
        if (newPost.type == "Lights") || (newPost.type == "Blocker"){
            
            print("if 1 \(currentUser.carNumber) <---> \(newPost.carNumber)")
            
            if(currentUser.carNumber == newPost.carNumber){
                                
                
                print("--------------------Classifier if 2----------------------")
                
                Alert.showBasic(title: "Attention!", message: "Someone reported a policeman near the place where you parked", vc: self)
                
                interestingTheUserEventNotification(inSeconds:2) { (success) in
                    if success {
                        print("Successfully Notified")
                    }
                    else{
                        print("Failed Notified")
                    }
                    
                }
                
            }
            
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////
    
    //In case the report is about a policeman
    //Checks the distance between the parking location and the reporting location
    
    //        else if (newPost.type == "Policeman"){
    //
    //            var distance = LH.stringLocationToIntLonLat(reportLocation: (newPost.locationGPS), parkLocation: homePark.locationGPS)
    //
    //            if (distance <= 0.5){
    //
    //                interestingTheUserEventNotification(inSeconds: 1) { (success) in
    //                    if success {
    //                        print("Successfully Notified")
    //                    }
    //                    else{
    //                        print("Failed Notified")
    //                    }
    //
    //                }
    //
    //            }
    //
    //        }
    //
    //    }
    
    //////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Notify to the user about event that relevant relevant
    
    func interestingTheUserEventNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = "Attention!"
        content.subtitle = "Someone reported a policeman near the place where you parked"// TODO: The wording is too long and should be shortened
        content.body = "One of your friend reported a xxxx minutes ago about a policeman who looked about a xxxx meters from where you parked"// TODO: The wording is too long and should be shortened
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
    }
    
    
    // MARK: -  permissions for popUp notifications
    func notificationPermissions(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CustomPostCell
        
        
        var currentPost = postsArray[indexPath.row]
        
        cell.mainLabel.text = currentPost.note
        cell.timeLabel.text = currentPost.time
        cell.senderLabel.text = currentPost.sender
        let targetURL = URL(string: currentPost.url)
        cell.typeImageView.image = imageTypeSelector(correntRepoetType: postsArray[indexPath.row].type)
        
        
       ImageService.getImage(withURL: targetURL!) { image in
            cell.mainImageView.image = image
        }
        
        return cell
    }
    
    func imageTypeSelector(correntRepoetType: String)->UIImage{
        
        switch correntRepoetType {
            
        case "Lights":
            return UIImage(named: "light")!
            break
            
        case "Blocker":
            return UIImage(named: "traffic-signal")!
            break
            
        case "Policeman":
            return UIImage(named: "people (1)")!
            break
            
        default:
            return UIImage(named: "error")!
        }
        
    }
    
    // MARK: - Segue -Sent data to repoet VC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "feedToReport"{
            
            let Repo: ReportViewController = segue.destination  as! ReportViewController
            
            Repo.reportType = self.reportType
            
            for User in usersArray {
                
                if  Auth.auth().currentUser?.email == User.email{
                    
                    Repo.senderName = User.name
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func reportButtonPressed(_ sender: UIButton) {
   
        //Show UI report type
        let imgTitle = UIImage(named:"megaphone (1)")
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle
        
        let alert = UIAlertController(title: "Report", message: "What you would like to report?", preferredStyle: .alert)
        
        
        let lights = UIAlertAction(title: " Someone had forgotten the lights on", style: .default) { (UIAlertAction) in
            
            self.reportType = ReportTypes.Lights.rawValue
            self.performSegue(withIdentifier: "feedToReport", sender: self)
            
        }
        
        let blocker = UIAlertAction(title: "Someone is blocking my car", style: .default) { (UIAlertAction) in
            
            self.reportType = ReportTypes.Blocker.rawValue
            self.performSegue(withIdentifier: "feedToReport", sender: self)
            
        }
        let policeman = UIAlertAction(title: "A policeman dispenses parking tickets", style: .default) { (UIAlertAction) in
            
            self.reportType = ReportTypes.Policeman.rawValue
            self.performSegue(withIdentifier: "feedToReport", sender: self)
            
        }
        let cancel = UIAlertAction(title: "cancel", style: .default) { (UIAlertAction) in
            
            
        }
        
        alert.view.addSubview(imgViewTitle)
        
        
        alert.addAction(lights)
        
        alert.addAction(blocker)
        
        alert.addAction(policeman)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil )
        
    }
    
}































