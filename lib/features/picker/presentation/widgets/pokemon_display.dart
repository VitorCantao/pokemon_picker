import 'package:flutter/material.dart';

import '../../domain/entities/pokemon_info.dart';

class PokemonDisplay extends StatelessWidget {
  final PokemonInfo pokemonInfo;

  const PokemonDisplay({Key key, @required this.pokemonInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FittedBox(
              child: Image(
                image: NetworkImage(pokemonInfo.imageUrl),
              ),
            ),
          ),
          Container(
            height: 40,
            child: Text(
              pokemonInfo.name,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
