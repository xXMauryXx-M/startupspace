import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:startupspace/widgets/shared/custom_bottom_navigation.dart';

final passNextProvider = StateProvider<bool>((ref) {
  return false;
});
final passNextFace3Provider = StateProvider<bool>((ref) {
  return false;
});
final passNextContactProvider = StateProvider<bool>((ref) {
  return false;
});

final choseProvider = StateProvider<String>((ref) {
  return "";
});
final nameProyectProvider = StateProvider<String>((ref) {
  return "";
});
final descriptionProyectProvider = StateProvider<String>((ref) {
  return "";
});
final onedresriptionProyectProvider = StateProvider<String>((ref) {
  return "";
});
final oobstaculosProyectProvider = StateProvider<String>((ref) {
  return "";
});
final imageProvider = StateProvider<List<String>>((ref) {
  return [];
});
final isloading = StateProvider<bool>((ref) {
  return false;
});
Future<void> pickAndUploadImages(BuildContext context, WidgetRef reff) async {
  final List<String> imageUrls = [];
  final picker = ImagePicker();

  try {
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFiles != null) {
      reff.read(isloading.notifier).update((state) => true);
      for (var pickedFile in pickedFiles) {
        try {
          final Reference ref = FirebaseStorage.instance
              .ref()
              .child('images/${DateTime.now().toString()}');
          final UploadTask uploadTask = ref.putFile(File(pickedFile.path));
          final TaskSnapshot storageTaskSnapshot = await uploadTask;
          final String url = await storageTaskSnapshot.ref.getDownloadURL();

          imageUrls.add(url);
          reff.read(imageProvider.notifier).update((state) => imageUrls);
        } catch (e) {
          print('Error al subir imagen: $e');
        }
      }
      reff.read(isloading.notifier).update((state) => false);
      // Actualizar el StateProvider con los URLs de las imágenes
      // context.read(imageProvider).state = [...context.read(imageProvider).state, ...imageUrls];
    }
  } catch (e) {
    print('Error al seleccionar imágenes: $e');
  }
}

// Future<String?> takePhoto1() async {
//   final XFile? photo = await ImagePicker()
//       .pickImage(source: ImageSource.camera, imageQuality: 80);
//   if (photo == null) return null;

//   ref.read(imagerProvider.notifier).update((state) => photo.path);
//   Reference referenceRoot = FirebaseStorage.instance.ref();
//   Reference referenceDirImages = referenceRoot.child("photosPet");
//   Reference referenceImageToUplad = referenceDirImages.child(photo.name);
//   try {
//     await referenceImageToUplad.putFile(File(photo.path));
//     imagerUrl = await referenceImageToUplad.getDownloadURL();
//     print("imageurl${imagerUrl}");
//     ref.read(urlrProvider.notifier).update((state) => imagerUrl);
//     ref.read(isurlrFinishProvider.notifier).update((state) => true);
//   } catch (e) {
//     return null;
//   }
// }

