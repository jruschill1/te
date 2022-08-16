import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/screens/repeat_note.dart';
import 'all_notes.dart' as allNotes;
import 'completed_notes.dart' as comp;
import 'package:reminder_app/models/repeat_store.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/screens/table_calendar.dart' as table;

Color col1 = const Color.fromARGB(255, 171, 222, 230);
Color col2 = const Color.fromARGB(255, 203, 170, 203);
Color col3 = const Color.fromARGB(255, 245, 214, 196);
Color col4 = const Color.fromARGB(255, 222, 237, 213);
Color col5 = const Color.fromARGB(255, 238, 206, 206);
Color col6 = const Color.fromARGB(255, 197, 210, 114);
Color col7 = const Color.fromARGB(255, 245, 154, 142);
Color col8 = const Color.fromARGB(255, 116, 154, 214);

enum ColorList { col1, col2, col3, col4, white, col5, col6, col7, col8 }

//enum Priorities { low, medium, high}
class EditNote extends StatefulWidget {
  const EditNote({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _db = Localstore.instance;
  final _items = <String, store.Notes>{};
  final _notifs = <String, Notifs>{};
  late DateTime scheduler = DateTime.now();
  late DateTime scheduler2 = DateTime.now();
  StreamSubscription<Map<String, dynamic>>? _subscription;
  // var item;
  DateFormat format = DateFormat("yyyy-MM-dd");
  final dCont = TextEditingController();
  final cCont = TextEditingController();
  Color colPick = const Color.fromARGB(255, 255, 254, 254);
  final formatter = DateFormat().add_jm();
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  String priority = "high";
  String be = "beak";
  @override
  void initState() {
    super.initState();
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
        });
      });
    });
    _db
        .collection("notifs")
        .doc(widget.id)
        .get()
        .then((value) => _db.collection('notifs').stream.listen((event) {
              // setState(() {
              final item = Notifs.fromMap(event);
              _notifs.putIfAbsent(item.id, () => item);
              //});
            }));
  }

  Widget eventTitle() {
    return TextFormField(
      maxLines: 2,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(decoration: TextDecoration.none),
      initialValue: title,
      decoration: const InputDecoration(
        hintText: 'Add Title',
        border: InputBorder.none,
      ),
      onChanged: (value) => title = value,
      autofocus: true,
    );
  }

  Widget eventBody() {
    return TextFormField(
      maxLines: 3,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(decoration: TextDecoration.none),
      initialValue: body,
      decoration: const InputDecoration(
        hintText: 'Add Reminder',
        border: InputBorder.none,
      ),
      onChanged: (value) => body = value,
      autofocus: false,
    );
  }

  Widget eventDate() {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.calendar),
      title: Text(dCont.text),
      onTap: () async {
        final DateTime? dateT = await showDatePicker(
            context: context,
            initialDate: DateTime.parse(selectDate),
            firstDate: DateTime(2022),
            lastDate: DateTime(2025));
        String compForm = format.format(dateT!);
        selectDate = compForm;
        setState(() {
          scheduler = dateT;
        });

        dCont.text = compForm;
      },
    );
  }

  Widget eventTime() {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.clock),
      title: Text(cCont.text),
      onTap: () async {
        TimeOfDay? timeT = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        if (!mounted) return;
        String timeString = timeT!.format(context);
        daySelect = timeString;
        cCont.text = timeString;
        scheduler2 = DateTime(scheduler.year, scheduler.month, scheduler.day,
            timeT.hour, timeT.minute);
      },
    );
  }

  Widget eventColor() {
    return PopupMenuButton<ColorList>(
      icon: Material(
        // type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.5),
            color: selectColor,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            radius: 100.0,
          ),
        ),
      ),
      onSelected: (value) {
        if (value == ColorList.col1) {
          setState(() {
            selectColor = const Color.fromARGB(255, 171, 222, 230);
          });

          colPick = const Color.fromARGB(255, 171, 222, 230);
        } else if (value == ColorList.col2) {
          setState(() {
            selectColor = const Color.fromARGB(255, 203, 170, 203);
          });
          colPick = const Color.fromARGB(255, 203, 170, 203);
        } else if (value == ColorList.col3) {
          colPick = const Color.fromARGB(255, 245, 214, 196);
          setState(() {
            selectColor = const Color.fromARGB(255, 245, 214, 196);
          });
        } else if (value == ColorList.col4) {
          colPick = const Color.fromARGB(255, 222, 237, 213);
          setState(() {
            selectColor = const Color.fromARGB(255, 222, 237, 213);
          });
        } else if (value == ColorList.white) {
          colPick = Colors.white;
          setState(() {
            selectColor = const Color.fromARGB(255, 180, 175, 175);
          });
        } else if (value == ColorList.col5) {
          colPick = const Color.fromARGB(255, 238, 206, 206);
          setState(() {
            selectColor = const Color.fromARGB(255, 238, 206, 206);
          });
        } else if (value == ColorList.col6) {
          colPick = const Color.fromARGB(255, 197, 210, 114);

          setState(() {
            selectColor = const Color.fromARGB(255, 197, 210, 114);
          });
        } else if (value == ColorList.col7) {
          colPick = const Color.fromARGB(255, 245, 154, 142);
          setState(() {
            selectColor = const Color.fromARGB(255, 245, 154, 142);
          });
        } else if (value == ColorList.col8) {
          colPick = const Color.fromARGB(255, 116, 154, 214);
          setState(() {
            selectColor = const Color.fromARGB(255, 116, 154, 214);
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ColorList>>[
        PopupMenuItem(
            child: Row(children: [
          PopupMenuItem<ColorList>(
            value: ColorList.col1,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 171, 222, 230),
                shape: BoxShape.circle,
              ),
            ),
          ),
          PopupMenuItem<ColorList>(
            value: ColorList.col2,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 203, 170, 203),
                shape: BoxShape.circle,
              ),
            ),
          ),
          PopupMenuItem<ColorList>(
            value: ColorList.col3,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 245, 214, 196),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ])),
        PopupMenuItem(
            child: Row(
          children: [
            PopupMenuItem<ColorList>(
              value: ColorList.col4,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 222, 237, 213),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.white,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46)),
                      right: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46)),
                      bottom: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46)),
                      left: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46))),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.col5,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 206, 206),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        )),
        PopupMenuItem(
            child: Row(
          children: [
            PopupMenuItem<ColorList>(
              value: ColorList.col6,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 197, 210, 114),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.col7,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 154, 142),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.col8,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 116, 154, 214),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }

  Widget eventRepeat() {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.repeat),
      title: const Text('Repeat'),
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            context: context,
            builder: (context) {
              return const RepeatNote();
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var item = _items[widget.id]!;
    if (selectDate == "") {
      selectDate = item.date;
    }
    if (title == "") {
      title = item.title;
    }
    if (body == "") {
      body = item.data;
    }
    if (daySelect == "") {
      daySelect = item.time;
    }

    //DateTime? dateT = DateTime.now();
    dCont.text = selectDate;

    cCont.text = daySelect;
    //TimeOfDay timer = TimeOfDay.fromDateTime(formatter.parse(daySelect));
    if (colPick == const Color.fromARGB(255, 255, 254, 254)) {
      colPick = Color(int.parse(item.color));
    }
    if (selectColor == const Color.fromARGB(255, 180, 175, 174)) {
      selectColor = Color(int.parse(item.color));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(item.title),
        actions: [
          TextButton(
              onPressed: () {
                if (_notifs[widget.id] != null) {
                  var ter = _notifs[widget.id];
                  if (ter != null) {
                    String tre = ter.id2;
                    NotificationService().deleteNotif(tre);
                  }
                }
                if (count.notifChoice == true) {
                  if (scheduler2.isAfter(DateTime.now())) {
                    NotificationService().displayScheduleNotif(
                        body: body,
                        channel: count.channelCounter,
                        title: title,
                        date: scheduler2);
                  } else {
                    NotificationService().displayNotification(
                        body: body,
                        channel: count.channelCounter,
                        title: title);
                  }
                }

                var obj = table.items3[item.id];
                if (obj != null) {
                  obj.delete();
                }
                bool bloop = item.done;
                setState(() {
                  int b = searchResults.indexWhere((val) => val.id == item.id);
                  if (b != -1) {
                    searchResults.removeAt(b);
                  }
                  int c = uncompleted.indexWhere((val) => val.id == item.id);
                  if (c != -1) {
                    uncompleted.removeAt(c);
                  }
                  allNotes.items.remove(item.id);
                  int d = table.items1
                      .indexWhere((element) => element.id == item.id);
                  if (d != -1) {
                    table.items1.removeAt(d);
                  }

                  notes.removeWhere((element) => element == item.id);
                  _items.remove(item.id);
                });
                item.delete();
                final id = Localstore.instance.collection("notes").doc().id;
                // print(item.id);
                final item1 = store.Notes(
                    id: id,
                    title: title,
                    data: body,
                    date: selectDate,
                    time: daySelect,
                    priority: priority,
                    color: colPick.value.toString(),
                    done: bloop);
                item1.save();

                Notifs notif1 = Notifs(
                  id: id,
                  id2: count.channelCounter.toString(),
                );
                if (obj != null) {
                  if (obj.option == "Daily") {
                    Repeat reeeeee = Repeat(id: id, option: "Daily");
                    reeeeee.save();
                  }
                }
                notif1.save();
                setState(() {
                  searchResults.add(item1);
                  uncompleted.add(item1);
                  allNotes.items.putIfAbsent(id, () => item1);
                  table.items1.add(item1);
                  _items.putIfAbsent(item1.id, () => item1);
                });

                // Navigator.pop(context);
                bool b = true;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home2(boo: b)));
              },
              child: const Text(
                'Save',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ))
        ],
      ),
      body: LayoutBuilder(
          builder: (context, constraints) => Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: constraints.maxHeight * 1,
                          child: ListView(
                            children: <Widget>[
                              ListTile(title: eventTitle()),
                              ListTile(title: eventBody()),
                              eventDate(),
                              eventTime(),
                              eventColor(),
                              eventRepeat(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    // Clean up the controller when the widget is removed
    dCont.dispose();
    super.dispose();
  }
}
