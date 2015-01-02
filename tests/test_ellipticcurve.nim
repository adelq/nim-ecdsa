import unittest
import ellipticcurve

proc test_add(c, x1, y1, x2, y2, x3, y3) =
  var p1 = Point(curve: c, x: x1, y: y1)
  var p2 = Point(curve: c, x: x2, y: y2)
  var p3 = p1 + p2

  if p3.x != x3 or p3.y != y3:
    echo("Failure")
  else:
    echo("Success")

var c = CurveFp(p: 23, a: 1, b: 1)
test_add(c, 3, 10, 9, 7, 17, 20)
