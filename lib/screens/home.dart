import 'package:be_my_interpreter_2/auth_service.dart';
import 'package:be_my_interpreter_2/db_manager.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/meeting_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  const ListReunion({Key? key, required this.currentUser}) : super(key: key);
  final UserModel? currentUser;

  @override
  ListReunionState createState() => ListReunionState();
}

class ListReunionState extends State<ListReunion> {
  MeetingsManager meetingsManager = MeetingsManager();
  Meeting? meeting;
  final Stream<QuerySnapshot> _meetingsData =
      FirebaseFirestore.instance.collection("meetings").snapshots();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: _meetingsData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Column(
                children: [
                  SvgPicture.asset('assets/images/illustration/undraw_server_down_s-4-lk.svg', height: size.height * 0.4,)
                ],
              )),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Color(0XFF4FA3A5),
              )),
            );
          }
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/illustration/undraw_no_data_re_kwbl.svg',
                      height: size.height * 0.40,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Vos réunions'),
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: widget.currentUser!.meetings!.isNotEmpty ? Column(children: [
                  SvgPicture.asset(
                    'assets/images/illustration/undraw_my_documents_re_13dc.svg',
                    height: size.height * 0.25,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                    children:
                        widget.currentUser!.meetings!.map((meet) {
                              meeting = meet;

                              return ListViewMeeting(
                                meeting: meeting!,
                                onTapInfo: showMeetingInfo,
                                onDelete: deleteMeeting,
                                onUpdate: updateMeeting,
                              );
                            }).toList(),
                  )) 
                ]) : Center(
                  child: SvgPicture.asset(
                    'assets/images/illustration/undraw_empty_re_opql.svg',
                    height: size.height * 0.25,
                  ),
                )
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreerReunion(
                                currentUser: widget.currentUser,
                              )));
                },
                backgroundColor: const Color(0XFF4FA3A5),
                child: const Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            );
          }
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
                meeting.language!.language)));
  }

  void deleteMeeting(Meeting meeting) {
    meetingsManager.deleteMeeting(meeting);
  }

  void updateMeeting(Meeting meeting) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateMeeting(
                  meeting: meeting,
                  currentUser: widget.currentUser,
                )));
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
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                    color: Color(0XFF4FA3A5),
                  ),
                  onPressed: () => onUpdate(meeting)),
              IconButton(
                  icon: const Icon(Icons.delete,
                      size: 30, color: Color(0XFFee6f86)),
                  onPressed: () => onDelete(meeting)),
            ])));
  }
}
