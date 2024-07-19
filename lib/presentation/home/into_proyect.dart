import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupspace/presentation/providers/auth/proyects/proyects_repository_provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final colaborarProvider = StateProvider<String>((ref) {
  return "";
});
final feedbackProvider = StateProvider<String>((ref) {
  return "";
});

class IntoProyect extends ConsumerWidget {
  const IntoProyect({super.key});

//crear init que obtenga los datos del usuaruis
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proyec = ref.watch(proyectIntoProvider);
    final colabmessage = ref.watch(colaborarProvider);
    final feebackmessage = ref.watch(feedbackProvider);

    final Uri privacypolicy = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=-33.402067,-70.575443');

    Future<void> launchUrls(Uri url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $privacypolicy');
      }
      launchUrl(url);
    }

    String getUrl() {
      if (proyec.instagram.isNotEmpty) {
        return proyec.instagram;
      } else {
        return "";
      }
    }

    String url = getUrl();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text("${proyec.nameproyect}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "${proyec.proyectDescription}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                // Envuelve la parte que quieres que sea desplazable con un Container
                height: MediaQuery.of(context).size.height *
                    0.3, // Define una altura específica
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      proyec.images[index],
                      fit: BoxFit.contain,
                    );
                  },
                  itemCount: proyec.images.length,
                  viewportFraction: 1,
                  scale: 0.9,
                  loop: true,
                  pagination: SwiperPagination(),
                ),
              ),
              Container(
                color: Color(0xff373737),
                width: 600,
                height: 1000,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    proyec.web!=""?
                      ElevatedButton(
                            onPressed: () => launchUrls(Uri.parse(proyec.web)),
                            child: Text('Probar >'),
                          )
                          :
                    url != ""
                        ? ElevatedButton(
                            onPressed: () => launchUrls(Uri.parse(url)),
                            child: Text('Probar >',),
                          )
                        : ElevatedButton(
                            onPressed: () => {},
                            child: Text(
                              'Próximamente',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color(0xff262626),
                        borderRadius:
                            BorderRadius.circular(20), // Radio circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.1), // Color de la sombra
                            spreadRadius: 5, // Radio de difusión de la sombra
                            blurRadius: 7, // Radio de desenfoque de la sombra
                            offset: Offset(0, 3), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Como Funciona",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${proyec.descrition}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 220,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color(0xff262626),
                        borderRadius:
                            BorderRadius.circular(20), // Radio circular
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.1), // Color de la sombra
                            spreadRadius: 5, // Radio de difusión de la sombra
                            blurRadius: 7, // Radio de desenfoque de la sombra
                            offset: Offset(0, 3), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Los principales obstáculos",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${proyec.obstaculos}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SupportProject(
                      key: key,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
    //    SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(20),
    //           child: Center(
    //               child: Text(
    //             "${proyec.descrition}",
    //             style: TextStyle(
    //               fontSize: 18,
    //             ),
    //           )),
    //         ),
    //         Expanded(

    //           child: Swiper(
    //             itemBuilder: (BuildContext context, int index) {
    //             return Image.network(
    //               images[index],
    //               fit: BoxFit.fill,
    //             );
    //             },
    //             itemCount: images.length,
    //             viewportFraction: 0.8,
    //             scale: 0.9,
    //                 pagination: SwiperPagination(),
    //           ),
    //         ),
    //         FilledButton(onPressed: (){}, child: Text("Probar>")),
    //     // SizedBox(height: 300),
    //         Text("Como funciona"),
    //         Container(
    //           color: Color(0xff1E1E1E),
    //           width: 600,
    //           height: 200,
    //           child: Column(
    //             children: [
    //               Text("asdasda")
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

class SupportProject extends ConsumerStatefulWidget {
  const SupportProject({super.key});

  @override
  _SupportProjectState createState() => _SupportProjectState();
}

class _SupportProjectState extends ConsumerState<SupportProject> {
  bool showFeedbackInput = false;
  bool showCollaborateInput = false;

  String userName = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      // Obtener el UID del usuario actual
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Obtener el documento del usuario actual
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Extraer el campo 'name' del documento
      if (docSnapshot.exists) {
        setState(() {
          userName = docSnapshot.data()?['name'];
          photo = docSnapshot.data()?["photo"];
        });
      }
    } catch (e) {
      print("Error al obtener el nombre: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final proyec = ref.watch(proyectIntoProvider);
    final colabmessage = ref.watch(colaborarProvider);
    final feebackmessage = ref.watch(feedbackProvider);

    void _shareProject(BuildContext context) {
      final RenderBox box = context.findRenderObject() as RenderBox;

      String moreInfo;

      if (proyec.web.isNotEmpty) {
        moreInfo = proyec.web;
      } else if (proyec.github.isNotEmpty) {
        moreInfo = proyec.github;
      } else if (proyec.instagram.isNotEmpty) {
        moreInfo = proyec.instagram;
      } else {
        moreInfo = "App no lanzada";
      }

      Share.share(
        '¡Mira este proyecto de startup space: ${proyec.nameproyect}!\n\nDescripción: ${proyec.descrition}\n\nMás información: $moreInfo',
        subject: 'Proyecto de Startup: ${proyec.nameproyect}',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    }

    void sendMessage(
        bool shared, String name, String message, String photo, String type) {
      final coleccion = FirebaseFirestore.instance.collection("users");

      coleccion.doc(proyec.id).collection("notifications").add({
        "type": type,
        "compartir": shared,
        "name": name,
        "message": message,
        "photo": photo,
        "solicitud": "",
        "date": DateTime.now(),
        "seen": false,
        "uidrequest": FirebaseAuth.instance.currentUser!.uid,
        "acceptable": false
      }).then((value) {
        final snackbar = SnackBar(content: Text("Entregado con exito"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        setState(() {
          showCollaborateInput = false;
          showFeedbackInput = false;
        });
      }).then((value) => {

          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
            {
              "colaboration":FieldValue.increment(1)
            }
          )
        
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 350,
      height: 390,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: showFeedbackInput
            ? Column(
                children: [
                  const Icon(Icons.message),
                  SizedBox(height: 20),
                  Text(
                    "Envia tu Feedback",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff979797)),
                  ),
                  SizedBox(height: 20),
                  CustomText2Input(
                    hintText: "feedback",
                    onChanged: (message) {
                      // Handle feedback input change
                      ref
                          .read(feedbackProvider.notifier)
                          .update((state) => message);
                    },
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Cancelar'),
                    onPressed: () {
                      setState(() {
                        showFeedbackInput = false;
                      });
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Enviar'),
                    onPressed: () {
                      //TODO feedback
                      // Acciones a realizar cuando se presiona el botón "Enviar"
                      sendMessage(
                          false, userName, feebackmessage, photo, "feedback");
                    },
                  ),
                ],
              )
            : showCollaborateInput
                ? Column(
                    children: [
                      const Icon(Icons.message),
                      SizedBox(height: 20),
                      Text(
                        "Mensaje para colaborar",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff979797)),
                      ),
                      SizedBox(height: 20),
                      CustomText2Input(
                        hintText: "Colaborar",
                        onChanged: (message) {
                          // Handle collaborate input change
                          ref
                              .read(colaborarProvider.notifier)
                              .update((state) => message);
                        },
                        obscureText: false,
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Cancelar'),
                        onPressed: () {
                          setState(() {
                            showCollaborateInput = false;
                          });
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Enviar'),
                        onPressed: () {
                          //TODO feedback
                          // Acciones a realizar cuando se presiona el botón "Enviar"
                          sendMessage(false, userName, colabmessage, photo,
                              "colaborar");
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Apoya al Proyecto",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Con estas acciones apoyarás",
                        style: TextStyle(),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            showFeedbackInput = true;
                          });
                        },
                        icon: Icon(Icons.message, color: Colors.black),
                        label: Text('Feedback',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50)),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            showCollaborateInput = true;
                          });
                        },
                        icon: Icon(Icons.developer_board, color: Colors.black),
                        label: Text('Colaborar',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50)),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle share action
                          _shareProject(context);
                        },
                        icon: Icon(Icons.share, color: Colors.black),
                        label: Text('Compartir',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50)),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class CustomText2Input extends StatelessWidget {
  final Function(String) onChanged;
  final bool obscureText;
  final String hintText;

  const CustomText2Input({
    required this.onChanged,
    required this.obscureText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
