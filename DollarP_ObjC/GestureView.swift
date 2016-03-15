import Foundation
class GestureView: UIView {
    var currentTouches: [NSObject : AnyObject]
    var completeStrokes: [AnyObject]

    func clearAll() {
        completeStrokes.removeAllObjects()
        currentTouches.removeAllObjects()
        self.setNeedsDisplay()
    }

    convenience override init(frame: CGRect) {
        self.init(frame: frame)
        self.setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    func setup() {
        currentTouches = [NSObject : AnyObject]()
        completeStrokes = NSMutableArray()
        self.backgroundColor = UIColor.whiteColor()
        self.multipleTouchEnabled = true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        for touch: UITouch in touches {
            var key: NSValue = NSValue(nonretainedObject: touch)
            var location: CGPoint = touch.locationInView(self)
            var stroke: Stroke = Stroke()
            stroke.points = [NSValue(CGPoint: location)]
            stroke.color = UIColor.blackColor()
            currentTouches[key] = stroke
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        for touch: UITouch in touches {
            var key: NSValue = NSValue(nonretainedObject: touch)
            var points: [AnyObject] = (currentTouches[key] as! [AnyObject]).points()
            var location: CGPoint = touch.locationInView(self)
            points.append(NSValue(CGPoint: location))
        }
        self.setNeedsDisplay()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        self.endTouches(touches)
    }

    func touchesCancelled(touches: Set<AnyObject>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        self.endTouches(touches)
    }

    func endTouches(touches: Set<AnyObject>) {
        for touch: UITouch in touches {
            var key: NSValue = NSValue(nonretainedObject: touch)
            var stroke: Stroke = (currentTouches[key] as! Stroke)
            stroke.color = self.randomColor()
            if stroke != nil {
                completeStrokes.append(stroke)
                currentTouches.removeObjectForKey(key)
            }
        }
        self.setNeedsDisplay()
    }

    func drawRect(rect: CGRect) {
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 5.0)
        CGContextSetLineCap(context, kCGLineCapRound)
        for var i = 0; i < completeStrokes.count; i++ {
            var stroke: Stroke = completeStrokes[i]
            self.drawStroke(stroke, inContext: context)
        }
        for touchValue: NSValue in currentTouches {
            var stroke: Stroke = (currentTouches[touchValue] as! Stroke)
            self.drawStroke(stroke, inContext: context)
        }
    }

    func drawStroke(stroke: Stroke, inContext context: CGContextRef) {
        stroke.color().set()
        var points: [AnyObject] = stroke.points()
        var point: CGPoint = points[0].CGPointValue
        CGContextFillRect(context, CGRectMake(point.x - 5, point.y - 5, 10, 10))
        CGContextMoveToPoint(context, point.x, point.y)
        for var i = 1; i < points.count; i++ {
            point = points[i].CGPointValue
            CGContextAddLineToPoint(context, point.x, point.y)
        }
        CGContextStrokePath(context)
    }

    func randomColor() -> UIColor {
        var hue: CGFloat = (arc4random() % 256 / 256.0)
        var saturation: CGFloat = (arc4random() % 128 / 256.0) + 0.5
        var brightness: CGFloat = (arc4random() % 128 / 256.0) + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
class Stroke: NSObject {
    var points: [AnyObject]
    var color: UIColor
}