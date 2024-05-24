import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// class CustomTextFormField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final String? errorMessage;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final Function(String)? onChanged;
//   final String? Function(String?)? validator;
//   final bool filterNumbers;
//   final TextEditingController? controller; // Paso 1

//   const CustomTextFormField({
//     Key? key,
//     this.label,
//     this.hint,
//     this.errorMessage,
//     this.obscureText = false,
//     this.keyboardType = TextInputType.text,
//     this.onChanged,
//     this.validator,
//     this.filterNumbers = false,
//     this.controller, // Paso 1
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final border = OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.grey),
//         borderRadius: BorderRadius.circular(9));

//     const borderRadius = Radius.circular(9);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: borderRadius,
//           bottomLeft: borderRadius,
//           bottomRight: borderRadius,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: TextFormField(
        
//         controller: controller, // Paso 2
//         inputFormatters: [
//           if (filterNumbers) // Solo si se debe filtrar números
//             FilteringTextInputFormatter.deny(RegExp(r'[0-9]')), // Filtra los números
//         ],
//         onChanged: onChanged,
//         validator: validator,
//         obscureText: obscureText,
//         keyboardType: keyboardType,
//         style: const TextStyle(fontSize: 20, color: Colors.black54),
//         decoration: InputDecoration(
       
//           floatingLabelStyle: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//           enabledBorder: border,
//           focusedBorder: border,
//           errorBorder: border.copyWith(
//             borderSide: const BorderSide(color: Colors.transparent),
//           ),
//           focusedErrorBorder: border.copyWith(
//             borderSide: const BorderSide(color: Colors.transparent),
//           ),
//           isDense: true,
//           hintText: hint,
//           hintStyle: const TextStyle(fontSize: 16),
//           errorText: errorMessage,
//           focusColor: colors.primary,
//         ),
//       ),
//     );
//   }
// }

class CustomTextInput extends StatelessWidget {
  final String? label;
  final bool enabled;
  final String? hint;
  final String? errorMessage;
  final TextEditingController? controller;
  final bool icon;
  final bool obscureText;
  final Function(String)? onChanged;
  final bool numericKeyboard; // Nueva propiedad

  const CustomTextInput({
    Key? key,
    this.label,
    this.enabled = true,
    this.hint,
    this.errorMessage,
    this.controller,
    this.icon = false,
    this.onChanged,
    this.numericKeyboard = false, required this.obscureText, // Valor por defecto es falso
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          Container(
            padding: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                 obscureText: obscureText,
                enabled: enabled,
                controller: controller,
                maxLines: null,
                onChanged: onChanged,
                style: const TextStyle(fontSize: 20, color: Colors.black54),
                keyboardType: numericKeyboard
                    ? TextInputType.number
                    : TextInputType.text, // Tipo de teclado dinámico
                decoration: InputDecoration(
                  prefixIcon: icon ? const Icon(Icons.search, size: 30) : null,
                  filled: enabled == false ? true : false,
                  fillColor: Colors.grey[300],
                  border: InputBorder.none,
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  isDense: true,
                  hintText: hint,
                  hintStyle: const TextStyle(fontSize: 16),
                  errorText: errorMessage,
                  focusColor: colors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
