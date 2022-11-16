//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Ghalaab on 17/11/2022.
//

import Foundation

struct URLRequestBuilder: URLRequestBuilding {
    
    func urlRequest<E>(from endPoint: E) -> URLRequest? where E : EndPoint{
        guard endPoint.fullPath.isValidURL else {
            logError("Url is not valid \(endPoint.fullPath)", tag: .networking)
            return nil
        }

        var urlComponents = URLComponents(string: endPoint.fullPath)

        if [.get, .head, .delete].contains(endPoint.httpMethod){
            let parameters = endPoint.parameters?.asDictionary?.map({ URLQueryItem(name: $0.key, value: "\($0.value)" )})
            urlComponents?.queryItems = parameters
        }

        guard let url = urlComponents?.url else {
            logError("malformed url from path \(endPoint.fullPath)", tag: .networking)
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.httpMethod.rawValue
        for header in endPoint.headersComponents.headers{
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        if ![.get, .head, .delete].contains(endPoint.httpMethod){
            do{
                let jsonObject = endPoint.parameters?.asDictionary ?? [:]
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                request.httpBody = jsonData
                return request

            }catch{
                logError("Trying to convert model to JSON data \(error.localizedDescription)", tag: .networking)
                return nil
            }
        }else{
            return request
        }
    }
}

