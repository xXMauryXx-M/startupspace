import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class IconButtonWithNavigation extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final void Function(int) onTap;

  const IconButtonWithNavigation({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: index == selectedIndex ? Colors.white : Colors.white.withOpacity(0.6),
          ),
          Text(
            label,
            style: TextStyle(
              color: index == selectedIndex ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  const CustomBottomNavigation({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go("/home/0");
        break;
      case 1:
        context.go("/home/1");
        break;
      case 2:
        context.go("/home/2");
        break;
        case 3:
        context.go("/home/3");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
     return BottomAppBar(
      
      notchMargin: 4,
      shape: CircularNotchedRectangle(),
      color:Color(0xff181818),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButtonWithNavigation(
            icon: Icons.home,
            label: 'Inicio',
            index: 0,
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          IconButtonWithNavigation(
            icon: Icons.rocket,
            label: 'Proyectos',
            index: 1,
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          SizedBox(width: 10,),
          IconButtonWithNavigation(
            icon: Icons.calendar_month,
            label: 'Meetups',
            index: 2,
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          IconButtonWithNavigation(
            icon: Icons.person,
            label: 'cuenta',
            index: 3,
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );

    //    Container(
    //     color: Colors.black.withOpacity(0.8),
    //     child: Padding(
    //       padding: EdgeInsets.only(
    //    bottom: 0//separacion
    //       ),
    //       child: Container(
    //         margin: const EdgeInsets.symmetric(horizontal: 0),
    //         padding: const EdgeInsets.all(0),
    //         decoration: BoxDecoration(
    //           color: Colors.black.withOpacity(0.8),
    //           borderRadius: BorderRadius.all(Radius.circular(2)),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey.withOpacity(0.2),
    //               spreadRadius: 2,
    //               blurRadius: 7,
    //               offset: const Offset(0, 1),
    //             ),
    //           ],
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             ...List.generate(
    //               bottomNav.length,
    //               (index) => GestureDetector(
    //                 onTap: () => _onItemTapped(index),
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     AnimatedContainer(
    //                       duration: Duration(milliseconds: 200),
    //                       margin: EdgeInsets.only(bottom:20),
    //                       height: 4,
    //                       width: _selectedIndex == index ? 20 : 0,
    //                       decoration: BoxDecoration(
    //                         color: Color(0xFF81B4FF),
    //                         borderRadius: BorderRadius.all(Radius.circular(20)),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 36,
    //                       width: 36,
    //                       child: Opacity(
    //                         opacity: _selectedIndex == index ? 1 : 0.5,
    //                         child: _buildIcon(index),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

//   Widget _buildIcon(int index) {
//     if (index == 1) {
//       return Icon(
//         Icons.rocket,
//         color: Colors.white,
//         size: 36,
//       );
//     } else {
//       return RiveAnimation.asset(
//         bottomNav[index].src,
//         artboard: bottomNav[index].artboard,
//       );
//     }
//   }
// }
  }
}

// otra forma de bottom nav

// NavigationBar(
//       height: 86,
//       elevation: 0,
//       selectedIndex: 1,
//       onDestinationSelected: (value) {

//       },
//       destinations: [
//         NavigationDestination(icon: Icon(Icons.home), label: "Home"),
//         NavigationDestination(icon: Icon(Icons.search), label: "proyectos"),
//         NavigationDestination(icon: Icon(Icons.rocket), label: ""),
//         NavigationDestination(icon: Icon(Icons.info), label: "Info")
//       ],
//     );

class RiveAssets {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;
  RiveAssets(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAssets> bottomNav = [
  RiveAssets("assets/RiveAssets/icons.riv",
      artboard: "HOME", stateMachineName: "", title: "Space"),
  RiveAssets("assets/RiveAssets/icons.riv",
      artboard: "SEARCH", stateMachineName: "", title: "Space"),
  RiveAssets("assets/RiveAssets/icons.riv",
      artboard: "CHAT", stateMachineName: "", title: "Space"),
  RiveAssets("assets/RiveAssets/icons.riv",
      artboard: "CHAT", stateMachineName: "", title: "Space"),
  RiveAssets("assets/RiveAssets/icons.riv",
      artboard: "CHAT", stateMachineName: "", title: "Space")
];
