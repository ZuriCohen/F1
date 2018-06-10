

import UIKit
import Foundation

open class CustomImage: UIImageView{
    
    override open func didMoveToWindow() {
 
    self.layer.cornerRadius = self.frame.height / 2.0
    self.layer.masksToBounds = true
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.white.cgColor

    }
}
