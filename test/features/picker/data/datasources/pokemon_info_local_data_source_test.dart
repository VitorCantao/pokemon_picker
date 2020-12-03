import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_picker/core/error/exception.dart';
import 'package:pokemon_picker/features/picker/data/datasources/pokemon_info_local_data_source.dart';
import 'package:pokemon_picker/features/picker/data/models/pokemon_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  PokemonInfoLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PokemonInfoLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastPokemon', () {
    final tPokemonInfoModel =
        PokemonInfoModel.fromJson(json.decode(fixture('pokemon_cached.json')));

    test(
        'should return PokemonInfo from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('pokemon_cached.json'));

      final result = await dataSource.getLastPokemonInfo();

      verify(mockSharedPreferences.getString(CACHED_POKEMON_INFO));
      expect(result, tPokemonInfoModel);
    });

    test('should throw CacheException when there is no cached PokemonInfo',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastPokemonInfo;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cachePokemonInfo', () {
    final tPokemonInfoModel = PokemonInfoModel(name: 'Test', imageUrl: 't');

    test('should call SharedPreferences to cache the data', () async {
      dataSource.cachePokemonInfo(tPokemonInfoModel);

      final expectJsonString = json.encode(tPokemonInfoModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_POKEMON_INFO, expectJsonString));
    });
  });
}
