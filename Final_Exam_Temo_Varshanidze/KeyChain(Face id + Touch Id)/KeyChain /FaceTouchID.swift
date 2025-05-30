import Foundation
import LocalAuthentication
func saveSecretDataToKeychain(data: Data, key: String) -> Bool {
    let context = LAContext()
    
    // შემოწმება თუ შესაძლებელია ბიომეტრიული ავტორიზაციის გამოყენება
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
        // შემოწმება, რომ მოწყობილობა გაქვს კონფიგურირებული პაროლთან
        let accessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .biometryAny,
            nil
        )
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecUseAuthenticationContext as String: context,
            kSecAttrAccessControl as String: accessControl as Any
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    return false
}

func retrieveSecretDataFromKeychain(key: String) -> Data? {
    let context = LAContext()
    
    // ბიომეტრიული ავტორიზაციისთვის გადამოწმება
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
        // Biometric Authentication: face id / touch id
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access secure data") { success, error in
            if success {
                // ბიომეტრიული წარმატებით შემოწმება
            } else {
                // შეცდომის შეტყობინება თუ ვერ შეამოწმა
            }
        }
    }
    
    // სხვა ტიპის ავტორიზაცია (მაგალითად, პაროლი)
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecUseAuthenticationContext as String: context
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return data
        }
    }
    
    return nil
}

func usage() {
    let secretData = "რაღაც მნიშვნელოვანი მონაცემი".data(using: .utf8)!
    let key = "გასაღები"
    
    if saveSecretDataToKeychain(data: secretData, key: key) {
        print("მონაცემი შეინახა keychain ში")
    }
    
    if let retrievedData = retrieveSecretDataFromKeychain(key: key) {
        if let retrievedString = String(data: retrievedData, encoding: .utf8) {
            print("მონაცემი ამოიღეს keychain-დან: \(retrievedString)")
        }
    }
}
