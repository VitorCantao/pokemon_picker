import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PokemonInfo extends Equatable {
  final String name;
  final String imageUrl;

  PokemonInfo({
    @required this.name,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [name, imageUrl];
}
