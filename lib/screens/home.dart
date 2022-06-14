import 'package:be_my_interpreter_2/auth_service.dart';
import 'package:be_my_interpreter_2/db_manager.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/meeting_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final UserModel? userModel;
  const Home({Key? key, this.userModel}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    /*UserModel? userModel;
    Language? language;
    List<Language>? languages;
    List<Meeting>? meetings;*/
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              authService.signOut();
            },
            child: const Text("Sign Out"))
      ]),
    );
  }
}

class ListReunion extends StatefulWidget {
  const ListReunion({Key? key}) : super(key: key);

  @override
  ListReunionState createState() => ListReunionState();
}

class ListReunionState extends State<ListReunion> {
  MeetingsManager meetingsManager = MeetingsManager();
  Meeting? meeting;
  final Stream<QuerySnapshot> _meetingsData =
      FirebaseFirestore.instance.collection("meeting").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _meetingsData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Text("loading"),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Vos reunions'),
            ),
            body: Column(children: [
              Expanded(
                  child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  return FutureBuilder(
                      future: Meeting.create(data),
                      builder: (BuildContext context,
                          AsyncSnapshot<Meeting> snapshot) {
                        if (snapshot.hasData) {
                          meeting = snapshot.data;

                          return ListViewMeeting(
                            meeting: meeting!,
                            onTapInfo: showMeetingInfo,
                            onDelete: deleteMeeting,
                            onUpdate: updateMeeting,
                          );
                        } else {
                          return const Text("No data in there");
                        }
                      });
                }).toList(),
              )),
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreerReunion()));
              },
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.add,
                size: 35,
                color: Colors.white,
              ),
            ),
          );
        });
  }

  void showMeetingInfo(Meeting meeting) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(meeting.title!),
              content: Text("Debut : " +
                  meeting.start.toString() +
                  "\nFin : " +
                  meeting.end.toString() +
                  "\nLangue : " +
                  meeting.language!.language)
            ));
  }

  void deleteMeeting(Meeting meeting) {
    meetingsManager.deleteMeeting(meeting);
  }

  void updateMeeting(Meeting meeting) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateMeeting(meeting: meeting)));
  }
}

class ListViewMeeting extends StatelessWidget {
  final Meeting meeting;
  final ValueChanged<Meeting> onTapInfo;
  final ValueChanged<Meeting> onDelete;
  final ValueChanged<Meeting> onUpdate;

  const ListViewMeeting(
      {Key? key,
      required this.meeting,
      required this.onTapInfo,
      required this.onDelete,
      required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(meeting.title!),
        subtitle: Text("Debut : " +
            meeting.start.toString() +
            "\nFin : " +
            meeting.end.toString()),
        onTap: () => onTapInfo(meeting),
        trailing: SizedBox(
            width: 100.0,
            child: Row(children: [
              IconButton(
                  icon: const Icon(Icons.edit, size: 30, color: Colors.green),
                  onPressed: () => onUpdate(meeting)),
              IconButton(
                  icon: const Icon(Icons.delete, size: 30, color: Colors.red),
                  onPressed: () => onDelete(meeting)),
            ])));
  }
}
