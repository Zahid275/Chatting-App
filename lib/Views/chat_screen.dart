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

  ChatScreen({super.key, required this.userModel});

  final chatController = Get.put(ChatController());
  final DbServices dbServices = DbServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(backgroundColor: Colors.blue),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Chat Rooms')
            .doc(userModel.chatId)
            .collection('Chats')
            .orderBy("timeStamp")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }else {
            var messages = snapshot.data!.docs;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                topWidget(context: context),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.034, vertical: MediaQuery
                        .of(context)
                        .size
                        .height * 0.055),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(90)),
                    ),
                    child: ListView.builder(
                      controller: chatController.scrollController.value,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        chatController.checkCurrentUser(
                            senderId: message["senderId"],
                            currentUserId: FirebaseAuth.instance.currentUser!
                                .uid);

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery
                              .of(context)
                              .size
                              .height * 0.01,),
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
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue.shade100,
                  padding: EdgeInsets.only(right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.07, left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.07, bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05),

                  child: MessageField(
                    textMessage: chatController.messageController,
                    onSend: () {
                      print(homeController.myData);
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
            );
          }
        },
      ),
    );
  }

  Widget topWidget({required context}) {
    return Container(
      color: Colors.blue.shade100,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.09,vertical:MediaQuery.of(context).size.height*0.02 ),


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
                  Text(userModel.name, style: GoogleFonts.bebasNeue(fontSize: 30)),
                Text( userModel.isOnline? "Online" : "Offline",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white),
                      )
                ],
              ),
              userModel.profileImage == ""? CircleAvatar(
                radius: 50,
                backgroundColor: Colors.lightBlue,
                child: Icon(Icons.person, size: 80, color: Colors.white70),
              ):CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                backgroundImage: Image.network(userModel.profileImage).image, ),
            ],
          ),

      ),
    );
  }
}
