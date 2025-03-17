//
//  Defaults.swift
//  NetomiSampleApp
//
//  Created by Akash Gupta on 20/11/24.
//

import Foundation

struct Defaults {
    
    enum Keys: String {
        case email = "email"
        case name = "name"
        case mobile = "mobile"
        case password = "password"
        case profileInfo = "profile"
        case isLoggedIn = "isLoggedIn"
//        case selectedBotRefId = "selectedBotRefId"
//        case selectedBotName = "selectedBotName"
    }
    
    private static let preserveValues: [Keys] = []
    
    static func removeUnPreservedData() {
        for i in UserDefaults.standard.dictionaryRepresentation() {
            if let key = Defaults.Keys(rawValue: i.key), preserveValues.contains(key) {
                debugPrint("Preserved-->",i.key)
            } else {
                debugPrint("Deleted-->",i.key)
                UserDefaults.standard.removeObject(forKey: i.key)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static var email: String? {
        get {
            let email = UserDefaults.standard.string(forKey: Keys.email.rawValue)
            return email
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.email.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var name: String? {
        get {
            let name = UserDefaults.standard.string(forKey: Keys.name.rawValue)
            return name
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.name.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var mobile: String? {
        get {
            let mobile = UserDefaults.standard.string(forKey: Keys.mobile.rawValue)
            return mobile
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.mobile.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var password: String? {
        get {
            let password = UserDefaults.standard.string(forKey: Keys.password.rawValue)
            return password
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.password.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var profileInfo : ProfileInfo? {
        get {
            if let data = UserDefaults.standard.object(forKey: Keys.profileInfo.rawValue) as? Data {
                do {
                    let decoder = JSONDecoder()
                    let profile = try decoder.decode(ProfileInfo.self, from: data)
                    return profile
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: Keys.profileInfo.rawValue)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static var isLoggedIn: Bool {
        get {
            return !(Defaults.email?.isEmpty ?? true)
        }
    }
    
//    static var selectedBotRefId: String? {
//        get {
//            let selectedBotRefId = UserDefaults.standard.string(forKey: Keys.selectedBotRefId.rawValue)
//            return selectedBotRefId
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: Keys.selectedBotRefId.rawValue)
//            UserDefaults.standard.synchronize()
//        }
//    }
//    
//    static var selectedBotName: String? {
//        get {
//            let selectedBotName = UserDefaults.standard.string(forKey: Keys.selectedBotName.rawValue)
//            return selectedBotName
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: Keys.selectedBotName.rawValue)
//            UserDefaults.standard.synchronize()
//        }
//    }
}

struct ProfileInfo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case mobile
        case password
    }
    
    var name: String?
    var email: String?
    var mobile: String?
    var password: String?
        
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        mobile = try container.decodeIfPresent(String.self, forKey: .mobile)
        password = try container.decodeIfPresent(String.self, forKey: .password)
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
