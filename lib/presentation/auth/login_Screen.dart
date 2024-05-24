import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/widgets/shared/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child:  Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
               
            children: [
             Text("Lets Sign you in.",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
             SizedBox(height: 10,),
              Text("welcome back",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w200),),
                         SizedBox(height: 10,),
              Text("You´ve been missed!",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w200),),
                     SizedBox(height: 40,),
          
             Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username or Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              SizedBox(
                                  width: 320,
                                  height: 60,
                                  child: CustomTextInput(
                                    obscureText: false,
                                    label: "Beatriz",
                                    hint: "Enter Username or Email",
                                  ))
                            ],
                          ),
          
        SizedBox(height: 20,),
                   Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              SizedBox(
                                  width: 320,
                                  height: 60,
                                  child: CustomTextInput(
                                    obscureText: false,
                                    label: "Beatriz",
                                    hint: "Enter Password",
                                  ))
                            ],
        
                            
                          ),
        
                          Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
        Expanded(
          child: Divider(
            color: Colors.grey, // Color de la línea
            thickness: 1, // Grosor de la línea
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "O", // Tu elemento en el centro
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey, // Color de la línea
            thickness: 1, // Grosor de la línea
          ),
        ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                     Image.asset(
                               'assets/google.png', // Reemplaza con la ruta de la imagen de Google
                               width: 44,
                               height: 44,
                             ),
                             SizedBox(width: 20,),
                                      Image.asset(
                               'assets/icons8-apple-150.png', // Reemplaza con la ruta de la imagen de Google
                               width: 44,
                               height: 44,
                             ),
          ],
        ),

         
        SizedBox(height: 130,),
         GestureDetector(
                  onTap: () {
                    // Navegar a la pantalla de inicio de sesión
              
                  },
                  child: RichText(
                    text:  TextSpan(
                      style:  TextStyle(color: Colors.black),
                      children: [
                         TextSpan(
                          text: 'Dont have any account: ',
                          style: TextStyle(fontSize: 15),
                        ),
                      
                        TextSpan(
                         recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Aquí puedes manejar el evento onTap, por ejemplo, navegar a la pantalla de registro
            context.go('/RegisterScreen');
          },
                          text: 'Register',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15,fontWeight: FontWeight.w700), // Color verde
                        ),
                      ],
                    ),
                  ),
                ),
         FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                )),
        
            ],
          ),
        ),
      ),
    );
  }
}