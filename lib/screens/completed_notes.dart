import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reminder_app/screens/table_calendar.dart';
import 'all_notes.dart' as all_notes;
import 'package:reminder_app/controllers/notifications.dart';
import '../models/note_data_store.dart';
import 'package:reminder_app/screens/edit_notes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'checkbox.dart';
import 'package:reminder_app/main.dart';
import 'home.dart';

List<Notes> completed = <Notes>[];
String id = "No notes exist";
ValueNotifier<bool> res = ValueNotifier(false);

class CompletedNotes extends StatefulWidget {
  const CompletedNotes({Key? key}) : super(key: key);

  @override
  State<CompletedNotes> createState() => _CompletedNotesState();
}

class _CompletedNotesState extends State<CompletedNotes> {
  void initState() {
    super.initState();
    completed.clear();
    all_notes.items.forEach((key, value) {
      if (value.done == true) {
        completed.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ValueListenableBuilder(
          valueListenable: res,
          builder: (context, value, child) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: completed.length,
              // items.keys.length,
              itemBuilder: (context, index) {
                // final key = items.keys.elementAt(index);
                // final item = items[key]!;

                final item = completed[index];

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            await _showDialog(item);

                            // if (res == true) {
                            //   setState(() {
                            //     int b = searchResults
                            //         .indexWhere((val) => val.id == item.id);
                            //     if (b != -1) {
                            //       searchResults.removeAt(b);
                            //     }
                            //     int c = uncompleted
                            //         .indexWhere((val) => val.id == item.id);
                            //     if (c != -1) {
                            //       uncompleted.removeAt(c);
                            //     }
                            //     all_notes.items.remove(item.id);
                            //     int d = items1
                            //         .indexWhere((element) => element.id == item.id);
                            //     if (d != -1) {
                            //       items1.removeAt(d);
                            //     }

                            //     notes.removeWhere((element) => element == item.id);

                            //     int e = completed
                            //         .indexWhere((element) => element.id == item.id);
                            //     if (e != -1) {
                            //       completed.removeAt(e);
                            //     }

                            //     item.delete();

                            //     if (all_notes.notifs[item.id] == null) {
                            //       String not = all_notes.notifs[item.id]!.id2;
                            //       NotificationService().deleteNotif(not);
                            //     }
                            //     all_notes.items.remove(item.id);
                            //     res = false;
                            //     done.clear();
                            //     items1.clear();
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => Home(
                            //                   key: UniqueKey(),
                            //))

                            //   });
                            // }
                          },
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: FontAwesomeIcons.trash,
                        ),
                      ],
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Text(
                        '${item.date} ${item.time}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      tileColor: Color(int.parse(item.color)).withOpacity(1),
                      onTap: () {
                        id = item.id;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditNote(id: id)));
                      },
                      trailing:
                          Wrap(children: <Widget>[CheckBoxNote(id: item.id)]),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Future<bool?> _showDialog(Notes item) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Are you sure you want to delete?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a permanent and data cannot be recovered again!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    int b =
                        searchResults.indexWhere((val) => val.id == item.id);
                    if (b != -1) {
                      searchResults.removeAt(b);
                    }
                    int c = uncompleted.indexWhere((val) => val.id == item.id);
                    if (c != -1) {
                      uncompleted.removeAt(c);
                    }
                    all_notes.items.remove(item.id);
                    int d =
                        items1.indexWhere((element) => element.id == item.id);
                    if (d != -1) {
                      items1.removeAt(d);
                    }

                    notes.removeWhere((element) => element == item.id);
                    //notes.remove(item.id);
                    int e = completed
                        .indexWhere((element) => element.id == item.id);
                    if (e != -1) {
                      completed.removeAt(e);
                    }

                    item.delete();

                    if (all_notes.notifs[item.id] == null) {
                      String not = all_notes.notifs[item.id]!.id2;
                      NotificationService().deleteNotif(not);
                    }
                    all_notes.items.remove(item.id);

                    done.remove(DateTime.parse(item.date));

                    Navigator.of(context).pop();
                  });
                },
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)))
          ],
        );
      },
    );
  }
}