class AddProyectScreen extends ConsumerWidget {
  const AddProyectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passNext = ref.watch(passNextProvider);
    final chose = ref.watch(choseProvider);
    return passNext
        ? AddProyect22Screen(
            choseMessage: chose,
          )
        : Scaffold(
            backgroundColor: Colors.grey.withOpacity(0.2),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: Container(
                  width: 800,
                  height: 800,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      // Agrega un borde
                      color: Colors.black, // Color del borde
                      width: 2, // Ancho del borde
                    ),
                    borderRadius: BorderRadius.circular(
                        20), // Opcional: agrega bordes redondeados
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Comparte tu proyecto con la comunidad de Startup space",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff818181)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "¿En qué etapa está tu proyecto?",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // SizedBox(
                      //   height: 0,
                      // ),

                      SizedBox(
                        height: 30,
                      ),
                      // Agrega más widgets según sea necesario
                      SizedBox(
                        width: 200, // Ancho deseado del botón
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(passNextProvider.notifier)
                                .update((state) => true);
                            ref
                                .read(choseProvider.notifier)
                                .update((state) => "idea");

                            // context.go("/AddProyect2Screen");
                            // Acción a realizar cuando se presione el botón
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Color de fondo del botón
                            padding: const EdgeInsets.all(
                                16), // Espaciado dentro del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Bordes redondeados del botón
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: Colors.black), // Icono del botón
                              SizedBox(
                                  width:
                                      8), // Espacio entre el icono y el texto
                              Expanded(
                                child: Text(
                                  'Idea', // Texto del botón
                                  textAlign: TextAlign
                                      .center, // Alineación del texto al centro
                                  style: TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontSize: 16, // Tamaño del texto
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      SizedBox(
                        width: 200, // Ancho deseado del botón
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(passNextProvider.notifier)
                                .update((state) => true);
                            ref
                                .read(choseProvider.notifier)
                                .update((state) => "prototipo");
                            // Acción a realizar cuando se presione el botón
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Color de fondo del botón
                            padding: const EdgeInsets.all(
                                16), // Espaciado dentro del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Bordes redondeados del botón
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.rocket,
                                  color: Colors.black), // Icono del botón
                              SizedBox(
                                  width:
                                      8), // Espacio entre el icono y el texto
                              Expanded(
                                child: Text(
                                  'Prototipo', // Texto del botón
                                  textAlign: TextAlign
                                      .center, // Alineación del texto al centro
                                  style: TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontSize: 16, // Tamaño del texto
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      SizedBox(
                        width: 200, // Ancho deseado del botón
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(passNextProvider.notifier)
                                .update((state) => true);
                            ref
                                .read(choseProvider.notifier)
                                .update((state) => "startup");
                            // Acción a realizar cuando se presione el botón
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.white, // Color de fondo del botón
                            padding: const EdgeInsets.all(
                                16), // Espaciado dentro del botón
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Bordes redondeados del botón
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.work,
                                  color: Colors.black), // Icono del botón
                              SizedBox(
                                  width:
                                      8), // Espacio entre el icono y el texto
                              Expanded(
                                child: Text(
                                  'Startup', // Texto del botón
                                  textAlign: TextAlign
                                      .center, // Alineación del texto al centro
                                  style: TextStyle(
                                    color: Colors.black, // Color del texto
                                    fontSize: 16, // Tamaño del texto
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.arrow_back_sharp),
                                Text("Atras")
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class AddProyect22Screen extends ConsumerWidget {
  final String choseMessage;
  const AddProyect22Screen({super.key, required this.choseMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameproyect = ref.watch(nameProyectProvider);
    final proyectDescription = ref.watch(onedresriptionProyectProvider);
    final passnext = ref.watch(passNextFace3Provider);

    return passnext
        ? const Face3()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // Oculta el teclado al tocar fuera de los campos de texto
            },
            child: FadeIn(
              child: Scaffold(
                backgroundColor: Colors.grey.withOpacity(0.2),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                    child: Container(
                      width: 800,
                      height: 900,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Comparte tu proyecto con la comunidad de Startup space",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff818181)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              maxLines: null,
                              onChanged: (value) {
                                ref
                                    .read(nameProyectProvider.notifier)
                                    .update((state) => value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: nameproyect.isNotEmpty
                                    ? "${nameproyect}(nombre Proyecto)"
                                    : "Nombre del Proyecto",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
                              textAlign: TextAlign.center,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .unfocus(); // Oculta el teclado al presionar "return"
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              maxLength: 80,
                              maxLines: 2,
                              onChanged: (value) {
                                ref
                                    .read(
                                        onedresriptionProyectProvider.notifier)
                                    .update((state) => value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: proyectDescription.isNotEmpty
                                    ? "${proyectDescription}(descripcion proyecto)"
                                    : "De qué trata (en pocas palabras)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 70, horizontal: 16),
                              ),
                              textAlign: TextAlign.center,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .unfocus(); // Oculta el teclado al presionar "return"
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 110,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(passNextProvider.notifier)
                                          .update((state) => false);
                                    },
                                    child: const Column(
                                      children: [
                                        Icon(Icons.arrow_back_sharp),
                                        Text("Atras")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (nameproyect.isEmpty ||
                                          proyectDescription.isEmpty) {
                                        const snackbar = SnackBar(
                                            content: Text(
                                                "Debes Completar todos los campos"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                      } else {
                                        ref
                                            .read(
                                                passNextFace3Provider.notifier)
                                            .update((state) => true);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward,
                                          color: nameproyect.isEmpty ||
                                                  proyectDescription.isEmpty
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Paso 1 de 3")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class Face3 extends ConsumerWidget {
  const Face3({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = ref.watch(descriptionProyectProvider);
    final obstaculos = ref.watch(oobstaculosProyectProvider);
    final contactbool = ref.watch(passNextContactProvider);
    final images = ref.watch(imageProvider);
    final nameproyect = ref.watch(nameProyectProvider);
    // final UploadPhotoService _uploadPhotoService = UploadPhotoService();
    final isload = ref.watch(isloading);
    return contactbool
        ? Contact()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: FadeIn(
              child: Scaffold(
                backgroundColor: Colors.grey.withOpacity(0.2),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                    child: Container(
                      width: 800,
                      height: 900,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$nameproyect",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              maxLength: 190,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                ref
                                    .read(descriptionProyectProvider.notifier)
                                    .update((state) => value);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(16),
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: 'Description',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              maxLength: 190,
                              maxLines: 3,
                              onChanged: (value) {
                                ref
                                    .read(oobstaculosProyectProvider.notifier)
                                    .update((state) => value);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(16),
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: 'Tus principales obstáculos',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                            ),
                            height: 90,
                            width: 240,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: isload
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Center(
                                            child: Text(
                                          "Cargando...",
                                          textAlign: TextAlign.center,
                                        )),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          images.isEmpty
                                              ? SizedBox(width: 10)
                                              : SizedBox(),
                                          images.isEmpty
                                              ? Text("Imágenes")
                                              : SizedBox(),
                                          images.isEmpty
                                              ? SizedBox(width: 20)
                                              : SizedBox(),
                                          if (images.isNotEmpty)
                                            Container(
                                              width: 600,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: images.length,
                                                itemBuilder: (context, index) {
                                                  final imageUrl = ref.watch(
                                                      imageProvider)[index];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          width:
                                                              80, // Ajusta el ancho según tus necesidades
                                                          child: Image.network(
                                                            imageUrl,
                                                            fit: BoxFit
                                                                .cover, // Para ajustar la imagen al contenedor
                                                          ),
                                                        ),
                                                        if (index == 0) ...[
                                                          SizedBox(
                                                              width:
                                                                  10), // Espacio adicional antes del separador
                                                          Container(
                                                            width:
                                                                2, // Ancho del separador
                                                            color: Colors.grey[
                                                                400], // Puede cambiar el color si lo deseas
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          SizedBox(width: 80),
                                          images.isEmpty
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    await pickAndUploadImages(
                                                        context, ref);
                                                  },
                                                  child: Icon(Icons.upload),
                                                )
                                              : SizedBox(),
                                        ],
                                      )),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(passNextFace3Provider.notifier)
                                          .update((state) => false);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.arrow_back_sharp),
                                        Text("Atrás"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (description.isEmpty ||
                                          obstaculos.isEmpty ||
                                          images.isEmpty) {
                                        final snackbar = SnackBar(
                                            content: Text(
                                                "Debes completar todos los campos"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                      } else {
                                        ref
                                            .read(passNextContactProvider
                                                .notifier)
                                            .update((state) => true);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward,
                                          color: description.isEmpty ||
                                                  obstaculos.isEmpty ||
                                                  images.isEmpty
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                        SizedBox(height: 20),
                                        Text("Paso 2 de 3"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // Color de fondo del botón
        elevation: 5, // Altura del sombreado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bordes redondeados
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30, // Tamaño del icono
            color: Colors.black, // Color del icono
          ),
          SizedBox(height: 10), // Espacio entre el icono y el texto
          Text(
            text,
            style: TextStyle(
              color: Colors.black, // Color del texto
              fontWeight: FontWeight.bold, // Negrita del texto
              shadows: [
                Shadow(
                  blurRadius: 2, // Radio de desenfoque
                  color: Colors.grey, // Color del sombreado
                  offset: Offset(1, 1), // Desplazamiento del sombreado
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThreeButtonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Three Buttons'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              icon: Icons.home,
              text: 'Inicio',
              onPressed: () {
                // Acción cuando se presiona el botón de inicio
              },
            ),
            SizedBox(height: 20), // Espacio entre los botones
            CustomButton(
              icon: Icons.search,
              text: 'Buscar',
              onPressed: () {
                // Acción cuando se presiona el botón de buscar
              },
            ),
            SizedBox(height: 20), // Espacio entre los botones
            CustomButton(
              icon: Icons.person,
              text: 'Perfil',
              onPressed: () {
                // Acción cuando se presiona el botón de perfil
              },
            ),
          ],
        ),
      ),
    );
  }
}

final webProvider = StateProvider<String>((ref) {
  return "";
});
final instagramProvider = StateProvider<String>((ref) {
  return "";
});
final phoneProvider = StateProvider<int>((ref) {
  return 0;
});
final githubProvider = StateProvider<String>((ref) {
  return "";
});

final theLastScreen = StateProvider<bool>((ref) {
  return false;
});

class Contact extends ConsumerWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameproyect = ref.watch(nameProyectProvider);
    final proyectDescription = ref.watch(onedresriptionProyectProvider);
    final descrition = ref.watch(descriptionProyectProvider);
    final obstaculos = ref.watch(oobstaculosProyectProvider);
    final web = ref.watch(webProvider);
    final instagram = ref.watch(instagramProvider);
    final phone = ref.watch(phoneProvider);
    final github = ref.watch(githubProvider);
    final chose = ref.watch(choseProvider);
    final end = ref.watch(theLastScreen);
    final images = ref.watch(imageProvider);
    return end
        ? FinalScreen()
        : FadeIn(
            child: Scaffold(
              backgroundColor: Colors.grey.withOpacity(0.2),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Container(
                    width: 800,
                    height: 900,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        // Agrega un borde
                        color: Colors.black, // Color del borde
                        width: 2, // Ancho del borde
                      ),
                      borderRadius: BorderRadius.circular(
                          20), // Opcional: agrega bordes redondeados
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Contacto(opcional)",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Para que personas de la comunidad puedna apoyarte de mejor manera",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: TextField(
                            onChanged: (value) {
                              ref
                                  .read(webProvider.notifier)
                                  .update((state) => value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.web), //
                              filled: true, // Habilita el relleno del campo
                              fillColor:
                                  Colors.grey[200], // Color de fondo gris
                              hintText: 'tu paguina web', // Texto de sugerencia
                              border: OutlineInputBorder(
                                // Establece el borde del campo
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados
                                borderSide: BorderSide.none,
                                // Sin borde
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      16), // Espaciado interno del campo
                            ),
                            textAlign: TextAlign.center, //
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            onChanged: (value) {
                              ref
                                  .read(instagramProvider.notifier)
                                  .update((state) => value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.social_distance), //
                              filled: true, // Habilita el relleno del campo
                              fillColor:
                                  Colors.grey[200], // Color de fondo gris
                              hintText: 'instagram', // Texto de sugerencia
                              border: OutlineInputBorder(
                                // Establece el borde del campo
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados
                                borderSide: BorderSide.none,
                                // Sin borde
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      16), // Espaciado interno del campo
                            ),
                            textAlign: TextAlign.center, //
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: TextField(
                            onChanged: (value) {
                              ref
                                  .read(phoneProvider.notifier)
                                  .update((state) => int.parse(value));
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone), //
                              filled: true, // Habilita el relleno del campo
                              fillColor:
                                  Colors.grey[200], // Color de fondo gris
                              hintText: 'telefono', // Texto de sugerencia
                              border: OutlineInputBorder(
                                // Establece el borde del campo
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados
                                borderSide: BorderSide.none,
                                // Sin borde
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      16), // Espaciado interno del campo
                            ),
                            textAlign: TextAlign.center, //
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 1),
                          child: TextField(
                            onChanged: (value) {
                              ref
                                  .read(githubProvider.notifier)
                                  .update((state) => value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.safety_check), //
                              filled: true, // Habilita el relleno del campo
                              fillColor:
                                  Colors.grey[200], // Color de fondo gris
                              hintText: 'github', // Texto de sugerencia
                              border: OutlineInputBorder(
                                // Establece el borde del campo
                                borderRadius: BorderRadius.circular(
                                    10), // Bordes redondeados
                                borderSide: BorderSide.none,
                                // Sin borde
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      16), // Espaciado interno del campo
                            ),
                            textAlign: TextAlign.center, //
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(passNextContactProvider.notifier)
                                        .update((state) => false);
                                    // context.go("/home/0");
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(Icons.arrow_back_sharp),
                                      Text("Atras"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(theLastScreen.notifier)
                                        .update((state) => true);
                                    Future.delayed(
                                        const Duration(milliseconds: 4000), () {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("proyects")
                                          .add({
                                        "date": DateTime.now(),
                                        "nameproyect": "${nameproyect}",
                                        "proyectDescription":
                                            "${proyectDescription}",
                                        "descrition": "${descrition}",
                                        "obstaculos": "${obstaculos}",
                                        "web": "${web}",
                                        "instagram": "${instagram}",
                                        "phone": "${phone}",
                                        "github": "${github}",
                                        "chose": chose,
                                        "images": images,
                                        "uid": FirebaseAuth
                                            .instance.currentUser!.uid
                                      }).then((value) => ref
                                              .read(readyProvider.notifier)
                                              .update((state) => true));
                                    }).then((value) => {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "proyect": FieldValue.increment(1)
                                          })
                                        });

                                    //un future.delay

                                    //aca subir toda la info
                                    // if (descrition.isEmpty ||
                                    //     obstaculos.isEmpty) {
                                    //   const snackbar = SnackBar(
                                    //       content: Text(
                                    //           "Debes Completar todos losc campos"));
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(snackbar);
                                    // } else {
                                    //   //pasar a la siguente
                                    // }
                                    //aca valirda

                                    // context.pop();
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Paso 3 de 3")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

final readyProvider = StateProvider<bool>((ref) {
  return false;
});

class FinalScreen extends ConsumerWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReady = ref.watch(readyProvider);
    return FadeIn(
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.2),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Container(
              width: 800,
              height: 900,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(
                  // Agrega un borde
                  color: Colors.black, // Color del borde
                  width: 2, // Ancho del borde
                ),
                borderRadius: BorderRadius.circular(
                    20), // Opcional: agrega bordes redondeados
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isReady ? "Listo" : "Que buena idea!😆",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  isReady
                      ? SizedBox()
                      : Center(
                          child: LinearProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: isReady
                        ? GestureDetector(
                            onTap: () {
                              context.push("/home/1");
                              ref
                                  .read(theLastScreen.notifier)
                                  .update((state) => true);

                              ref
                                  .read(nameProyectProvider.notifier)
                                  .update((state) => "");
                              ref
                                  .read(passNextProvider.notifier)
                                  .update((state) => false);
                              ref
                                  .read(passNextFace3Provider.notifier)
                                  .update((state) => false);
                              ref
                                  .read(passNextContactProvider.notifier)
                                  .update((state) => false);
                              ref
                                  .read(choseProvider.notifier)
                                  .update((state) => "");
                              ref
                                  .read(descriptionProyectProvider.notifier)
                                  .update((state) => "");
                              ref
                                  .read(onedresriptionProyectProvider.notifier)
                                  .update((state) => "");
                              ref
                                  .read(oobstaculosProyectProvider.notifier)
                                  .update((state) => "");
                              ref
                                  .read(imageProvider.notifier)
                                  .update((state) => []);
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: 'puedes ver tu ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18), // Estilo para "Texto"
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: 'proyecto aqui',
                                    style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors
                                          .black, // Opcional: puedes personalizar el color del subrayado
                                      decorationThickness:
                                          2.0, // Opcional: puedes personalizar el grosor del subrayado
                                    ),
                                  )
                                ])),
                          )
                        : Text(
                            "Estamos subiendo tu proyecto a la Comunidad",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                      onTap: () {
                        ref
                            .read(theLastScreen.notifier)
                            .update((state) => true);

                        ref
                            .read(nameProyectProvider.notifier)
                            .update((state) => "");
                        ref
                            .read(passNextProvider.notifier)
                            .update((state) => false);
                        ref
                            .read(passNextFace3Provider.notifier)
                            .update((state) => false);
                        ref
                            .read(passNextContactProvider.notifier)
                            .update((state) => false);
                        ref.read(choseProvider.notifier).update((state) => "");
                        ref
                            .read(descriptionProyectProvider.notifier)
                            .update((state) => "");
                        ref
                            .read(onedresriptionProyectProvider.notifier)
                            .update((state) => "");
                        ref
                            .read(oobstaculosProyectProvider.notifier)
                            .update((state) => "");
                        ref.read(imageProvider.notifier).update((state) => []);
                      },
                      child: Text(
                        "o volver al inicio",
                        style: TextStyle(fontSize: 18),
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final passfinalProvider = StateProvider<bool>((ref) {
  return false;
});
