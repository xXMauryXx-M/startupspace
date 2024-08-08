import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  title: const Text('Cerrar Sesión'),
                  content: const Text('¿Estás Seguro que deseas salir?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Startup Space",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(0.1),
        actions: [
          NotificationIcon(),
          SizedBox(width: 20.w),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
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
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Próximas Meetups",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              MeetupFilter(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
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

    Future<void> launchMeetup(Uri ulr) async {
      if (!await launchUrl(ulr)) {
        throw Exception("could not lauch");
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('meetups').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No hay datos disponibles'),
          );
        }

        String getDayName(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'lunes';
    case DateTime.tuesday:
      return 'martes';
    case DateTime.wednesday:
      return 'miércoles';
    case DateTime.thursday:
      return 'jueves';
    case DateTime.friday:
      return 'viernes';
    case DateTime.saturday:
      return 'sábado';
    case DateTime.sunday:
      return 'domingo';
    default:
      return '';
  }
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'enero';
    case 2:
      return 'febrero';
    case 3:
      return 'marzo';
    case 4:
      return 'abril';
    case 5:
      return 'mayo';
    case 6:
      return 'junio';
    case 7:
      return 'julio';
    case 8:
      return 'agosto';
    case 9:
      return 'septiembre';
    case 10:
      return 'octubre';
    case 11:
      return 'noviembre';
    case 12:
      return 'diciembre';
    default:
      return '';
  }
}

        return SizedBox(
          height: 400.h, // Adaptando la altura
          width: double.infinity,
          child: Swiper(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              
              final meetupDoc = snapshot.data!.docs[index];
              final data = meetupDoc.data() as Map<String, dynamic>;
              final place = data['place'] ?? 'Lugar no disponible';
              final type = data["type"] ?? 'Tipo no disponible';
              final photo = data["photo"] ?? '';
              final description =
                  data["description"] ?? 'Descripción no disponible';
              final timestamp = data['date'] as Timestamp?;
              final link = data['link'];
              final dateTime = timestamp?.toDate() ?? DateTime.now();
                String dayName = getDayName(dateTime.day);
  String monthName = getMonthName(dateTime.month);
 String formattedDate = '$dayName ${dateTime.day} de $monthName del ${dateTime.year}';

           

                 
              print("link${data["link"]}");
              return GestureDetector(
                  onTap: () {
                    //link
                    launchMeetup(Uri.parse("${link}"));
                  },
                  child: SizedBox(
                    height: 400.h,
                    width: 400.w,
                    child: Card(
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  type,
                                  style: TextStyle(
                                      fontSize: 15.sp, color: Colors.white),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(type),
                                            content: Text(description),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('ok'),
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
                            SizedBox(height: 10.h),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            type == "Tech Talks"
                                ? Image.network(
                                    photo,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Image.asset("assets/presentatuidea.jpeg"),
                            SizedBox(height: 10.h),
                            Text(
                              place,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Avenida Presidente Kennedy 5601",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            TextButton(
                              onPressed: () {
                                termsandConditions();
                              },
                              child: Text(
                                "Ver lugares en Maps >",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
            pagination: SwiperPagination(
              builder: const DotSwiperPaginationBuilder(
                activeColor: Colors.white,
                color: Color(0xff4C4C4C),
              ),
              margin: EdgeInsets.symmetric(vertical: 10.h),
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
    return SizedBox(
      width: 400,
      height: 120,
      child: Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          final d = data[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {},
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
                            child: SizedBox(
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
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "${d["proyectDescription"]}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                            maxLines:
                                                2, // Limita el texto a una sola línea
                                            overflow: TextOverflow
                                                .ellipsis, // Agrega puntos suspensivos al final si el texto es demasiado largo
                                          ),
                                        ),
                                      ],
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
                            ? const Icon(
                                Icons.rocket,
                                color: Colors.white,
                              )
                            : d["chose"] == "idea"
                                ? const Icon(
                                    Icons.lightbulb,
                                    color: Colors.white,
                                  )
                                : d["chose"] == "prototipo"
                                    ? const Icon(
                                        Icons.work,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.abc,
                                        color: Colors.white,
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
        itemCount: data.length,
        pagination: const SwiperPagination(
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
  const NotificationIcon({super.key});

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
              return const Stack(
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
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 5,
                        minHeight: 5,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Stack(
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
