import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_note/features/note/providers/note_provider.dart';
import 'package:z_note/data/models/note_model.dart';

class NoteShowPage extends StatefulWidget {
  const NoteShowPage({super.key});

  @override
  State<NoteShowPage> createState() => _NoteShowPageState();
}

class _NoteShowPageState extends State<NoteShowPage> {
  String? noteId;
  NoteModel? note;

  void loadNote() {
    if (noteId == null) return;
    note = context.read<NoteProvider>().getNoteById(id: noteId!);
    //notifyListeners();
  }

  Future<bool> showDeleteDialog() async {
    final res = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('确定要删除吗(T_T)'),
          content: Text('你将要删除这篇笔记，操作是无法撤回的哦！'),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 8),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context, 0),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 1),
              child: Text('删除'),
            ),
          ],
        );
      },
    );
    switch (res) {
      case 1:
        return true;
      default:
        return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final routeArg = ModalRoute.of(context)?.settings.arguments;
    if (noteId != null) return;
    if (routeArg is Map) {
      noteId = routeArg['noteId'];
    }
    loadNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('笔记', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () async {
              if (noteId == null) return;
              bool canDelete = await showDeleteDialog();
              if (canDelete) {
                await context.read<NoteProvider>().deleteNote(id: noteId!);
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            icon: Icon(Icons.delete, color: Colors.red[400]),
          ),
          SizedBox(width: 15),
          IconButton(
            onPressed: () async {
              final res = await Navigator.pushNamed(
                context,
                '/edit',
                arguments: {'noteId': noteId},
              );
              if (mounted) {
                loadNote();
                setState(() {});
              }
              if (res == 'delete' && mounted) {
                Navigator.pop(context);
              }
            }, //接收到delete标识并返回主页
            icon: Icon(Icons.edit),
          ),
          SizedBox(width: 5),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: note == null
              ? Container(
                  //width: double.infinity,
                  //height: double.infinity,
                  alignment: Alignment.center,
                  child: Text('找不到笔记(>_<)'),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note!.title, style: TextStyle(fontSize: 27)),
                    SizedBox(height: 10),
                    Text(note!.content),
                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
