//
//  ViewController.swift
//  Sports App
//
//  Created by Adham Samer on 21/01/2023.
//

import CoreData
import SDWebImage
import UIKit

class ViewController: UIViewController {
    @IBOutlet var sportsView: UICollectionView!
    var sportsArr:[Sport]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sportsView.delegate = self
        sportsView.dataSource = self
        self.navigationItem.title = "Sports"
        getData(completionHandler: { mySport in
            DispatchQueue.main.async {
                let sports = mySport?.data
                self.sportsArr = sports ?? []
                print("loaded successfully")
                self.sportsView.reloadData()
            }
        })
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sportsArr.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        let sport = sportsArr[indexPath.row]
        cell.cellLabel.text = sport.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lvc:LeaguesViewController = self.storyboard?.instantiateViewController(withIdentifier: "leagues") as! LeaguesViewController
        lvc.sportId = sportsArr[indexPath.row].id ?? 0
        navigationController?.pushViewController(lvc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2) - 22, height: (UIScreen.main.bounds.width/2) - 22)
    }
}

extension ViewController {
    
    class Sport:Decodable{
        var id:Int?
        var slug:String?
        var name:String?
        var name_translations:[String:String]?
    }
    
    class Results:Decodable{
        var data:[Sport]?
    }
    
    func getData(completionHandler: @escaping (Results?) -> Void){
        let headers = [
            "X-RapidAPI-Key": "60ebcd3a19mshf2d7cb17fffa6fcp146ef4jsn18c35c7f3230",
            "X-RapidAPI-Host": "sportscore1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://sportscore1.p.rapidapi.com/sports")! as URL,
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
            
            do{
                let json = try JSONDecoder().decode(Results.self, from: data)
                completionHandler(json)
            }catch{
                print(String(describing: error))
                completionHandler(nil)
            }
        }
        dataTask.resume()
    }
}
