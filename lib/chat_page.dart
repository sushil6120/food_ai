import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:food_ai/chat_input.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ImagePicker picker = ImagePicker();
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText, result, image;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  Uint8List? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Food AI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          if (searchedText != null)
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10),
              child: Row(
                children: [
                  const Text(
                    'You: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' $searchedText',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),
          loading == true
              ? SizedBox()
              : selectedImage == null
                  ? Center(
                      child: LottieBuilder.asset(
                      'assets/Animation - 1710496380335.json',
                      height: 160,
                    ))
                  : Image.memory(
                      selectedImage!,
                      height: 400,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
          Expanded(
              child: loading
                  ? Center(
                      child: LottieBuilder.asset(
                          'assets/Animation - 1710496735985.json'))
                  : result != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Markdown(
                            data: result!,
                          ),
                        )
                      : const Center(child: Text('Search Food Receipe!'))),
          ChatInputBox(
            onClickCamera: () {
              _showSelectionDialog(context);
            },
            controller: controller,
            onSend: () async {
              if (controller.text.isNotEmpty) {
                setState(() {
                  selectedImage == null;
                });
                if (controller.text.isNotEmpty) {
                  searchedText = controller.text;
                  controller.clear();
                  loading = true;

                  gemini
                      .text(searchedText! +
                          ' provide full described recipe in hindi with food imoji and if you get other then food text reply "please provide food prompt"')
                      .then((value) {
                    result = value?.content?.parts?.last.text;

                    loading = false;
                  });
                }
              } else if (selectedImage != null) {
                searchedText = controller.text;
                controller.clear();
                loading = true;
                gemini.textAndImage(
                    text: searchedText!.isEmpty || searchedText == null
                        ? "If image has food so please provide recipe of food in hindi with food imoji that shown in image otherwise say provide food image!"
                        : searchedText!,
                    images: [selectedImage!]).then((value) {
                  result = value?.content?.parts?.last.text;
                  loading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final XFile? photo =
                        await picker.pickImage(source: ImageSource.camera);

                    if (photo != null) {
                      photo.readAsBytes().then((value) => setState(() {
                            selectedImage = value;
                          }));
                    }
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.camera_alt, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Camera'),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  onTap: () async {
                    final XFile? photo =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (photo != null) {
                      photo.readAsBytes().then((value) => setState(() {
                            selectedImage = value;
                          }));
                    }
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.photo_library, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
