import Foundation
import UIKit


//RoundedView is a simple class to create a rounded view for the about me section.
public  class roundedView:UIView{
    
    
    public init(frame: CGRect, cR:CGFloat, cl:UIColor) {
        cornRad = cR
        color = cl
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cornRad: CGFloat = 40.0
    var color:UIColor = UIColor.white
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        
        self.layer.cornerRadius = cornRad
        self.layer.masksToBounds = true
        
    }
    
}
