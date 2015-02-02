import ellipticcurve
import numbertheory
import sha1


type
  Signature = object of RootObj
    r*: int
    s*: int

  Public_key = object of RootObj
    curve*: CurveFp
    generator*: Point
    point*: Point

  Private_key = object of RootObj
    public_key*: Public_key
    secret_multiplier: int


proc int_to_string(x: int): string =
  ## Convert integer x into a string of bytes, as per X9.62.
  assert x >= 0
  if x == 0:
    return $chr(0)
  result = ""
  var x = x
  while x > 0:
    var q = x div 256
    var r = x mod 256
    result = chr(r) & result
    x = q

proc string_to_int(s: string): int =
  ## Convert a string of bytes into an integer, as per X9.62.
  result = 0
  for c in s:
    result = 256 * result + ord(c)

proc digest_integer(m: int): int =
  ## Convert an integer into a string of bytes, compute its SHA-1 hash, and
  ## convert the result into an integer.
  return string_to_int(sha1.compute(int_to_string(m)).toHex())
