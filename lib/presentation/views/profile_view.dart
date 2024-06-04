import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
//crear el streambilder co el uid de firbease y la coleccion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff313131),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc("ZyOdtJdsfvYxRzGxxeCrJPg7bk52")
              .snapshots(),
          builder: (context, snapshot) {
    
      if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("No data available"));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
      
            return Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 390,
                    height: 340,
                    decoration: BoxDecoration(
                      color: Color(0xff3B3B3B),
                      borderRadius:
                          BorderRadius.circular(20), // Bordes redondeados
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            "${userData["photo"]}",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${userData["name"]}",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        // Text(
                        //   "hi i am developer and i make apps ",
                        //   style:
                        //       TextStyle(fontSize: 15, color: Color(0xffE0E0E0)),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Proyectos",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text("${userData["proyect"]}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Column(
                              children: [
                                Text("Contribuciones",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                Text("${userData["colaboration"]}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
