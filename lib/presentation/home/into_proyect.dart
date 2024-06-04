
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupspace/presentation/providers/auth/proyects/proyects_repository_provider.dart';

import 'package:share_plus/share_plus.dart';

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

 
    // void _showModalBottomSheet(BuildContext context) {
    //   showModalBottomSheet(
    //     backgroundColor: Color(0xffEFEFEF),
    //     context: context,
    //     isScrollControlled: true,
    //     builder: (BuildContext context) {
    //       return Container(
    //         height: MediaQuery.of(context).size.height * 0.9,
    //         padding: EdgeInsets.all(16.0),
    //         child: Column(
    //           children: <Widget>[
    //             SizedBox(height: 90),
    //             Padding(
    //               padding: const EdgeInsets.all(20),
    //               child: Text(
    //                 '¿De qué forma te gustaría aportar a este proyecto?',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 90), // Espacio entre el título y los botones
    //             ElevatedButton.icon(
    //               onPressed: () {
    //                 showDialog(
    //                   context: context,
    //                   builder: (context) {
    //                     return AlertDialog(
    //                       title: Center(child: Text("Entrega tu Feedback")),
    //                       content: Container(
    //                         width: 300, // Ajusta el ancho según sea necesario
    //                         height: 200, // Ajusta la altura según sea necesario
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.all(
    //                                   10), // Ajusta el padding según sea necesario
    //                               child: CustomTextInput(
    //                                   onChanged: (message) {
    //                                     ref
    //                                         .read(feedbackProvider.notifier)
    //                                         .update((state) => message);
    //                                   },
    //                                   obscureText: false),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       actions: <Widget>[
    //                         TextButton(
    //                           child: Text('Cancelar'),
    //                           onPressed: () {
    //                             Navigator.of(context).pop();
    //                           },
    //                         ),
    //                         TextButton(
    //                           child: Text('Enviar'),
    //                           onPressed: () {
    //                             //TODO feedback
    //                             // Acciones a realizar cuando se presiona el botón "Enviar"
    //                             sendMessage(false, "nombre", feebackmessage,
    //                                 "photo", "feedback");
    //                           },
    //                         ),
    //                       ],
    //                     );
    //                   },
    //                 );

    //                 // Acciones cuando se selecciona la opción
    //               },
    //               icon: Icon(
    //                 Icons.message,
    //                 color: Colors.black,
    //               ),
    //               label: Text(
    //                 'Feedback',
    //                 style: TextStyle(color: Colors.black),
    //               ),
    //               style: ElevatedButton.styleFrom(
    //                 minimumSize:
    //                     Size(double.infinity, 50), // Ancho completo del botón
    //               ),
    //             ),
    //             SizedBox(height: 30), // Espacio entre botones
    //             ElevatedButton.icon(
    //               onPressed: () {
    //                 showDialog(
    //                   context: context,
    //                   builder: (context) {
    //                     return AlertDialog(
    //                       title: Center(child: Text("Mesage para colaborar")),
    //                       content: Container(
    //                         width: 300, // Ajusta el ancho según sea necesario
    //                         height: 200, // Ajusta la altura según sea necesario
    //                         child: Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.all(
    //                                   10), // Ajusta el padding según sea necesario
    //                               child: CustomTextInput(
    //                                   onChanged: (message) {
    //                                     ref
    //                                         .read(colaborarProvider.notifier)
    //                                         .update((state) => message);
    //                                     //TODO obtener colaboracion text
    //                                   },
    //                                   obscureText: false),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       actions: <Widget>[
    //                         TextButton(
    //                           child: Text('Cancelar'),
    //                           onPressed: () {
    //                             Navigator.of(context).pop();
    //                           },
    //                         ),
    //                         TextButton(
    //                           child: Text('Enviar'),
    //                           onPressed: () {
    //                             // Acciones a realizar cuando se presiona el botón "Enviar"
    //                             sendMessage(false, "nombre", colabmessage,
    //                                 "photo", "colaborar");
    //                           },
    //                         ),
    //                       ],
    //                     );
    //                   },
    //                 );
    //               },
    //               icon: Icon(
    //                 Icons.developer_board,
    //                 color: Colors.black,
    //               ),
    //               label:
    //                   Text('Colaborar', style: TextStyle(color: Colors.black)),
    //               style: ElevatedButton.styleFrom(
    //                 minimumSize: Size(double.infinity, 50),
    //               ),
    //             ),
    //             SizedBox(height: 30),
    //             ElevatedButton.icon(
    //               onPressed: () {
    //                 // Acciones cuando se selecciona la opción
    //                 Share.share('check out my website https://example.com',
    //                         subject: 'Look what I made!')
    //                     .then((value) => {
    //                           sendMessage(
    //                               true, "nombre", "", "photo", "Compartir")
    //                         });
    //               },
    //               icon: Icon(
    //                 Icons.share,
    //                 color: Colors.black,
    //               ),
    //               label:
    //                   Text('Compartir', style: TextStyle(color: Colors.black)),
    //               style: ElevatedButton.styleFrom(
    //                 minimumSize: Size(double.infinity, 50),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    final images = [
      "https://cdn.shopify.com/s/files/1/0229/0839/files/bancos_de_imagenes_gratis.jpg?v=1630420628",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1mZ60rzVBwxkvOG_7EwK4GCPTWcRHru8DWgYiJlc8QU2AHu8dbwESBrXj4j_JVG2HV9o&usqp=CAU",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsRwsIBwmJsXqJiBxL41D7IBTFeOTDTNusvNZEyono7Iko_fenXG24SBflpE6Px422-rU&usqp=CAU"
    ];
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
                      fit: BoxFit.fill,
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
                height: 800,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(0xffE3E3E3),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Probar >",
                          style: TextStyle(color: Colors.black),
                        )),
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
                    // Container(
                    //   height: 220,
                    //   width: 300,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xff262626),
                    //     borderRadius:
                    //         BorderRadius.circular(20), // Radio circular
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey
                    //             .withOpacity(0.1), // Color de la sombra
                    //         spreadRadius: 5, // Radio de difusión de la sombra
                    //         blurRadius: 7, // Radio de desenfoque de la sombra
                    //         offset: Offset(0, 3), // Desplazamiento de la sombra
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Los principales obstáculos",
                    //         style: TextStyle(fontSize: 16, color: Colors.white),
                    //       ),
                    //       SizedBox(height: 10),
                    //       Text(
                    //         "${proyec.obstaculos}",
                    //         style: TextStyle(fontSize: 16, color: Colors.white),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ],
                    //   ),
                    // ),

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
  

  @override
  Widget build(BuildContext context) {
      final proyec = ref.watch(proyectIntoProvider);
    final colabmessage = ref.watch(colaborarProvider);
    final feebackmessage = ref.watch(feedbackProvider);
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff979797)),
                  ),
                  SizedBox(height: 20),
                  CustomText2Input(
                    hintText: "feedback",
                    onChanged: (message) {
                      // Handle feedback input change
                      ref.read(feedbackProvider.notifier).update((state) => message);
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
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('Enviar'),
                    onPressed: () {
                      //TODO feedback
                      // Acciones a realizar cuando se presiona el botón "Enviar"
                      // sendMessage(false, "nombre", feebackmessage,
                      //     "photo", "feedback");
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff979797)),
                      ),
                      SizedBox(height: 20),
                      CustomText2Input(
                        hintText: "Colaborar",
                        onChanged: (message) {
                          // Handle collaborate input change
                          ref.read(colaborarProvider.notifier).update((state) => message);
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
                           sendMessage(false, "nombre", feebackmessage,
                               "photo", "feedback");
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Apoya al Proyecto",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        label: Text('Feedback', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            showCollaborateInput = true;
                          });
                        },
                        icon: Icon(Icons.developer_board, color: Colors.black),
                        label: Text('Colaborar', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle share action
                          Share.share('check out my website https://example.com', subject: 'Look what I made!');
                        },
                        icon: Icon(Icons.share, color: Colors.black),
                        label: Text('Compartir', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
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
