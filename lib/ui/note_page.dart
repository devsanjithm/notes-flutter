import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:notes/controllers/note_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Notepage extends StatefulWidget {
  @override
  Notepagestate createState() => Notepagestate();
}

class Notepagestate extends State<Notepage> {
  final NoteController controller = Get.find();
  final contentfocus = FocusNode();
  final titlefocus = FocusNode();
  bool isNew = Get.arguments['isNew'];
  final int i = Get.arguments['id'];
  String dateandtime = "";
  String newtime = "";

  @override
  void initState() {
    if (!isNew) {
      controller.titleController.text = controller.items[i].tlt;
      controller.contentController.text = controller.items[i].desc;
      convertdateandtime(controller.items[i].udnt);
    } else {
      convertnewtime();
    }

    super.initState();
  }

  void convertdateandtime(int time) {
    DateTime ds = DateTime.fromMillisecondsSinceEpoch(time);
    String ti = DateFormat("h:mm a").format(ds);
    String date = DateFormat('MMM').format(ds) + " " + ds.day.toString();
    String dt = date +
        "  " +
        ti +
        " | " +
        (controller.titleController.text.trim().length +
                controller.contentController.text.trim().length)
            .toString() +
        " characters";
    setState(() {
      dateandtime = dt;
    });
  }

  void convertnewtime() {
    int nowtime = DateTime.now().millisecondsSinceEpoch;
    DateTime ds = DateTime.fromMillisecondsSinceEpoch(nowtime);
    String ti = DateFormat("h:mm a").format(ds);
    String date = DateFormat('MMM').format(ds) + " " + ds.day.toString();
    String dt = date +
        "  " +
        ti +
        " | " +
        (controller.titleController.text.trim().length +
                controller.contentController.text.trim().length)
            .toString() +
        " characters";
    setState(() {
      newtime = dt;
      dateandtime = dt;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 245, 245, 245),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    Future<bool> onBackpressed() async {
      if (isNew) {
        await controller.addNote({
          "tlt": controller.titleController.text,
          "desc": controller.contentController.text
        });
        setState(() {
          isNew = false;
        });
        return false;
      } else if (controller.iseditedit.value) {
        await controller.UpdateNote({
          "id": controller.items[i].id,
          "tlt": controller.titleController.text.trim(),
          "desc": controller.contentController.text.trim(),
          "cdnt": controller.items[i].cdnt
        });
        return false;
      }

      return true;
    }

    return WillPopScope(
        onWillPop: onBackpressed,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          body: SafeArea(
            child: Column(
              children: [_appBar(context), _body(context)],
            ),
          ),
          bottomSheet: Container(
            color: Color.fromARGB(255, 245, 245, 245),
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isNew
                      ? Container(
                          child: Text(
                            newtime,
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      : Container(
                          child: Text(
                            dateandtime,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  _appBar(context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            splashColor: Colors.yellowAccent,
            onTap: () async {
              if (isNew) {
                await controller.addNote({
                  "tlt": controller.titleController.text,
                  "desc": controller.contentController.text
                });
                setState(() {
                  isNew = false;
                });
                Navigator.pop(context);
                Get.back();
                Get.showSnackbar(GetSnackBar(
                  message: "Note Saved",
                  icon: const Icon(Icons.check),
                  duration: const Duration(seconds: 1),
                ));
              } else if (controller.iseditedit.value) {
                await controller.UpdateNote({
                  "id": controller.items[i].id,
                  "tlt": controller.titleController.text.trim(),
                  "desc": controller.contentController.text.trim(),
                  "cdnt": controller.items[i].cdnt
                });
                Navigator.pop(context);
                Get.back();
                Get.showSnackbar(GetSnackBar(
                  message: "Note Updated",
                  icon: const Icon(Icons.check),
                  duration: const Duration(seconds: 1),
                ));
              }
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          isNew
              ? Obx(() => controller.iseditadd.value
                  ? InkWell(
                      onTap: () async {
                        await controller.addNote({
                          "tlt": controller.titleController.text.trim(),
                          "desc": controller.contentController.text.trim()
                        });
                        setState(() {
                          isNew = false;
                        });
                      },
                      child: Icon(
                        Icons.check,
                        size: 30,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        // print(isNew);
                        // Get.snackbar("title", isNew.toString());
                      },
                      child: Icon(
                        Icons.more_vert,
                        size: 30,
                      )))
              : Obx(() => controller.iseditedit.value
                  ? InkWell(
                      onTap: () {
                        controller.UpdateNote({
                          "id": controller.items[i].id,
                          "tlt": controller.titleController.text.trim(),
                          "desc": controller.contentController.text.trim(),
                          "cdnt": controller.items[i].cdnt
                        });
                      },
                      child: Icon(
                        Icons.check,
                        size: 30,
                      ))
                  : _simplePopup())
        ],
      ),
    );
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        onSelected: (value) {
          if (value == 1) {
            var id = controller.items[i].id;
            controller.noteDelete(id);
            Navigator.pop(context);
          }
        },
        offset: Offset(0.0, AppBar().preferredSize.height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Delete"),
          ),
          // PopupMenuItem(
          //   value: 2,
          //   child: Text("Second"),
          // ),
        ],
      );

  _body(context) {
    return Expanded(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                focusNode: titlefocus,
                controller: controller.titleController,
                onChanged: (text) {
                  if (isNew) {
                    controller.checksave();
                    convertnewtime();
                  } else {
                    controller.checkeditsave(i);
                    convertdateandtime(controller.items[i].udnt);
                  }
                },
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
              TextField(
                focusNode: contentfocus,
                autofocus: isNew,
                onChanged: (text) {
                  if (isNew) {
                    controller.checksave();
                    convertnewtime();
                  } else {
                    controller.checkeditsave(i);
                    convertdateandtime(controller.items[i].udnt);
                  }
                },
                controller: controller.contentController,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 2,
                ),
                maxLines: null,
                minLines: 20,
                decoration: InputDecoration(
                    hintText: "Start typing",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
