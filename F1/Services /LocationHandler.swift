

import Foundation

class LocationHandler{
    
    
    
    //TODO:  delete temp - gps ,longitude , latitude,  Distance , coordinates ,  [my home 32.111255, 35.033274]   [yael's home 32.087586, 34.888388]
    
    func stringLocationToIntLonLat(reportLocation: String, parkLocation: String ) -> Double {//Returns distance in K.M
        
        var reportLocationArr = reportLocation.components(separatedBy: "/")
        var parkLocationArr = parkLocation.components(separatedBy: "/")
        print("location test")
        
        let  reportLat = Double(reportLocationArr[0])
        let  reportLon = Double(reportLocationArr[1])
        
        let  parkLat = Double(parkLocationArr[0])
        let  parkLon = Double(parkLocationArr[1])

        let latDist = reportLat! - parkLat!
        let lotDist = reportLon! - parkLon!
       
        print("distance = \(sqrt(Double((latDist * latDist) + (lotDist * lotDist)))*100)")
        
        return (sqrt(Double((latDist * latDist) + (lotDist * lotDist))))*100
        
    }
}


