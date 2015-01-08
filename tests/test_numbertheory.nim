import unittest
import numbertheory

const bigprimes = [999671,
                   999683,
                   999721,
                   999727,
                   999749,
                   999763,
                   999769,
                   999773,
                   999809,
                   999853,
                   999863,
                   999883,
                   999907,
                   999917,
                   999931,
                   999953,
                   999959,
                   999961,
                   999979,
                   999983]

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

test "Testing is_prime with small primes":
  for prime in smallprimes:
    check:
      isprime(prime)

test "Test is_prime with big primes":
  check:
    isprime(999331)

test "Test is_prime with bigger primes":
  for prime in bigprimes:
    check:
      isprime(prime)

test "Test next_prime with bigger primes":
  for i in 0..bigprimes.high-1:
    check next_prime(bigprimes[i]) == bigprimes[i+1]

test "Test factorization":
  check factorization(1091*977) == @[(977, 1), (1091, 1)]
  check factorization(1091*977*1091) == @[(977, 1), (1091, 2)]

test "Test phi":
  check:
    phi(36) == 12
    phi(99) == 60
    phi(64) == 32

test "Test Jacobi":
  check:
    jacobi(19, 45) == 1
    jacobi(8, 21) == -1
    jacobi(5, 21) == 1
    jacobi(1001, 9907) == -1
