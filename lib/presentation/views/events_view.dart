import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final resutProvider = StateProvider<ScanResult>((ref) => ScanResult(rawContent: ''));
final rowProvider = StateProvider<String>((ref) => '');
final namecolectionProvider = StateProvider<String>((ref) => "");

class EventsView extends ConsumerWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoScanner = ref.watch(resutProvider);
    final currentUser = FirebaseAuth.instance.currentUser;
    final colection = ref.watch(namecolectionProvider);

    void _launchURLs(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    }

    Future<void> _scan() async {
      try {
        final result = await BarcodeScanner.scan(
          options: const ScanOptions(
            strings: {
              'cancel': "",
              'flash_on': "",
              'flash_off': "",
            },
            restrictFormat: [],
            useCamera: 0,
          ),
        );

        if (result.rawContent.isNotEmpty &&
            result.rawContent.startsWith("startup-space")) {
          // Usa el resultado del escaneo para crear el nombre de la colección
          final collectionName = result.rawContent;
          final userUid = currentUser!.uid;
          ref.read(namecolectionProvider.notifier).update((state) => collectionName);
          await FirebaseFirestore.instance.collection(collectionName).add({"uid": userUid});
          await FirebaseFirestore.instance.collection("users").doc(userUid).update({"inatablespace": true});

          ref.read(rowProvider.notifier).update((state) => result.rawContent);
          ref.read(resutProvider.notifier).update((state) => result);
        } else {
          // Manejar el caso donde el resultado no cumple con los requisitos
          ref.read(resutProvider.notifier).update((state) {
            return ScanResult(
              rawContent: 'Invalid scan result',
            );
          });
        }
      } on PlatformException catch (e) {
        ref.read(resutProvider.notifier).update((state) {
          return ScanResult(
            rawContent: e.code == BarcodeScanner.cameraAccessDenied
                ? 'The user did not grant the camera permission!'
                : 'Unknown error: $e',
          );
        });
      }
    }

    Future<void> _endMeeting() async {
      final assistants = await FirebaseFirestore.instance.collection(colection).get();

      for (var doc in assistants.docs) {
        final uid = doc.data()["uid"];
        await FirebaseFirestore.instance.collection("users").doc(uid).update({"showUsers": true});
      }
    }

    void showResourcesDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Recursos"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    title: Text("Lean Startup"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://pqs.pe/wp-content/uploads/2021/03/El-metodo-Lean-Startup-PDFDrive-.pdf');
                    },
                  ),
                  ListTile(
                    title: Text("Zero to One"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://theoffice.pe/wp-content/uploads/De%20Cero%20a%20Uno%20Como%20Inventar%20-%20Peter%20Thiel%20VL.pdf');
                    },
                  ),
                  ListTile(
                    title: Text("La clase (fundadores de Cornershop y Fintual explican sobre startups)"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://youtu.be/vUePmkQYIDQ?si=WG1jTWfZaLfGPBAz');
                    },
                  ),
                  ListTile(
                    title: Text("Y Combinator"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://youtu.be/CBYhVcO4WgI?si=vqYu76f3wtF5sNRn');
                    },
                  ),
                  ListTile(
                    title: Text("Noticias de startups en general"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://ecosistemastartup.com');
                    },
                  ),
                  ListTile(
                    title: Text("Startup Chile (aceleradora de startups del gobierno)"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://startupchile.org');
                    },
                  ),
                  ListTile(
                    title: Text("¿Por qué fracasan las startups?"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://rockstart.com/wp-content/uploads/2023/01/Estudio-del-fracaso.pdf');
                    },
                  ),
                  ListTile(
                    title: Text("Podcast de negociar"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://open.spotify.com/show/5q56Q5c5knRHxaefs5uJFx?si=050c4c4add684079');
                    },
                  ),
                  ListTile(
                    title: Text("Cómo hablar con tu cliente"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _launchURLs('https://www.amazon.com/-/es/Rob-Fitzpatrick/dp/1671455355');
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Meetups",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text("Escáner Mesa Startup Space"),
                          content: Text(
                              "Escáner Space te permite escanear la mesa en la que te reúnes y obtener datos de los participantes, recursos y más."),
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.help,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('No user data found'));
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final isInSpace = userData['inatablespace'] ?? false;
                  final showUser = userData['showUsers'] ?? false;

                  if (showUser) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('showUsers', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text(
                            "No hay usuarios para mostrar",
                            style: TextStyle(color: Colors.white),
                          );
                        }

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("¿Deseas salir?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .update({"inatablespace": false, "showUsers": false});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Sí"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("No"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs.map((doc) {
                                  final user = doc.data() as Map<String, dynamic>;
                                  return ListTile(
                                    leading: user['photo'] != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(user['photo']),
                                          )
                                        : const CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                    title: Text(
                                      user['name'] ?? 'No Name',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      user['email'] ?? 'No Email',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => showResourcesDialog(context),
                              icon: Icon(Icons.book),
                              label: Text("Recursos"),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (isInSpace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.group, color: Colors.white, size: 90),
                        const Text(
                          "En reunión...",
                          style: TextStyle(
                            fontSize: 27,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "Al finalizar te daremos el contacto de todos los asistentes",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        if (currentUser.email == "admin01@gmail.com" || currentUser.email == "admin1@gmail.com" || currentUser.email == FirebaseAuth.instance.currentUser!.email)
                          ElevatedButton(
                            onPressed: _endMeeting,
                            child: const Text("Parar la reunión"),
                          ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 90),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff313131),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 240,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Escanear",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const SizedBox(height: 20),
                            IconButton.filledTonal(
                              onPressed: _scan,
                              icon: const Icon(
                                FontAwesomeIcons.qrcode,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Escanea la mesa Startup Space",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
