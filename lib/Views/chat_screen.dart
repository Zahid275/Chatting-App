import 'package:chit_chat/Widgets/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chit_chat/Models/msg_model.dart';
import 'package:chit_chat/Models/user_model.dart';
import 'package:chit_chat/Services/db_services.dart';
import 'package:chit_chat/Widgets/message_tile.dart';
import 'package:chit_chat/Widgets/message_field.dart';
import '../Cotrollers/chatpage_controller.dart';
import '../Cotrollers/home_controller.dart';

class ChatScreen extends StatelessWidget {
  HomeController homeController = Get.find<HomeController>();
  final UserModel userModel;
  final chatController = Get.put(ChatController());
  final DbServices dbServices = DbServices();

  ChatScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(backgroundColor: Colors.blue),
      body: Column(
        children: [
          topWidget(context: context),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.034,
                  vertical: screenHeight * 0.055),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(90)),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Chat Rooms')
                      .doc(userModel.chatId)
                      .collection('Chats')
                      .orderBy("timeStamp")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something Went Wrong"));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: Colors.blueAccent),
                      );
                    } else {
                      chatController.getOnline(userId: userModel.userId);
                      var messages = snapshot.data!.docs;

                      return ListView.builder(
                        controller: chatController.scrollController.value,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          chatController.checkCurrentUser(
                              senderId: message["senderId"],
                              currentUserId:
                                  FirebaseAuth.instance.currentUser!.uid);

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                ),
                                child: MessageTile(
                                  onLongPress: () {
                                    showCustomBottomSheet(
                                        context: context,
                                        message: message,
                                        chatController: chatController,
                                        dbServices: dbServices);
                                  },
                                  status: message["status"],
                                  isCurrentUser: chatController.isCurrentUser,
                                  message: message["message"],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }),
            ),
          ),
          Container(
            color: Colors.blue.shade100,
            padding: EdgeInsets.only(
                right: screenWidth * 0.07,
                left: screenWidth * 0.07,
                bottom: screenHeight * 0.02),
            child: MessageField(
              textMessage: chatController.messageController,
              onSend: () {
                String currentTime = DateTime.now().toString();
                MessageModel msgInfo = MessageModel(
                  message: chatController.messageController.text.trim(),
                  chatId: userModel.chatId,
                  timeStamp: currentTime,
                  receiverId: userModel.userId,
                  senderId: FirebaseAuth.instance.currentUser!.uid,
                );

                if (chatController.messageController.text
                    .toString()
                    .isNotEmpty) {
                  chatController.messageController.clear();
                  dbServices.sendMessage(
                      messageObject: msgInfo, userModel: userModel);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget topWidget({required context}) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      return Container(
        color: Colors.blue.shade100,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.09, vertical: screenHeight * 0.02),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userModel.name,
                      style: GoogleFonts.bebasNeue(fontSize: 30)),
                  Text(
                    chatController.isOnline.value ? "Online" : "Offline",
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
              userModel.profileImage == ""
                  ? CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.lightBlue,
                      child:
                          Icon(Icons.person, size: 80, color: Colors.white70),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          Image.network(userModel.profileImage).image,
                    ),
            ],
          ),
        ),
      );
    });
  }
}
