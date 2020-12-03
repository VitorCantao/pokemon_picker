import 'package:flutter/foundation.dart';

import '../../domain/entities/pokemon_info.dart';

class PokemonInfoModel extends PokemonInfo {
  final String name;
  final String imageUrl;

  PokemonInfoModel({@required this.name, @required this.imageUrl})
      : super(name: name, imageUrl: imageUrl);

  factory PokemonInfoModel.fromJson(Map<String, dynamic> json) {
    return PokemonInfoModel(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': {'front_default': imageUrl}
    };
  }
}
