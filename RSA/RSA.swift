/// RSA-encryption scheme.
/// This struct includes functions for key generation, encryption, and decryption.
public struct RSA {
    
    /// Generates a pair of RSA keys.
    /// - Parameters:
    ///     - size: The bit length of the keys (typically 1024 or more for security purpose),
    /// - Returns: A tuple containing the public key and private key. Each key is represented as a tuple `(modulus: n, exponent: e)`
    /// - Important: The generated keys are for educational purposes and are not suitable for production use.
    public static func generateKeys(size: Int) -> (publicKey: (modulus: Int, exponent: Int), privateKey: (modulus: Int, exponent: Int)) {
        
        // Generate two prime numbers, p and q
        let p: Int = MathUtilities.getRandomPrime(withBitLength: size)
        let q: Int = MathUtilities.getRandomPrime(withBitLength: size)
        
        // Calculate the modulus n
        let n: Int = p * q
        
        // Compute Euler's totient function phi(n)
        let phi: Int = MathUtilities.lcm(p - 1, q - 1)
        
        // Determine the public key exponent e
        var e: Int = 0
        while true {
            e = Int.random(in:2...phi-1)
            if MathUtilities.gcd(e, phi) == 1 {
                break
            }
        }
        
        // Compute the private key exponent d
        let x: Int
        (_, x, _) = MathUtilities.extendedGCD(a: e, b: phi)
        let d: Int = (x % phi + phi) % phi
        
        return ((n, e), (n, d))
        
    }
    
    /// Encrypts a message using the RSA public key.
    /// - Parameters:
    ///   - m: The message to encrypt, represented as an integer.
    ///   - publicKey: The public key `(modulus: n, exponent: e)` used for encryption.
    /// - Returns: The encrypted message as an integer.
    /// - Note: The message `m` must be less than the modulus `n` of the public key.
    public static func encrypt(message m: Int, using publicKey: (modulus: Int, exponent: Int)) -> Int {
        return MathUtilities.powMod(base: m, exponent: publicKey.exponent, mod: publicKey.modulus)
    }
    
    /// Decrypts an encrypted message using the RSA private key.
    /// - Parameters:
    ///   - c: The ciphertext to decrypt, represented as an integer.
    ///   - privateKey: The private key `(modulus: n, exponent: d)` used for decryption.
    /// - Returns: The decrypted message as an integer.
    /// - Note: The decrypted message should match the original plaintext message.
    public static func decrypt(ciphertext c: Int, using privateKey: (modulus: Int, exponent: Int)) -> Int {
        return MathUtilities.powMod(base: c, exponent: privateKey.exponent, mod: privateKey.modulus)
    }
}

