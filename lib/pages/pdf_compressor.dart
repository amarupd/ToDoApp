// ignore_for_file: avoid_print, sort_child_properties_last

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFCompressorPage extends StatefulWidget {
  const PDFCompressorPage({super.key});

  @override
  _PDFCompressorPageState createState() => _PDFCompressorPageState();
}

class _PDFCompressorPageState extends State<PDFCompressorPage> {
  double _progress = 0.0;
  String? _inputPath;
  String? _outputPath;

  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
  }

  Future<String> getCustomFolderPath() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory.path;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return "$bytes B"; // Bytes
    } else if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(2)} KB"; // Kilobytes
    } else {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB"; // Megabytes
    }
  }

  Future<String?> getAuthToken() async {
    const apiKey =
        'project_public_37187a6801c14b75bc4a489370fdca6e_eJWyu80d85dc122c061d9388d4a968b539457'; // Replace with your actual private API key
    try {
      final response = await http.post(
        Uri.parse('https://api.ilovepdf.com/v1/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'public_key': apiKey}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> startCompression() async {
    if (_inputPath == null) {
      _showDialog("No File Selected", "Please select a PDF file first.");
      return;
    }

    bool permissionGranted = await requestStoragePermission();
    if (!permissionGranted) {
      _showDialog(
          "Permission Denied", "Storage permission is required to proceed.");
      return;
    }

    try {
      setState(() {
        _progress = 0.1;
      });

      String? token = await getAuthToken();
      if (token == null) {
        setState(() {
          _progress = 0.0;
        });
        _showDialog("Error", "Failed to authenticate with iLovePDF API.");
        return;
      }

      final startTaskResponse = await http.get(
        Uri.parse('https://api.ilovepdf.com/v1/start/compress'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (startTaskResponse.statusCode != 200) {
        setState(() {
          _progress = 0.0;
        });
        throw Exception("Failed to create compression task.");
      }

      setState(() {
        _progress = 0.2;
      });

      final taskData = jsonDecode(startTaskResponse.body);
      final String taskId = taskData['task'];
      final String serverUrl = taskData['server'];

      var uploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://$serverUrl/v1/upload'),
      );
      uploadRequest.headers['Authorization'] = 'Bearer $token';
      uploadRequest.fields['task'] = taskId;
      uploadRequest.files
          .add(await http.MultipartFile.fromPath('file', _inputPath!));
      setState(() {
        _progress = 0.3;
      });

      final uploadResponse =
          await http.Response.fromStream(await uploadRequest.send());

      if (uploadResponse.statusCode != 200) {
        setState(() {
          _progress = 0.0;
        });
        throw Exception("File upload failed.");
      }

      setState(() {
        _progress = 0.4;
      });

      final uploadResult = jsonDecode(uploadResponse.body);
      if (uploadResult['server_filename'] == null) {
        setState(() {
          _progress = 0.0;
        });
        throw Exception("File upload did not return a server filename.");
      }

      String serverFilename = uploadResult['server_filename'];

      setState(() {
        _progress = 0.5;
      });

      final processResponse = await http.post(
        Uri.parse('https://$serverUrl/v1/process'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task': taskId,
          'tool': 'compress',
          'compression_level': 'recommended',
          'files': [
            {
              'server_filename': serverFilename,
              'filename': File(_inputPath!).uri.pathSegments.last
            }
          ]
        }),
      );

      if (processResponse.statusCode != 200) {
        setState(() {
          _progress = 0.0;
        });
        throw Exception("Failed to process compression.");
      }

      setState(() {
        _progress = 0.7;
      });

      final downloadResponse = await http.get(
        Uri.parse('https://$serverUrl/v1/download/$taskId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (downloadResponse.statusCode != 200) {
        setState(() {
          _progress = 0.0;
        });
        throw Exception("Failed to download compressed file.");
      }

      String customFolderPath = await getCustomFolderPath();
      setState(() {
        _progress = 0.9;
      });

      // ✅ Handle File Name Duplication
      String originalFileName = File(_inputPath!).uri.pathSegments.last;
      String outputFilePath = '$customFolderPath/compressed_$originalFileName';

      int count = 1;
      while (File(outputFilePath).existsSync()) {
        outputFilePath =
            '$customFolderPath/compressed_${count}_$originalFileName';
        count++;
      }

      File compressedFile = File(outputFilePath);
      await compressedFile.writeAsBytes(downloadResponse.bodyBytes);

      // ✅ Get Compressed File Size
      int fileSizeInBytes = compressedFile.lengthSync();
      String readableFileSize = _formatFileSize(fileSizeInBytes);

      setState(() {
        _outputPath = outputFilePath;
        _progress = 1.0;
      });

// ✅ Show Dialog with Compressed File Size
      _showDialog(
        "Compression Successful",
        "Compressed file saved at:\n$_outputPath\n\nFile Size: $readableFileSize",
        onOkPressed: () {
          setState(() {
            _inputPath = null;
            _outputPath = null;
            _progress = 0.0;
          });
        },
      );
      OpenFile.open(_outputPath!);
    } catch (e) {
      setState(() {
        _progress = 0.0;
      });
      _showDialog("Error", e.toString());
    }
  }

  Future<void> pickPDF() async {
    try {
      String? path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
          allowedMimeTypes: ['application/pdf'],
          allowedFileExtensions: ['pdf'],
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

  void _showDialog(String title, String message, {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onOkPressed != null) onOkPressed();
            },
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
        title: const Text("Compress PDF",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "IndieFlower",
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            )),
        backgroundColor: Colors.teal[400],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickPDF,
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text("Choose PDF File",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "IndieFlower",
                    fontWeight: FontWeight.bold,
                  )),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            const SizedBox(height: 20),
            if (_inputPath != null)
              Text("Selected File: ${File(_inputPath!).uri.pathSegments.last}"),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 20),
            Text("${(_progress * 100).toInt()}% Completed"),
            const Spacer(),
            ElevatedButton(
              onPressed: startCompression,
              child: const Text("Start Compression",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "IndieFlower",
                    fontWeight: FontWeight.bold,
                  )),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.teal[400]),
            ),
          ],
        ),
      ),
    );
  }
}
