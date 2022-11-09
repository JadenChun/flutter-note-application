import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'database.dart';

class NoteCard extends StatefulWidget{
  const NoteCard({
    Key? key,
    required this.word,
    required this.getData
  }) : super(key: key);

  final VoidCallback getData;
  final Word word;

  @override
  State<NoteCard> createState() => _NoteCard();
}

class _NoteCard extends State<NoteCard>{

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedBuilder: (context, openBuilder) {
          return Card(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 30,
                  child: Text(widget.word.word!),
                )
              ],
            ),
          );
        },
        openBuilder: (context, openBuilder) => NoteDetails(word: widget.word, getData: widget.getData,)
    );
  }
}

class NoteDetails extends StatefulWidget{
  const NoteDetails({Key? key, required this.word, required this.getData}) : super(key: key);

  final VoidCallback getData;
  final Word word;

  @override
  State<NoteDetails> createState() => _NoteDetails();
}

class _NoteDetails extends State<NoteDetails> with SingleTickerProviderStateMixin {

  bool _saveVisibility = false;
  String _input = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.word.word!;
  }

  void _saveChanges(String input) async {
    widget.word.word = _input;
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.update(widget.word);
    widget.getData();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
                _saveChanges(_input);
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
          controller: _controller,
          maxLines: null,
          expands: true,
          decoration: null,
          autofocus: true,
          cursorHeight: 28,
          onChanged: (String text){
            _input = text;
            if (text != '' && text != widget.word.word){
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
  }
}