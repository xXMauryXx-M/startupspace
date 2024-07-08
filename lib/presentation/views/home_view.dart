import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Cerrar Sesíon'),
                      content: const Text('¿Estas Seguro que deseas salir?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: Text('ok'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
          title: const Text(
            "Startup Space",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.1),
          actions: [
            NotificationIcon(),
            SizedBox(
              width: 20,
            )
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(children: [
                  // Text("Startup Space",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),

                  // Text(
                  //   "Somos una comunidad que reúne a mentes apasionadas que buscan dar vida a sus ideas Ya sea que estés en las etapas iniciales de tu proyecto, en búsqueda de colaboradores o  conectar con personas afines.",
                  //   style: TextStyle(color: Colors.grey,fontSize: 18),
                  //   ),

//                Text("Nuevo en Startup Space",style: TextStyle(fontSize: 23,color: Colors.white,fontWeight: FontWeight.bold),),
// SizedBox(height: 20,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collectionGroup("proyects")
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        );
                      }
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var document = snapshot.data!.docs;
                        var data = document;
                        return NewProyects(
                          data: data,
                          lengthNewProyects: data.length,
                          key: key,
                        );
                      } else {
                        return Text('No se encontraron proyectos');
                      }
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Proximas Meetups",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700),
                      )),
                  MeetupFilter(),
                  SizedBox(
                    height: 20,
                  ),

                  //       TextButton.icon(
                  //         onPressed: () {
                  //           showDialog(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return AlertDialog(
                  //                   title: const Text('Añadir Calendario'),
                  //                   content: const Text('¿Quieres Añadir Calendario?'),
                  //                   actions: <Widget>[
                  //                     TextButton(
                  //                       onPressed: () {
                  //                         context.pop();
                  //                       },
                  //                       child: Text('ok'),
                  //                     ),
                  //                   ],
                  //                 );
                  //               }); // Agrega aquí la función que se ejecutará al presionar el botón
                  //         },
                  //         style: TextButton.styleFrom(
                  //           backgroundColor: Colors.grey[
                  //               800], // Cambia el color del texto y el icono según sea necesario
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 12,
                  //               horizontal: 16), // Ajusta el espacio dentro del botón
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //                 BorderRadius.circular(8), // Define el radio del borde
                  //           ),
                  //         ),
                  //         icon: Icon(
                  //           Icons.calendar_today, // Icono de calendario
                  //           color: Colors.white, // Color del icono
                  //         ),
                  //         label: Text(
                  //           "Añadir al calendario", // Texto del botón
                  //           style: TextStyle(
                  //             fontSize: 16, // Tamaño del texto
                  //             color: Colors.white, // Color del texto
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 100,
                  //       )
                  //     ],
                  //   ),
                  // ),
                ]))));
  }
}

class MeetupFilter extends StatelessWidget {
  const MeetupFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri privacypolicy = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=-33.402067,-70.575443');

    Future<void> termsandConditions() async {
      if (!await launchUrl(privacypolicy)) {
        throw Exception('Could not launch $privacypolicy');
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('meetups').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No hay datos disponibles'),
          );
        }

        return SizedBox(
          height: 400,
          // Elimina la altura fija para permitir que el contenedor se expanda verticalmente
          width: double
              .infinity, // Opcional: puedes ajustar el ancho según tus necesidades
          child: Swiper(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final meetupDoc = snapshot.data!.docs[index];
              final data = meetupDoc.data() as Map<String, dynamic>;

              final place = data['place'];
              final type = data["type"];
              final photo = data["photo"];
              final description = data["description"];
              final timestamp = data['date'] as Timestamp;
              final dateTime = timestamp.toDate();
              final formattedDate =
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}';

              return Container(
                height: 400,
                // Ajusta el tamaño del contenedor según tus necesidades
                width: 400,
                child: Card(
                  color: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${type}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("${type}"),
                                        content: Text("${description}"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.help,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${formattedDate}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                   type=="Tech Talks"?       Image.network(
                            "${photo}",
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                        ):Image.asset("assets/presentatuidea.jpeg",),
                        SizedBox(height: 10),
                        Text(
                          "${place}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Avenida Presidente Kennedy 5601",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            termsandConditions();
                          },
                          child: Text(
                            "Ver lugares en Maps >",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: Colors.white,
                color: Color(0xff4C4C4C),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        );
      },
    );
  }
}

class NewProyects extends StatelessWidget {
  final int lengthNewProyects;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
  const NewProyects(
      {super.key, required this.lengthNewProyects, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 120,
      child: Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          final d = data[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  // context.push("/IntoProyect");
                  // ref
                  //     .read(proyectIntoProvider.notifier)
                  //     .update((state) => project);
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: double.infinity,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(21),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(
                                    "${d["images"][0]}",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${d["nameproyect"]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "${d["proyectDescription"]}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: d["chose"] == "startup"
                            ? Icon(
                                Icons.rocket,
                                color: Colors.white,
                              )
                            : d["chose"] == "idea"
                                ? Icon(
                                    Icons.lightbulb,
                                    color: Colors.white,
                                  )
                                : d["chose"] == "prototipo"
                                    ? Icon(
                                        Icons.work,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.abc,
                                        color: Colors.white,
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          );

          // return Text(
          //   "${data["images"][0]}",
          //   style: TextStyle(color: Colors.white),
          // );p
          // return Image.network(
          //   "${d["images"][0]}",
          //   fit: BoxFit.fill,
          // );
        },
        itemCount: data.length,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.white,
            color: Color(0xff4C4C4C),
          ),
          margin: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          context.push("/NotificationScreen");
        },
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: fetchNotificationsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Stack(
                children: [
                  Icon(
                    Icons.messenger_outline_outlined,
                    color: Colors.white,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Stack(
                children: [
                  Icon(
                    Icons.messenger_outline_outlined,
                    color: Colors.white,
                  ),
                ],
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Stack(
                children: [
                  const Icon(
                    Icons.messenger_outline_outlined,
                    color: Colors.white,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 5,
                        minHeight: 5,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  Icon(
                    Icons.messenger_outline_outlined,
                    color: Colors.white,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Stream<List<DocumentSnapshot>> fetchNotificationsStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .where('seen', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}
