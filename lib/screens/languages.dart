import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models.dart';

class LanguageList extends StatefulWidget {
  final bool isMultiSelection;
  final List<Language?>? listLanguages;

  const LanguageList(
      {Key? key, this.isMultiSelection = false, this.listLanguages})
      : super(key: key);
  @override
  LanguageListState createState() => LanguageListState();
}

class LanguageListState extends State<LanguageList> {
  Language? language;
  List<Language?>? localList = [];
  final Stream<QuerySnapshot> _languagesData =
      FirebaseFirestore.instance.collection("langues").snapshots();

  @override
  void initState() {
    super.initState();

    localList = widget.listLanguages;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _languagesData,
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
            title: const Text('Choisissez vos langues'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    language = Language.fromMap(data);
                    bool isSelected = false;

                    if (widget.isMultiSelection) {
                      for (var element in localList!) {
                        if (element!.id == language!.id) {
                          isSelected = true;
                          break;
                        }
                      }
                    }

                    return LanguageListView(
                      language: language,
                      isSelected: isSelected,
                      onSelectedLanguage: selectLanguage,
                    );
                  }).toList(),
                ),
              ),
              buildSelectionButton(context)!,
            ],
          ),
        );
      },
    );
  }

  Widget? buildSelectionButton(BuildContext context) {
    final label = widget.isMultiSelection
        ? 'Vous avez selectionne ${localList!.length} Langues'
        : 'Continue';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      color: Theme.of(context).primaryColor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: const Size.fromHeight(40),
          primary: Colors.white,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        onPressed: submit,
      ),
    );
  }

  void submit() => Navigator.pop(context, localList);

  void selectLanguage(Language language) {
    if (widget.isMultiSelection) {
      bool isSelected = false;
      for (var element in localList!) {
        if (element!.id == language.id) {
          isSelected = true;
          break;
        }
      }
      setState(() {
        if (isSelected) {
          for (var element in localList!) {
            if (element!.id == language.id) {
              localList!.remove(element);
              break;
            }
          }
        } else {
          localList!.add(language);
        }
      });
    } else {
      Navigator.pop(context, language);
    }
  }
}

class LanguageListView extends StatelessWidget {
  final Language? language;
  final bool isSelected;
  final ValueChanged<Language> onSelectedLanguage;

  const LanguageListView(
      {Key? key,
      required this.language,
      required this.isSelected,
      required this.onSelectedLanguage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final style = isSelected
        ? TextStyle(
            fontSize: 18,
            color: selectedColor,
            fontWeight: FontWeight.bold,
          )
        : const TextStyle(fontSize: 18);
    return ListTile(
      onTap: () => onSelectedLanguage(language!),
      title: Text(
        language!.language,
        style: style,
      ),
      subtitle: Text(language!.country),
      trailing:
          isSelected ? Icon(Icons.check, color: selectedColor, size: 26) : null,
    );
  }
}
