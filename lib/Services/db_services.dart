import 'package:chit_chat/Cotrollers/chatpage_controller.dart';
import 'package:chit_chat/Models/msg_model.dart';
import 'package:chit_chat/Models/user_model.dart';
import 'package:chit_chat/Services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DbServices {
  Future<bool> checkInternet() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }

  NotificationServices notificationServices = NotificationServices();
  final chatController = ChatController(); // Find the controller


  createUser({
    required UserModel userModel,required password
  }) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.userId)
        .set(userModel.toMap2(password: password));
  }

  void sendMessage(
      {required MessageModel messageObject,
      required UserModel userModel}) async {
    try {
      chatController.messageController.clear();

      await FirebaseFirestore.instance
          .collection("Chat Rooms")
          .doc(messageObject.chatId)
          .collection("Chats")
          .doc(messageObject.timeStamp)
          .set(messageObject.toMap());

      await FirebaseFirestore.instance
          .collection("Chat Rooms")
          .doc(messageObject.chatId)
          .collection("Chats")
          .doc(messageObject.timeStamp)
          .update({"status": "sent"});


      updateUserFriend(receiverId: messageObject.receiverId);
      String? token = await notificationServices.getDeviceToken();

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Friends")
          .doc(messageObject.receiverId)
          .set(userModel.toMap1());




      await notificationServices.sendNotification(
          title: "You got a message",
          body: messageObject.message,
          receiverToken: userModel.userToken);
    } catch (e) {
      print("ERROR: $e");
    }
  }

  deleteMessage(QueryDocumentSnapshot message) async {
    print(message["chatId"]);
    await FirebaseFirestore.instance
        .collection("Chat Rooms")
        .doc(message["chatId"])
        .collection("Chats")
        .doc(message.id)
        .delete();
  }

  addUserImage({required String imageUrl, required String userId}) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .update({"profileImage": imageUrl});
  }



  updateUserFriend({required receiverId})async{


     final myData = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get();


     if(myData != null) {
       Map<String, dynamic>? data = myData.data();

       await FirebaseFirestore.instance
           .collection("Users")
           .doc(receiverId)
           .collection("Friends")
           .doc(data!["userId"])
           .set(data);
     }
  }
}
