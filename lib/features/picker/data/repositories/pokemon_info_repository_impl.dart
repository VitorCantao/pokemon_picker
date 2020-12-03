import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/pokemon_info.dart';
import '../../domain/repositories/pokemon_info_repository.dart';
import '../datasources/pokemon_info_local_data_source.dart';
import '../datasources/pokemon_info_remote_data_source.dart';

class PokemonInfoRepositoryImpl implements PokemonInfoRepository {
  final PokemonInfoRemoteDataSource remoteDataSource;
  final PokemonInfoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonInfoRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, PokemonInfo>> getRandomPokemonInfo() async {
    if (await networkInfo.isConnected) {
      return await _tryGetPokemonFromRemoteAndCacheIt();
    } else {
      return await _tryGetLastPokemonFromCache();
    }
  }

  Future<Either<Failure, PokemonInfo>>
      _tryGetPokemonFromRemoteAndCacheIt() async {
    try {
      final remotePokemon = await remoteDataSource.getRandomPokemonInfo();
      localDataSource.cachePokemonInfo(remotePokemon);
      return Right(remotePokemon);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, PokemonInfo>> _tryGetLastPokemonFromCache() async {
    try {
      var localPokemon = await localDataSource.getLastPokemonInfo();
      return Right(localPokemon);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
