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

proc `+`* (self, other: Point): Point =
  assert self.curve == other.curve

  let
    p = self.curve.p
    l = ((other.y - self.y) * numbertheory.inverse_mod(other.x - self.x, p)) mod p

  let
    x3 = (l*l - self.x - other.x) mod p
    y3 = (l * (self.x - x3) - self.y) mod p

  return Point(curve: self.curve, x: x3, y: y3)
