import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atv_final/models/notes.dart';
import 'package:flutter_atv_final/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController fieldAddNoteController = TextEditingController();

  Future<List<Notes>>? _futureNotes;
  //List<Notes> notes = [];
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_futureNotes == null) {
          _futureNotes = _apiService.getAllNotes();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 16),
        children: [
          LogoutMenu(),
          body(context),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      alignment: Alignment.center,
      child: Container(
        width: 800,
        child: Center(
            child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Atividade Final NodeJS',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            add_new_note(context),
            SizedBox(height: 25),
            Expanded(child: list_notes(context))
          ],
        )),
      ),
    );
  }

  Widget list_notes(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<List<Notes>>(
      future: _futureNotes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator.adaptive();
        }

        if (snapshot.hasData) {
          final list = snapshot.data!;
          list.sort((a, b) => a.id.compareTo(b.id));
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  note_item(context, list[index], index),
                  SizedBox(
                    height: 4,
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          if (snapshot.error.toString().contains('401')) {
            Navigator.pop(context);
          } else if (snapshot.error.toString().contains('400')) {
            showSnackbarFailed(context);
            reloadNotes();
          }
          return Text('Recarregando a listagem...');
        }

        return Container();
      },
    ));
  }

  void changeCompletedStatus({required int noteId, required bool completed}) {
    setState(() {
      _futureNotes = _apiService.changeNoteStatus(
        noteId: noteId,
        completed: completed,
      );
    });
  }

  Widget note_item(BuildContext context, Notes note, int index) {
    return Card(
      child: ListTile(
        title: Text(note.note),
        leading: Checkbox(
            activeColor: Color.fromARGB(255, 68, 209, 155),
            value: note.completed,
            onChanged: ((value) => {
                  changeCompletedStatus(
                    noteId: note.id,
                    completed: !note.completed,
                  )
                })),
        trailing: IconButton(
          onPressed: () => {deleteNote(noteId: note.id)},
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void deleteNote({required noteId}) {
    setState(() {
      _futureNotes = _apiService.deleteNote(noteId: noteId);
    });
  }

  Widget add_new_note(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              maxLength: 200,
              controller: fieldAddNoteController,
              decoration: InputDecoration(
                hintText: 'Adicione algo interessante...',
                filled: true,
                fillColor: Colors.blueGrey[50],
                labelStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.only(left: 30),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey[50]!),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey[50]!),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent,
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ElevatedButton(
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    "Adicionar\nnota",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onPressed: () => {
                addNewNote(noteText: fieldAddNoteController.text),
                fieldAddNoteController.clear()
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 68, 209, 155),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addNewNote({required String noteText}) {
    setState(() {
      _futureNotes = null;
      _futureNotes = _apiService.addNewNote(noteText: noteText);
    });
  }

  void reloadNotes() {
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _futureNotes = _apiService.getAllNotes();
        });
      });
    });
  }

  void showSnackbarFailed(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nao foi possível realizar a ação. Verifique os dados e tente novamente.',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
    });
  }
}

class LogoutMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              _menuItem(
                title: 'Sair',
                isActive: true,
                onTap: () => {Navigator.pop(context)},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    String title = 'Title Menu',
    isActive = false,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.red : Colors.grey,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              isActive
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
