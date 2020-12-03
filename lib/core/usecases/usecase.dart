import 'package:dartz/dartz.dart';
import 'package:pokemon_picker/core/error/failures.dart';

abstract class UseCase<Type> {
  Future<Either<Failure, Type>> call();
}
