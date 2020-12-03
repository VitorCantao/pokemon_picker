import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_picker/core/error/exception.dart';
import 'package:pokemon_picker/features/picker/data/datasources/pokemon_info_remote_data_source.dart';
import 'package:pokemon_picker/features/picker/data/models/pokemon_info_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeRandom extends Fake implements Random {
  @override
  int nextInt(int max) => 1;
}

void main() {
  FakeRandom fakeRandom;
  PokemonInfoRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    fakeRandom = FakeRandom();
    mockHttpClient = MockHttpClient();
    dataSource = PokemonInfoRemoteDataSourceImpl(
        httpClient: mockHttpClient, randomGenerator: fakeRandom);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('pokemon.json'), 200));
  }

  final tPokemonInfoModel =
      PokemonInfoModel.fromJson(json.decode(fixture('pokemon.json')));

  test(
      'should perform a GET request on a URL with a random number being '
      'the endpoint and with application/json header', () async {
    setUpMockHttpClientSuccess200();

    dataSource.getRandomPokemonInfo();

    verify(mockHttpClient.get(
        'https://pokeapi.co/api/v2/pokemon-form/'
        '${fakeRandom.nextInt(POKEMON_MAX_NUMBER)}',
        headers: {'Content-Type': 'application/json'}));
  });

  test('should return PokemonInfo when the response code is 200 (success)',
      () async {
    setUpMockHttpClientSuccess200();

    final result = await dataSource.getRandomPokemonInfo();

    expect(result, equals(tPokemonInfoModel));
  });

  test(
      'should throw ServerException when the response code is 404 or other (not 200)',
      () async {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));

    final call = dataSource.getRandomPokemonInfo;

    expect(() => call(), throwsA(TypeMatcher<ServerException>()));
  });
}
