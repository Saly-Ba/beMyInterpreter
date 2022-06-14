import 'package:be_my_interpreter_2/db_manager.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/languages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:math';

class CreerReunion extends StatefulWidget {
  const CreerReunion({Key? key}) : super(key: key);

  @override
  CreerReunionState createState() => CreerReunionState();
}

class CreerReunionState extends State<CreerReunion> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final emailsController = TextEditingController();
  DateTime now = DateTime.now();
  DateTime? startDateTime = DateTime.now();
  DateTime? endDateTime;
  List<UserModel> participants = [];
  Language? language;
  UserModel? userModel;
  MeetingsManager meetingsManager = MeetingsManager();
  var emails = [];
  final Stream<QuerySnapshot> _usersData =
      FirebaseFirestore.instance.collection('users').snapshots();

  Widget? _buildTitle() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Titre de la reunion :"),
      controller: titleController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
    );
  }

  Widget? _buildParticipantsEmails() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Ajouter un participant :"),
      controller: emailsController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
      onFieldSubmitted: (value) {
        setState(() {
          emails = value.split(";");
        });
      },
    );
  }

  Widget? _buildSingleLanguage() {
    // ignore: prefer_function_declarations_over_variables
    final onTap = () async {
      final language = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LanguageList()));

      if (language == null) return;

      setState(() => this.language = language);
    };

    return language == null
        ? _buildListLanguage(title: 'No language', onTap: onTap)
        : _buildListLanguage(title: language!.language, onTap: onTap);
  }

  Widget? _buildListLanguage({
    @required String? title,
    @required VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersData,
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
            appBar: AppBar(title: const Text("Créer une reunion")),
            body: Container(
              margin: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle()!,
                      const SizedBox(height: 20),
                      _FormDatePicker(
                          input: "Date du debut",
                          minDate: now,
                          maxDate: DateTime(2100),
                          onChanged: (value) {
                            setState(() {
                              startDateTime = value;
                            });
                          }),
                      const SizedBox(height: 20),
                      _FormDatePicker(
                          input: "Date de la fin",
                          minDate: startDateTime!,
                          maxDate: startDateTime!.add(const Duration(hours: 5)),
                          onChanged: (value) {
                            setState(() {
                              endDateTime = value;
                            });
                          }),
                      const SizedBox(height: 20),
                      _buildParticipantsEmails()!,
                      SizedBox(
                        height: 50.0,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs.where((element) {
                            return emails.contains(element.get('email'));
                          }).map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return FutureBuilder(
                                future: UserModel.create(data),
                                builder: (BuildContext context,
                                    AsyncSnapshot<UserModel> snapshot) {
                                  if (snapshot.hasData) {
                                    userModel = snapshot.data;
                                    
                                    if (participants.every(
                                        (item) => item.id != userModel!.id)) {
                                      participants.add(userModel!);
                                    }

                                    return InputChip(
                                        label: Text(userModel!.email!));
                                  } else {
                                    return const Text("No data in there");
                                  }
                                });
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSingleLanguage()!,
                      ElevatedButton(
                        onPressed: (() {
                          if (_formKey.currentState!.validate()) {
                            Random random = Random();
                            int id = random.nextInt(100000);

                            Meeting meeting = Meeting(
                                id: id,
                                title: titleController.text,
                                start: startDateTime,
                                end: endDateTime,
                                language: language,
                                participants: participants,
                                validate: false);

                            meetingsManager.createMeeting(meeting);

                            titleController.clear();
                            emailsController.clear();
                            startDateTime = now;
                            endDateTime = now;
                          }
                        }),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class UpdateMeeting extends StatefulWidget {
  final Meeting meeting;
  const UpdateMeeting({Key? key, required this.meeting}) : super(key: key);

  @override
  UpdateMeetingState createState() => UpdateMeetingState();
}

class UpdateMeetingState extends State<UpdateMeeting> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final emailsController = TextEditingController();
  DateTime now = DateTime.now();
  DateTime? startDateTime = DateTime.now();
  DateTime? endDateTime;
  List<UserModel> participants = [];
  Language? language;
  UserModel? userModel;
  MeetingsManager meetingsManager = MeetingsManager();
  var emails = [];

  Widget? _buildTitle() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Titre de la reunion :"),
      controller: titleController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    titleController.text = widget.meeting.title!;
    startDateTime = widget.meeting.start!;
    endDateTime = widget.meeting.end;
  }

  Widget? _buildParticipantsEmails() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Ajouter un participant :"),
      controller: emailsController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
      onFieldSubmitted: (value) {
        setState(() {
          emails = value.split(";");
        });
      },
    );
  }

  Widget? _buildSingleLanguage() {
    // ignore: prefer_function_declarations_over_variables
    final onTap = () async {
      final language = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LanguageList()));

      if (language == null) return;

      setState(() => this.language = language);
    };

    return language == null
        ? _buildListLanguage(title: 'No language', onTap: onTap)
        : _buildListLanguage(title: language!.language, onTap: onTap);
  }

  Widget? _buildListLanguage({
    @required String? title,
    @required VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer une reunion")),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle()!,
                const SizedBox(height: 20),
                _FormDatePicker(
                    input: "Date du debut",
                    minDate: now,
                    maxDate: DateTime(2100),
                    onChanged: (value) {
                      setState(() {
                        startDateTime = value;
                      });
                    }),
                const SizedBox(height: 20),
                _FormDatePicker(
                    input: "Date de la fin",
                    minDate: startDateTime!,
                    maxDate: startDateTime!.add(const Duration(hours: 5)),
                    onChanged: (value) {
                      setState(() {
                        endDateTime = value;
                      });
                    }),
                const SizedBox(height: 20),
                _buildParticipantsEmails()!,
                /*SizedBox(
                        height: 50.0,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: widget.meeting.participants!.forEach((element) {
                            
                            return InputChip(label: Text(element.email!));
                          })

                            
                          
                        ),
                      ),*/
                const SizedBox(height: 20),
                _buildSingleLanguage()!,
                ElevatedButton(
                  onPressed: (() {
                    if (_formKey.currentState!.validate()) {
                      Meeting meeting = Meeting(
                          id: widget.meeting.id,
                          title: titleController.text,
                          start: startDateTime,
                          end: endDateTime,
                          language: language,
                          participants: participants,
                          validate: false);

                      meetingsManager.updateMeeting(meeting);

                      titleController.clear();
                      emailsController.clear();
                      startDateTime = now;
                      endDateTime = now;

                      Navigator.pop(context);
                    }
                  }),
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final String input;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.input,
    required this.minDate,
    required this.maxDate,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.input,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            Text(
              intl.DateFormat.yMd().format(date) +
                  " a " +
                  intl.DateFormat.Hms().format(date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Icon(
            Icons.calendar_today,
            color: Colors.amber,
            size: 26,
          ),
          onPressed: () async {
            /*var newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: widget.minDate,
              lastDate: DateTime(2100),
            );*/
            var newDate = await DatePicker.showDateTimePicker(
              context,
              minTime: widget.minDate,
              maxTime: widget.maxDate,
              currentTime: DateTime.now(),
              locale: LocaleType.en,
            );
            //print(newDate);
            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            setState(() {
              date = newDate;
            });

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
