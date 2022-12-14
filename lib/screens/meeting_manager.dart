import 'package:be_my_interpreter_2/db_manager.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:be_my_interpreter_2/screens/languages.dart';
import 'package:be_my_interpreter_2/screens/users_chips.dart';
import 'package:be_my_interpreter_2/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path/path.dart';
import 'dart:math';

import 'package:provider/provider.dart';

import '../auth_service.dart';
import '../constantes/theme_variable.dart';

class CreerReunion extends StatefulWidget {
  final UserModel? currentUser;
  const CreerReunion({Key? key, required this.currentUser}) : super(key: key);

  @override
  CreerReunionState createState() => CreerReunionState();
}

class CreerReunionState extends State<CreerReunion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final emailsController = TextEditingController();
  DateTime now = DateTime.now();
  DateTime? startDateTime = DateTime.now();
  DateTime? endDateTime;
  List<UserModel> participants = [];
  Language? language;
  UserModel? userModel;
  MeetingsManager meetingsManager = MeetingsManager();
  List<String?>? emails = [];

  final Stream<QuerySnapshot> _usersData =
      FirebaseFirestore.instance.collection('users').snapshots();

  Widget _titleIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.title,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget _emailIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.email_outlined,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget? _buildTitle(Size size) {
    return TextFormField(
      decoration: inputStyle(size, 'Donnez le titre de cette réunion', 'Titre', _titleIcon(size)),
      controller: titleController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Ce champ est requis !";
        }
        return null;
      },
      
    );
  }

  Widget? _buildParticipantsEmails(size) {
    return TextFormField(
      decoration: inputStyle(size, 'Ajouter des participants', 'Participants', _emailIcon(size)),
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
      final language = await Navigator.push(this.context,
          MaterialPageRoute(builder: (context) => const LanguageList()));

      if (language == null) return;

      setState(() => this.language = language);
    };

    return OutlinedButton(
        onPressed: () => {},
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(
            color: APP_PRIMARY,
            width: 1.5,
          )
        ), 
        child: language == null
        ? _buildListLanguage(title: 'Choisissez une langue', onTap: onTap)!
        : _buildListLanguage(title: language!.language, onTap: onTap)!,
      );
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
      trailing: const Icon(Icons.arrow_drop_down, color: APP_PRIMARY),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

          if (widget.currentUser!.userType != UserType.interpret) {
          
            return Scaffold(
                      appBar: AppBar(title: const Text("Créer une réunion")),
                      body: Container(
                        margin: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/illustration/undraw_insert_re_s97w.svg',height: size.height * 0.20,),
                                const SizedBox(height: 20),
                                _buildTitle(size)!,
                                const SizedBox(height: 20),
                                _FormDatePicker(
                                    input: "Date du début",
                                    initialDate: now,
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
                                    initialDate: now,
                                    minDate: startDateTime!,
                                    maxDate: startDateTime!
                                        .add(const Duration(hours: 5)),
                                    onChanged: (value) {
                                      setState(() {
                                        endDateTime = value;
                                      });
                                    }),
                                const SizedBox(height: 20),
                                _buildParticipantsEmails(size)!,
                                const SizedBox(
                                  height: 10.0
                                  ),

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: emails!.map((e) => EmailChips(email: e)).toList(),
                                ),
                                const SizedBox(height: 10),
                                _buildSingleLanguage()!,
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: (() async {
                                    if (_formKey.currentState!.validate()) {
                                      
                                      Meeting meeting = Meeting(
                                          title: titleController.text,
                                          start: startDateTime,
                                          end: endDateTime,
                                          language: language,
                                          participants: emails,
                                          creator: widget.currentUser!.id,
                                          validate: false);

                                      String idMeet = await meetingsManager.createMeeting(meeting);
                                    
                                      UserManager.updateUserMeetings(widget.currentUser!.id!, idMeet);

                                      for (var element in emails!) {
                                        var user = await UserManager.getUsersEmail(element!);

                                        UserManager.updateUserMeetings(user!.id!, idMeet);
                                      }


                                      titleController.clear();
                                      emailsController.clear();
                                      startDateTime = now;
                                      endDateTime = now;
                                      emails = [];
                                      language = null;

                                      Navigator.pop(context);
                                    }
                                  }),
                                  style: buttonStyle(size),
                                  child: const Text("Ajouter"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

            } else {
              return AccessDenied(size: size);
            }
          } 
      
  }

