import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//User model
class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  List<Language?>? languages;
  List<Meeting?>? meetings;
  UserType? userType;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.languages,
    required this.userType,
    this.meetings,
  });

  List<Meeting?>? get getMeetings => meetings;

  set setMeetings(List<Meeting?>? meetings) {
    this.meetings = meetings;
  }

  List<Language?>? get getLanguages => languages;

  set setLanguages(List<Language?>? languages) {
    this.languages = languages;
  }

  UserModel._({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.userType,
    this.languages,
    this.meetings,
  });

  static Future<UserModel> create(map) async {
    return UserModel._(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
      languages:
          await Future.wait((map['languages'] as List<dynamic>).map((e) async {
        return await (e as DocumentReference).get().then((value) {
          return Language.fromMap(value.data());
        });
      })),
      userType: UserType.values.byName(map['userType']),
      meetings: map['meetings'] is Iterable ?
          await Future.wait((map['meetings'] as List<dynamic>).map((e) async {
        return await (e as DocumentReference).get().then((value) async {
          return await Meeting.create(value.data());
        });
      })) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'languages': languages,
      'userType': userType.toString(),
      'meetings': meetings,
    };
  }
}

enum UserType {
  interpret,
  sourd,
  autre,
}

class Language {
  final int id;
  final String language;
  final String country;
  final String region;
  final String family;

  Language(
      {required this.id,
      required this.language,
      required this.country,
      required this.region,
      required this.family});

  factory Language.fromMap(map) {
    return Language(
        id: map['id'],
        language: map['Langue'],
        country: map['Country'],
        region: map['Region'],
        family: map['Family']);
  }
}

class Meeting {
  final String? id;
  final String? title;
  final DateTime? start;
  final DateTime? end;
  bool? validate = false;
  final Language? language;
  final String? creator;
  final List<String?>? participants;
  bool? status = false;

  Meeting({
    this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.language,
    required this.creator,
    required this.participants,
    this.validate,
    this.status,
  });

  bool? get getValidate => validate;

  set setValidate(bool? validation) {
    validate = validation;
  }

  bool? get getStatus => status;

  set setStatus(bool? status) {
    status = status;
  }

  Meeting._(
      {this.id,
      this.title,
      this.start,
      this.end,
      this.validate,
      this.language,
      this.creator,
      this.participants,});

  static Future<Meeting> create(map) async {
    return Meeting._(
      id: map['id'],
      title: map['title'],
      start: (map['start'] as Timestamp).toDate(),
      end: (map['end'] as Timestamp).toDate(),
      language:
          await (map['language'] as DocumentReference).get().then((value) {
        return Language.fromMap(value);
      }),
      validate: map['validate'],
      creator: map['creator'],
      participants: map['participants'] is Iterable ? List.from(map['participants']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'start': start,
      'end': end,
      'language': language,
      'validate': validate,
      'creator': creator,
      'participants': participants,
    };
  }
}