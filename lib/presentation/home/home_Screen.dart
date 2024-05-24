import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/presentation/views/events_view.dart';
import 'package:startupspace/presentation/views/home_view.dart';
import 'package:startupspace/presentation/views/profile_view.dart';
import 'package:startupspace/presentation/views/proyects_view.dart';
import 'package:startupspace/widgets/shared/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const [
    HomeView(),
    // SizedBox(),
    ProyectsView(),
    EventsView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.grey[400],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            //con
            //  _showBottomSheet(context);
              context.push("/AddProyectScreen");
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          mini: false,
          child: Icon(Icons.add, color: Colors.black),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70, // Ajusta la altura según sea necesario
        child: CustomBottomNavigation(currentIndex: pageIndex),
      ),
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
    );
  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    

    context: context,
    isScrollControlled:
        true, // Permite que el bottom sheet se desplace hacia arriba
    builder: (BuildContext context) {
      return Wrap(
        
        children: [
          Container(
            height: 600,
            width: 370,
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
            padding:const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            SizedBox(height: 10,),
       IconButton(onPressed: (){}, icon: Icon(Icons.add)),
             const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Comparte tu proyecto con la comunidad de Startup space",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              
              
                // Agrega más widgets según sea necesario
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      context
                          .go("/AddProyect2Screen"); // Cierra el bottom sheet
                      // Acción a realizar cuando se presione el botón
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.black),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Idea',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cierra el bottom sheet
                      // Acción a realizar cuando se presione el botón
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.rocket, color: Colors.black),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Prototipo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cierra el bottom sheet
                      // Acción a realizar cuando se presione el botón
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.work, color: Colors.black),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Startup',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Cierra el bottom sheet
                      },
                      child: Column(
                        children: [
                          
                          Icon(Icons.arrow_back_sharp), Text("Atrás"),
                           SizedBox(
                  height: 20,
                ),
                          ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}
