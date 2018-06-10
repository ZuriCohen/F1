



import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ChameleonFramework
import UserNotifications

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{//, UICollectionViewDataSource{
    
    let homeUser = UserC.singletonUser
    
    let homePark = Park.singletonPark
    
    @IBOutlet weak var tempLabel: UILabel! //TODO:delete
    
    
    enum ReportTypes: String {
        case Lights
        case Blocker
        case Policeman
    }
    
    var reportType = ""
    
    @IBOutlet weak var reportButton: UIButton!
    
    
    var timer = Timer()
    
    var backgroundTask = BackgroundTask()
    
    var bgt =  BGT()
    var timer2 = Timer()
    
    @IBOutlet weak var messageTableView: UITableView!
    
    var reportsArray : [Report] = [Report]()
    
    let TH = TimeHandler()
    
    let LH = LocationHandler()
    
    
    // MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempLabel.text = homeUser.carNumber
        
        notificationPermissions() //Requesting permissions for popup notifications
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // Xib file (ReportCell) registeretion
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
        
        reportButton.backgroundColor = UIColor.clear
        

        
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
    
    override func viewDidAppear(_ animated: Bool) {
        print("loop was sterted!!!!!!!!!!!!!")
        
        
        startBackground()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("loop stop!!!!!!!!!!!!!")
        cancelBackground()
    }
    
    func startBackground(){//TODO: Change to a logical function name
        
        self.backgroundTask.startBackgroundTask()
        self.timer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        
        self.bgt.startBackgroundTask()
        self.timer2 = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.ifEventInterestTheUser), userInfo: nil, repeats: true)
    }
    
    func cancelBackground(){//TODO: Change to a logical function name
        print("cancel - stopBackgroundTask")
        self.timer.invalidate()
        self.backgroundTask.stopBackgroundTask()
    }
    
    
    // MARK: - table view Method 1 [cell for row at index path]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        //MARK: - Cell outputs // [sender , note , location , carsDescription , time, picture]
        
//        cell.messageBackground.layer.borderWidth = 2 // UI
//        cell.messageBackground.layer.borderColor = UIColor.white.cgColor//UI
        
        
//        cell.senderUsername.text = reportsArray[indexPath.row].sender
        
//        cell.time.text = reportsArray[indexPath.row].time
        
//        cell.messageBody.text = reportsArray[indexPath.row].note
        
        //Only when there is an image attached to the report The server requests the appropriate image
        
       //$if reportsArray[indexPath.row].hasImage == "true" {

            let storage = Storage.storage().reference()
            let tempImageRef = storage.child("reportImages/\(reportsArray[indexPath.row].ID)")
            tempImageRef.getData(maxSize: 1*10000*10000) { (data, error) in

                if error == nil {
                    print(data!)
//                    cell.avatarImageView.image = UIImage(data: data!)
                }else{
                    print("------------------------- error dounland ---------------------------")
                    print(error)
                }

            }

       // }
        
        
//        cell.typeImage.image = UIImage(named: "people (1)")
        
        cell.layoutMargins.top = 70 // not working
        
        let key = reportsArray[indexPath.row].ID
        
        var index = indexPath.row
        
        //MARK: - This section visually shows the time passed from the report
        
        //Calculates the time passed from the report
        let realTime = TH.currentTimeString()
        var t1 = TH.StringToIntTimeInMinut(myString: realTime)
        var t2 = TH.StringToIntTimeInMinut(myString: "")//cell.time.text!)
        var timeLeft = t1 - t2
        
        
