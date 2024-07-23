import Foundation

class SeriesService {
    static let apiUrl: String = "https://www.omdbapi.com/?apikey=3e2b1ec0&s="
    
    public static func searchSeries(withTitle title: String, completion: @escaping (SearchResult?, Error?) -> Void) {
        let urlString = apiUrl + title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Dados não encontrados")
                completion(nil, NSError(domain: "Dados não encontrados", code: -1, userInfo: nil))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                print("Decodificação bem-sucedida: \(result)")
                completion(result, nil)
            } catch {
                print("Erro ao decodificar JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        }.resume()
    }
}
