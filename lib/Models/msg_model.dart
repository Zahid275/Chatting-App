class MessageModel {
  final message;
  final senderId;
  final receiverId;
  final timeStamp;
  String? status;
  final chatId;

  MessageModel(
      {
      required this.message,
      required this.chatId,
      required this.timeStamp,
      required this.receiverId,
      required this.senderId,
        this.status = "sending",

      });



  Map<String, dynamic> toMap() {
    return {
      "chatId":chatId,
      "message": message,
      "senderId": senderId,
      "receiverId": receiverId,
      "timeStamp": timeStamp,
      "status": status,
    };
  }
}
