import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: RainbowAIApp()));

class RainbowAIApp extends StatefulWidget {
  @override
  _RainbowAIAppState createState() => _RainbowAIAppState();
}

class _RainbowAIAppState extends State<RainbowAIApp> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
  );
  
  Uint8List? aiTemplate;
  TextEditingController _promptController = TextEditingController();

  Future<void> generateImage() async {
    // Replace with your Cloudflare Worker URL
    var response = await http.post(
      Uri.parse('https://rainbow-ai-api.yourname.workers.dev/api/generate'),
      body: '{"prompt": "${_promptController.text}"}',
    );
    setState(() {
      aiTemplate = response.bodyBytes;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rainbow AI Coloring")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: "What do you want to color? (e.g. Cat, Dragon)",
                suffixIcon: IconButton(icon: Icon(Icons.auto_awesome), onPressed: generateImage)
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (aiTemplate != null) 
                  Center(child: Image.memory(aiTemplate!, opacity: const AlwaysStoppedAnimation(.5))),
                Signature(
                  controller: _controller,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          // Tool Bar
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.brush, color: Colors.red), onPressed: () => setState(() => _controller.penColor = Colors.red)),
                IconButton(icon: Icon(Icons.brush, color: Colors.blue), onPressed: () => setState(() => _controller.penColor = Colors.blue)),
                IconButton(icon: Icon(Icons.brush, color: Colors.green), onPressed: () => setState(() => _controller.penColor = Colors.green)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => _controller.clear()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
