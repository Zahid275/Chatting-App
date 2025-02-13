import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

showCustomBottomSheet(
    {required context,
    required message,
    required chatController,
    required dbServices}) {
  return showModalBottomSheet(
      backgroundColor: Colors.blue,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  dbServices.deleteMessage(message);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                    )
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message["message"]));
                  Get.showSnackbar(const GetSnackBar(
                    messageText: Center(
                        child: Text(
                      "Message Coppied",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
                    duration: Duration(seconds: 1),
                  ));
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder()),
                child: const Text(
                  "Copy",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Edit Message"),
                      content: Form(
                        key: chatController.editKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "${message["message"]}"),
                          onSaved: (value) {
                            FirebaseFirestore.instance
                                .collection("Chat Rooms")
                                .doc("${message["chatId"]}")
                                .collection("Chats")
                                .doc(message.id)
                                .update({"message": "$value"});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Write the edited message";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                          child: const Text("Close"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (chatController.editKey.currentState!
                                .validate()) {
                              chatController.editKey.currentState!.save();
                              Get.back();
                              Get.back();
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder()),
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        );
      });
}
