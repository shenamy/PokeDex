//
//  PokemonListViewController.swift
//  
//
//  Created by Boris Yue on 2/16/17.
//
//


import UIKit

class PokemonListViewController: UIViewController {
    
    var pokemons: [Pokemon]!
    var selectedPokemon: Pokemon!
    var tableView: UITableView!
    var segmentedControl: UISegmentedControl!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpTableView()
        changeNavBarText()
    }
    
    func changeNavBarText() {
        //        let customFont = UIFont(name: "Pokemon GB", size: 15.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.minY, width: view.frame.width, height: view.frame.height))
        tableView.register(PokemonListTableViewCell.self, forCellReuseIdentifier: "pokemonCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        view.addSubview(tableView)
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.maxY + 30, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: "pokemonCell")
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func setUpSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.setWidth(70, forSegmentAt: 0)
        segmentedControl.setWidth(70, forSegmentAt: 1) //increase width of segmented control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(changeView), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }
    
    func changeView() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setUpTableView()
        case 1:
            setUpCollectionView()
        default:
            print("default")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            ProfileViewController.currentPokemon = selectedPokemon
        }
    }
}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    // Setting up cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeCell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as! PokemonListTableViewCell
        for subview in pokeCell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
        pokeCell.awakeFromNib() //initialize cell
        let currentPokemon = pokemons[indexPath.row]
        // retrieving images
        let url = URL(string: currentPokemon.imageUrl)
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
        pokeCell.name.text = currentPokemon.name.replacingOccurrences(of: "  ", with: " ") // make it a bit neater, get rid of double spaces
        pokeCell.name.sizeToFit()
        pokeCell.name.frame.origin.y = tableView.rowHeight / 2 - pokeCell.name.frame.height / 2
        pokeCell.name.frame.origin.x = pokeCell.pokeImage.frame.maxX + 10
        if currentPokemon.number < 10 {
            pokeCell.pokeNum.text = "#00\(currentPokemon.number!)"
        } else if currentPokemon.number < 100 {
            pokeCell.pokeNum.text = "#0\(currentPokemon.number!)"
        } else {
            pokeCell.pokeNum.text = "#\(currentPokemon.number!)"
        }
        pokeCell.pokeNum.sizeToFit()
        pokeCell.pokeNum.frame.origin.y = tableView.rowHeight / 2 - pokeCell.pokeNum.frame.height / 2
        pokeCell.pokeNum.frame.origin.x = view.frame.width - pokeCell.pokeNum.frame.width - 15
        return pokeCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //CELL IS SELECTED, DISPLAY INDIVIDUAL POKEMON
        selectedPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    
    
}




extension PokemonListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as! PokemonCollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove previous subviews in cell
        }
        cell.awakeFromNib() //initialize cell
        let currentPokemon = pokemons[indexPath.row]
        // get the images using URL, set to questionmark if nonexistant
        let url = URL(string: currentPokemon.imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let dataRetrieved = data {
                    cell.pokemonImageView.image = UIImage(data: dataRetrieved)
                } else {
                    cell.pokemonImageView.image = #imageLiteral(resourceName: "question-mark")
                }
            }
        }
        //sets up the name and num
        cell.pokemonName.text = currentPokemon.name.replacingOccurrences(of: "  ", with: " ")
        
        if currentPokemon.number < 10 {
            cell.pokemonName.text = "#00\(currentPokemon.number!)" + " " + cell.pokemonName.text!
        } else if currentPokemon.number < 100 {
            cell.pokemonName.text = "#00\(currentPokemon.number!)" + " " + cell.pokemonName.text!
        } else {
            cell.pokemonName.text = "#00\(currentPokemon.number!)" + " " + cell.pokemonName.text!
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let pokemonCell = cell as! PokemonCollectionViewCell
        pokemonCell.pokemonName.setTextSpacing(spacing: 0.08)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3 - 20, height: view.frame.width/3 + 50 )
    }
    func collectionView(_ tableView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //CELL IS SELECTED, DISPLAY INDIVIDUAL POKEMON
        selectedPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
}
