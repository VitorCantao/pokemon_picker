import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_picker/features/picker/data/models/pokemon_info_model.dart';
import 'package:pokemon_picker/features/picker/domain/entities/pokemon_info.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tPokemonInfoModel = PokemonInfoModel(name: 'Test', imageUrl: 't');

  test('should be a subclass of PokemonInfo entity', () async {
    expect(tPokemonInfoModel, isA<PokemonInfo>());
  });

  group('fromJson', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('pokemon.json'));

      final result = PokemonInfoModel.fromJson(jsonMap);

      expect(result, tPokemonInfoModel);
    });
  });
}
