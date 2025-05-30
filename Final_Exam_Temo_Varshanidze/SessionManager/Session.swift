

import Foundation

class SessionManager {
    static let shared = SessionManager()

    private init() {}

    var isLoggedIn: Bool = false {
        didSet {
            // შეცვლის შემთხვევაში შეიძლება ამის ჩაწერა UserDefaults-ში ან სხვა
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }

    func logOut() {
        isLoggedIn = false
        // დამატებითი ქმედებები (როგორც გადატვირთვა) თუ საჭიროა
    }
}
