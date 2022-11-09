import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'notes_details.dart';
import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePage();
}

class _HomePage extends State {

  List allNote=[];

  void getData() async{
    DatabaseHelper helper = DatabaseHelper.instance;
    List updateNote = await helper.queryWord();
    setState(() {
      allNote = updateNote;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void addNewNote(Word w){
    setState(() {
      allNote.add(w);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Memo'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                DatabaseHelper helper = DatabaseHelper.instance;
                helper.deleteAll();
                setState(() {
                  allNote=[];
                });
              },
              child: const Text('Delete All'),
            ),
          ],
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return NoteList(noteList: allNote,key: UniqueKey(), getData: getData,);
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          child: NewNote(noteList: allNote,function: addNewNote),
        )
    );
  }
}

class NoteList extends StatefulWidget{
  const NoteList({Key? key,
    required this.noteList,
    required this.getData
  }) : super(key: key);

  final List noteList;
  final VoidCallback getData;

  @override
  State createState() => _NoteList();
}

class _NoteList extends State<NoteList>{

  late List noteList;

  @override
  void initState() {
    super.initState();
    noteList = widget.noteList;
  }

  @override
  Widget build(BuildContext context) {
    return noteList.isNotEmpty
        ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: noteList.length,
        itemBuilder:(BuildContext context, int index){
          return NoteCard(word: noteList[index],getData: widget.getData,);
        },
        )
        : const Center(child: Text('No Notes'),);
  }
}

class NewNote extends StatefulWidget{

  const NewNote({Key? key,
    required this.noteList,
    required this.function
  }) : super(key: key);

  final Function function;
  final List noteList;

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> with SingleTickerProviderStateMixin {

  late List noteList;
  bool _saveVisibility = false;
  String _input = '';

  @override
  void initState() {
    super.initState();
    noteList = widget.noteList;
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedBuilder: (context, openContainer){
          return const SizedBox(
              width: 55,
              height: 55,
              child: Icon(Icons.add)
          );
        },
        closedShape: const CircleBorder(),
        closedColor: Theme.of(context).primaryIconTheme.color as Color,
        openBuilder: (context, openBuilder){
          return StatefulBuilder(builder: (context, setState){
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).primaryIconTheme.color,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  Visibility(
                    visible: _saveVisibility,
                    maintainState: true,
                    child: TextButton(
                      onPressed: () {
                        _save(_input);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: null,
                  autofocus: true,
                  cursorHeight: 28,
                  onChanged: (String text){
                    _input = text;
                    if (text != ''){
                      setState(() {
                        _saveVisibility = true;
                      });
                    }else{
                      setState(() {
                        _saveVisibility = false;
                      });
                    }
                  },
                ),
              ),
            );
          });
        },
    );
  }

  _save(String text) async {
    Word word = Word();
    word.word = text;
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.insert(word);
    widget.function(word);
    Navigator.of(context).pop();
  }

}