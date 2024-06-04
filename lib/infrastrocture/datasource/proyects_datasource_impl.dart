import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupspace/domain/datasource/proyects_datasource.dart';
import 'package:startupspace/domain/entities/proyect.dart';

class ProyectsDatasourceImpl extends ProyectsDatasource {
  final colectionn = FirebaseFirestore.instance.collectionGroup("proyects");

@override
Stream<List<Proyect>> getAllProyects() {
  return colectionn
      .snapshots()
      .map((event) => event.docs.map((e) {
            final data = e.data();
        
            return Proyect(
                docid: e.id,
                id: data["uid"]??"",
                chose: data["chose"] ?? "",
                descrition: data["descrition"] ?? "",
                github: data["github"] ?? "",
                instagram: data["instagram"] ?? "",
                nameproyect: data["nameproyect"] ?? "",
                obstaculos: data["obstaculos"] ?? "",
                phone: data["phone"] ?? 0,
                proyectDescription: data["proyectDescription"] ?? "",
                web: data["web"] ?? "",
                images: data["images"]??["https://www.educaciontrespuntocero.com/wp-content/uploads/2020/04/mejores-bancos-de-imagenes-gratis.jpg"]
                );
          }).toList())
      .map((list) => list.cast<Proyect>());
}

}
