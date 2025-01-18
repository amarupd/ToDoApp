import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:open_file/open_file.dart';

class PDFCompressorPage extends StatefulWidget {
  const PDFCompressorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PDFCompressorPageState createState() => _PDFCompressorPageState();
}

class _PDFCompressorPageState extends State<PDFCompressorPage> {
  double _progress = 0.0;
  String? _inputPath;
  String? _outputPath;

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
  }

  // Get the external storage directory for storing compressed PDFs
  Future<String> getCustomFolderPath() async {
    const folderName = 'compressed_pdf';
    Directory? externalStorageDir = Directory('/storage/emulated/0/$folderName');

    // Create the folder if it doesn't exist
    if (!await externalStorageDir.exists()) {
      await externalStorageDir.create(recursive: true);
    }
    return externalStorageDir.path;
  }

  // Start compression
  Future<void> startCompression() async {
    if (_inputPath == null) {
      _showDialog("No File Selected", "Please select a PDF file first.");
      return;
    }

    bool permissionGranted = await requestStoragePermission();
    if (!permissionGranted) {
      _showDialog("Permission Denied", "Storage permission is required to proceed.");
      return;
    }

    try {
      // Get the custom folder path
      String customFolderPath = await getCustomFolderPath();

      String originalFileName = File(_inputPath!).uri.pathSegments.last;
      String fileNameWithoutExtension = originalFileName.split('.').first;
      String fileExtension = ".pdf";

      // Create a new output file name for the compressed PDF
      String outputFileName = '${fileNameWithoutExtension}_compressed$fileExtension';
      String outputFilePath = '$customFolderPath/$outputFileName';

      // Check for file existence and add a count if needed
      int count = 1;
      while (File(outputFilePath).existsSync()) {
        outputFileName = '${fileNameWithoutExtension}_compressed_$count$fileExtension';
        outputFilePath = '$customFolderPath/$outputFileName';
        count++;
      }

      _outputPath = outputFilePath;

      // Simulate progress
      setState(() {
        _progress = 0.0;
      });

      Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        if (_progress < 1.0) {
          setState(() {
            _progress = (_progress + 0.1).clamp(0.0, 1.0); // Ensure progress is between 0.0 and 1.0
          });
        } else {
          timer.cancel(); // Stop the timer when progress reaches 100%

          try {
            // Compress the PDF
            await PdfCompressor.compressPdfFile(
              _inputPath!,
              _outputPath!,
              CompressQuality.HIGH,
            );
            _showDialog(
              "Compression Successful",
              "Compressed file saved at:\n$_outputPath",
            );
            OpenFile.open(_outputPath!);
          } catch (e) {
            _showDialog("Compression Failed", "An error occurred: $e");
          }

          // Reset progress to 0 after completion (optional)
          setState(() {
            _progress = 0.0;
          });
        }
      });
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

  // File Picker to choose a PDF
  Future<void> pickPDF() async {
  try {
    String? path = await FlutterDocumentPicker.openDocument(
      params: FlutterDocumentPickerParams(
        allowedMimeTypes: ['application/pdf'], // Restrict to PDF files
        allowedFileExtensions: ['pdf'], // Ensure only `.pdf` files
      ),
    );
    if (path != null) {
      setState(() {
        _inputPath = path;
      });
    }
  } catch (e) {
    _showDialog("Error", "Failed to pick a file: $e");
  }
}

  // Show dialog for status messages
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Compress PDF",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "IndieFlower",
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        backgroundColor: Colors.teal[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickPDF,
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
              label: const Text(
                "Choose PDF File",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            if (_inputPath != null)
              Text(
                "Selected File: ${File(_inputPath!).uri.pathSegments.last}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            const SizedBox(height: 20),
            Text(
              "${(_progress * 100).toInt()}% Completed",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: startCompression,
              // ignore: sort_child_properties_last
              child: const Text(
                "Start Compression",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
