import 'package:flutter/material.dart';
import 'package:z_note/db/note_db.dart';
import 'package:z_note/main.dart';
import 'package:z_note/models/note_model.dart';
import 'package:flutter/widgets.dart';

class NoteShowPage extends StatefulWidget {
  const NoteShowPage({super.key});

  @override
  State<NoteShowPage> createState() => _NoteShowPageState();
}

class _NoteShowPageState extends State<NoteShowPage> with RouteAware {
  String? noteId;
  NoteModel? note;

  void loadCurrentNote() {
    if (noteId == null) return;
    note = NoteDb.getNoteById(id: noteId!);
    setState(() {});
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
          title: Text('确定要删除吗？'),
          content: Text('您正在删除笔记，这将不可撤回！'),
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
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    final routeArg = ModalRoute.of(context)?.settings.arguments;
    if (noteId != null) return;
    if (routeArg is Map) {
      noteId = routeArg['noteId'];
    }
    loadCurrentNote();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    loadCurrentNote();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    routeObserver.unsubscribe(this);
    super.dispose();
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
                NoteDb.deleteNote(id: noteId!);
                setState(() {});
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
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Text('找不到笔记'),
                )
              : Column(
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
