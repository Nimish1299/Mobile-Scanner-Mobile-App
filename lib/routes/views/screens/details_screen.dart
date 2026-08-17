import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatelessWidget {
  final String? code;

  const DetailsScreen({super.key, this.code});

  @override
  Widget build(BuildContext context) {
    final String scannedCode = code ?? (Get.arguments as String? ?? '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Details Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scanned Result:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      scannedCode.isNotEmpty ? scannedCode : 'No code scanned',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.green),
                    tooltip: 'Copy Code',
                    onPressed: () {
                      if (scannedCode.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: scannedCode));
                        Get.snackbar(
                          'Success',
                          'Code copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.green),
                    tooltip: 'Share Code',
                    onPressed: () {
                      if (scannedCode.isNotEmpty) {
                        Share.share(scannedCode);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
