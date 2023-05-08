 //
//  NetworkManager.swift
//  Yummie
//
//  Created by MacOS on 13/08/2022.
//

import UIKit

struct NetworkManager{
    
    static let shared = NetworkManager()
    private init() {}
    
    let cache = NSCache<NSString , UIImage>()
    
    // the complletion will pass the data
    /// what happen in all code
    /// - Parameter completion: completion gives the func what is the data type
    /// request func get the data and get the data get the data and pass it to func to handel the data
    /// handelResponse make the data into the type the struct
    /// - SO why we need the type in first completion: to get the type od the data on one of the vars on the big struct
    /// the big struct decoded into the Api response that contains the struct we need to make completion for
    /// we need the completion type to make the completion to the one element on the strucr that we get
    /// الشغل ده هبل كان ممكن يجيب الdata كامله يحطها في الstruct وبس   
    
    
    
    func featchAllCategories(completion:@escaping(Result<AllDishes , Error>)->Void){
        request(route: .feachAllCategories, method: .get, completion: completion)
    }
    
    func placeOrder(dishId : String , name : String , completion : @escaping (Result<Order , Error>)->Void){
        let params = ["name" : name]
        request(route: .placeOrder(dishId), method: .post, parameters: params, completion: completion)
    }
    
    private func request<T : Codable>(route : Route ,
                                      method : Method ,
                                      parameters : [String : Any]? = nil ,
                                      completion : @escaping (Result<T , Error>)->Void){
        
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return}
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            var result : Result<Data , Error>?
            guard let data = data , error == nil else {
                result = .failure(error!)
                return}
            result = .success(data)
            let responseString = String(data: data, encoding: .utf8) ?? "Could not convet the data into String"
            print(responseString)
            // make an action in the ai
            DispatchQueue.main.async {
                self.handelResponse(result: result, completion: completion)
            }
        }.resume()
    }
    
    // get the data convert it into model type
    private func handelResponse<T : Decodable >(result : Result<Data , Error>? , completion : @escaping (Result<T , Error>)->Void){
        
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result{
            
        case .success(let data):
            do{
                let decoder = JSONDecoder()
                // the type on the struct the (T) what ever it is
                let result = try decoder.decode(ApiResponse<T>.self, from: data)
                // you might get an error from the server so you shold handel this
                if let error = result.error{
                    completion(.failure(AppError.serverError(error)))
                    return
                }
                
                if let decodedData = result.data {
                    completion(.success(decodedData))
                }else{
                    // if no data
                    completion(.failure(AppError.unknownError))
                }
                
            }catch{
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
            return
        }
        
    }
    
    private func createRequest(route : Route , method : Method , parameters : [String : Any]? = nil)-> URLRequest? {
        
        // why you don't return it from the Rout file???????
        let urlString = Route.baseURL + route.description
        guard let url = URL(string: urlString) else {return nil}
        var urlRequest = URLRequest(url: url)
        // make the header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        // check for extra parameter
        if let parameters = parameters {
            switch method {
            case .get:
                // it adds the parameters for example you have
                //http://google.come it will add ?bages=1
                // and the only thig you addes is ["bages" : 1] (order does not matter in parameters)
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = parameters.map{ URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponent?.url
            case .post , .delete , .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
    
    func feachCategoryDishs(categoryId : String , completion : @escaping(Result<[Dish] , Error>)->Void){
        request(route: .feachCategoryDishes(categoryId), method: .get, completion: completion)
    }
    
    func feachOrders(completion : @escaping(Result<[Order] , Error>)->Void){
        request(route: .feachOrders, method: .get, completion: completion)
    }
    
    func downloadImage(from urlString : String , completion : @escaping (UIImage?)-> Void){
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString)else{
            completion(nil)
            return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response , error in
            guard error == nil ,
                  let response = response as? HTTPURLResponse ,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else{
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
    
}





