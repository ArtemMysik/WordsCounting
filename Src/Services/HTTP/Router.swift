//
//  Router.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Alamofire

enum Router {
    
    //MARK: - Static
    fileprivate static let baseHttpURL = WebConstants.Router.baseURL
    
    //MARK: - Cases
    case apiGetText
    case apiGetPerson
    case apiLogin(email: String, password: String)
    case apiLogout
    case apiSignup(nickname: String, email: String, password: String)
    
    //MARK: - Computed properties
    var method: Alamofire.HTTPMethod {
        switch self {
        case .apiLogin, .apiLogout, .apiSignup:
            return .post
            
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .apiGetText:
            return WebConstants.Router.textPath
            
        case .apiGetPerson:
            return WebConstants.Router.personPath
            
        case .apiLogin:
            return WebConstants.Router.loginPath
            
        case .apiLogout:
            return WebConstants.Router.logoutPath
            
        case .apiSignup:
            return WebConstants.Router.signupPath
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .apiGetText, .apiGetPerson:
            return [WebConstants.Router.localeKey : Locale.ru.rawValue]
            
        default:
            return nil
        }
    }
    
    var httpBodyJSON: JSON? {
        switch self {
        case .apiLogin(let email, let password):
            return [WebConstants.Router.emailKey : email,
                    WebConstants.Router.passwordKey : password]
            
        case .apiSignup(let nickname, let email, let password):
            return [WebConstants.Router.nicknameKey : nickname,
                    WebConstants.Router.emailKey : email,
                    WebConstants.Router.passwordKey : password]
            
        default:
            return nil
        }
    }
    
}

//MARK: - Extensions

// MARK: - URLRequestConvertible
extension Router: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        
        let baseURL = try Router.baseHttpURL.asURL()
        let urlWithPath = URL(string: self.path, relativeTo: baseURL)
        
        guard let fullURL = urlWithPath else {
            let urlRequest = URLRequest(url: baseURL)
            
            return urlRequest
        }
        
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.addValue(WebConstants.Router.contentTypeJSONValue,
                            forHTTPHeaderField: WebConstants.Router.contentTypeHeader)
        
        if let accessToken = APIClient.shared.user?.accessToken {
            urlRequest.addValue(WebConstants.Router.tokenPrefixValue + accessToken,
                                forHTTPHeaderField: WebConstants.Router.authorizationHeader)
        }
        
        if let json = httpBodyJSON,
            let jsonData = try? JSONSerialization.data(withJSONObject: json) {
            urlRequest.httpBody = jsonData
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
    
}
