import 'package:flutter/material.dart';

class ChatInputBox extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend, onClickCamera;

  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
    this.onClickCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      color: Colors.blue,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
     
            
          Expanded(
              child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 6,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Colors.blue,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              hintText: 'Message...',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
          )),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: onClickCamera,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: onSend,
              child: const Icon(
                Icons.send_rounded,
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
