import 'package:startupspace/domain/datasource/proyects_datasource.dart';
import 'package:startupspace/domain/entities/proyect.dart';
import 'package:startupspace/domain/repository/proyects_repository.dart';

class ProyectsRepositoryImpl extends ProyectsRepository {
  final ProyectsDatasource datasource;

  ProyectsRepositoryImpl(this.datasource);
  @override
  Stream<List<Proyect>> getAllProyects() {
    return datasource.getAllProyects();
  }
}
