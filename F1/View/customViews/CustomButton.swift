


import UIKit
import Foundation

open class CustomButton: UIButton{

    override open func didMoveToWindow() {
    
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    
}


