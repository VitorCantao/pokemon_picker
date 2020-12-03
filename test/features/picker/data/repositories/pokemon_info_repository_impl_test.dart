import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_picker/core/error/exception.dart';
import 'package:pokemon_picker/core/error/failures.dart';
import 'package:pokemon_picker/core/network/network_info.dart';
import 'package:pokemon_picker/features/picker/data/datasources/pokemon_info_local_data_source.dart';
import 'package:pokemon_picker/features/picker/data/datasources/pokemon_info_remote_data_source.dart';
import 'package:pokemon_picker/features/picker/data/models/pokemon_info_model.dart';
import 'package:pokemon_picker/features/picker/data/repositories/pokemon_info_repository_impl.dart';
import 'package:pokemon_picker/features/picker/domain/entities/pokemon_info.dart';

class MockRemoteDataSource extends Mock implements PokemonInfoRemoteDataSource {
}

class MockLocalDataSource extends Mock implements PokemonInfoLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  PokemonInfoRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PokemonInfoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getRandomPokemonInfo', () {
    final tPokemonInfoModel = PokemonInfoModel(name: 'Test', imageUrl: 't');
    final tPokemonInfo = tPokemonInfoModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomPokemonInfo();

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call '
          'to remote data source is successful', () async {
        when(mockRemoteDataSource.getRandomPokemonInfo())
            .thenAnswer((_) async => tPokemonInfoModel);

        final Either<Failure, PokemonInfo> result =
            await repository.getRandomPokemonInfo();

        expect(result, Right(tPokemonInfo));
      });

      test(
          'should cache data locally when the call '
          'to remote data source is successful', () async {
        when(mockRemoteDataSource.getRandomPokemonInfo())
            .thenAnswer((_) async => tPokemonInfoModel);

        await repository.getRandomPokemonInfo();

        verify(mockLocalDataSource.cachePokemonInfo(tPokemonInfo));
      });

      test(
          'should return server failure when the call '
          'to remote data source is unsuccessful', () async {
        when(mockRemoteDataSource.getRandomPokemonInfo())
            .thenThrow(ServerException());

        final Either<Failure, PokemonInfo> result =
            await repository.getRandomPokemonInfo();

        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the '
          'cached data is present', () async {
        when(mockLocalDataSource.getLastPokemonInfo())
            .thenAnswer((_) async => tPokemonInfoModel);

        final Either<Failure, PokemonInfo> result =
            await repository.getRandomPokemonInfo();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastPokemonInfo());
        expect(result, Right(tPokemonInfo));
      });

      test(
          'should return cache failure data when there is'
          'no cached data present', () async {
        when(mockLocalDataSource.getLastPokemonInfo())
            .thenThrow(CacheException());

        final Either<Failure, PokemonInfo> result =
            await repository.getRandomPokemonInfo();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastPokemonInfo());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
