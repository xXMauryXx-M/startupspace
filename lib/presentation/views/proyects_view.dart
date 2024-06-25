import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/presentation/providers/auth/proyects/proyects_repository_provider.dart';

final filterProvider = StateProvider<String>((ref) => 'todo');

class FilterBar extends ConsumerStatefulWidget {
  final List<String> options;

  const FilterBar({
    Key? key,
    required this.options,
  }) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<FilterBar> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption =
        widget.options.first; // Inicialmente selecciona la primera opción
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = 80;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffD4D4D4), // Color de fondo de la barra
        borderRadius:
            BorderRadius.circular(25.0), // Bordes redondeados de la barra
      ),
      height: 50,
      // Altura de la barra de filtro
      child: Stack(
        children: [
          Row(
            children: widget.options.map((option) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOption = option;
                  });
                  ref.read(filterProvider.notifier).state = option;
                },
                child: Container(
                  width: itemWidth,
                  color: Colors
                      .transparent, // Hace que el contenedor sea transparente para que la detección de gestos funcione correctamente
                  child: Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: option == _selectedOption
                            ? Colors.black87
                            : Color(
                                0xff828282), // Color del texto activo o inactivo
                        fontWeight: option == _selectedOption
                            ? FontWeight.bold
                            : FontWeight
                                .normal, // Peso de la fuente activa o inactiva
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          AnimatedPositioned(
            duration: Duration(
                milliseconds: 200), // Duración de la animación más rápida
            curve: Curves.easeInOut, // Curva de animación
            left: widget.options.indexOf(_selectedOption) * itemWidth,
            width: itemWidth,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF4F4F4)
                    .withOpacity(0.2), // Color de fondo activo con opacidad
                borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                ], // Sombra
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProyectsView extends ConsumerWidget {
  const ProyectsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(proyectFirebaseProvider);
    final filter = ref.watch(filterProvider);

    return projects.when(
      data: (data) {
        // Filtrar los proyectos según el filtro seleccionado
        final filteredProjects = filter == 'todo'
            ? data
            : data.where((project) => project.chose == filter).toList();

        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 70),
              child: Column(
                children: [
               const   Align( alignment: Alignment.bottomLeft, child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Proyectos",style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w700),),
                  )),
                const  SizedBox(height: 25),
                 const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FilterBar(
                      options: ["todo", "idea", "startup", "prototipo"],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        final project = filteredProjects[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push("/IntoProyect");
                                ref
                                    .read(proyectIntoProvider.notifier)
                                    .update((state) => project);
                              },
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
                                          child: Container(
                                            height: double.infinity,
                                            width: 60,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(21),
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Image.network(
                                                  "${project.images.isNotEmpty ? project.images[0] : 'https://via.placeholder.com/60'}",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${project.nameproyect}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 4.0),
                                                  child: Text(
                                                    "${project.proyectDescription}",
                                                    style: TextStyle(
                                                        color: Colors.white),
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
                                      child:
      
                                     
                                      
                                     project.chose=="startup"?  Icon(
                                        Icons.rocket,
                                        color: Colors.white,
                                      ):
                                      project.chose=="idea"?
                                       Icon(Icons.lightbulb,color: Colors.white,):
                                       project.chose=="prototipo"?
                                       Icon(Icons.work,color: Colors.white,):Icon(Icons.abc,color: Colors.white,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                          ],
                        );
                      },
                    ),
                  ),
  
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text("Error: $error"));
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SquareButton2 extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool selected;

  const SquareButton2({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400], // Color del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1), // Bordes redondeados
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            color: selected
                ? Colors.black
                : Colors
                    .white, // Cambia el color del icono según el estado de selección
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: selected ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomToggleButtons extends StatefulWidget {
  @override
  _CustomToggleButtonsState createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List<bool>.filled(
        4, false); // Inicializa todos los botones como no seleccionados
    _isSelected[0] =
        true; // Marca el primer botón como seleccionado inicialmente
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ToggleButtons(
        borderWidth: 0,
        borderColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
        isSelected: _isSelected,
        onPressed: (int index) {
          setState(() {
            // Cambia el estado del botón presionado
            _isSelected[index] = !_isSelected[index];
          });
        },
        children: [
          SquareButton2(
            icon: Icons.abc,
            text: 'Todo',
            onPressed: () {
              _handleSelection(0);
            },
            selected: _isSelected[0],
          ),
          SquareButton2(
            icon: Icons.ac_unit_sharp,
            text: 'Idea',
            onPressed: () {
              _handleSelection(1);
            },
            selected: _isSelected[1],
          ),
          SquareButton2(
            icon: Icons.ac_unit_sharp,
            text: 'Prototipo',
            onPressed: () {
              _handleSelection(2);
            },
            selected: _isSelected[2],
          ),
          SquareButton2(
            icon: Icons.ac_unit_sharp,
            text: 'startup',
            onPressed: () {
              _handleSelection(3);
            },
            selected: _isSelected[3],
          ),
        ],
      ),
    );
  }

  void _handleSelection(int index) {
    setState(() {
      // Cambia el estado de selección del botón
      _isSelected[index] = !_isSelected[index];
      // Deselecciona todos los demás botones
      for (int i = 0; i < _isSelected.length; i++) {
        if (i != index) {
          _isSelected[i] = false;
        }
      }
    });
  }
}



class DottedBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double dotSpacing;
  final double dotRadius;
  final Color dotColor;
  final String topText;
  final String bottomText;

  const DottedBox({
    Key? key,
    required this.width,
    required this.height,
    this.color = Colors.black,
    this.dotSpacing = 4.0, // Reducir el espaciado entre los puntos
    this.dotRadius = 1.0, // Reducir el radio de los puntos
    this.dotColor = Colors.white,
    this.topText = "",
    this.bottomText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
      child: Stack(
        children: [
          CustomPaint(
            painter: DottedBorderPainter(
              dotSpacing: dotSpacing,
              dotRadius: dotRadius,
              dotColor: dotColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  topText,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  bottomText,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.add,color: Colors.white,size: 30,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final double dotSpacing;
  final double dotRadius;
  final Color dotColor;

  DottedBorderPainter({
    required this.dotSpacing,
    required this.dotRadius,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dotColor
      ..strokeWidth = 1.0;

    final double horizontalDots = (size.width / dotSpacing).ceilToDouble();
    final double verticalDots = (size.height / dotSpacing).ceilToDouble();

    // Draw dots on top and bottom edges
    for (int i = 0; i < horizontalDots; i++) {
      final double x = i * dotSpacing;
      canvas.drawCircle(Offset(x, 0), dotRadius, paint); // Top edge
      canvas.drawCircle(Offset(x, size.height), dotRadius, paint); // Bottom edge
    }

    // Draw dots on left and right edges (except at the corners to avoid duplication)
    for (int i = 1; i < verticalDots - 1; i++) {
      final double y = i * dotSpacing;
      canvas.drawCircle(Offset(0, y), dotRadius, paint); // Left edge
      canvas.drawCircle(Offset(size.width, y), dotRadius, paint); // Right edge
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


