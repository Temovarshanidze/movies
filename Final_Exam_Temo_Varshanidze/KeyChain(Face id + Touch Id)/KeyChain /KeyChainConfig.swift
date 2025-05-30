
import Foundation
import Security

enum KeyChainError: Error {
    case sameItemFound
    case unknown
    case nosuchDataFound
    case KCErrorWithCode(Int) // KCErrorWithCode(Int) — კონკრეტული კოდი სტატუსით (დეტალური შეცდომებისთვის).
}

class KeyChainConfig {
    
    
    func save() {
        do {
            try save(
                service: "some service",   //ანუ რომელი სერვისისისთვის ხდება  შენახვა
                account: "ios",
                password: "paroli".data(using: .utf8) ?? Data()
               // print("Saved to Keychain — Service: \(service), Account: \(account), Password: \(String(decoding: password, as: UTF8.self))")
            )
        } catch {
            print(error)
        }
    }
    
    func get() {
        guard let data = get(service: "countryAPI", account: "saxeli@sasas") else {
            print("failed load password")
            return
        }
        
        let password = String(decoding: data, as: UTF8.self)
        print(password, "🟢")
    }
    
    //⬇️SAVE data
    func save(
        service: String, //    service: აღნიშნავს რისთვის ინახება მონაცემი (მაგ. "com.myapp.login")
        account: String, //      account: მომხმარებლის იდენტიფიკატორი (მაგ. "user123" ან "email@domain.com")
        password: Data //password: შენახული პაროლი, Data ფორმატში (მაგ. "pass123".data(using: .utf8))
    ) throws {
        // service account password class
        let query: [String: AnyObject] = [
            kSecClass as String         : kSecClassGenericPassword,
            kSecAttrService as String   : service as AnyObject,
            kSecAttrAccount as String   : account as AnyObject,
            kSecValueData as String     : password as AnyObject,
        ]
        
        /* ეს არის Keychain-ის მოთხოვნა (query), რაც მას ეუბნება:
         •    შენახე Generic Password
         •    ეს ეკუთვნის ამ service-ს
         •    ეკუთვნის ამ account-ს
         •    და აი ეს password უნდა შეინახო */
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeyChainError.sameItemFound
        }
        ///......
        guard status == errSecSuccess else {
            throw KeyChainError.unknown
        }
        print("✅Saved to Keychain — Service: \(service), Account: \(account), Password: \(String(decoding: password, as: UTF8.self))")
        print("saved")
    }
    
    //⬆️GET data
    func get(
        // service account class return-data, matchlimit
        service: String,
        account: String
    ) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("read status \(status)")
        return result as? Data
    }
    
    //🔄update
    func update(password: Data, service: String, account: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        
        guard status != errSecItemNotFound else {
            throw KeyChainError.nosuchDataFound
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.KCErrorWithCode(Int(status))
        }
        
    }
    //❌delete
    func deletePassword(service: String, account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeyChainError.KCErrorWithCode(Int(status))
        }
    }
    
    func getAllAccounts(for service: String) -> [String] {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let items = result as? [[String: Any]] else {
            print("No accounts found or error")
            return []
        }

        let accounts = items.compactMap { $0[kSecAttrAccount as String] as? String }
        return accounts
    }
    
#warning("OPTIONAL: ⏳ აჩვენე ბიომეტრიული წვდომის საშუალება ekychain ში შენახულ მონაცემებზე")
}
