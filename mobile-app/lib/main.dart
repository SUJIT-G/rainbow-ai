import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

void main() => runApp(const MaterialApp(home: RainbowAI(), debugShowCheckedModeBanner: false));

class RainbowAI extends StatefulWidget {
  const RainbowAI({super.key});
  @override
  State<RainbowAI> createState() => _RainbowAIState();
}

class _RainbowAIState extends State<RainbowAI> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.black;
  Uint8List? aiImage;
  bool isLoading = false;
  final TextEditingController _prompt = TextEditingController();

  Future<void> generateAIImage() async {
  String userPrompt = _prompt.text.trim(); // Prompt ko saaf karein
  if (userPrompt.isEmpty) return; 

  setState(() => isLoading = true);
  try {
    final response = await http.post(
      Uri.parse('https://rainbow-ai-backend.devsujit.workers.dev'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'image/png',
      },
      body: jsonEncode({'prompt': userPrompt}), // Dhyan rahe JSON sahi bane
    );

    if (response.statusCode == 200) {
      setState(() {
        aiImage = response.bodyBytes;
      });
    } else {
      // Agar error aaye toh use console mein dekhein
      debugPrint("Server Error: ${response.body}");
    }
  } catch (e) {
    debugPrint("App Error: $e");
  }
  setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rainbow AI Coloring"), backgroundColor: Colors.purple),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _prompt,
              decoration: InputDecoration(
                hintText: "What to color?",
                suffixIcon: IconButton(icon: const Icon(Icons.auto_awesome), onPressed: getAIImage),
              ),
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  points.add(DrawingPoint(
                    point: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeWidth = 4.0
                      ..strokeCap = StrokeCap.round,
                  ));
                });
              },
              onPanEnd: (details) => points.add(null),
              child: Stack(
                children: [
                  if (aiImage != null) Center(child: Image.memory(aiImage!)),
                  CustomPaint(painter: MyPainter(points: points), size: Size.infinite),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => points.clear())),
                _btn(Colors.red), _btn(Colors.blue), _btn(Colors.green), _btn(Colors.orange), _btn(Colors.black),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _btn(Color color) => GestureDetector(
    onTap: () => setState(() => selectedColor = color),
    child: CircleAvatar(backgroundColor: color, radius: 15),
  );
}

class DrawingPoint {
  Paint paint;
  Offset point;
  DrawingPoint({required this.point, required this.paint});
}

class MyPainter extends CustomPainter {
  List<DrawingPoint?> points;
  MyPainter({required this.points});
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.point, points[i + 1]!.point, points[i]!.paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
