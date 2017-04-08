//
//  FavoritesViewController.swift
//  Pokedex
//
//  Created by Boris Yue on 2/17/17.
//  Copyright © 2017 trainingprogram. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    var favorites = UserDefaults.standard
    var array: [[String]] = [[]]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites.synchronize()
        array = favorites.array(forKey: "pokemonArray") as! [[String]]
        if array.count > 0 { // if theres stuff in the array
            setUpTableView()
        }
    }

    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height))
        tableView.register(PokemonListTableViewCell.self, forCellReuseIdentifier: "pokemonCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        view.addSubview(tableView)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    // Setting up cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeCell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as! PokemonListTableViewCell
        for subview in pokeCell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
        pokeCell.awakeFromNib() //initialize cell
        let currentPokemon = array[indexPath.row]
        // retrieving images
        let url = URL(string: currentPokemon[1])
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let dataRetrieved = data {
                    pokeCell.pokeImage.image = UIImage(data: dataRetrieved)
                } else {
                    pokeCell.pokeImage.image = #imageLiteral(resourceName: "question-mark")
                }
            }
        }
        //setting up text
        pokeCell.name.text = currentPokemon[0].replacingOccurrences(of: "  ", with: " ") // make it a bit neater, get rid of double spaces
        pokeCell.name.sizeToFit()
        pokeCell.name.frame.origin.y = tableView.rowHeight / 2 - pokeCell.name.frame.height / 2
        pokeCell.name.frame.origin.x = pokeCell.pokeImage.frame.maxX + 10
        if Int(currentPokemon[2])! < 10 {
            pokeCell.pokeNum.text = "#00" + currentPokemon[2]
        } else if Int(currentPokemon[2])! < 100 {
            pokeCell.pokeNum.text = "#0" + currentPokemon[2]
        } else {
            pokeCell.pokeNum.text = "#" + currentPokemon[2]
        }
        pokeCell.pokeNum.sizeToFit()
        pokeCell.pokeNum.frame.origin.y = tableView.rowHeight / 2 - pokeCell.pokeNum.frame.height / 2
        pokeCell.pokeNum.frame.origin.x = view.frame.width - pokeCell.pokeNum.frame.width - 15
        return pokeCell
    }
    
}
