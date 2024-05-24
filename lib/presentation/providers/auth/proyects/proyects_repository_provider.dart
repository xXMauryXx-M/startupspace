
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupspace/domain/entities/proyect.dart';
import 'package:startupspace/presentation/providers/auth/proyects/proyects_provider.dart';

final proyectFirebaseProvider = StreamProvider.autoDispose<List<Proyect>>((ref) {
  final tutors = ref.watch(proyectRepositoryProvider).getAllProyects();

// print ()|
  return tutors;
});

final proyectIntoProvider = StateProvider<Proyect>((ref) {
  return Proyect( id: "", chose: "", descrition: "", github: "", instagram: "", nameproyect: "", obstaculos: "", phone: "", proyectDescription: "", web: "", images: []) ;
});