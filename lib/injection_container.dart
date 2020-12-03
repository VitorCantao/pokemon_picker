import 'dart:math';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/picker/data/datasources/pokemon_info_local_data_source.dart';
import 'features/picker/data/datasources/pokemon_info_remote_data_source.dart';
import 'features/picker/data/repositories/pokemon_info_repository_impl.dart';
import 'features/picker/domain/repositories/pokemon_info_repository.dart';
import 'features/picker/domain/usecases/get_random_pokemon_info.dart';
import 'features/picker/presentation/bloc/pokemon_info_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Features - Picker
  // BloC
  getIt.registerFactory(() => PokemonInfoBloc(randomGetter: getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => GetRandomPokemonInfo(getIt()));

  // Repository
  getIt.registerLazySingleton<PokemonInfoRepository>(
    () => PokemonInfoRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<PokemonInfoRemoteDataSource>(
    () => PokemonInfoRemoteDataSourceImpl(
      httpClient: getIt(),
      randomGenerator: getIt(),
    ),
  );

  getIt.registerLazySingleton<PokemonInfoLocalDataSource>(
    () => PokemonInfoLocalDataSourceImpl(
      sharedPreferences: getIt(),
    ),
  );

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // External
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => DataConnectionChecker());
  getIt.registerLazySingleton(() => Random());
}
