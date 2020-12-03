import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pokemon_info.dart';

abstract class PokemonInfoRepository {
  Future<Either<Failure, PokemonInfo>> getRandomPokemonInfo();
}
