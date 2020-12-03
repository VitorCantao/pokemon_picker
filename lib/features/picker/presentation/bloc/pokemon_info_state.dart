part of 'pokemon_info_bloc.dart';

@immutable
abstract class PokemonInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends PokemonInfoState {}

class Loading extends PokemonInfoState {}

class Loaded extends PokemonInfoState {
  final PokemonInfo pokemonInfo;

  Loaded({@required this.pokemonInfo});

  @override
  List<Object> get props => [pokemonInfo];
}

class Error extends PokemonInfoState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
