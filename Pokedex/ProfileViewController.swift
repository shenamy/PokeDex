//
//  ProfileViewController.swift
//  Pokedex
//
//  Created by Boris Yue on 2/17/17.
//  Copyright © 2017 trainingprogram. All rights reserved.
//

import UIKit

// FOR SOME REASON, we weren't able to change the tab bar color or navigation bar color...?

class ProfileViewController: UIViewController {
    
    var scrollView: UIScrollView!   //The scroll view that contains everything
    
    var types = ["fire", "flying"]
    static var currentPokemon : Pokemon!
    let favorites = UserDefaults.standard
    var pokemonArray = [[]]
    var imageView : UIImageView!
    var nameLabel : UILabel!
    
    var numLabel: UILabel!
    var atkLabel: UILabel!
    var defLabel: UILabel!
    var hpLabel: UILabel!
    
    var statsLabel: UILabel!
    var speciesLabel: UILabel!
    var spAttackLabel: UILabel!
    var spDefLabel: UILabel!
    var speedLabel: UILabel!
    var totalLabel: UILabel!
    
    var typeRects : [RectButton] = []
    
    var flavorTitle: UILabel!
    var flavorText: UILabel!
    
    var genericView = UIView()
    
    var topView = UIView()
    var middleView = UIView()
    var bottomView = UIView()
    var favoriteButton: RectButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if favorites.array(forKey: "pokemonArray") == nil {
            pokemonArray = []
            favorites.set(pokemonArray, forKey: "pokemonArray")
        } else {
            pokemonArray = favorites.array(forKey: "pokemonArray") as! [Array<Any>]
        }
        tabBarController?.tabBar.tintColor = UIColor.black
        initImageViewUI()
        initLabelUI()
        initNumLabelUI()
        initATKLabelUI()
        initDEFLabelUI()
        initHPLabelUI()
        initTypeRectsUI()
//        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.isUserInteractionEnabled = true
        genericView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: typeRects[0].frame.maxY + 20))
        topView.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        topView.addSubview(typeRects[0])
        if (typeRects.count == 2) {
            topView.addSubview(typeRects[1])
        }
        topView.addSubview(imageView)
        topView.addSubview(nameLabel)
        topView.addSubview(numLabel)
        topView.addSubview(atkLabel)
        topView.addSubview(defLabel)
        topView.addSubview(hpLabel)
        
        //ALL UI INITIALIZATION FOR MIDDLE VIEW
        
        initStatsLabelUI()
        initSpeciesLabelUI()
        initSpAttackLabelUI()
        initSpDefenseLabelUI()
        initSpeedLabelUI()
        initTotalLabelUI()

        middleView = UIView(frame: CGRect(x: 0, y: topView.frame.maxY, width: view.frame.width, height: totalLabel.frame.maxY + 20))   //HEIGHT IS CURRENTLY SOME ARBITRARY VALUE, WILL BE SET WHEN ALL COMPONENTS HAVE BEEN ADDED TO MIDDLE VIEW
        middleView.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        middleView.addSubview(statsLabel)
        middleView.addSubview(speciesLabel)
        middleView.addSubview(spAttackLabel)
        middleView.addSubview(spDefLabel)
        middleView.addSubview(speedLabel)
        middleView.addSubview(totalLabel)
        if ProfileViewController.currentPokemon.flavorText != "" {
            initFlavorUI()
            view.addSubview(flavorTitle)
            view.addSubview(flavorText)
        }
        let url = URL(string: ProfileViewController.currentPokemon.imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let dataRetrieved = data {
                    self.imageView.image = UIImage(data: dataRetrieved)
                } else {
                    self.imageView.image = #imageLiteral(resourceName: "question-mark")
                }
            }
        }
        initFavoriteButton()
        genericView.addSubview(topView)
        genericView.addSubview(middleView)
        view.addSubview(genericView)
        view.addSubview(favoriteButton)
    }
    
    func initTypeRectsUI() {
        if ProfileViewController.currentPokemon.types.count == 1 {
            typeRects.append(RectButton(frame: CGRect(x: view.frame.width / 2 - 60, y: imageView.frame.maxY + 10, width: 120, height: 35)))
            typeRects[0].setTitle(ProfileViewController.currentPokemon.types[0], for: .normal)
            typeRects[0].titleLabel?.font = UIFont(name: "PokemonGB", size: 12.0)
            typeRects[0].titleLabel?.setTextSpacing(spacing: 0.7)
            typeRects[0].backgroundColor = UIColor.init(red:190/255, green:110/255, blue: 110/255, alpha: 1.0)
            //topView.addSubview(typeRects[0])
        } else {
            typeRects.append(RectButton(frame: CGRect(x: view.frame.width / 2 - 135, y: imageView.frame.maxY + 10, width: 120, height: 35)))
            typeRects[0].setTitle(ProfileViewController.currentPokemon.types[0], for: .normal)
            typeRects[0].titleLabel?.font = UIFont(name: "PokemonGB", size: 12.0)
            typeRects[0].titleLabel?.setTextSpacing(spacing: 0.7)
            typeRects[0].backgroundColor = UIColor.init(red:190/255, green:110/255, blue: 110/255, alpha: 1.0)
            //topView.addSubview(typeRects[0])
            
            typeRects.append(RectButton(frame: CGRect(x: view.frame.width / 2 + 30, y: imageView.frame.maxY + 10, width: 120, height: 35)))
            typeRects[1].setTitle(ProfileViewController.currentPokemon.types[1], for: .normal)
            typeRects[1].titleLabel?.font = UIFont(name: "PokemonGB", size: 12.0)
            typeRects[1].titleLabel?.setTextSpacing(spacing: 0.7)
            typeRects[1].backgroundColor = UIColor.init(red:110/255, green:110/255, blue: 190/255, alpha: 1.0)
            //topView.addSubview(typeRects[1])
        }
    }
    
    func initImageViewUI() {
        imageView = UIImageView(frame: CGRect(x: 20, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: 150, height: 150))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        //topView.addSubview(imageView)
    }
    
    func initLabelUI() {
        nameLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: view.frame.width - imageView.frame.width, height: 40))
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.text = ProfileViewController.currentPokemon.name
        nameLabel.setTextSpacing(spacing: 3.0)
        nameLabel.font = UIFont.init(name: "PokemonGB", size: 18.0)
        
        //topView.addSubview(nameLabel)
    }
    
    func initNumLabelUI() {
        numLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: nameLabel.frame.maxY, width: view.frame.width - imageView.frame.width, height: 25))
        numLabel.textAlignment = NSTextAlignment.center
        
        let pokeNumber = ProfileViewController.currentPokemon.number
        if (pokeNumber! < 10) {
            numLabel.text = "#00" + String(ProfileViewController.currentPokemon.number)
        } else if (pokeNumber! < 100) {
            numLabel.text = "#0" + String(ProfileViewController.currentPokemon.number)
        } else {
            numLabel.text = "#" + String(ProfileViewController.currentPokemon.number)
        }
        numLabel.setTextSpacing(spacing: 3.0)
        numLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
        
        //topView.addSubview(numLabel)
    }
    
    func initATKLabelUI() {
        atkLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: numLabel.frame.maxY, width: view.frame.width - imageView.frame.width, height: 25))
        atkLabel.textAlignment = NSTextAlignment.center
        atkLabel.text = "ATK: " + String(ProfileViewController.currentPokemon.attack)
        atkLabel.setTextSpacing(spacing: 3.0)
        atkLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
        
        //topView.addSubview(atkLabel)
    }
    
    func initDEFLabelUI() {
        defLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: atkLabel.frame.maxY, width: view.frame.width - imageView.frame.width, height: 25))
        defLabel.textAlignment = NSTextAlignment.center
        defLabel.text = "DEF: " + String(ProfileViewController.currentPokemon.defense)
        defLabel.setTextSpacing(spacing: 3.0)
        defLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
        
        //topView.addSubview(defLabel)
    }
    
    func initHPLabelUI() {
        hpLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: defLabel.frame.maxY, width: view.frame.width - imageView.frame.width, height: 25))
        hpLabel.textAlignment = NSTextAlignment.center
        hpLabel.text = "HP: " + String(ProfileViewController.currentPokemon.defense)
        hpLabel.setTextSpacing(spacing: 3.0)
        hpLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
        
        //topView.addSubview(hpLabel)
    }
    
    func initStatsLabelUI() {
        statsLabel = UILabel(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 50))
        statsLabel.textAlignment = NSTextAlignment.center
        statsLabel.text = "Statistics"
        statsLabel.setTextSpacing(spacing: 7.0)
        statsLabel.font = UIFont.init(name: "PokemonGB", size: 18.0)
        
        //topView.addSubview(statsLabel)
    }
    
    func initSpeciesLabelUI() {
        speciesLabel = UILabel(frame: CGRect(x: 0, y: statsLabel.frame.maxY + 10, width: view.frame.width, height: 25))
        speciesLabel.textAlignment = NSTextAlignment.center
        speciesLabel.text = "Species: " + ProfileViewController.currentPokemon.species
        speciesLabel.setTextSpacing(spacing: 3.0)
        speciesLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
        
        speciesLabel.numberOfLines = 0
    }
    
    func initSpAttackLabelUI() {
        spAttackLabel = UILabel(frame: CGRect(x: 0, y: speciesLabel.frame.maxY + 5, width: view.frame.width, height: 25))
        spAttackLabel.textAlignment = NSTextAlignment.center
        spAttackLabel.text = "Special Attack: " + String(ProfileViewController.currentPokemon.specialAttack)
        spAttackLabel.setTextSpacing(spacing: 3.0)
        spAttackLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
    }
    
    func initSpDefenseLabelUI() {
        spDefLabel = UILabel(frame: CGRect(x: 0, y: spAttackLabel.frame.maxY + 5, width: view.frame.width, height: 25))
        spDefLabel.textAlignment = NSTextAlignment.center
        spDefLabel.text = "Special Defense: " + String(ProfileViewController.currentPokemon.specialDefense)
        spDefLabel.setTextSpacing(spacing: 3.0)
        spDefLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
    }
    
    func initSpeedLabelUI() {
        speedLabel = UILabel(frame: CGRect(x: 0, y: spDefLabel.frame.maxY + 5, width: view.frame.width, height: 25))
        speedLabel.textAlignment = NSTextAlignment.center
        speedLabel.text = "Speed: " + String(ProfileViewController.currentPokemon.speed)
        speedLabel.setTextSpacing(spacing: 3.0)
        speedLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
    }
    
    func initTotalLabelUI() {
        totalLabel = UILabel(frame: CGRect(x: 0, y: speedLabel.frame.maxY + 5, width: view.frame.width, height: 25))
        totalLabel.textAlignment = NSTextAlignment.center
        totalLabel.text = "Total: " + String(ProfileViewController.currentPokemon.total)
        totalLabel.setTextSpacing(spacing: 3.0)
        totalLabel.font = UIFont.init(name: "PokemonGB", size: 12.0)
    }
    
    func initFlavorUI() {
        flavorTitle = UILabel(frame: CGRect(x: 0, y: middleView.frame.maxY + 5, width: view.frame.width, height: 50))
        flavorTitle.textAlignment = NSTextAlignment.center
        flavorTitle.text = "Did you know?"
        flavorTitle.setTextSpacing(spacing: 7.0)
        flavorTitle.font = UIFont.init(name: "PokemonGB", size: 18.0)
        
        flavorText = UILabel(frame: CGRect(x: 0, y: flavorTitle.frame.maxY - 40, width: view.frame.width, height: 0))
        flavorText.numberOfLines = 0    //Causes the text in the label to wrap
        flavorText.textAlignment = NSTextAlignment.center
        flavorText.text = ProfileViewController.currentPokemon.flavorText
        flavorText.setTextSpacing(spacing: 1.0)
        flavorText.font = UIFont.init(name: "PokemonGB", size: 12.0)
        flavorText.sizeToFit()
        flavorText.frame = CGRect(x:0, y: flavorTitle.frame.maxY + 10, width: view.frame.width, height: flavorText.frame.height + 10)
    }
    
    func initFavoriteButton() {
        if (ProfileViewController.currentPokemon.flavorText != "") {
            favoriteButton = RectButton(frame: CGRect(x: view.frame.width / 2 - 125, y: flavorText.frame.maxY + 5, width: 250, height: 35))
        } else {
            favoriteButton = RectButton(frame: CGRect(x: view.frame.width / 2 - 125, y: middleView.frame.maxY + 70, width: 250, height: 35))
        }
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.titleLabel?.font = UIFont(name: "PokemonGB", size: 12.0)
        favoriteButton.titleLabel?.setTextSpacing(spacing: 0.7)
        favoriteButton.backgroundColor = UIColor.init(red:190/255, green:110/255, blue: 110/255, alpha: 1.0)
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
    }
    
    func addToFavorite() {
        var currentArray = favorites.array(forKey: "pokemonArray") as! [[String]]
        var arrayToAdd = [ProfileViewController.currentPokemon.name, ProfileViewController.currentPokemon.imageUrl, "\(ProfileViewController.currentPokemon.number!)"]
        if currentArray.count == 0 {
            currentArray.append(arrayToAdd as! [String])
        } else {
            for arr in currentArray {
                if arr[0] == arrayToAdd[0] { //make sure no duplicates
                    return
                }
            }
        }
        currentArray.append(arrayToAdd as! [String])
        favorites.set(currentArray, forKey: "pokemonArray")
    }
}
