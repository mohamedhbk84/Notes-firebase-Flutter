import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  // ignore: must_be_immutable
  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeDate = new DateTime.fromMillisecondsSinceEpoch(
        snapshot.documents[index].data["timeTamp"].seconds * 1000);
    var dateFormatted = new DateFormat("EEEE, MMM d").format(timeDate);

    TextEditingController nameInputController =
        TextEditingController(text: snapshot.documents[index].data["name"]);
    TextEditingController titleInputController =
        TextEditingController(text: snapshot.documents[index].data["title"]);
    TextEditingController descriptionInputController = TextEditingController(
        text: snapshot.documents[index].data["description"]);

    return Column(children: [
      Container(
        height: 90,
        child: Card(
          elevation: 9,
          child: ListTile(
            title: Text(snapshot.documents[index].data["title"]),
            subtitle: Text(snapshot.documents[index].data["description"]),
            leading: CircleAvatar(
              radius: 30,
              child:
                  Text(snapshot.documents[index].data["title"].toString()[0]),
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(" By ${snapshot.documents[index]["name"]}  "),
          Text((dateFormatted == null) ? "N/A" : dateFormatted),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              icon: Icon(FontAwesomeIcons.edit),
              onPressed: () async {
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
                                        descriptionInputController
                                            .text.isNotEmpty) {
                                      Firestore.instance
                                          .collection("board")
                                          .document(snapshot
                                              .documents[index].documentID)
                                          .updateData({
                                        "name": nameInputController.text,
                                        "title": titleInputController.text,
                                        "description":
                                            descriptionInputController.text,
                                        "timeTamp": new DateTime.now(),
                                      }).then((value) =>
                                              Navigator.pop(context));
                                      //     Firestore.instance
                                      //         .collection("board")
                                      //         .add({
                                      //       "name": nameInputController.text,
                                      //       "title": titleInputController.text,
                                      //       "description":
                                      //           descriptionInputController.text,
                                      //       "timeTamp": new DateTime.now(),
                                      //     }).then((response) {
                                      //       print(response.documentID);
                                      //       Navigator.pop(context);
                                      //       nameInputController.clear();
                                      //       titleInputController.clear();
                                      //       descriptionInputController.clear();
                                      //     }).catchError(
                                      //             (onError) => print("error"));
                                    }
                                  },
                                  child: Text("update"))
                            ],
                          ),
                        ));
              }),
          IconButton(
              icon: Icon(FontAwesomeIcons.trash),
              onPressed: () async {
                await Firestore.instance
                    .collection("board")
                    .document(snapshot.documents[index].documentID)
                    .delete();
              })
        ],
      )
    ]);
  }
}
