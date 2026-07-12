import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:z_note/db/note_db.dart';
//import 'package:z_note/models/note_model.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({super.key});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String originTitle = '';
  String originContent = '';
  bool _isFirstLoad = true;
  String? noteId;

  bool get isModified {
    String ot = originTitle;
    String oc = originContent;
    String t = _titleController.text;
    String c = _contentController.text;
    return ot != t || oc != c;
  }

  bool get isAllEmpty {
    String t = _titleController.text;
    String c = _contentController.text;
    return t.isEmpty && c.isEmpty;
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFirstLoad) return;
    _isFirstLoad = false;

    final routeArg = ModalRoute.of(context)?.settings.arguments;

    if (routeArg is Map) {
      noteId = routeArg['noteId'];
    }

    if (noteId == null) {
      originContent = '';
      originTitle = '';
      if (_contentController.text == '' && _titleController.text == '') {
        _titleController.text = '';
        _contentController.text = '';
      }
    } else {
      final note = NoteDb.getNoteById(id: noteId!);
      if (note != null) {
        _titleController.text = note.title;
        _contentController.text = note.content;
        originTitle = note.title;
        originContent = note.content;
      }
    }
  }

  Future<bool> showExitDialog() async {
    final res = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('内容尚未保存'),
          content: Text('当前笔记内容发生变化，请问如何处理？'),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 8),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 0),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 1),
              child: Text('放弃并退出'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, 2),
              child: Text('保存并退出'),
            ),
          ],
        );
      },
    );
    switch (res) {
      case 0:
        return false;
      case 1:
        return true;
      case 2:
        //Navigator.pop(context);
        await saveHandle();
        return true;
      default:
        return false;
    }
  }

  Future<bool> showExitDialogTwo() async {
    final res = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('删除笔记'),
          content: Text('您清空了笔记内容，该笔记将会删除！'),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 8),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context, 0),
              child: Text('取消并退出'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 1),
              child: Text('删除并退出'),
            ),
          ],
        );
      },
    );
    switch (res) {
      case 0:
        return false;
      default:
        return true;
    }
  }

  Future<void> showExitDialogThree() async {
    final res = await showDialog<int>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('标题或正文为空'),
          content: Text('您的标题或正文为空，无法保存！'),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 8),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> saveHandle() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    if (title.isEmpty || content.isEmpty) {
      return null;
    }
    if (noteId == null) {
      final newId = await NoteDb.addNote(title: title, content: content);
      return newId;
    } else {
      await NoteDb.editNote(id: noteId!, title: title, content: content);
      return noteId;
    }
    /*
    if (mounted) {
      //_hasChange = false;
      Navigator.pop(context, 'refresh');
      //setState(() {});
    }
    */
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (isAllEmpty) {
          if (noteId == null) {
            if (mounted) Navigator.pop(context);
            return;
          } else {
            final res = await showExitDialogTwo();
            if (res) {
              await NoteDb.deleteNote(id: noteId!);
              if (mounted) Navigator.pop(context, 'delete'); //向上一页返回delete标识
            } else {
              Navigator.pop(context);
            }
            return;
          }
        }

        if (!isModified) {
          if (mounted) Navigator.pop(context);
          return;
        }

        if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
          await showExitDialogThree();
          return;
        }

        bool canExit = await showExitDialog();
        if (canExit) {
          if (mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                final targetId = await saveHandle();
                if (targetId == null) {
                  await showExitDialogThree();
                  return;
                }
                if (mounted && targetId != null) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check),
            ),
            SizedBox(width: 5),
          ],
          centerTitle: false,
          title: Text('编辑', style: TextStyle(fontSize: 20)),
        ),
        body: Container(
          //height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '标题',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 27),
                ),
                //SizedBox(height: 20),
                TextField(
                  controller: _contentController,
                  //expands: true,
                  maxLines: null,
                  maxLength: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '正文',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
