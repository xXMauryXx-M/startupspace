import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final expandedNotificationProvider = StateProvider<String?>((ref) => null);

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Color(0xff313131),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff313131),
          actions: const [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Icon(
                Icons.message,
                color: Colors.white,
              ),
            ),
          ],
          title: const Text(
            "Notificaciones",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [NotificationNotSeen(), NotificationSeen()],
          ),
        ));
  }
}

class NotificationNotSeen extends StatelessWidget {
  const NotificationNotSeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchNotifications(),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return Column(
            children: [
              const Text("No hay notificaciones Nuevas",style: TextStyle(fontSize: 15,color: Colors.grey),),
              SizedBox(height: 20,)
            ],
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        var notifications = snapshot.data ?? [];

        return SingleChildScrollView(
          child: Column(
            children: notifications.map((notification) {
              var notificationData =
                  notification.data() as Map<String, dynamic>;
              var notificationId = notification.id;

              return NotificationItem(
                notificationId: notificationId,
                notificationData: notificationData,
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("notifications")
                      .doc(notificationId)
                      .update({'seen': true});
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<List<DocumentSnapshot>> fetchNotifications() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .where('seen', isEqualTo: false)
        .get();

    return snapshot.docs;
  }
}

class NotificationItem extends StatefulWidget {
  final String notificationId;
  final Map<String, dynamic> notificationData;
  final VoidCallback onTap;

  const NotificationItem({
    Key? key,
    required this.notificationId,
    required this.notificationData,
    required this.onTap,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isExpanded = false;
  String userName = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        setState(() {
          userName = docSnapshot.data()?['name'] ?? '';
          photo = docSnapshot.data()?["photo"] ?? '';
        });
      }
    } catch (e) {
      print("Error al obtener el nombre: $e");
    }
  }

  Widget _buildNotificationText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Builder(
        builder: (context) {
          if (widget.notificationData['type'] == "acceptableNotification") {
            if (widget.notificationData["acceptableNotification"] == true) {
              return Text(
                "${widget.notificationData["gmail"]}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              );
            } else {
              return const Text("Solicitud rechazada");
            }
          } else {
            if (widget.notificationData.containsKey("acceptable") &&
                widget.notificationData["acceptable"] == true) {
              return const Text(
                "Le hemos notificado que has aceptado su solicitud y se pondrá en contacto contigo lo antes posible",
                style: TextStyle(color: Colors.white, fontSize: 15),
              );
            } else {
              return Text(
                widget.notificationData['message'] ??
                    " ${widget.notificationData["name"]} ha aceptado tu petición de colaboración. Su contacto es: ${widget.notificationData['contact']}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasAcceptableColaboration =
        widget.notificationData.containsKey('acceptableColaboration') &&
            widget.notificationData['acceptableColaboration'] is bool;
    bool acceptableColaboration = hasAcceptableColaboration
        ? widget.notificationData['acceptableColaboration']
        : false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        if (!_isExpanded) {
          widget.onTap();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xff3B3B3B),
          borderRadius: BorderRadius.circular(26),
        ),
        width: 340,
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      NetworkImage(widget.notificationData['photo'] ?? ""),
                ),
                const SizedBox(width: 10),
                acceptableColaboration
                    ? Text("nombre", style: TextStyle(color: Colors.white))
                    : Text(
                        widget.notificationData['name'] ?? 'No name',
                        style: TextStyle(color: Colors.white),
                      ),
                acceptableColaboration
                    ? Text(
                        "${widget.notificationData["type"] == "colaborar" ? "ha solicitado colaborar" : widget.notificationData["type"] == "feedback" ? "te ha enviado feedback" : widget.notificationData["type"] == "acceptableColaboration" ? "solicitud aceptada" : "compartir"}",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "${widget.notificationData["type"] == "colaborar" ? "Ha solicitado una colaboración" : widget.notificationData["type"] == "feedback" ? "Te ha entregado feedback" : widget.notificationData["type"] == "acceptableColaboration" ? "solicitud aceptada" : "compartir"}",
                          style: TextStyle(color: Colors.grey[200]),
                        ),
                      ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Column(
                children: [
                  SizedBox(height: 10),
                  _buildNotificationText(),
                  SizedBox(height: 30),
                  widget.notificationData["type"] == "colaborar"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Text(
                                "Cerrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            widget.notificationData.containsKey("acceptable") &&
                                    widget.notificationData["acceptable"] ==
                                        true
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "¿Aceptas la Colaboracion?"),
                                            content: Text(
                                                "Si presionas Aceptar, la persona podrá ver tu contacto."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancelar"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  // Actualizar la notificación original como 'seen' y 'acceptable'
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .collection(
                                                          "notifications")
                                                      .doc(
                                                          widget.notificationId)
                                                      .update({
                                                    'seen': true,
                                                    'acceptable': true
                                                  });

                                                  // Crear una nueva notificación para la persona que solicitó la colaboración
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget
                                                              .notificationData[
                                                          "uidrequest"])
                                                      .collection(
                                                          "notifications")
                                                      .add({
                                                    "name": userName,
                                                    "photo": photo,
                                                    "seen": false,
                                                    "type":
                                                        "acceptableColaboration",
                                                    "idrequest":
                                                        widget.notificationData[
                                                            "uidrequest"],
                                                    "acceptableNotification":
                                                        true,
                                                    "contact": FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .email
                                                  }).then((value) {
                                                    const snackBar = SnackBar(
                                                        content: Text(
                                                            "Has aceptado la colaboración"));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  });

                                                  setState(() {
                                                    widget.notificationData[
                                                        'acceptable'] = true;
                                                  });

                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Aceptar"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSeen extends StatefulWidget {
  @override
  _NotificationSeenState createState() => _NotificationSeenState();
}

class _NotificationSeenState extends State<NotificationSeen> {
  late List<QueryDocumentSnapshot> _notifications = [];
  String userName = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        setState(() {
          userName = docSnapshot.data()?['name'] ?? '';
          photo = docSnapshot.data()?["photo"] ?? '';
        });
      }
    } catch (e) {
      print("Error al obtener el nombre: $e");
    }
  }

  Future<void> _loadNotifications() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .where('seen', isEqualTo: true)
        .get();

    setState(() {
      _notifications = snapshot.docs;
      _notifications.sort((a, b) {
        var aData = a.data() as Map<String, dynamic>?;
        var bData = b.data() as Map<String, dynamic>?;
        var aDate = aData?['date'] as Timestamp?;
        var bDate = bData?['date'] as Timestamp?;
        if (aDate == null && bDate == null) {
          return 0;
        } else if (aDate == null) {
          return 1;
        } else if (bDate == null) {
          return -1;
        } else {
          return bDate.compareTo(aDate);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_notifications.isEmpty)
          const Center(
            child: Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
          )
        else
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Anteriores",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        var notification = _notifications[index];
                        var notificationData =
                            notification.data() as Map<String, dynamic>;
                        var notificationId = notification.id;

                        return _NotificationItem(
                          notificationData: notificationData,
                          notificationId: notificationId,
                          userName: userName,
                          photo: photo,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}

class _NotificationItem extends StatefulWidget {
  final Map<String, dynamic> notificationData;
  final String notificationId;
  final String userName;
  final String photo;

  const _NotificationItem({
    required this.notificationData,
    required this.notificationId,
    required this.userName,
    required this.photo,
  });

  @override
  __NotificationItemState createState() => __NotificationItemState();
}

class __NotificationItemState extends State<_NotificationItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool hasAcceptableColaboration =
        widget.notificationData.containsKey('acceptableColaboration') &&
            widget.notificationData['acceptableColaboration'] is bool;
    bool acceptableColaboration = hasAcceptableColaboration
        ? widget.notificationData['acceptableColaboration']
        : false;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xff3B3B3B),
          borderRadius: BorderRadius.circular(26),
        ),
        width: 340,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                acceptableColaboration
                    ? Text(
                        "nombre",
                        style: TextStyle(color: Colors.white),
                      )
                    : Text(
                        widget.notificationData['name'] ?? 'No name',
                        style: TextStyle(color: Colors.white),
                      ),
                acceptableColaboration
                    ? Text(
                        "${widget.notificationData["type"] == "colaborar" ? "ha solicitado colaborar" : widget.notificationData["type"] == "feedback" ? "te ha enviado feedback" : widget.notificationData["type"] == "acceptableColaboration" ? "solicitud aceptada" : "compartir"}",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "${widget.notificationData["type"] == "colaborar" ? "Ha solicitado colaborar" : widget.notificationData["type"] == "feedback" ? "Te ha entregado feedback" : widget.notificationData["type"] == "acceptableColaboration" ? "solicitud aceptada" : "compartir"}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Column(
                children: [
                  SizedBox(height: 10),
                  _buildNotificationText(),
                  SizedBox(height: 30),
                  widget.notificationData["type"] == "colaborar"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Text(
                                "Cerrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            widget.notificationData.containsKey("acceptable") &&
                                    widget.notificationData["acceptable"] ==
                                        true
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "¿Aceptas la Colaboracion?"),
                                            content: Text(
                                                "Si presionas Aceptar, la persona podrá ver tu contacto"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancelar"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(widget
                                                              .notificationData[
                                                          "uidrequest"])
                                                      .collection(
                                                          "notifications")
                                                      .add({
                                                    "name": widget.userName,
                                                    "photo": widget.photo,
                                                    "seen": false,
                                                    "type":
                                                        "acceptableColaboration",
                                                    "idrequest":
                                                        widget.notificationData[
                                                            "uidrequest"],
                                                    "acceptableNotification":
                                                        true,
                                                    "contact": FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .email
                                                  }).then((value) {
                                                    const snackBar = SnackBar(
                                                        content: Text(
                                                            "Has aceptado la colaboración"));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }).then((value) => {
                                                            Navigator.of(
                                                                    context)
                                                                .pop()
                                                          });
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .collection(
                                                          "notifications")
                                                      .doc(
                                                          widget.notificationId)
                                                      .update(
                                                          {'acceptable': true});
                                                  setState(() {
                                                    widget.notificationData[
                                                        'acceptable'] = true;
                                                  });
                                                },
                                                child: Text("Aceptar"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Builder(
        builder: (context) {
          if (widget.notificationData["type"] == "acceptableNotification") {
            if (widget.notificationData["acceptableNotification"] == true) {
              return Text(
                "${widget.notificationData["gmail"]}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              );
            } else {
              return const Text("Solicitud rechazada");
            }
          } else {
            if (widget.notificationData.containsKey("acceptable") &&
                widget.notificationData["acceptable"] == true) {
              return const Text(
                "Le hemos notificado que has aceptado su solicitud y se pondrá en contacto contigo lo antes posible",
                style: TextStyle(color: Colors.white, fontSize: 15),
              );
            } else {
              return Text(
                widget.notificationData['message'] ??
                    " ${widget.notificationData["name"]} ha aceptado tu petición de colaboración. Su contacto es: ${widget.notificationData['contact']}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              );
            }
          }
        },
      ),
    );
  }
}

class ExpandableBox extends StatefulWidget {
  @override
  _ExpandableBoxState createState() => _ExpandableBoxState();
}

class _ExpandableBoxState extends State<ExpandableBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Presiona para ver más',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Text(
                'Este es el contenido oculto que ahora es visible. Puedes añadir más texto o widgets aquí según sea necesario.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}

//en pasadas es por que el documento  ha sido visto es true
//por lo cual debo filtrar por ese campo


//                   SizedBox(
//                     height: 40,
//                   ),
//                   Text("anteriore"),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Color(0xff2D2D2D),
//                       borderRadius: BorderRadius.circular(
//                           26), // Cambia el valor según tus necesidades
//                     ),
//                     width: 340,
//                     height: 40,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               "Diego Vargas ",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             Text(" ha solicitado colaborar",
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Color(0xff2D2D2D),
//                       borderRadius: BorderRadius.circular(
//                           26), // Cambia el valor según tus necesidades
//                     ),
//                     width: 340,
//                     height: 40,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               "Diego Vargas ",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             Text(" ha solicitado colaborar",
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ));
//   }
// }
