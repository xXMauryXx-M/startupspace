 import 'package:startupspace/domain/entities/proyect.dart';

abstract class ProyectsDatasource {
  Stream<List<Proyect>> getAllProyects();
  
}
