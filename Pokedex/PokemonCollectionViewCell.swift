//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Amy on 2/15/17.
//  Copyright © 2017 trainingprogram. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    var pokemonImageView: UIImageView!
    var pokemonName: UILabel!
    var entireCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pokemonImageView = UIImageView(frame: contentView.frame)
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.clipsToBounds = true
        contentView.addSubview(pokemonImageView) //remember to add UI elements to content view not the cell itself
        entireCell = UIButton(frame: CGRect(x: 0, y: 0, width: contentView.frame.width-50, height: contentView.frame.height-10))
    
        entireCell.sizeToFit()
        entireCell.backgroundColor = UIColor.clear
        contentView.addSubview(entireCell)
        pokemonName = UILabel(frame: CGRect(x: 0, y: contentView.frame.height * 0.9, width: contentView.frame.width, height: contentView.frame.height * 0.1))
        pokemonName.backgroundColor = UIColor.clear
        pokemonName.textColor = UIColor.black
        pokemonName.clipsToBounds = true
        pokemonName.font = UIFont(name: "PokemonGB", size: 7.0)
        
        contentView.addSubview(pokemonName)
      
    }

    
}
