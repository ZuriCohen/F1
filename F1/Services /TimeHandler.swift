

import Foundation

class TimeHandler {
    
    func currentTimeString() -> String { //current time in String (hours miutes and seconds)
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([ .hour, .minute, .second], from: date)
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        let time = "\(hour ?? 0):\(minutes ?? 0):\(seconds ?? 0)"
        
        return time
    }
    
    //The function converts time from string to Int and from hours and minutes to minutes -  more 
    func StringToIntTimeInMinut(myString: String) -> Int {
        
        var myStringArr = myString.components(separatedBy: ":")
//        print("test")
//        print(myStringArr[0])
//        print(myStringArr[1])
//        print(myStringArr[2])
        
        var intTimeInMinut = (Int(myStringArr[0])! * 60) + Int(myStringArr[1])!
        
        return intTimeInMinut
    }
    
    func temp(TimeInMinut: Int) -> Int {
        
        var  hour =  TimeInMinut / 60
         var  minutes =  TimeInMinut % 60
        
        return 2 // temp
    }
    
}

//the old version of currentTimeString() function
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = String(calendar.component(.hour, from: date))
//        let minutes = String(calendar.component(.minute, from: date))
//        let seconds = String(calendar.component(.second, from: date))
//
//        let time = (hour  + ":" + minutes + ":" + seconds)
//
//        return time


