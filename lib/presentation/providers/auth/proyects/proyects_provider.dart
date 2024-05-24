import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupspace/infrastrocture/datasource/proyects_datasource_impl.dart';
import 'package:startupspace/infrastrocture/repository/proyects_repository_impl.dart';

final proyectRepositoryProvider = Provider((ref) {
  return ProyectsRepositoryImpl(
      ProyectsDatasourceImpl());
});
