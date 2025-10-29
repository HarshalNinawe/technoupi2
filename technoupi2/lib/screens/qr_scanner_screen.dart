import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleScannedCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          // Overlay with frame
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
            ),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Position QR code\ninside the frame',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Corner brackets
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 125,
            left: MediaQuery.of(context).size.width / 2 - 125,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.transparent,
                ),
              ),
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 4),
                          left: BorderSide(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 4),
                          right: BorderSide(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4),
                          left: BorderSide(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4),
                          right: BorderSide(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScannedCode(String code) {
    // Stop scanning
    cameraController.stop();

    // Parse UPI QR code
    if (code.startsWith('upi://pay')) {
      // Extract UPI ID from QR code
      final uri = Uri.parse(code);
      final upiId = uri.queryParameters['pa'];

      if (upiId != null) {
        // Navigate back with the scanned UPI ID
        Navigator.of(context).pop(upiId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned UPI ID: $upiId')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid UPI QR code')),
        );
        cameraController.start(); // Restart scanning
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not a valid UPI QR code')),
      );
      cameraController.start(); // Restart scanning
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
