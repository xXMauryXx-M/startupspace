import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/config/router/app_route_notifier.dart';
import 'package:startupspace/presentation/auth/login_Screen.dart';
import 'package:startupspace/presentation/auth/onboarding_Screen.dart';
import 'package:startupspace/presentation/auth/register_Screen.dart';
import 'package:startupspace/presentation/home/add_proyect_2_Screen.dart';
import 'package:startupspace/presentation/home/add_proyect_Screen.dart';
import 'package:startupspace/presentation/home/home_Screen.dart';
import 'package:startupspace/presentation/home/into_proyect.dart';
import 'package:startupspace/presentation/views/profile_view.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
 return GoRouter(
    refreshListenable: goRouterNotifier,
    initialLocation: "/",
    routes: [
    GoRoute(  
        path: "/home/:page",
        builder: (context, state) {
        final pageIndex = state.pathParameters["page"] ?? "0";
          return HomeScreen(
            pageIndex: int.parse(pageIndex),
          );
        }),
    GoRoute(
      path: "/RegisterScreen",
      builder: (context, state) => const RegisterScreen(),
    ),
 GoRoute(
      path: "/LoginScreen",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/OnBoardingScreen",
      builder: (context, state) => const OnBoardingScreen(),
    ),
//  GoRoute(
//       path: "/AddProyectScreen",
//       builder: (context, state) => const AddProyectScreen(),
//     ),
     GoRoute(
        path: '/AddProyectScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AddProyectScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Change the opacity of the screen using a Curve based on the the animation's
              // value
              return SlideTransition(
               position: Tween<Offset>(
            begin: const Offset(0, 1), // Start from below the screen
            end: Offset.zero,
          ).animate(animation),
          child: child,
              );
            },
          );
        },
      ),
  GoRoute(
       path: "/AddProyect2Screen",
       builder: (context, state) => const AddProyect2Screen(),
     ),
    // GoRoute(
    //   path: "/FlightMap",
    //   builder: (context, state) =>  const  FlightMap(),
    // ),
     GoRoute(
      path: "/ProfileView",
      builder: (context, state) => const ProfileView(),
    ),
  GoRoute(
      path: "/IntoProyect",
      builder: (context, state) => const IntoProyect(),
    ),
   
  ],
   redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      if (goRouterNotifier.isAuthenticated) {
        if (isGoingTo == '/home/0'
        || isGoingTo=="/home/1" ||
        isGoingTo=="/home/2"||
          isGoingTo=="/home/3"||
        isGoingTo=="/AddProyectScreen"||isGoingTo=="/AddProyect2Screen"
        ||isGoingTo=="/IntoProyect"
           ) return null;
        return "/home/0";
      } else {
        if (isGoingTo == '/LoginScreen' ||
            isGoingTo == '/RegisterScreen' ||
             isGoingTo == '/OnBoardingScreen' 
            ) return null;

        return '/OnBoardingScreen';
      }

      return null;
      }
  );
});
