import UIKit
class GestureViewController: UIViewController {
    var dollarPGestureRecognizer: DollarPGestureRecognizer
    @IBOutlet var gestureView: GestureView
    @IBOutlet var resultLabel: UILabel
    @IBOutlet var recognizeButton: UIBarButtonItem
    var recognized: Bool

    @IBAction func recognize(sender: AnyObject) {
        if recognized {
            gestureView.clearAll()
            resultLabel.text = "Draw..."
        }
        else {
            dollarPGestureRecognizer.recognize()
        }
        recognized = !recognized
        recognizeButton.title = recognized ? "Clear" : "Recognize"
        gestureView.userInteractionEnabled = !recognized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dollarPGestureRecognizer = DollarPGestureRecognizer(target: self, action: "gestureRecognized:")
        dollarPGestureRecognizer.pointClouds = DollarDefaultGestures.defaultPointClouds()
        dollarPGestureRecognizer.delaysTouchesEnded = false
        gestureView.addGestureRecognizer(dollarPGestureRecognizer)
    }

    func gestureRecognized(sender: DollarPGestureRecognizer) {
        var result: DollarResult = sender.result()
        resultLabel.text = "Result: \(result.name()) (Score: %.2f)"
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if (segue.identifier() == "CustomizeViewController") {
            var customizeViewController: CustomizeViewController = segue.destinationViewController()
            customizeViewController.gestureRecognizer = dollarPGestureRecognizer
        }
    }
}