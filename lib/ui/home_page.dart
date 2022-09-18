import 'package:get/get.dart';
import 'package:notes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(NoteController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 245, 245, 245),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    Future<bool> onBackpressed() async {
      if (controller.searchclk.value) {
        controller.searchclk.value = false;
        return false;
      }
      return true;
    }

    return WillPopScope(
        onWillPop: onBackpressed,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 237, 223, 71),
              onPressed: () {
                controller.contentController.text = "";
                controller.titleController.text = "";
                Get.toNamed('/note', arguments: {'isNew': true, 'id': 0});
              },
              child: Icon(Icons.add),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          body: SafeArea(
            // child: SingleChildScrollView(
            child: Column(
              children: [
                (Obx(() =>
                    controller.searchclk.value ? _searchbar() : _appBar())),
                const SizedBox(
                  height: 16,
                ),
                _body()
              ],
            ),
            // )
          ),
        ));
  }

  void handleSearch(text) {
    var filterData = controller.Orginalitems.where((element) =>
        element.desc.toLowerCase().contains(text.toString().toLowerCase()) ||
        element.tlt.toLowerCase().contains(text.toString().toLowerCase()));
    controller.items.assignAll(filterData);
  }

  _searchbar() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(children: [
        Flexible(
          child: TextField(
            autofocus: true,
            controller: controller.serachController,
            onChanged: (text) {
              handleSearch(text);
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search notes',
                // filled: true,
                // fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.0)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: InkWell(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onTap: controller.handleSearch))
      ]),
    );
  }

  _body() {
    String convertdateandtime(int time, int i) {
      DateTime nowtime = DateTime.now();
      DateTime ds = DateTime.fromMillisecondsSinceEpoch(time);
      Duration diff = nowtime.difference(ds);
      int day = diff.inDays;
      if (day < 1) {
        String ti = DateFormat("h:mm a").format(ds);
        return ti;
      } else if (day < 2) {
        String ti = DateFormat("h:mm a").format(ds);
        return "Yesterday " + ti;
      } else if (day < 7) {
        String ti = DateFormat("h:mm a").format(ds);
        String dayname = DateFormat.E().format(ds);
        return dayname + " " + ti;
      } else if (day < 365) {
        String ti = DateFormat("h:mm a").format(ds);
        String dayname = DateFormat("MMMMd").format(ds);
        return dayname + " " + ti;
      } else {
        String date = DateFormat('yMMMMd').format(ds);
        return date;
      }
    }

    return Expanded(
        child: Obx(() => controller.items.isNotEmpty
            ? MasonryGridView.count(
                padding: const EdgeInsets.fromLTRB(30.0, 14.0, 30.0, 14.0),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  // final crtitm = _items[index];
                  return InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Get.toNamed('/note',
                            arguments: {'isNew': false, 'id': index});
                      },
                      onLongPress: () {
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              ),
                              height: 200,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Delete Note",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "Do you want to delete ? ",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              )),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color.fromARGB(
                                                          255, 208, 208, 208)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 50)),
                                            )),
                                      ),
                                      Container(
                                        child: TextButton(
                                            child: Text("Delete"),
                                            onPressed: () {
                                              var id =
                                                  controller.items[index].id;
                                              controller.noteDelete(id);
                                              Navigator.pop(context);
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              )),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 50)),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                          width: Get.width,
                          // height: 150.0,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    controller.items[index].tlt,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    controller.items[index].desc,
                                    // _items[index]['desc'],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 4,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      convertdateandtime(
                                          controller.items[index].udnt, index),
                                      // _items[index].cdnt.toString(),
                                      // _items[index]['timestamp'],
                                      style: TextStyle(color: Colors.black38),
                                    ))
                              ],
                            ),
                          )));
                })
            : const Center(
                child: Text("No Notes"),
              )));
  }

  _appBar() {
    icon(IconData icon, Color color) {
      return InkWell(
        onTap: () {
          controller.handleSearch();
          // controller.refresh();
        },
        child: Container(
            child: Center(
          child: Icon(
            icon,
            color: color,
            size: 30.0,
          ),
        )),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notes',
            style: TextStyle(fontSize: 25),
          ),
          icon(Icons.search, Colors.grey)
        ],
      ),
    );
  }
}
