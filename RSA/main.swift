import Foundation

print("RSA Cryptography Program Running")
// 実際の処理をここに追加

let keyLength: Int
let p, q: Int

keyLength = 16

print("----- System Parameters -----")
print("Key size: \(keyLength)\n")


let keys = RSA.generateKeys(size: keyLength)
let publicKey = keys.publicKey
let privateKey = keys.privateKey

print("----- Keys -----")
print("Public  Key: (n: 0x\(String(publicKey.modulus, radix: 16)), e: 0x\(String(publicKey.exponent, radix: 16)))")
print("Private Key: (n: 0x\(String(privateKey.modulus, radix: 16)), d: 0x\(String(privateKey.exponent, radix: 16)))\n")

print("----- Messages -----")

for i in 0...9 {
    
    let message = Int.random(in: 0..<publicKey.modulus)
    let cipherText = RSA.encrypt(message: message, using: publicKey)
    let decryptedMessage = RSA.decrypt(ciphertext: cipherText, using: privateKey)
    
    print("# \(i)")
    print("Plain     text: 0x\(String(message, radix: 16))")
    print("Encrypted text: 0x\(String(cipherText, radix: 16))")
    print("Decrypted text: 0x\(String(decryptedMessage, radix: 16))")
    if message == decryptedMessage {
        print("Decryption    : Success.\n")
    } else {
        print("Decription    : Failed.\n")
    }
}
