import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xff313131),
      body: Column(
       
      children: [
        SizedBox(height: 80,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
  width: 390,
  height: 340,
  decoration: BoxDecoration(
    color: Color(0xff3B3B3B),
    borderRadius: BorderRadius.circular(20), // Bordes redondeados
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ClipOval(
        child: Image.network(
          "https://images.unsplash.com/photo-1519456264917-42d0aa2e0625?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(height: 20,),
      Text(
        "Sans Undertale",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      Text(
        "hi i am developer and i make apps ",
        style: TextStyle(fontSize: 15, color: Color(0xffE0E0E0)),
      ),
      SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text("Proyectos",style: TextStyle(fontSize: 20,color: Colors.white),),
              Text("2",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 40,),
          Column(
            children: [
              Text("Contribuciones",style: TextStyle(fontSize: 20,color: Colors.white)),
              Text("2",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold)),
            ],
          )
        ],
      )
    ],
  ),
),
)
      ],
      ),
    );
  }
}