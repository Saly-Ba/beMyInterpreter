import 'package:be_my_interpreter_2/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    UserModel? userModel;
    Language? language;
    List<Language>? languages;
    List<Meeting>? meetings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(children: []),
    );
  }
}

class ListReunion extends StatefulWidget {
  const ListReunion({Key? key}) : super(key: key);

  @override
  ListReunionState createState() => ListReunionState();
}

class ListReunionState extends State<ListReunion> {
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
                      document.data()! as Map<String, dynamic>;
                  meeting = Meeting.fromMap(data);

                  return ListTile(
                    title: Text(meeting!.title!),
                    subtitle: Text("Debut : " +
                        meeting!.start.toString() +
                        "\nFin : " +
                        meeting!.end.toString()),
                    onLongPress: () => {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(meeting!.title!),
                                content: Text("Debut : " +
                                    meeting!.start.toString() +
                                    "\nFin : " +
                                    meeting!.end.toString()),
                              ))
                    },
                    trailing: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.red,
                    ),
                  );
                }).toList(),
              ))
            ]),
          );
        });
  }
}
