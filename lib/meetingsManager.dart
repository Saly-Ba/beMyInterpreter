import 'package:be_my_interpreter_2/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MeetingsManager {
  FirebaseFirestore meetings = FirebaseFirestore.instance;

  void createMeeting(Meeting meeting) async {
    dynamic users = [];
    for (var element in meeting.participants!) {
      users.add(meetings.doc("users/" + (element.id).toString()));
    }

    await meetings.collection("meeting").doc((meeting.id).toString()).set({
      'id': meeting.id,
      'title': meeting.title,
      'start': meeting.start,
      'end': meeting.end,
      'participants': users,
      //'language': meetings.doc("langues/" + (meeting.language!.id).toString()),
      'validate': meeting.validate,
    });

    Fluttertoast.showToast(msg: "La reunion a été créer avec succes !");
  }

  void updateMeeting(Meeting meeting) async {
    await meetings.collection("meeting").doc().update(meeting.toMap());
  }

  void deleteMeeting(Meeting meeting) async {
    await meetings.collection("meeting").doc().delete();
  }
}

class UserManager {
  FirebaseFirestore users = FirebaseFirestore.instance;

  void createUser(UserModel user) async {}
}
