//
//  NetworkService.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation

class NetworkService {
    
    func fetchAPOD(date: String, completionHandler: @escaping (Picture?) -> Void) {
        
        let url = buildSearchURL(date: date)
        
        getDataFromUrl(url: url) { data in
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    let picture = try decoder.decode(Picture.self, from: data)
                    DispatchQueue.main.async(execute: {
                        completionHandler(picture)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        completionHandler(nil)
                    })
                }
               
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler(nil)
                })
            }
        }
    }
    
    func downloadImage(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completionHandler(data,response,error)
        })
        task.resume()
    }
    
    
    private func getDataFromUrl(url:URL, completionHandler: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching facility data: \(error)")
                completionHandler(nil)
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Error with the response, unexpected status code: \(String(describing: response))")
                      completionHandler(nil)
                      return
                  }
            if let data = data{
                completionHandler(data)
            }
        })
        task.resume()
    }
    
    private func buildSearchURL(date: String) -> URL {
        let queryParameters = ["date": date, "api_key":"RiBe4LGMzsLjLa5AHMBSD80gF9kpWXgvbdw9wgaa","thumbs":"true"]
        return buildURL(path: "/planetary/apod", parameters: queryParameters)
    }
    
    private func buildURL(path: String, parameters: [String: String]?) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.nasa.gov"
        urlComponents.path = path
        urlComponents.queryItems = parameters?.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            fatalError("Error: expected iTunes URL but instead it is nil")
        }
        return url
    }
    
    
}
