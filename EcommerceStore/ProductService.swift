import Foundation

final class ProductService {
    static let shared: ProductService = .init()
    private init() {}

    func fetchProductList(_ completion: @escaping ([Item]) -> Void) {
        var urlComponents: URLComponents? = .init(string: "https://api.yoox.biz/Search.API/1.3/CHLOE_GB/search/results.json")
        urlComponents?.queryItems = [
            URLQueryItem(name: "ave", value: "prod"),
            URLQueryItem(name: "productsPerPage", value: "50"),
            URLQueryItem(name: "gender", value: "D"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "department", value: "shssnkrs"),
            URLQueryItem(name: "format", value: "lite"),
            URLQueryItem(name: "sortRule", value: "Ranking")
        ]
        URLSession.shared.dataTask(with: urlComponents!.url!) { data, response, error in
            guard
                error == nil,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let resultsLite = json["ResultsLite"] as? [String: Any],
                let items = resultsLite["Items"] as? [[String: Any]]
            else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            let mappedItems = self.mapItems(from: items)
            DispatchQueue.main.async {
                completion(mappedItems)
            }
        }.resume()
    }

    private func mapItems(from jsonItems: [[String: Any]]) -> [Item] {
        jsonItems.map {
            Item(productName: $0["ModelNames"] as! String,
                 price: "\($0["FullPrice"] as! Int) €")
        }
    }
}

struct Item {
    let productName: String
    let price: String
}
