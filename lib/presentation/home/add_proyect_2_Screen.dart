import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/widgets/shared/custom_text_form_field.dart';

class AddProyect2Screen extends StatelessWidget {
  const AddProyect2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Comparteeee tu proyecto con la comunidad de Startup space",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true, // Habilita el relleno del campo
                      fillColor: Colors.grey[200], // Color de fondo gris
                      hintText: 'Nombre del Proyecto', // Texto de sugerencia
                      border: OutlineInputBorder(
                        // Establece el borde del campo
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                        borderSide: BorderSide.none, // Sin borde
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16), // Espaciado interno del campo
                    ),
                    textAlign: TextAlign.center, //
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true, // Habilita el relleno del campo
                      fillColor: Colors.grey[200], // Color de fondo gris
                      hintText:
                          'De que trata(en pocas palabras)', // Texto de sugerencia
                      border: OutlineInputBorder(
                        // Establece el borde del campo
                        borderRadius:
                            BorderRadius.circular(10), // Bordes redondeados
                        borderSide: BorderSide.none,
                        // Sin borde
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 70,
                          horizontal: 16), // Espaciado interno del campo
                    ),
                    textAlign: TextAlign.center, //
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            context.go("/home/0");
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
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: const Column(
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.grey,
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
    );
  }
}
