import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/model/note.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class NoteController extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final serachController = TextEditingController();
  final notebox = Hive.box('NoteBox');
  final List<NoteDatamodel> items = <NoteDatamodel>[].obs;
  final List<NoteDatamodel> Orginalitems = <NoteDatamodel>[].obs;
  final List<NoteDatamodel> Selecteditems = <NoteDatamodel>[].obs;
  var uuid = Uuid();
  final searchclk = false.obs;
  final iseditadd = false.obs;
  final iseditedit = false.obs;
  final isNew = true.obs;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  Future<void> refresh() async {
    final data = notebox.keys.map((key) {
      final value = notebox.get(key);
      final value1 = json.decode(value);
      Map<String, dynamic> decode = {
        "id": value1["id"],
        "tlt": value1["tlt"],
        "desc": value1["desc"],
        "cdnt": value1["cdnt"],
        "udnt": value1["udnt"]
      };
      NoteDatamodel note = NoteDatamodel.fromJson(decode);
      return note;
    }).toList();
    items.assignAll(data);
    items.sort(((a, b) => b.udnt.compareTo(a.udnt)));
    Orginalitems.assignAll(items);
  }

  Future<void> addNote(Map<String, dynamic> newItem) async {
    if (newItem["tlt"].toString().length == 0 &&
        newItem["desc"].toString().length == 0) {
      Get.back();
      return null;
    }
    String id = uuid.v4();
    int time = DateTime.now().millisecondsSinceEpoch;
    NoteDatamodel newite =
        NoteDatamodel(id, newItem["tlt"], newItem["desc"], time, time);
    Map<String, dynamic> usermap = newite.toJson();
    final encodejson = jsonEncode(usermap);
    await notebox.put(id, encodejson);
    Get.showSnackbar(GetSnackBar(
      message: "Note Saved",
      icon: const Icon(Icons.check),
      duration: const Duration(seconds: 1),
    ));
    iseditadd(!iseditadd.value);
    refresh();
  }

  Future<void> UpdateNote(Map<String, dynamic> updatedItem) async {
    String id = updatedItem['id'];
    int time = DateTime.now().millisecondsSinceEpoch;
    NoteDatamodel newite = NoteDatamodel(
        id, updatedItem['tlt'], updatedItem['desc'], updatedItem['cdnt'], time);
    Map<String, dynamic> usermap = newite.toJson();
    final encodejson = jsonEncode(usermap);
    await notebox.put(id, encodejson);
    Get.showSnackbar(GetSnackBar(
      message: "Note Updated",
      icon: const Icon(Icons.check),
      duration: const Duration(seconds: 1),
    ));
    iseditedit(!iseditedit.value);
    refresh();
  }

  void noteDelete(String id) async {
    await notebox.delete(id);
    refresh();
  }

  void handleSearch() {
    searchclk(!searchclk.value);
    if (!searchclk.value) {
      items.assignAll(Orginalitems);
      serachController.text = "";
    }
  }

  void checksave() {
    var len = contentController.text.length;
    var len2 = titleController.text.length;
    if (len != 0 || len2 != 0) {
      iseditadd.value = true;
    } else {
      iseditadd.value = false;
    }
  }

  void checkeditsave(int index) {
    var title = titleController.text;
    var content = contentController.text;
    if (title.isEmpty && content.isEmpty) {
      iseditedit(false);
      return null;
    }
    if (items[index].desc != content) {
      iseditedit(true);
    } else if (items[index].tlt != title) {
      iseditedit(true);
    } else {
      iseditedit(false);
    }
  }
}
