class UserModel {
  final name;
  final email;
  final userId;
  final chatId;
  final isOnline;
  final profileImage;
  final userToken;
  UserModel({required this.userToken,required this.profileImage,required this.isOnline ,required this.name,required this.email, this.chatId,required this.userId});



 Map<String,dynamic> toMap1(){
   return {
     "name":name,
     "email":email,
     "userId":userId,
     "chatId":chatId,
     "isOnline":isOnline,
     "profileImage":profileImage,
     "deviceToken": userToken
   };
 }
  Map<String,dynamic> toMap2({required password}){
    return {
      "name":name,
      "email":email,
      "userId":userId,
      "isOnline":isOnline,
      "profileImage":profileImage,
      "deviceToken": userToken,
      "password":password
    };
  }





}
