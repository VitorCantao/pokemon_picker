import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_picker/core/error/failures.dart';
import 'package:pokemon_picker/features/picker/domain/entities/pokemon_info.dart';
import 'package:pokemon_picker/features/picker/domain/usecases/get_random_pokemon_info.dart';
import 'package:pokemon_picker/features/picker/presentation/bloc/pokemon_info_bloc.dart';

// ignore: must_be_immutable
class MockGetRandomPokemonInfo extends Mock implements GetRandomPokemonInfo {}

void main() {
  PokemonInfoBloc bloc;
  MockGetRandomPokemonInfo mockGetRandomPokemonInfo;

  setUp(() {
    mockGetRandomPokemonInfo = MockGetRandomPokemonInfo();

    bloc = PokemonInfoBloc(randomGetter: mockGetRandomPokemonInfo);
  });

  test('initialState should be Empty', () {
    expect(bloc.state, Empty());
  });

  group('GetRandomPokemonInfo', () {
    final tPokemonInfo = PokemonInfo(name: 'Test', imageUrl: 't');

    test('should get data from the random use case', () async {
      when(mockGetRandomPokemonInfo())
          .thenAnswer((_) async => Right(tPokemonInfo));

      bloc.add(GetRandomPokemonInfoEvent());
      await untilCalled(mockGetRandomPokemonInfo());

      verify(mockGetRandomPokemonInfo());
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      when(mockGetRandomPokemonInfo())
          .thenAnswer((_) async => Right(tPokemonInfo));

      final expected = [Loading(), Loaded(pokemonInfo: tPokemonInfo)];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetRandomPokemonInfoEvent());
    });
  });

  test('should emit [Loading, Error] when gettind data fails', () async {
    when(mockGetRandomPokemonInfo())
        .thenAnswer((_) async => Left(ServerFailure()));

    final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];

    expectLater(bloc, emitsInOrder(expected));

    bloc.add(GetRandomPokemonInfoEvent());
  });

  test(
      'should emit [Loading, Error] with proper message for the '
      'error when getting data fails', () async {
    when(mockGetRandomPokemonInfo())
        .thenAnswer((_) async => Left(CacheFailure()));

    final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];

    expectLater(bloc, emitsInOrder(expected));

    bloc.add(GetRandomPokemonInfoEvent());
  });
}
