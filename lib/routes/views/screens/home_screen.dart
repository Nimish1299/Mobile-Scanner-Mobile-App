// import 'package:flutter/material.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.black),
//         backgroundColor: Colors.green,
//         title: const Text('Barcode & Qr Scan'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.browse_gallery_sharp),
//             onPressed: () {
//               // Map બટન પર ક્લિક કરવાથી થતી ક્રિયા
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.flashlight_off),
//             onPressed: () async {
//               // QR code સકેન કરવાની ક્રિયા
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.camera_front_outlined),
//             onPressed: () {
//               // Cancel / Clear કરવાની ક્રિયા
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Get.to(() => const DetailsScreen());
//           },
//           child: const Text("Go To Details"),
//         ),
//       ),
//     );
//   }
// }