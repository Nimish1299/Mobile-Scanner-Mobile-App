import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner_app/routes/views/screens/details_screen.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver  {
  bool _cameraPermissionGranted = false;
  late AnimationController _lineController;
  bool isSettingPermissionDialogOpen = false;
  bool isCheckingPermission = false; 
  bool isPermissionRequested = false; 
   MobileScannerController cameraController = MobileScannerController();
   bool isScanCompleted = false;
   BuildContext? dialogContext;
   bool openedSettings = false;
   bool isLoaderShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkPermission();

    cameraController = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: false,   
    );

    //Line animation controller
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

   @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {

      if (openedSettings) {

      openedSettings = false;   

      final status = await Permission.camera.status;
       if (status.isGranted) {
        if (dialogContext != null && Navigator.canPop(dialogContext!)) {
          Navigator.pop(dialogContext!);  
          dialogContext = null;            
          isSettingPermissionDialogOpen = false;
        }
       }

      checkPermission();
    }
    }
  }

  Future<void> checkPermission() async {
      if (isCheckingPermission) return;    
      isCheckingPermission = true;
      isLoaderShowing = true;
     try {
          final status = await Permission.camera.status;
          if (status.isGranted) {
            setState(() {
            _cameraPermissionGranted = true;
            });
          }
          else if (status.isDenied) {
            if(!isPermissionRequested)
            {
              isPermissionRequested =true;
              final newStatus = await Permission.camera.request();
              if (newStatus.isGranted) {
                setState(() {
                _cameraPermissionGranted = true;
                });
              }
              else{
                  if (Navigator.canPop(context)) Navigator.pop(context);
              }
            }
          }

          else if (status.isPermanentlyDenied) {
             if (isSettingPermissionDialogOpen) return;
             isSettingPermissionDialogOpen = true; 
            showDialog(
              context: context,
              builder: (ctx) {
                  dialogContext = ctx; 
                return AlertDialog(
                title:  Text('Camera Permission Required'),
                content: Text(
                ' You have permanently denied camera permission, Please enable it manually from settings.')
                ,
                actions: [
                  TextButton(
                    onPressed: () {
                      openedSettings = true; 
                      openAppSettings();  
                    },
                    child: Text('Open Settings'),
                  ),
                  TextButton(
                    onPressed: () {
                       isSettingPermissionDialogOpen = false;    
                         Navigator.of(ctx).pop();  
                        dialogContext = null;
                        if (mounted && Navigator.canPop(context)) {
                          Navigator.pop(context); 
                        }
                    },
                    child: Text('Cancel')),
                ],
              );
          }
            );
            return;
          }

    } catch (e) {
      print(e);
    }finally {
    isCheckingPermission = false;  
  }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lineController.dispose();
     cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(),
          backgroundColor: Colors.green,
          title: Text(' Barcode & QR Scanner'),
          actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: cameraController,
            builder: (context, state, child) {
              final isTorchOn = state.torchState == TorchState.on;
              return IconButton(
                icon: Icon(
                  isTorchOn ? Icons.flash_on : Icons.flash_off,
                  color: isTorchOn ? Colors.yellow : Colors.black,
                ),
                onPressed: () => cameraController.toggleTorch(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
        ),
      body: !_cameraPermissionGranted
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
            builder: (context, constraints)
            {
             // Camera preview actual height/width
              final double width = constraints.maxWidth;
              final double height = constraints.maxHeight;

              // Scan window size
              final double boxSize = width * 0.55;

              final double scanTop = (height - boxSize) / 2;

              // Proper centered rectangle
              final scanRect = Rect.fromLTWH(
                (width - boxSize) / 2,
                scanTop,
                boxSize,
                boxSize,
              );

            return Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    scanWindow: scanRect,
                    onDetect: (capture) {
                      if (isScanCompleted) return;
            
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final code = barcodes.first.rawValue;
                        if (code != null) {
                          isScanCompleted = true;
                          cameraController.stop();
            
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              Get.to(() => DetailsScreen(code: code))?.then((_) {
                                isScanCompleted = false;
                                cameraController.start();
                              });
                            }
                          });
                        }
                      }
                    },
                    overlayBuilder: (context, constraints) {
                      return Stack(
                        children: [
                          // Border
                          Positioned(
                            left: scanRect.left,
                            top: scanRect.top,
                            child: Container(
                              width: scanRect.width,
                              height: scanRect.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.greenAccent, width: 3),
                              ),
                            ),
                          ),
            
                          // Moving line
                          AnimatedBuilder(
                            animation: _lineController,
                            builder: (context, child) {
                              final double lineY =
                                  scanRect.top + (scanRect.height * _lineController.value);
            
                              return Positioned(
                                left: scanRect.left,
                                width: scanRect.width,
                                top: lineY,
                                child: Container(
                                  height: 3,
                                  color: Colors.redAccent,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  )
            
                ],
              );
                  },
          ),
          
    );
  }
}