class UpdateMeeting extends StatefulWidget {
  final Meeting meeting;
  final UserModel? currentUser;
  const UpdateMeeting({Key? key, required this.meeting, required this.currentUser}) : super(key: key);

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
  List<String?>? emails = [];

  Widget _titleIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.title,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget _emailIcon(Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, size.width * 0.02, size.width * 0.035, size.width * 0.02),
      child: const Icon(
        Icons.email_outlined,
        color: APP_PRIMARY,
        size: 27.5,
      ),
    );
  }

  Widget? _buildTitle(Size size) {
    return TextFormField(
      decoration: inputStyle(size, 'Le titre de la réunion', 'Titre', _titleIcon(size)),
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
    language = widget.meeting.language!;
    emails = widget.meeting.participants!;
  }

  Widget? _buildParticipantsEmails(Size size) {
    return TextFormField(
      decoration: inputStyle(size,'','Participants', _emailIcon(size)),
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
      final language = await Navigator.push(this.context,
          MaterialPageRoute(builder: (context) => const LanguageList()));

      if (language == null) return;

      setState(() => this.language = language);
    };

    return OutlinedButton(
        onPressed: () => {},
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(
            color: APP_PRIMARY,
            width: 1.5,
          )
        ), 
        child: language == null
        ? _buildListLanguage(title: 'Choisissez une langue', onTap: onTap)!
        : _buildListLanguage(title: language!.language, onTap: onTap)!,
      );
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
    Size size = MediaQuery.of(context).size;

            if (widget.currentUser!.userType != UserType.interpret && widget.currentUser!.id == widget.meeting.creator) {
              return Scaffold(
                appBar: AppBar(title: const Text("Modifier la réunion")),
                body: Container(
                  margin: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/illustration/undraw_update_re_swkp.svg',height: size.height * 0.2, ),
                          const SizedBox(height: 20),
                          _buildTitle(size)!,
                          const SizedBox(height: 20),
                          _FormDatePicker(
                              input: "Date du debut",
                              initialDate: startDateTime,
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
                              initialDate: endDateTime,
                              minDate: startDateTime!,
                              maxDate:
                                  startDateTime!.add(const Duration(hours: 5)),
                              onChanged: (value) {
                                setState(() {
                                  endDateTime = value;
                                });
                              }),
                          const SizedBox(height: 20),
                          _buildParticipantsEmails(size)!,
                          const SizedBox(
                                  height: 10.0
                                  ),

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: emails!.map((e) => EmailChips(email: e)).toList(),
                                ),
                          const SizedBox(height: 10),
                          _buildSingleLanguage()!,
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: (() {
                              if (_formKey.currentState!.validate()) {
                                Meeting meeting = Meeting(
                                    id: widget.meeting.id,
                                    title: titleController.text,
                                    start: startDateTime,
                                    end: endDateTime,
                                    language: language,
                                    participants: emails,
                                    creator: widget.currentUser!.id,
                                    validate: false);

                                meetingsManager.updateMeeting(meeting);

                                titleController.clear();
                                emailsController.clear();
                                startDateTime = now;
                                endDateTime = now;

                                Navigator.pop(context);
                              }
                            }),
                            style: buttonStyle(size),
                            child: const Text("Modifier"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }else {
              return AccessDenied(size: size);
            }
          }
}

// ignore: must_be_immutable
class _FormDatePicker extends StatefulWidget {
  DateTime? initialDate = DateTime.now(); 
  final String input;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onChanged;

  _FormDatePicker({
    this.initialDate,
    required this.input,
    required this.minDate,
    required this.maxDate,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  DateTime? date;

  @override
  void initState() {
    super.initState();
    date = widget.initialDate!;
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
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
      style: TextButton.styleFrom(
        shape: const StadiumBorder(),
        side: const BorderSide(
          color: APP_PRIMARY,
          width: 1.5,
        )
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.input,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  "${intl.DateFormat('EEEE, d MMMM y').format(date!)} à ${intl.DateFormat('H:m').format(date!)}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            const Icon(
                Icons.calendar_today,
                color: APP_PRIMARY,
                size: 26,
            ),
            
          ],
        ),
      ),
    );
  }
}
