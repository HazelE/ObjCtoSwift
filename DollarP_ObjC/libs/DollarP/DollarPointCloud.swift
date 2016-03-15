import Foundation
class DollarPointCloud: NSObject {
    var name: String
    var points: [AnyObject]

    convenience override init(name aName: String, points somePoints: [AnyObject]) {
        self.init()
        self.name = aName
            somePoints = DollarP.resample(somePoints, numPoints: DollarPNumPoints)
            somePoints = DollarP.scale(somePoints)
            somePoints = DollarP.translate(somePoints, to: DollarPoint.origin())
            self.points = somePoints
    }
}