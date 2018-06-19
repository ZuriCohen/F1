

class Park: Codable{
    
    var time : String = ""
    var locationGPS : String = ""
    var locationDescription : String = ""
    var duration : Int = 2
    var status : Bool = false
    
    static let singletonPark = Park()
    
    
    func toString(){
        
        print("--PARK-- time: \(time) locationGPS: \(locationGPS) locationDescription: ֿֿֿ\(locationDescription) parkingTime: \(duration) status: \(status)")
    }
}



