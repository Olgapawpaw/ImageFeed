import Foundation

//enum ApiConstants: String {
//    case secretKey = "ND3bdDzFSscslZ1HaDu1jqU6yQ-xxGwZ0yAcaXSoKyY"
//    case accessKey = "uC_pOLOQUQuhnblD1XKEubllt3aeqrTr5SIGezr5mKM"
//    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//    case accessScope = "public+read_user+write_likes"
//    case hostURL = "unsplash.com"
//    case baseURL = "api.unsplash.com"
//    case schemeURL = "https"
//}

let SecretKey = "ND3bdDzFSscslZ1HaDu1jqU6yQ-xxGwZ0yAcaXSoKyY"
let AccessKey = "uC_pOLOQUQuhnblD1XKEubllt3aeqrTr5SIGezr5mKM"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let HostURL = "unsplash.com"
let BaseURL = "api.unsplash.com"
let SchemeURL = "https"
let AuthURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let hostURL: String
    let baseURL: String
    let schemeURL: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, hostURL: String, baseURL: String, schemeURL: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.hostURL = hostURL
        self.baseURL = baseURL
        self.schemeURL = schemeURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 hostURL: HostURL,
                                 baseURL: BaseURL,
                                 schemeURL: SchemeURL,
                                 authURLString: AuthURLString)
    }
}

