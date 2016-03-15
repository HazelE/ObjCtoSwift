import UIKit
class TemplatesViewController: UIViewController {
    
    
    @IBOutlet var imageView:  UIImageView!

    @IBAction func gotoWebsite(sender: AnyObject) {
        let url = NSURL(string: "http://depts.washington.edu/aimgroup/proj/dollar/pdollar.html")
        UIApplication.sharedApplication().openURL(url!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView {
        return imageView
    }
}