import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:z_note/core/utils/time_util.dart';
import 'package:z_note/features/note/providers/note_provider.dart';
import 'package:z_note/features/settings/services/update_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final noteList = noteProvider.notes;
    //NoteModel? item;

    CheckUpdate.autoCheckUpdate();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false, // appbar标题居左
        automaticallyImplyLeading: false, // appbar去除home默认返回按键
        title: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Z Note', style: TextStyle(fontSize: 27)),
            Text('好用的笔记APP(^ω^)!', style: TextStyle(fontSize: 9.5)),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 380));
                context.read<NoteProvider>().loadNotes();
                //print('Refresh');
              },
              child: noteList.isEmpty
                  ? CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            //height: double.infinity,
                            //width: double.infinity,
                            //alignment: Alignment.center,
                            child: Center(child: Text('呜呜，这里空空荡荡的(T_T)!')),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 83),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          TimeUtil.formatShowTime(item.updateTime),
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
            ),
            Positioned(
              bottom: 23,
              right: 10,
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
