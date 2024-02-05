import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:provider/provider.dart';

class AddPlayerDialogue extends StatefulWidget {
  const AddPlayerDialogue({super.key});

  @override
  State<AddPlayerDialogue> createState() => _AddPlayerDialogueState();
}

class _AddPlayerDialogueState extends State<AddPlayerDialogue> {
  final TextEditingController nameController = TextEditingController();
  String? nameError;

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(builder: (context, game, child) {
      game.getGameFromHive();

      return AlertDialog(
        title: const Text(
          "Add Player",
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    errorText: nameError, label: const Text("Player Name")),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    if (!RegExp(r'^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*$')
                        .hasMatch(nameController.text)) {
                      setState(() {
                        nameError = "Name can only be alpha numeric";
                      });
                    } else {
                      setState(() {
                        nameError = null;
                      });

                      game.addPlayer(nameController.text);
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text("Add Player"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
