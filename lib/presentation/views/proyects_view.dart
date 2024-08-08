import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            duration: const Duration(
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
                boxShadow: const[
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

        filteredProjects.sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 70.h),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Text(
                            "Proyectos",
                            style: TextStyle(
                                fontSize: 28.sp,
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
                                    title: Text("Visualiza y Colabora en Proyectos"),
                                    content: Text("Explora los proyectos en Startup Space, descubre cómo puedes colaborar y deja tu feedback."),
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.help_rounded,
                              color: Colors.white,
                              size: 24.sp, // Tamaño del ícono responsivo
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: FilterBar(
                      options: ["todo", "idea", "startup", "prototipo"],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        final project = filteredProjects[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push("/IntoProyect");
                                ref.read(proyectIntoProvider.notifier).update((state) => project);
                              },
                              child: Container(
                                height: 80.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.w,
                                  ),
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(4.w),
                                          child: Container(
                                            height: double.infinity,
                                            width: 60.w,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(21.r),
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
                                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${project.nameproyect}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.sp),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 4.h),
                                                  child: Text(
                                                    "${project.proyectDescription}",
                                                    maxLines: 2, // Limita el texto a dos líneas
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 9.h,
                                      right: 9.w,
                                      child: project.chose == "startup"
                                          ?  Icon(
                                              Icons.rocket,
                                              color: Colors.white,
                                              size: 20.sp,
                                            )
                                          : project.chose == "idea"
                                              ?  Icon(
                                                  Icons.lightbulb,
                                                  color: Colors.white,
                                                  size: 20.sp,
                                                )
                                              : project.chose == "prototipo"
                                                  ?  Icon(
                                                      Icons.work,
                                                      color: Colors.white,
                                                      size: 20.sp,
                                                    )
                                                  : Icon(
                                                      Icons.abc,
                                                      color: Colors.white,
                                                      size: 20.sp,
                                                    ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
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
          borderRadius: BorderRadius.circular(5.r), // Bordes redondeados
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selected ? Colors.black87 : Colors.white, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp, // Tamaño de fuente
              color: selected ? Colors.black87 : Colors.white, // Color del texto
            ),
          ),
        ],
      ),
    );
  }
}