import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/pokemon_info_model.dart';

abstract class PokemonInfoLocalDataSource {
  /// Gets the cached [PokemonInfoModel] witch was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<PokemonInfoModel> getLastPokemonInfo();

  Future<void> cachePokemonInfo(PokemonInfoModel pokemonToCache);
}

const CACHED_POKEMON_INFO = 'CACHED_POKEMON_INFO';

class PokemonInfoLocalDataSourceImpl implements PokemonInfoLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonInfoLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<PokemonInfoModel> getLastPokemonInfo() {
    final jsonString = sharedPreferences.getString(CACHED_POKEMON_INFO);

    if (jsonString != null)
      return Future.value(PokemonInfoModel.fromJson(json.decode(jsonString)));
    else
      throw CacheException();
  }

  @override
  Future<void> cachePokemonInfo(PokemonInfoModel pokemonToCache) {
    return sharedPreferences.setString(
        CACHED_POKEMON_INFO, json.encode(pokemonToCache.toJson()));
  }
}
