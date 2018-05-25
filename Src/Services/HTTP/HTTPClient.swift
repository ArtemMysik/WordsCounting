//
//  HTTPClient.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Alamofire

typealias JSON = [String: Any]

class HTTPClient {
  
    //MARK: - Properties
    private var decoder = JSONDecoder()
    
    //MARK: - Public Methods
    func request<T>(router: Router, completion: @escaping (DataResponseRessult<T>) -> Void) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            Alamofire.request(router).responseJSON(completionHandler: { [weak self] (response) in
                self?.proceedResponse(response, done: completion)
            })
        } else {
            completion(DataResponseRessult.fail(message: WebConstants.FailMessages.internetConnection))
        }
    }
    
    //MARK: - Private Methods
    private func proceedResponse<T>(_ response: DataResponse<Any>,
                                    done: @escaping (DataResponseRessult<T>) -> Void) {
        switch response.result {
        case .success(let json):
            if let statusCode = response.response?.statusCode,
                let httpStatusCode = HTTPStatusCode(rawValue: statusCode) {
                formReplyByHTTPStatus(result: json, statusCode: httpStatusCode, done: done)
            } else {
                done(.fail(message: WebConstants.FailMessages.unknown))
            }
            
        case .failure(let error):
            if let error = error as? URLError {
                if error.code == .notConnectedToInternet {
                    done(DataResponseRessult.fail(message: WebConstants.FailMessages.internetConnection))
                } else {
                    print(error)
                    done(DataResponseRessult.fail(message: error.localizedDescription))
                }
            } else {
                done(DataResponseRessult.fail(message: WebConstants.FailMessages.unknown))
            }
        }
    }
    
    private func formReplyByHTTPStatus<T>(result: Any?, statusCode: HTTPStatusCode, done: @escaping (DataResponseRessult<T>) -> Void) {
        guard let json = result as? JSON else {
            done(.fail(message: WebConstants.FailMessages.responseError))
            
            return
        }
        
        if let data = json[WebConstants.HTTPClient.dataKey] as? JSON,
            !data.isEmpty {
            formReplyOnStatusCodeWithContent(data: .plain(data), statusCode: statusCode, done: done)
        } else if let data = json[WebConstants.HTTPClient.dataKey] as? String {
            formReplyOnStatusCodeWithContent(data: .string(data), statusCode: statusCode, done: done)
        } else if let data = json[WebConstants.HTTPClient.errorsKey] as? [JSON],
            !data.isEmpty {
            formReplyOnStatusCodeWithContent(data: .array(data), statusCode: statusCode, done: done)
        } else {
            done(.fail(message: WebConstants.FailMessages.unknown))
        }
        
    }
    
    private func formReplyOnStatusCodeWithContent<T>(data: JSONType, statusCode: HTTPStatusCode, done: @escaping (DataResponseRessult<T>) -> Void) {
        
        switch statusCode {
        case .ok:
            if case .plain(let json) = data,
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                let data = String(data: jsonData, encoding: .utf8)?.data(using: .utf8),
                let model = try? decoder.decode(T.self, from: data) {
                done(.success(model))
                
                return
            } else if case .string(let string) = data {
                done(.stringSuccess(string))
            } else {
                done(.fail(message: WebConstants.FailMessages.internalError))
            }
            
            
        case .generalError, .validation, .methodNotAllowed:
            if case .array(let jsonArray) = data {
                let dataArray = jsonArray.flatMap({ try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) })
                let errorsArray = dataArray.flatMap({try? decoder.decode(DataResponseError.self, from: $0)})
                done(.errors(errorsArray))
            }
            
        default:
            done(.fail(message: WebConstants.FailMessages.unknown))
        }
    }
}
