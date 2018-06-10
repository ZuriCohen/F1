

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var textTextView: UITextView!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    @IBOutlet weak var senderLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //override open func didMoveToWindow() {
            
            //self.layer.cornerRadius = 40
            self.layer.borderWidth = 4
            self.layer.borderColor = UIColor.white.cgColor
            
        //}
    }

}
