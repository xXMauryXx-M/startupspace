import 'package:startupspace/domain/entities/proyect.dart';

 abstract class ProyectsRepository{
   Stream<List<Proyect>> getAllProyects();
}