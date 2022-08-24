import 'package:be_my_interpreter_2/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MeetingsManager {
  FirebaseFirestore meetings = FirebaseFirestore.instance;
  Meeting? meeting;

  Future<String> createMeeting(Meeting meeting) async {
    var id = meetings.collection("meetings").doc().id;

    await meetings.collection("meetings").doc(id).set({
      'id' : id,
      'title': meeting.title,
      'start': meeting.start,
      'end': meeting.end,
      'language': meetings.doc("langues/" + (meeting.language!.id).toString()),
      'validate': meeting.validate,
      'creator' : meeting.creator,
      'participants' : meeting.participants,
    });

    Fluttertoast.showToast(msg: "La reunion a été créer avec succes !");

    return id;
  }

  void updateMeeting(Meeting meeting) async {
    await meetings.collection("meetings").doc((meeting.id).toString()).update({
      'title': meeting.title,
      'start': meeting.start,
      'end': meeting.end,
      'language': meetings.doc("langues/" + (meeting.language!.id).toString()),
      'participants' : meeting.participants,
    });

    Fluttertoast.showToast(msg: "La reunion a été modifier avec succes !");
  }

  void deleteMeeting(Meeting meeting) async {
    await meetings.collection("meetings").doc((meeting.id).toString()).delete();
  }
}

class UserManager {
  FirebaseFirestore users = FirebaseFirestore.instance;

  static void createUser(UserModel user) async {
    dynamic lan = [];

    if (user.languages!.isNotEmpty) {
      for (var element in user.languages!) {
        lan.add(firebaseFirestore.doc("langues/" + (element!.id).toString()));
      }
    }
    await firebaseFirestore.collection('users').doc(user.id).set({
      "id": user.id,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "password": user.password,
      "languages": lan,
      "userType": user.userType!.name,
      "meetings": user.meetings,
    });
  }

  static void updateUser(UserModel user) async {
    dynamic lan = [];

    if (user.languages!.isNotEmpty) {
      for (var element in user.languages!) {
        lan.add(firebaseFirestore.doc("langues/" + (element!.id).toString()));
      }
    }

    await firebaseFirestore.collection('users').doc(user.id).update({
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "languages": lan,
    });
  }

  static Future<UserModel> getUser(String id) async {
    var user = await firebaseFirestore.collection("users").doc(id).get();
    return UserModel.create(user);
  }

  static Future<UserModel?> getUsersEmail(String email) async {
    Future<UserModel?>? user;
    return await firebaseFirestore.collection('users').where('email', isEqualTo: email).get().then((value) {
      if(value.docs.isNotEmpty){
        user = UserModel.create(value.docs[0].data());
      }
      
      return user;
    });
  }

  static void updateUserMeetings(String id, String idMeet) async{
    try{
      await firebaseFirestore.collection("users").doc(id).update({
        'meetings' : FieldValue.arrayUnion([firebaseFirestore.doc("meetings/" + idMeet)])
      });

        Fluttertoast.showToast(msg: "La reunion a été créer avec succes !");
    }on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: e.message! );
    }
    
  }
}



class LanguageManager {
  FirebaseFirestore languages = FirebaseFirestore.instance;
  Language? language;

  Future<Language?> getLanguage(String path) async {
    await languages.collection(path).get().then(
          (value) => language = Language.fromMap(value),
        );

    return language;
  }
}
