import 'package:be_my_interpreter_2/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MeetingsManager {
  FirebaseFirestore meetings = FirebaseFirestore.instance;
  Meeting? meeting;

  void createMeeting(Meeting meeting) async {
    await meetings.collection("meeting").doc((meeting.id).toString()).set({
      'id': meeting.id,
      'title': meeting.title,
      'start': meeting.start,
      'end': meeting.end,
      'language': meetings.doc("langues/" + (meeting.language!.id).toString()),
      'validate': meeting.validate,
    });

    Fluttertoast.showToast(msg: "La reunion a été créer avec succes !");
  }

  void updateMeeting(Meeting meeting) async {
    await meetings.collection("meeting").doc((meeting.id).toString()).update({
      'id': meeting.id,
      'title': meeting.title,
      'start': meeting.start,
      'end': meeting.end,
      'language': meetings.doc("langues/" + (meeting.language!.id).toString()),
      'validate': meeting.validate,
    });

    Fluttertoast.showToast(msg: "La reunion a été modifier avec succes !");
  }

  void deleteMeeting(Meeting meeting) async {
    await meetings.collection("meeting").doc((meeting.id).toString()).delete();
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
    dynamic meet = [];

    if (user.languages!.isNotEmpty) {
      for (var element in user.languages!) {
        lan.add(firebaseFirestore.doc("langues/" + (element!.id).toString()));
      }
    }

    if (user.meetings!.isNotEmpty) {
      for (var elt in user.meetings!) {
        meet.add(firebaseFirestore.doc("meetings/" + (elt!.id).toString()));
      }
    }

    await firebaseFirestore.collection('users').doc(user.id).update({
      "id": user.id,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "password": user.password,
      "languages": lan,
      "userType": user.userType!.name,
      "meetings": meet,
    });
  }

  static Future<UserModel> getUser(String id) async {
    var user = await firebaseFirestore.collection("users").doc(id).get();
    return UserModel.create(user);
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
