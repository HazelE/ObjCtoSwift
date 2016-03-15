import Foundation
class DollarPoint: NSObject {
    var x: Float
    var y: Float
    var id: AnyObject

    class func origin() -> DollarPoint {
        var origin: DollarPoint? = nil
        if !origin {
            origin = DollarPoint(id: 0, x: 0.0, y: 0.0)
        }
        return origin!
    }

    convenience override init(id anId: AnyObject, x aX: Float, y aY: Float) {
        self.init()
        self.id = anId
            self.X = aX
            self.Y = aY
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        var point: DollarPoint = DollarPoint()
        point.X = self.x()
        point.Y = self.y()
        point.id = self.id()
        return point
    }

    func description() -> String {
        return "id:\(self.id()) x:\(self.x()) y:\(self.y())"
    }
}