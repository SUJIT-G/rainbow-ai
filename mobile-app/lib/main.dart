import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

void main() => runApp(const MaterialApp(home: RainbowApp(), debugShowCheckedModeBanner: false));

class RainbowApp extends StatefulWidget {
  const RainbowApp({super.key});
  @override
  State<RainbowApp> createState() => _RainbowAppState();
}

class _RainbowAppState extends State<RainbowApp> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  Uint8List? aiImage;
  bool isLoading = false;
  final TextEditingController _promptText = TextEditingController();

  Future<void> generateAIImage() async {
    if (_promptText.text.isEmpty) return;
    setState(() => isLoading = true);
    try {
      // Replace with your Cloudflare Worker URL later
      final response = await http.post(
        Uri.parse('https://your-worker.workers.dev/api/generate'), 
        body: jsonEncode({'prompt': _promptText.text}),
      );
      if (response.statusCode == 200) {
        setState(() => aiImage = response.bodyBytes);
      }
    } catch (e) {
      print("Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rainbow AI Coloring"), backgroundColor: Colors.purpleAccent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _promptText,
              decoration: InputDecoration(
                hintText: "What to color? (e.g. Cat, Robot)",
                suffixIcon: IconButton(icon: const Icon(Icons.magic_button), onPressed: generateAIImage),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Stack(
                children: [
                  if (aiImage != null) Center(child: Image.memory(aiImage!)),
                  Signature(controller: _controller, backgroundColor: Colors.transparent),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.refresh, color: Colors.black), onPressed: () => _controller.clear()),
                _colorPicker(Colors.red),
                _colorPicker(Colors.blue),
                _colorPicker(Colors.green),
                _colorPicker(Colors.orange),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _colorPicker(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _controller.penColor = color),
      child: CircleAvatar(backgroundColor: color, radius: 15),
    );
  }
}
