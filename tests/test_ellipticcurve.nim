import unittest
import ellipticcurve

proc test_add(c, x1, y1, x2, y2, x3, y3) =
  var p1 = Point(curve: c, x: x1, y: y1)
  var p2 = Point(curve: c, x: x2, y: y2)
  var p3 = p1 + p2

  test "Test adding":
    check p3.x == x3 and p3.y == y3

proc test_double(c, x1, y1, x3, y3) =
  var p1 = Point(curve: c, x: x1, y: y1)
  var p3 = p1.double

  test "Test doubling":
    check p3.x == x3 and p3.y == y3

proc test_multiply(c, x1, y1, m, x3, y3) =
  var p1 = Point(curve: c, x: x1, y: y1)
  var p3 = p1 * m

  test "Test doubling":
    check p3.x == x3 and p3.y == y3

var c = CurveFp(p: 23, a: 1, b: 1)

test_add(c, 3, 10, 9, 7, 17, 20)
test_double(c, 3, 10, 7, 12)
test_add(c, 3, 10, 3, 10, 7, 12)
test_multiply(c, 3, 10, 2, 7, 12)
