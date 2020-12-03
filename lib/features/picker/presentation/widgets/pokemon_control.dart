import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pokemon_info_bloc.dart';

class PokemonControl extends StatefulWidget {
  @override
  __PokemonControlState createState() => __PokemonControlState();
}

class __PokemonControlState extends State<PokemonControl> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(15),
      onPressed: () => BlocProvider.of<PokemonInfoBloc>(context).add(
        GetRandomPokemonInfoEvent(),
      ),
      child: Container(
        child: Text(
          'Go!',
          style: TextStyle(fontSize: 28),
        ),
      ),
      color: Theme.of(context).primaryColor,
    );
  }
}
