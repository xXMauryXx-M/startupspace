import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

final resutProvider = StateProvider<ScanResult>((ref) {
  return ScanResult();
});

final rowProvider = StateProvider<String>((ref) {
  return "";
});

class EventsView extends ConsumerWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoScanner = ref.watch(resutProvider);
    final row = ref.watch(rowProvider);

    Future<void> _scan() async {
      try {
        final result = await BarcodeScanner.scan(
          options: const ScanOptions(
            strings: {
              'cancel': "",
              'flash_on': "",
              'flash_off': "",
            },
            restrictFormat: [],
            useCamera: 0,
          ),
        );
        ref.read(rowProvider.notifier).update(
              (state) => result.rawContent,
            );

        ref.read(resutProvider.notifier).update((state) => result);
      } on PlatformException catch (e) {
        ref.read(resutProvider.notifier).update((state) {
          return ScanResult(
            rawContent: e.code == BarcodeScanner.cameraAccessDenied
                ? 'The user did not grant the camera permission!'
                : 'Unknown error: $e',
          );
        });
      }
    }

    return Scaffold(
      
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Column(

         children: [
         const SizedBox(height: 60,),
         const Text("Meetups",style: TextStyle(fontSize: 25,color: Colors.white),),

    infoScanner.rawContent.isNotEmpty? Column(

      children: [
  SizedBox(height: 90,),
        Icon(Icons.group,color: Colors.white,size: 90,),
        Text("En reunion...",style: TextStyle(fontSize: 27,color: Colors.white,fontWeight: FontWeight.bold),),
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text("Al finalizar te daremos el contacto de todos los los asistentes", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
        )

      ],
    ): Padding(
       padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 90),
       child: 
       Container(
      decoration: BoxDecoration(
        color: Color(0xff313131), // Ajuste de color para corregir error de formato
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 2,
            offset: Offset(0, 2), // Cambia la posición de la sombra
          ),
        ],
        borderRadius: BorderRadius.circular(10), // Bordes redondeados opcionales
      ),
      width: 240,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Escanear",
            style: TextStyle(color: Colors.white,fontSize: 20),
          ),
          SizedBox(height: 20,),
          IconButton.filledTonal(
         
            onPressed: () {
              _scan();
            },
            icon: Icon(FontAwesomeIcons.qrcode, color: Colors.black,size: 40,),
          ),
               SizedBox(height: 20,),
          Text(
            "Escanea la mesa Startup Space",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    )
     ),

        // QrImageView(
        //   semanticsLabel: "aasdasda",
        //   data: 'true',
        //   version: QrVersions.auto,
        //   size: 200.0,
        // ),
        // Text(
        //   "${infoScanner.rawContent}",
        //   style: TextStyle(fontSize: 50, color: Colors.white),
        // ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 100),
        //   child: Image.network("https://upload.wikimedia.org/wikipedia/commons/d/d7/Commons_QR_code.png"),
        // )
      ]),
    );
  }
}
