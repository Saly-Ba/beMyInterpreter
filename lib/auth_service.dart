import 'package:be_my_interpreter_2/db_manager.dart';
import 'package:be_my_interpreter_2/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Future<UserModel?> signIn(
      String? email, String? password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email!, password: password!);

    return UserManager.getUser(credential.user!.uid);
  }

  Future<UserModel?> createUser(
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      UserType? userType,
      List<Language?>? languages) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((value) {
        UserModel userModel = UserModel(
            id: value.user!.uid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            languages: languages!,
            userType: userType!,
            meetings: []);

        UserManager.createUser(userModel);
      });

      Fluttertoast.showToast(msg: "Votre compte a été créer avec succes !");
    } on auth.FirebaseAuthException catch (_) {
      Fluttertoast.showToast(
          msg: "Cet email est déjà présent dans notre base de données !");
    }
  }

  Stream<UserModel>? get getUser {
    return _firebaseAuth.authStateChanges().asyncMap((event) => UserManager.getUser(event!.uid));
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
