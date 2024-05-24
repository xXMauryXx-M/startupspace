import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnBoardingScreen extends ConsumerWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
     
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/startupspaceImage.jpg",
            width: 370,
          ),
          const Text("Startup-Space Welcome ",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              softWrap: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: const Text(
                "Unete A startup space, una comunidad para las startup , accede a beneficios, como co-work eventos y mas  ",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center),
          ),
          const SizedBox(
            height: 39,
          ),
          FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 140, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.push("/LoginScreen");
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              )),
          SizedBox(
            height: 15,
          ),
          FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.push("/RegisterScreen");
              },
              child: Text(
                "Register",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )),
        ],
      ),
    );
  }
}
