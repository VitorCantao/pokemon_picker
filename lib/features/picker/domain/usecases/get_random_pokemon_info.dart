import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pokemon_info.dart';
import '../repositories/pokemon_info_repository.dart';

class GetRandomPokemonInfo implements UseCase<PokemonInfo> {
  final PokemonInfoRepository repository;

  GetRandomPokemonInfo(this.repository);

  Future<Either<Failure, PokemonInfo>> call() async =>
      await repository.getRandomPokemonInfo();
}
