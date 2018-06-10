
import Foundation

class User {
    
    var id: String
    var name: String
    var email: String
    var carNumber: String
    
    //static let singletonUser = User()
    
    init(ID: String, Name: String, Email: String, CarNumber: String) {
        
        id = ID
        name = Name
        email = Email
        carNumber = CarNumber
    }
    
    
}
