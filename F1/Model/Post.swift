

import Foundation

class Post{
    
    var url: String
    var sender: String
    var note: String
    var time: String
    var locationDescription: String
    var locationGPS: String
    var carNumber: String
    var type: String
    var checked: Bool = false
    
    
    
    init(Url: String, Sender: String, Note: String, Time: String, LocationDescription: String, LocationGPS: String, CarNumber: String, Type: String) {
        
        url = Url
        sender = Sender
        note = Note
        time = Time
        locationDescription = LocationDescription
        locationGPS = LocationGPS
        carNumber = CarNumber
        type = Type
    }
    
    func setChecked(checkedMode: Bool){
        
        checked = checkedMode
  
    }
  
    func toString(){
        
        print(" url: \(url) sender: \(sender) note: \(note) time: \(time) locationGPS: \(locationGPS) locationDescription: ֿֿֿ\(locationDescription) carNumber: \(carNumber) type: \(type)")
    }
}
