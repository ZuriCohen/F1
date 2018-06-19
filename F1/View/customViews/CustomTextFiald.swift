import UIKit
import Foundation

open class CustomTextFiald: UITextField{

    override open func didMoveToWindow() {

        self.layer.cornerRadius = 30
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.clearsOnBeginEditing = true
    }
}




