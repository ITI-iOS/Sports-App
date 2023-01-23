//
//  LeaguesViewController.swift
//  Sports App
//
//  Created by Adham Samer on 21/01/2023.
//

import UIKit

class LeaguesViewController: UIViewController {
    @IBOutlet var leaguesTableView: UITableView!

    var sportId: Int = 0
    var leaguesArr: [League] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        leaguesTableView.dataSource = self
        leaguesTableView.delegate = self
        getData { myLeague in
            DispatchQueue.main.async {
                let league = myLeague?.data
                self.leaguesArr = league ?? []
                print("Loaded Successfully")
                self.leaguesTableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        leaguesTableView.reloadData()
    }
}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaguesArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomLeagueTCell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! CustomLeagueTCell
        let league = leaguesArr[indexPath.row]
        cell.leagelLabel.text = league.name_translations?["en"]
        cell.countryLabel.text = league.host?["country"]
        cell.leagueImage.sd_setImage(with: league.logo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension LeaguesViewController {
    class Fact: Decodable {
        var name: String?
        var value: String?
    }

    class Section: Decodable {
        var id: Int?
        var sport_id: Int?
        var slug: String?
        var name: String?
        var priority: Int?
        var flag: String?
    }

    class Sport: Decodable {
        var id: Int?
        var slug: String?
        var name: String?
    }

    class League: Decodable {
        var id: Int?
        var sport_id: Int?
        var section_id: Int?
        var slug: String?
        var name_translations: [String: String]?
        var has_logo: Bool?
        var logo: URL?
        var start_date: String?
        var end_date: String?
        var priority: Int?
        var host: [String: String]?
        var tennis_point: Int?
        var facts: [Fact]?
        var most_count: Int?
        var section: Section?
        var sport: Sport?
    }

    class Result: Decodable {
        var data: [League] = []
    }

    func getData(completionHandler: @escaping (Result?) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "60ebcd3a19mshf2d7cb17fffa6fcp146ef4jsn18c35c7f3230",
            "X-RapidAPI-Host": "sportscore1.p.rapidapi.com",
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://sportscore1.p.rapidapi.com/sports/\(sportId)/leagues")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request as URLRequest) { data, _, error in

            guard let data = data else {
                completionHandler(nil)
                return
            }

            do {
                let json = try JSONDecoder().decode(Result.self, from: data)
                completionHandler(json)
            } catch {
                print(String(describing: error))
                completionHandler(nil)
            }
        }
        dataTask.resume()
    }
}
