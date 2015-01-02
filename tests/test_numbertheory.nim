import unittest
import numbertheory

test "Testing gcd":
  check:
    gcd(3*5*7, 3*5*11, 3*5*13) == 3*5
    gcd([3*5*7, 3*5*11, 3*5*13]) == 3*5
    gcd(3) == 3

test "Testing lcm":
  check:
    lcm(3, 5*3, 7*3) == 3*5*7
    lcm([3, 5*3, 7*3]) == 3*5*7
    lcm(3) == 3

test "Testing inverse modulo":
  check inverse_mod(42, 2017) == 1969
