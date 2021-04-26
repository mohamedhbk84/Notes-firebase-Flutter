import 'package:firebase/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firebaseDb = Firestore.instance.collection("board").snapshots();
  TextEditingController nameInputController;
  TextEditingController titleInputController;
  TextEditingController descriptionInputController;

  @override
  void initState() {
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Board redeuce"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(FontAwesomeIcons.pen),
      ),
      body: StreamBuilder(
        stream: firebaseDb,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, int index) {
                return CustomCard(
                  snapshot: snapshot.data,
                  index: index,
                );
                // return Text(snapshot.data.documents[index]["description"]);
              });
        },
      ),
    );
  }

  _showDialog(BuildContext context) async {
    // ignore: missing_required_param
    await showDialog(
        context: context,
        builder: (context) => Card(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(10),
                content: Column(
                  children: [
                    Text("Please Fill out the form ."),
                    Expanded(
                        child: TextField(
                      autofocus: true,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: "Your Name*",
                      ),
                      controller: nameInputController,
                    )),
                    Expanded(
                        child: TextField(
                      autofocus: true,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: "title*",
                      ),
                      controller: titleInputController,
                    )),
                    Expanded(
                        child: TextField(
                      autofocus: true,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: "Description*",
                      ),
                      controller: descriptionInputController,
                    )),
                  ],
                ),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        nameInputController.clear();
                        titleInputController.clear();
                        descriptionInputController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        if (nameInputController.text.isNotEmpty &&
                            titleInputController.text.isNotEmpty &&
                            descriptionInputController.text.isNotEmpty) {
                          Firestore.instance.collection("board").add({
                            "name": nameInputController.text,
                            "title": titleInputController.text,
                            "description": descriptionInputController.text,
                            "timeTamp": new DateTime.now(),
                          }).then((response) {
                            print(response.documentID);
                            Navigator.pop(context);
                            nameInputController.clear();
                            titleInputController.clear();
                            descriptionInputController.clear();
                          }).catchError((onError) => print("error"));
                        }
                      },
                      child: Text("Save"))
                ],
              ),
            ));
  }
}
