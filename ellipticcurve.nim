import numbertheory

type
  CurveFp* = object of RootObj
    p*: int
    a*: int
    b*: int

proc contains_point(curve: CurveFp, x, y: int): bool =
  return (y*y - (x*x*x + curve.a * x + curve.b)) mod curve.p == 0

type
  Point* = object of RootObj
    curve*: CurveFp
    x*: int
    y*: int

proc `+` *(self, other: Point): Point =
  assert self.curve == other.curve

  let
    p = self.curve.p
    l = ((other.y - self.y) * numbertheory.inverse_mod(other.x - self.x, p)) mod p

  let
    x3 = (l*l - self.x - other.x) mod p
    y3 = (l * (self.x - x3) - self.y) mod p

  return Point(curve: self.curve, x: x3, y: y3)

proc double*(self: Point): Point =
  ## Return a new point that is twice the old.
  # X9.62 B.3:

  let p = self.curve.p
  let a = self.curve.a

  let l = ((3 * self.x * self.x + a) * inverse_mod(2 * self.y, p)) mod p

  let x3 = (l * l - 2 * self.x) mod p
  let y3 = (l * (self.x - x3) - self.y) mod p

  return Point(curve: self.curve, x: x3, y: y3)

proc `*` *(self: Point, other: int): Point =
  ## Multiply a point by an integer
  proc leftmost_bit(x: int): int =
    assert x > 0
    result = 1
    while result <= x:
      result = 2 * result
    return result div 2

  var e = other

  # From X9.62 D.3.2:
  var e3 = 3 * e
  var negative_self = Point(curve: self.curve, x: self.x, y: -self.y)
  var i = leftmost_bit(e3) div 2
  result = self
  while i > 1:
    result = result.double
    if (e3 and i) != 0 and (e and i) == 0:
      result = result + self
    if (e3 and i) == 0 and (e and i) != 0:
      result = result + negative_self
    i = i div 2
  return result
