import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
  Future<void> _reauthenticateUser(BuildContext context, User user) async {
    // Puedes solicitar al usuario que vuelva a ingresar su contraseña o utilizar cualquier otro método de reautenticación
    final password = await _promptForPassword(context); // Debes implementar esta función para pedir la contraseña al usuario
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

 Future<String> _promptForPassword(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController _passwordController = TextEditingController();

        return AlertDialog(
          title: Text('Reautenticación requerida'),
          content: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop('');
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(_passwordController.text);
              },
            ),
          ],
        );
      },
    ) ?? '';
  }

  void _handleFirebaseAuthException(BuildContext context, FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'requires-recent-login':
        errorMessage = 'Por favor, vuelve a iniciar sesión para eliminar tu cuenta.';
        break;
      default:
        errorMessage = 'Error al eliminar la cuenta: ${e.message}';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }


class ProfileView extends StatelessWidget {
  
  const ProfileView({super.key});
//crear el streambilder co el uid de firbease y la coleccion
  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: 
        AppBar(
        backgroundColor: Colors.black.withOpacity(0),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("¿Quieres eliminar tu cuenta?"),
                    content: Text(
                        "Si eliminas tu cuenta, se perderán todos tus datos y no podrás recuperarlos."),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            try {
                              await _reauthenticateUser(context, user);
                              await user.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cuenta eliminada exitosamente.'),
                                ),
                              );
                              Navigator.of(context).pop();
                            } on FirebaseAuthException catch (e) {
                              _handleFirebaseAuthException(context, e);
                            }
                          }
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
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
       backgroundColor: Colors.black.withOpacity(0.8),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                  child: Text(
                      "No data available${FirebaseAuth.instance.currentUser!.uid}"));
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
