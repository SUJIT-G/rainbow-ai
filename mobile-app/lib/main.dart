import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

void main() {
  runApp(const MaterialApp(home: RainbowApp(), debugShowCheckedModeBanner: false));
}

class RainbowApp extends StatefulWidget {
  const RainbowApp({super.key});
  @override
  State<RainbowApp> createState() => _RainbowAppState();
}

class _RainbowAppState extends State<RainbowApp> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
  );
  Uint8List? aiImage;
  bool isLoading = false;
  final TextEditingController _promptText = TextEditingController();

  Future<void> generateAIImage() async {
    if (_promptText.text.isEmpty) return;
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://your-worker.workers.dev/api/generate'),
        body: jsonEncode({'prompt': _promptText.text}),
      );
      if (response.statusCode == 200) {
        setState(() => aiImage = response.bodyBytes);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rainbow AI"), backgroundColor: Colors.purple),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _promptText,
              decoration: InputDecoration(
                hintText: "What to color?",
                suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: generateAIImage),
              ),
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: Stack(
              children: [
                if (aiImage != null) Center(child: Image.memory(aiImage!)),
                Signature(controller: _controller, backgroundColor: Colors.transparent),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.clear), onPressed: () => _controller.clear()),
                IconButton(icon: const Icon(Icons.brush, color: Colors.red), onPressed: () => setState(() => _controller.penColor = Colors.red)),
                IconButton(icon: const Icon(Icons.brush, color: Colors.blue), onPressed: () => setState(() => _controller.penColor = Colors.blue)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
