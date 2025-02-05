/// A utility struct providing mathematical operations used in number theory and cryptography.
public struct MathUtilities {
    
    /// Computes the greatest common divisor (GCD) of two integers using the Euclidean algorithm.
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: The GCD of `a` and `b`.
    public static func gcd(_ a: Int, _ b: Int) -> Int {
        var a: Int = a
        var b: Int = b
        var r: Int
        
        while b != 0 {
            r = a % b
            a = b
            b = r
        }
        return a
    }
    
    /// Computes the extended GCD of two integers.
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: A tuple containing:
    ///   - `gcd`: The GCD of `a` and `b`.
    ///   - `x` and `y`: Coefficients satisfying Bézout's identity (`a * x + b * y = gcd`).
    public static func extendedGCD(a: Int, b: Int) -> (gcd: Int, x: Int, y: Int) {
        if b == 0 {
            return (gcd: a, x: 1, y: 0)
        } else {
            let (gcd, x1, y1) = extendedGCD(a: b, b: a % b)
            let x = y1
            let y = x1 - (a / b) * y1
            return (gcd: gcd, x: x, y: y)
        }
    }
    
    /// Computes the least common multiple (LCM) of two integers.
    /// - Parameters:
    ///   - a: The first integer.
    ///   - b: The second integer.
    /// - Returns: The LCM of `a` and `b`.
    public static func lcm(_ a: Int, _ b: Int) -> Int {
        return a * b / gcd(a, b)
    }
    
    /// Computes modular exponentiation: `(a^n) % N`.
    /// - Parameters:
    ///   - a: The base.
    ///   - n: The exponent.
    ///   - N: The modulus.
    /// - Returns: The result of `(a^n) % N`.
    public static func powMod(base a: Int, exponent n: Int, mod N: Int) -> Int {
        var result: Int = 1
        let a: Int = a
        let n: Int = n
        let l: Int = n.bitWidth
        
        for i in (0...l-1).reversed() {
            result = result * result % N
            if (n >> i) & 1 == 1 {
                result = result * a % N
            }
        }
        
        return result
    }
    
    /// Computes standard exponentiation: `a^n`.
    /// - Parameters:
    ///   - a: The base.
    ///   - n: The exponent.
    /// - Returns: The result of `a^n`.
    public static func pow(base a: Int, exponent n: Int) -> Int {
        var result: Int = 1
        let a: Int = a
        let n: Int = n
        let l: Int = n.bitWidth
        
        for i in (0...l-1).reversed() {
            result = result * result
            if (n >> i) & 1 == 1 {
                result = result * a
            }
        }
        
        return result
    }
    
    /// Determines whether a given number is prime using the Miller-Rabin primality test.
    /// - Parameters:
    ///   - p: The number to test.
    ///   - a: The base used for the test (default: 2).
    /// - Returns: `true` if `p` is prime; otherwise, `false`.
    public static func isPrime(_ p: Int, withBase a: Int = 2) -> Bool {
        // Miller-Rabin
        let p: Int = p
        var s: Int = 0
        var t: Int = p-1
        var b: Int
        
        if p <= 1 {
            return false
        }
        
        if p == 2 {
            return true
        }
        
        while t % 2 == 0 {
            t /= 2
            s += 1
        }

        b = powMod(base: a, exponent: t, mod: p)
        if b == 1 {
            return true
        }
        
        for _ in 0...s {
            if b == p-1 {
                return true
            }
            b = powMod(base: b, exponent: 2, mod: p)
        }
        
        return false
    }
    
    // Generates a random prime number with the specified bit length.
    /// - Parameters:
    ///    - n: The bit length of the desired prime number.
    /// - Returns: A prime number of bit length `n`.
    public static func getRandomPrime(withBitLength n: Int) -> Int {
        var p: Int
        var twoPower: Int
        
        if n == 1 {
            return 2
        }
        
        twoPower = pow(base: 2, exponent: n-2)
        
        while true {
            p = Int.random(in: twoPower...(2*twoPower))
            p = (p << 1) | 1
            if isPrime(p) {
                return p
            }
        }
        
    }
    
    /// Computes the prime factorization of a given number.
    /// - Parameters:
    ///   - n: The number to factorize.
    /// - Returns: An array of tuples `(prime, exponent)` representing the prime factorization.
    public static func getPrimeFactors(of n: Int) -> [(Int, Int)] {
        var n: Int = n
        var factors: [(Int, Int)] = []
        
        // Factor out powers of 2
        var count: Int = 0
        while n % 2 == 0 {
            count += 1
            n /= 2
        }
        if count > 0 {
            factors.append((2, count))
        }
        
        // Factorize remaining odd numbers
        var divisor: Int = 3
        while divisor * divisor <= n {
            count = 0
            while n % divisor == 0 {
                count += 1
                n /= divisor
            }
            if count > 0 {
                factors.append((divisor, count))
            }
            divisor += 2
        }
        
        // If remaining n is prime
        if n > 1 {
            factors.append((n, 1))
        }
        
        return factors
    }
    
    /// Checks if a number is a primitive root modulo `p`.
    /// - Parameters:
    ///   - g: The number to check.
    ///   - p: The modulus (a prime number).
    /// - Returns: `true` if `g` is a primitive root modulo `p`; otherwise, `false`.
    public static func isPrimitive(_ g: Int, mod p: Int) -> Bool {
        let primefactors: [(Int, Int)] = getPrimeFactors(of: p-1)
        var k: Int
        
        if g == 0 {
            return false
        }
        
        for (ell, _) in primefactors {
            k = (p - 1) / ell
            if powMod(base: k, exponent: k, mod: p) == 1 {
                return false
            }
        }
        return true
    }
    
    /// Finds a random primitive root modulo `p`.
    /// - Parameters:
    ///   - p: The modulus (a prime number).
    /// - Returns: A primitive root modulo `p`.
    public static func getRandomPrimitiveRoot(mod p: Int) -> Int {
        var g: Int
        
        while true {
            g = Int.random(in: 1...p-1)
            if isPrimitive(g, mod: p) {
                return g
            }
        }
    }
}
