import UIKit
class CustomizeViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet var existingTypesPicker: UIPickerView
    @IBOutlet var customTypeField: UITextField
    var pointCloudNames: [AnyObject]
    var pointCloudCount: NSCountedSet

    var gestureRecognizer: DollarPGestureRecognizer

    @IBAction func addToExistingType(sender: AnyObject) {
        var selectedRowIndex: Int = existingTypesPicker.selectedRowInComponent(0)
        var selectedName: String = pointCloudNames[selectedRowIndex]
        self.addGesture(selectedName)
        self.navigationController().popViewControllerAnimated(true)
    }

    @IBAction func addToCustomType(sender: AnyObject) {
        var customType: String = customTypeField.text()
        if customType.characters.count == 0 {
            return
        }
        self.addGesture(customType)
        self.navigationController().popViewControllerAnimated(true)
    }

    @IBAction func deleteAllCustomTypes(sender: AnyObject) {
        gestureRecognizer.pointClouds = DollarDefaultGestures.defaultPointClouds()
        self.updatePointCloudNames()
        existingTypesPicker.reloadAllComponents()
        self.navigationController().popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePointCloudNames()
        existingTypesPicker.delegate = self
        existingTypesPicker.dataSource = self
        existingTypesPicker.selectRow(self.selectedTypeIndex(), inComponent: 0, animated: true)
        customTypeField.delegate = self
    }

    func updatePointCloudNames() {
        pointCloudNames = NSMutableArray()
        pointCloudCount = NSCountedSet()
        for pointCloud: AnyObject in gestureRecognizer.pointClouds() {
            if !pointCloudNames.containsObject(pointCloud.name()) {
                pointCloudNames.append(pointCloud.name())
            }
            pointCloudCount.append(pointCloud.name())
        }
    }

    func selectedTypeIndex() -> Int {
        var index: Int = pointCloudNames.indexOfObjectPassingTest({(obj: AnyObject, idx: Int, stop: Bool) -> BOOL in
                return (obj! == gestureRecognizer.result().name())
            })
        if index != NSNotFound {
            return index
        }
        return 0
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pointCloudNames.count
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView) -> UIView {
        var labelView: UILabel
        if view != nil {
            labelView = (view as! UILabel)
        }
        else {
            labelView = UILabel()
        }
        var label: String = pointCloudNames[row]
        label = label.stringByAppendingString(" (\(pointCloudCount.countForObject(label)))")
        labelView.text = label
        labelView.backgroundColor = UIColor.clearColor()
        labelView.sizeToFit()
        return labelView
    }

    func addGesture(name: String) {
        gestureRecognizer.addGestureWithName(name)
        self.updatePointCloudNames()
        existingTypesPicker.reloadAllComponents()
    }

    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}