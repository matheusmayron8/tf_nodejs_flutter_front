import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> notes = <String>['Nota 1', 'Nota 2', 'Nota 3', 'Nota 4'];
  final TextEditingController fieldAddNoteController = TextEditingController();

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
      height: 500,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        width: 800,
        child: Center(
            child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'Atividade Final NodeJS',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return note_item(context, notes[index], index);
        },
      ),
    );
  }

  Widget note_item(BuildContext context, String noteText, int index) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.all(8),
      height: 50,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(value: false, onChanged: ((value) => {})),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(noteText),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => {
                    setState(() => {notes.removeAt(index)})
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
                setState(() => {
                      notes.add(fieldAddNoteController.text),
                    }),
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
