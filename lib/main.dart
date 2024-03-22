import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:food_ai/chat_page.dart';

void main() {
   Gemini.init(apiKey: 'AIzaSyDuSpOFCHk-PH1kwKRgNDRhrHhq0GaIAQs', enableDebugging: true,
      generationConfig: GenerationConfig(     
        topK: 1,
        topP: 0.9,
        temperature: 1.0,
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatPage()
    );
  }
}

