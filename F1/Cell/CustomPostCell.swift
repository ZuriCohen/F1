
import UIKit

class CustomPostCell: UITableViewCell {
    
    @IBOutlet weak var profoleImageView: UIImageView!
    
    @IBOutlet weak var senderLabel: UILabel!
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
