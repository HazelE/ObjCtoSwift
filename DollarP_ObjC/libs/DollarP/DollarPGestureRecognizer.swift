import Foundation
import UIKit
class DollarPGestureRecognizer: UIGestureRecognizer {
    var dollarP: DollarP
    var currentTouches: [NSObject : AnyObject]
    var currentPoints: [AnyObject]
    var points: [AnyObject]
    var strokeId: Int

    var pointClouds: [AnyObject] {
        get {
            return dollarP.pointClouds()
        }
        set {
            dollarP.pointClouds = somePointClouds
        }
    }

    var result: DollarResult {
        get {
            return self.result
        }
    }


    func reset() {
        super.reset()
        currentTouches.removeAllObjects()
        currentPoints.removeAllObjects()
        strokeId = 0
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        for touch: UITouch in touches {
            strokeId++
            var key: NSValue = NSValue(nonretainedObject: touch)
            currentTouches[key] = Int(strokeId)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if self.state() == .Failed {
            return
        }
        for touch: UITouch in touches {
            var key: NSValue = NSValue(nonretainedObject: touch)
            var index: Int = CInt((currentTouches[key] as! Int))!
            var location: CGPoint = touch.locationInView(self.view!)
            var point: DollarPoint = DollarPoint(id: index, x: location.x, y: location.y)
            currentPoints.append(point)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
    }

    func touchesCancelled(touches: Set<AnyObject>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        self.state = .Failed
    }

    func recognize() {
        if currentPoints.count == 0 {
            self.state = .Failed
            return
        }
        points = currentPoints.copy()
        if self.state() == .Possible {
            result = dollarP.recognize(points)
            self.state = .Recognized
        }
    }

    func addGestureWithName(name: String) {
        if points.count > 0 {
            dollarP.addGesture(name, points: points)
        }
    }

    func points() -> [AnyObject] {
        return points
    }

    convenience override init(target: AnyObject, action: Selector) {
        self.init(target: target, action: action)
        dollarP = DollarP()
            currentTouches = [NSObject : AnyObject]()
            currentPoints = NSMutableArray()
            points = NSMutableArray()
    }
}