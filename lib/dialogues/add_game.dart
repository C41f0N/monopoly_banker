import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:provider/provider.dart';

class AddGameDialogue extends StatelessWidget {
  AddGameDialogue({super.key});

  final gameNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (BuildContext context, Game game, Widget? child) {
        return AlertDialog(
          title: const Text(
            "Add New Game",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                TextField(
                  controller: gameNameController,
                  decoration: const InputDecoration(
                    hintText: "Game Name",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (gameNameController.text != "" &&
                        RegExp(r'^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*$')
                            .hasMatch(gameNameController.text)) {
                      game.addNewGame(gameNameController.text);
                      Navigator.of(context).pop();
                    } else {
                      print("Invalid Name");
                    }
                  },
                  child: const Text("Add Game"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
