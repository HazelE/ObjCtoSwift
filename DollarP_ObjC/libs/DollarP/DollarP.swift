import Foundation
    let DollarPNumPoints: Int

class DollarP: NSObject {

    convenience override init() {
        self.init()
        pointClouds = NSMutableArray()
    }

    func recognize(points: [AnyObject]) -> DollarResult {
        var result: DollarResult = DollarResult()
        result.name = "No match"
        result.score = 0.0
        if points.count == 0 {
            return result
        }
        points = self.self.resample(points, numPoints: DollarPNumPoints)
        points = self.self.scale(points)
        points = self.self.translate(points, to: DollarPoint.origin())
        
        var b: Float = +INFINITY
        var u: Int = -1
        for var i = 0; i < self.pointClouds().count; i++ {
            var d: Float = self.self.greedyCloudMatch(points, template: self.pointClouds()[i].points())
            if d < b {
                b = d
                u = i
            }
        }
        if u != -1 {
            result.name = self.pointClouds()[u].name()
            result.score = max((b - 2.0) / -2.0, 0.0)
        }
        return result
    }

    func setPointClouds(somePointClouds: [AnyObject]) {
        pointClouds = somePointClouds.mutableCopy()
    }

    func addGesture(name: String, points: [AnyObject]) {
        var pointCloud: DollarPointCloud = DollarPointCloud(name: name, points: points)
        self.pointClouds().append(pointCloud)
    }

    class func greedyCloudMatch(points: [AnyObject], template: [AnyObject]) -> Float {
        var e: Float = 0.50
        var step: Float = floor(pow(points.count, 1 - e))
        var min: Float = +INFINITY
        
        for var i = 0; i < points.count; i += step {
            var d1: Float = self.cloudDistanceFrom(points, to: template, start: i)
            var d2: Float = self.cloudDistanceFrom(template, to: points, start: i)
            min = min(min, min(d1, d2))
        }
        return min
    }

    class func cloudDistanceFrom(points1: [AnyObject], to points2: [AnyObject], start: Int) -> Float {
        var numPoints1: Int = points1.count
        var numPoints2: Int = points2.count
        var matched: [AnyObject] = [AnyObject](minimumCapacity: numPoints1)
        for var k = 0; k < numPoints1; k++ {
            matched[k] =
        }
        var sum: Float = 0.0
        var i: Int = start
        repeat {
            var index: Int = -1
            var min: Float = 

    }

    class func INFINITY() {
        for var j = 0; j < matched.count; j++ {
            if !CBool(matched[j])! {
                if i < numPoints1 && j < numPoints2 {
                    var d: Float = self.distanceFrom(points1[i], to: points2[j])
                    if d < min {
                        min = d
                        index = j
                    }
                }
            }
        }
        if index > -1 {
            matched[index] =
        }
        var weight: Float = 1.0 - Float((i - start + numPoints1) % numPoints1) / numPoints1
        sum += weight * min
        i = (i + 1) % numPoints1
    }
    func () {
            var sum: 
    }

    class func resample(points: [AnyObject], numPoints: Int) -> [AnyObject] {
        var I: Float = self.pathLength(points) / (numPoints - 1)
        var D: Float = 0.0
        var thePoints: [AnyObject] = points.mutableCopy()
        var newPoints: [AnyObject] = [thePoints[0]]
        for var i = 1; i < thePoints.count; i++ {
            var prevPoint: DollarPoint = thePoints[i - 1]
            var thisPoint: DollarPoint = thePoints[i]
            if thisPoint.id() == prevPoint.id() {
                var d: Float = self.distanceFrom(prevPoint, to: thisPoint)
                if (D + d) >= I {
                    var qx: Float = prevPoint.x() + ((I - D) / d) * (thisPoint.x() - prevPoint.x())
                    var qy: Float = prevPoint.y() + ((I - D) / d) * (thisPoint.y() - prevPoint.y())
                    var q: DollarPoint = DollarPoint(id: thisPoint.id(), x: qx, y: qy)
                    newPoints.append(q)
                    thePoints.insertObject(q, atIndex: i)
                    D = 0.0
                }
                else {
                    D += d
                }
            }
        }
        if newPoints.count == numPoints - 1 {
            var lastPoint: DollarPoint = thePoints[thePoints.count - 1]
            newPoints.append(lastPoint.copy())
        }
        return newPoints
    }

    class func scale(points: [AnyObject]) -> [AnyObject] {
        var minX: Float = 
    }

    class func INFINITY() {
        var maxX: Float = -.infinity
        var minY: Float = 
    }

    class func INFINITY() {
        var maxY: Float = -.infinity
        var thisPoint: DollarPoint
        for var i = 0; i < points.count; i++ {
            thisPoint = points[i]
            minX = min(minX, thisPoint.x())
            minY = min(minY, thisPoint.y())
            maxX = max(maxX, thisPoint.x())
            maxY = max(maxY, thisPoint.y())
        }
        var size: Float = max(maxX - minX, maxY - minY)
        var newPoints: [AnyObject] = NSMutableArray()
        for var i = 0; i < points.count; i++ {
            thisPoint = points[i]
            var qx: Float = (thisPoint.x() - minX) / size
            var qy: Float = (thisPoint.y() - minY) / size
            var q: DollarPoint = DollarPoint(id: thisPoint.id(), x: qx, y: qy)
            newPoints.append(q)
        }
        return newPoints
    }

    class func translate(points: [AnyObject], to point: DollarPoint) -> [AnyObject] {
        var c: DollarPoint = self.self.centroid(points)
        var newPoints: [AnyObject] = NSMutableArray()
        for var i = 0; i < points.count; i++ {
            var thisPoint: DollarPoint = points[i]
            var qx: Float = thisPoint.x() + point.x() - c.x()
            var qy: Float = thisPoint.y() + point.y() - c.y()
            var q: DollarPoint = DollarPoint(id: thisPoint.id(), x: qx, y: qy)
            newPoints.append(q)
        }
        return newPoints
    }

    class func centroid(points: [AnyObject]) -> DollarPoint {
        var x: Float = 0.0
        var y: Float = 0.0
        for var i = 0; i < points.count; i++ {
            var thisPoint: DollarPoint = points[i]
            x += thisPoint.x()
            y += thisPoint.y()
        }
        x /= points.count
        y /= points.count
        return DollarPoint(id: 0, x: x, y: y)
    }

    class func pathDistanceFrom(points1: [AnyObject], to points2: [AnyObject]) -> Float {
        var d: Float = 0.0
        for var i = 0; i < points1.count; i++ {
            d += self.distanceFrom(points1[i], to: points2[i])
        }
        return d / points1.count
    }

    class func pathLength(points: [AnyObject]) -> Float {
        var d: Float = 0.0
        for var i = 1; i < points.count; i++ {
            var prevPoint: DollarPoint = points[i - 1]
            var thisPoint: DollarPoint = points[i]
            if thisPoint.id() == prevPoint.id() {
                d += self.distanceFrom(prevPoint, to: thisPoint)
            }
        }
        return d
    }

    class func distanceFrom(point1: DollarPoint, to point2: DollarPoint) -> Float {
        var dx: Float = point2.x() - point1.x()
        var dy: Float = point2.y() - point1.y()
        return sqrt(dx * dx + dy * dy)
    }
}
func () {
    NSMutableArray * pointClouds
}

func () {
}

func () {
    var numPoints: points
}

func () {
        (points as! [AnyObject])
}

func () {
}

func () {
    var to: points
    -
}

func () {
        (points as! [AnyObject])
    -
    var addGesture
    var points: name
}

let DollarPNumPoints: Int = 32