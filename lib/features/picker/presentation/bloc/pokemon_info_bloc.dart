import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pokemon_picker/core/error/failures.dart';
import 'package:pokemon_picker/features/picker/domain/usecases/get_random_pokemon_info.dart';

import '../../domain/entities/pokemon_info.dart';

part 'pokemon_info_event.dart';
part 'pokemon_info_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PokemonInfoBloc extends Bloc<PokemonInfoEvent, PokemonInfoState> {
  final GetRandomPokemonInfo _getRandomPokemonInfo;

  PokemonInfoBloc({@required GetRandomPokemonInfo randomGetter})
      : assert(randomGetter != null),
        this._getRandomPokemonInfo = randomGetter,
        super(Empty());

  @override
  Stream<PokemonInfoState> mapEventToState(
    PokemonInfoEvent event,
  ) async* {
    if (event is GetRandomPokemonInfoEvent) {
      yield* _randomPokemonStates();
    }
  }

  Stream<PokemonInfoState> _randomPokemonStates() async* {
    yield Loading();
    final failureOrPokemon = await _getRandomPokemonInfo();
    yield failureOrPokemon.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (pokemon) {
        final fPokemon = _getPokemonFormatted(pokemon);
        return Loaded(pokemonInfo: fPokemon);
      },
    );
  }

  PokemonInfo _getPokemonFormatted(PokemonInfo pokemon) {
    final pascalCaseName =
        pokemon.name[0].toUpperCase() + pokemon.name.substring(1);
    return PokemonInfo(
      name: pascalCaseName,
      imageUrl: pokemon.imageUrl,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
