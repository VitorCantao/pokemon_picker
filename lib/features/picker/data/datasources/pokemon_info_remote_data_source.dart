import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_picker/core/error/exception.dart';
import 'package:pokemon_picker/features/picker/data/models/pokemon_info_model.dart';
import 'package:pokemon_picker/features/picker/domain/entities/pokemon_info.dart';

abstract class PokemonInfoRemoteDataSource {
  /// Calls the https://pokeinfo.com/pokemon-form/{number}
  ///
  /// Throws a [ServerException] for all the error codes.
  Future<PokemonInfo> getRandomPokemonInfo();
}

const POKEMON_MAX_NUMBER = 386;

class PokemonInfoRemoteDataSourceImpl implements PokemonInfoRemoteDataSource {
  final http.Client httpClient;
  final Random _randomGenerator;

  PokemonInfoRemoteDataSourceImpl(
      {@required this.httpClient, @required Random randomGenerator})
      : this._randomGenerator = randomGenerator;

  @override
  Future<PokemonInfo> getRandomPokemonInfo() async {
    final response = await httpClient.get(
        'https://pokeapi.co/api/v2/pokemon-form/${_getRandomPokemonNumber()}',
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200)
      throw ServerException();
    else
      return PokemonInfoModel.fromJson(json.decode(response.body));
  }

  int _getRandomPokemonNumber() => _randomGenerator.nextInt(POKEMON_MAX_NUMBER);
}