//        print ("---------------\(reportsArray.count)------------")
        
        switch timeLeft {//Changes color according to time
            
        
        
        case 0..<2:
            //cell.messageBackground.backgroundColor = UIColor.blue
            
//            cell.messageBackground.backgroundColor = UIColor(red: 0.57, green: 0.61, blue: 0.66, alpha: 1.0)
            break
            
        case 3..<5:
 //           cell.messageBackground.backgroundColor = UIColor.brown
            break
        
        case 6..<49:
//            cell.messageBackground.backgroundColor = UIColor(red: 0.57, green: 0.61, blue: 0.66, alpha: 0.2)
            //cell.messageBackground.backgroundColor = UIColor.red
            print("indexPath \(indexPath.row)")
            //reportsArray.remove(at: indexPath.row)
            break
            
        case 50..<60://remove from firebase
            print("case 11..<60")
            FirebaseDatabase.Database.database().reference(withPath: "Reports").child(key).removeValue()
            
            reportsArray.remove(at: index)
            break
            
            
        default:
            
            print("default")
            
        }
        
        return cell
        
    }
    
    // MARK: - table view Method 2 [number Of Rows In Section]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reportsArray.count
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - configureTableView Method - Declare the  cell constraints
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension // Adjusts cell size to the text (like wrap_content in android)
        messageTableView.estimatedRowHeight = 50.0
        
        
        //messageTableView. //layoutMargins.bottom = 50
        
    }
    
    // MARK: - Log Out Method
    
    @IBAction func logoutBarButtonPressed(_ sender: UIBarButtonItem) {
        
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true) // go to WelcomeViewController (root)
            
        }
        catch {
            print("error: there was a problem logging out")
        }
        
    }
    
    
    
    // MARK: - retrieve Messages Method - get data from Firebase DB to reportsArray model
    
    func retrieveMessages() {
        
        
        let messageDB = Database.database().reference().child("Reports")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            
        
            let ID = snapshot.key
            let text = snapshotValue["Note"]!
            let sender = snapshotValue["Sender"]!
            let time = snapshotValue["Time"]!
            let gps = snapshotValue["GPS"]!
            let locationDescription = snapshotValue["locationDescription"]!
            let type = snapshotValue["Type"]!
            let carNumber = snapshotValue["carNumber"]!
            
            //if snapshotValue["hasImage"] != nil{
                
            let hasImage = snapshotValue["hasImage"]!
            //}
            
            
            let report = Report()
            
            report.ID = ID
            report.locationGPS = gps
            report.locationDescription = locationDescription
            report.note = text
            report.sender = sender
            report.time = time
            report.type = type
            report.carNumber = carNumber
         
     
            report.hasImage = hasImage
                
    
            if report.checked == false {

//                self.reportClassifier(myReport: report)
               
            }
            
            self.reportsArray.append(report) // add an new report to reports array
            
            self.configureTableView()
            
            self.messageTableView.reloadData()
            
        }
    }
    
    
    
    @IBAction func reportButtonPressed(_ sender: AnyObject) {
        
        print("reportButtonPressed")
        
   ///////////////////////////////////////////////////////////////////////////////////////////////////
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
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        
    }
    
    
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
    
    // MARK: - Background task [When starting a background job, need to confirm in "capabilities" -> "background modes"]
    
    @objc func timerAction() {
        //            let date = Date()//TODO: replace to timeHandler
        //            let calendar = Calendar.current
        //            let components = (calendar as NSCalendar).components([ .hour, .minute, .second], from: date)
        //            let hour = components.hour
        //            let minutes = components.minute
        //            let seconds = components.second
        //             let realTime = "\(hour ?? 0):\(minutes ?? 0):\(seconds ?? 0)"
        //             print(realTime)
        
        //print = "\(hour ?? 0):\(minutes ?? 0):\(seconds ?? 0)")
        print("Task 1 is Running...")
        self.messageTableView.reloadData()
        
        
    }
    
    @objc func ifEventInterestTheUser() {
        
        print("Task 2 is Running...")
        
        //retrieveMessages()
        
    }
    
    // reportClassifier function goal is to separat reports that do not interest the user
    // And alert to the user only the important reports
    
    func reportClassifier(myReport: Report){
        
        // TODO: delete temp - [my home 32.111255/35.033274] [yael's home 32.087586/34.888388]  [oranit 32.131003/34.991366] [elkana 32.109910/35.035463]
        //reportsArray[0].locationGPS  myPark.locationGPS
        //var distance = LH.stringLocationToIntLonLat(reportLocation: "32.111255/35.033274" , parkLocation: "32.109910/35.035463")//Returns the  distance in K.M
        
        myReport.checked = true
        
        print("--------------------Classifier start----------------------")
        
        
        myReport.toString()
        
        //In case of a report on leaving lights on or vehicle blocking
        //Checks if the vehicle number reported matches the vehicle number of the user
        
        if (myReport.type == "Lights") || (myReport.type == "Blocker"){
            
            if(homeUser.carNumber == myReport.carNumber){
                
                
                interestingTheUserEventNotification(inSeconds: 1) { (success) in
                    if success {
                        print("Successfully Notified")
                    }
                    else{
                        print("Failed Notified")
                    }
                    
                }
                
            }
            
            
        }
            
            
            //In case the report is about a policeman
            //Checks the distance between the parking location and the reporting location
            
        else if (myReport.type == "Policeman"){
            
            var distance = LH.stringLocationToIntLonLat(reportLocation: (myReport.locationGPS), parkLocation: homePark.locationGPS)
            
            if (distance <= 0.5){
                
                interestingTheUserEventNotification(inSeconds: 1) { (success) in
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "feedToReport"{
            
            let Repo: ReportViewController = segue.destination  as! ReportViewController
            
            Repo.reportType = self.reportType
            
            ///////////////////////////
            
//            for User in userArray {
//
//                if  Auth.auth().currentUser?.email == User.email{
//
//                    Repo.senderName = User.name
//
//                }
//
//            }
            
            ///////////////////////////////
            
        }
        
        
    }
    
}



























