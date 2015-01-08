import bigints
import math

const smallprimes* = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
                      43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
                      101, 103, 107, 109, 113, 127, 131, 137, 139, 149,
                      151, 157, 163, 167, 173, 179, 181, 191, 193, 197,
                      199, 211, 223, 227, 229, 233, 239, 241, 251, 257,
                      263, 269, 271, 277, 281, 283, 293, 307, 311, 313,
                      317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
                      383, 389, 397, 401, 409, 419, 421, 431, 433, 439,
                      443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
                      503, 509, 521, 523, 541, 547, 557, 563, 569, 571,
                      577, 587, 593, 599, 601, 607, 613, 617, 619, 631,
                      641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
                      701, 709, 719, 727, 733, 739, 743, 751, 757, 761,
                      769, 773, 787, 797, 809, 811, 821, 823, 827, 829,
                      839, 853, 857, 859, 863, 877, 881, 883, 887, 907,
                      911, 919, 929, 937, 941, 947, 953, 967, 971, 977,
                      983, 991, 997, 1009, 1013, 1019, 1021, 1031, 1033,
                      1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093,
                      1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153, 1163,
                      1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229]

proc reduce[U, V](fn: proc(a: V, b: U): V, s: openArray[U], z: V): V =
  result = z
  for i in 0..s.high:
    result = fn(result, s[i])

proc modular_exp(base, exponent, modulus: BigInt): BigInt =
  ## Raise base to exponent, reducing by modulus
  assert exponent >= 0
  var e = exponent
  var b = base
  result = initBigInt(1)
  while e > 0:
    if e mod 2 == 1:
      result = (result * b) mod modulus
    e = e div 2
    b = (b.pow 2) mod modulus

proc polynomial_reduce_mod(poly, polymod, p): int =
  ## Reduce poly by polymod, integer arithmetic modulo p
  ##
  ## Polynomials are represented as lists of coefficients of increasing powers
  ## of x.
  assert polymod[-1] == 1
  assert len(polymod) > 1

  while len(poly) >= len(polymod):
    if poly[-1] != 0:
      for i in countup(2, len(polymod) + 1):
        poly[-i] = (poly[-i] - poly[-1] * polymod[-i]) mod p
    poly = poly[0..poly.high]
  return poly

proc inverse_mod*(a, m): int =
  ## Inverse of a mod m
  var
    a = a
    b = m
    x = 0
  result = 1
  while a > 1:
    let q = a div b
    a = a mod b
    swap a, b
    result = result - q * x
    swap x, result
  if result < 0:
    result += m

proc gcd2(a: int, b: int): int =
  ## Greatest common divisor using Euclid's algorithm
  var tmp_a = 0
  var a = a
  var b = b
  while a != 0:
    tmp_a = a
    a = b mod a
    b = tmp_a
  return abs(b)

proc gcd*(a: varargs[int]): int =
  ## Greatest common divisor
  return reduce(gcd2, a, a[0])

proc lcm2(a: int, b: int): int =
  ## Least common multiple of 2 integers
  return int((a * b) / gcd(a, b))

proc lcm*(a: varargs[int]): int =
  ## Least common multiple
  return reduce(lcm2, a, a[0])

proc order_mod(x, m): int =
  ## Return the order of x in the multiplicative group mod m
  if m <= 1:
    return 0

  assert gcd(x, m) == 1

  var z = x
  result = 1
  while z != 1:
    z = (z * x) mod m
    result += 1
  return result

proc largest_factor_relatively_prime(a, b): int =
  while 1:
    var d = gcd(a, b)
    if d <= 1:
      break
    var b = d
    while 1:
      var q = a div d
      var r = a mod d
      if r > 0:
        break
      var a = q
  return a

proc kinda_order_mod(x, m): int =
  return order_mod(x, largest_factor_relatively_prime(m, x))

proc isprime*(n): bool =
  ## Returns whether x is prime
  ##
  ## Uses the Miller-Rabin test, as given in Menezes et al. p. 138.
  ## This test is not exact: there are composite values n for which
  ## it returns true.

  if n <= smallprimes[smallprimes.high]:
    if n in smallprimes:
      return true
    else:
      return false

  if gcd(n, 2*3*5*7*11) != 1:
    return false

  # Choose a number of iterations sufficient to reduce the
  # probability of accepting a composite below 2**-80
  # (from Menezes et al. Table 4.4)
  var t = 40
  var n_bits = 1 + int(math.log2(float(n)))
  const prime_constants = [[100, 27],
                           [150, 18],
                           [200, 15],
                           [250, 12],
                           [300, 9],
                           [350, 8],
                           [400, 7],
                           [450, 6],
                           [550, 5],
                           [650, 4],
                           [850, 3],
                           [1300, 2]]
  for prime_const_pair in prime_constants:
    let k = prime_const_pair[0]
    let tt = prime_const_pair[1]
    if n_bits < k:
      break
    t = tt

  # Run the test t times:

  var s = 0
  var r = n - 1
  while r mod 2 == 0:
    s += 1
    r = r div 2
  for i in countup(0, t):
    let a = smallprimes[i]
    var y = modular_exp(initBigInt(a), initBigInt(r), initBigInt(n))
    if y != initBigInt(1) and y != initBigInt(n-1):
      var j = 1
      while j <= s-1 and y != initBigInt(n-1):
        y = modular_exp(y, initBigInt(2), initBigInt(n))
        if y == 1:
          return false
        j += 1
      if y != initBigInt(n-1):
        return false
  return true

proc next_prime*(start: int): int =
  ## Return the smallest prime larger than the starting value
  if start < 2:
    return 2
  result = (start + 1) or 1
  while not isprime(result):
    result += 2

proc factorization*(n: int): seq[tuple[prime, exponent: int]] =
  var n = n
  if n < 2:
    return nil

  var d = 2
  result = @[]

  # Test the small primes
  for d in smallprimes:
    if d > n:
      break
    var q = n div d
    var r = n mod d
    if r == 0:
      var count = 1
      while d <= n:
        n = q
        q = n div d
        r = n mod d
        if r != 0:
          break
        count += 1
      result.add((d, count))

  # If n is still greater than the last of our small primes,
  # then it may require further work
  if n > smallprimes[smallprimes.high]:
    if isprime(n):
      result.add((d, 1))
    else:
      d = smallprimes[smallprimes.high]
      while true:
        d += 2
        var q = n div d
        var r = n mod d
        if q < d:
          break
        if r == 0:
          var count = 1
          n = q
          while d <= n:
            q = n div d
            r = n mod d
            if r != 0:
              break
            n = q
            count += 1
          result.add((d, count))
      if n > 1:
        result.add((n, 1))
  return result
