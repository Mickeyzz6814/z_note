import 'package:flutter/material.dart';
import 'package:z_note/db/note_db.dart';
import 'package:z_note/main.dart';
import 'package:z_note/models/note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  List<NoteModel> noteList = [];

  String formatTime(DateTime time) {
    String year = time.year.toString();
    String month = time.month.toString().padLeft(2, '0');
    String day = time.day.toString().padLeft(2, '0');
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  void loadNotes() {
    noteList = NoteDb.getAllNoteList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotes();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    loadNotes();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
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
        centerTitle: false, // appbar标题居左
        automaticallyImplyLeading: false, // appbar去除home默认返回按键
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Z Note', style: TextStyle(fontSize: 27)),
            Text('好用的笔记app', style: TextStyle(fontSize: 9.5)),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            noteList.isEmpty
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('这里一片荒芜'),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 65),
                    itemCount: noteList.length,
                    itemBuilder: (context, index) {
                      final item = noteList[index];
                      return Container(
                        height: 180,
                        width: double.infinity,
                        //color: Colors.blue,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/show',
                                arguments: {'noteId': item.id},
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.title.trim()}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${item.content.trim()}',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  //SizedBox(height: 4),
                                  Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatTime(item.updateTime),
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            Positioned(
              bottom: 10,
              right: 0,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/edit');
                },
              ),
            ),
          ],
        ),
      ), // container暂时填充
    );
  }
}
