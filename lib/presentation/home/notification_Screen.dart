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
            Icon(
              Icons.message,
              color: Colors.white,
            ),
          ],
          title: const Text(
            "Notificaciones",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        body:const SingleChildScrollView(
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
          return Center(child: CircularProgressIndicator());
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
                      .doc("ZyOdtJdsfvYxRzGxxeCrJPg7bk52")
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
        .doc("ZyOdtJdsfvYxRzGxxeCrJPg7bk52")
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
            if (widget.notificationData.containsKey("acceptable") && widget.notificationData["acceptable"] == true) {
              return const Text(
                "Le hemos notificado que has aceptado su solicitud y se pondrá en contacto contigo lo antes posible",
                style: TextStyle(color: Colors.white, fontSize: 15),
              );
            } else {
              return Text(
                widget.notificationData['message'] ?? "",
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
    bool hasAcceptableColaboration = widget.notificationData.containsKey('acceptableColaboration') && widget.notificationData['acceptableColaboration'] is bool;
    bool acceptableColaboration = hasAcceptableColaboration ? widget.notificationData['acceptableColaboration'] : false;

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
                  backgroundImage: NetworkImage(widget.notificationData['photo'] ?? ""),
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

                  : Text(""),
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
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("¿Aceptas la Colaboracion?"),
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
                                            //mandar una notificacion con solicitud aceptada
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc("ZyOdtJdsfvYxRzGxxeCrJPg7bk52")
                                                .collection("notifications")
                                                .doc(widget.notificationId)
                                                .update({'acceptable': true}).then(
                                              (value) {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc("ZyOdtJdsfvYxRzGxxeCrJPg7bk52")
                                                    .collection("notifications")
                                                    .add({
                                                      "seen": false,
                                                      "type": "acceptableColaboration",
                                                      "idrequest": widget.notificationData["uidrequest"],
                                                      "acceptableNotification": true,
                                                      "contact": "correo@gmail.com"
                                                });
                                              },
                                            );

                                            setState(() {
                                              widget.notificationData['acceptable'] = true;
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
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSeen extends ConsumerStatefulWidget {
  const NotificationSeen({Key? key}) : super(key: key);

  @override
  _NotificationSeenState createState() => _NotificationSeenState();
}

class _NotificationSeenState extends ConsumerState<NotificationSeen> {
  late List<QueryDocumentSnapshot> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

Future<void> _loadNotifications() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc("ZyOdtJdsfvYxRzGxxeCrJPg7bk52")
      .collection("notifications")
      .where('seen', isEqualTo: true)
      // .orderBy('timestamp', descending: true) // Ordenar por el campo 'timestamp' de forma descendente
      .get();

  setState(() {
    _notifications = snapshot.docs;
  });
}


  @override
  Widget build(BuildContext context) {
    final expandedNotificationId = ref.watch(expandedNotificationProvider);

    return Column(
      children: [
        if (_notifications.isEmpty)
          const Center(
            child: CircularProgressIndicator(),
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
                  child: Container(
                    height: 900,
                    width: 400,
                    child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        var notification = _notifications[index];
                        var notificationData = notification.data() as Map<String, dynamic>;
                        var notificationId = notification.id;
                        var isExpanded = expandedNotificationId == notificationId;

                        return GestureDetector(
                          onTap: () {
                            ref.read(expandedNotificationProvider.notifier).state =
                                isExpanded ? null : notificationId;
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Color(0xff2D2D2D),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            width: 340,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${notificationData['name']} ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${notificationData["type"] == "feedback" ? " te ha enviado feedback" : "ha solicitado colaborar"}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      isExpanded ? Icons.expand_less : Icons.expand_more,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                AnimatedCrossFade(
                                  firstChild: Container(),
                                  secondChild: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: Text(
                                          notificationData['message'] ?? "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                ref.read(expandedNotificationProvider.notifier).state = null;
                                              },
                                              child: Text(
                                                "Cerrar",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // Acción del botón "Aceptar"
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 300),
                                ),
                              ],
                            ),
                          ),
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
