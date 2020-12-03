import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_picker/features/picker/domain/entities/pokemon_info.dart';
import 'package:pokemon_picker/features/picker/domain/repositories/pokemon_info_repository.dart';
import 'package:pokemon_picker/features/picker/domain/usecases/get_random_pokemon_info.dart';

class MockPokemonInfoRepository extends Mock implements PokemonInfoRepository {}

void main() {
  GetRandomPokemonInfo useCase;
  MockPokemonInfoRepository mockPokemonInfoRepository;

  setUp(() {
    mockPokemonInfoRepository = MockPokemonInfoRepository();
    useCase = GetRandomPokemonInfo(mockPokemonInfoRepository);
  });

  final tPokemonInfo = PokemonInfo(name: 'Pikachu', imageUrl: 'test');

  test('should get pokemon info from the repository', () async {
    when(mockPokemonInfoRepository.getRandomPokemonInfo())
        .thenAnswer((_) async => Right(tPokemonInfo));

    final result = await useCase();

    expect(result, Right(tPokemonInfo));
    verify(mockPokemonInfoRepository.getRandomPokemonInfo());
    verifyNoMoreInteractions(mockPokemonInfoRepository);
  });
}
