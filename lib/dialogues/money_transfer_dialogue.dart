import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:provider/provider.dart';

class MoneyTransferDialogue extends StatefulWidget {
  const MoneyTransferDialogue({
    super.key,
    required this.fromPlayer,
    required this.toPlayer,
  });

  final String fromPlayer, toPlayer;

  @override
  State<MoneyTransferDialogue> createState() => _MoneyTransferDialogueState();
}

class _MoneyTransferDialogueState extends State<MoneyTransferDialogue> {
  final TextEditingController amountController = TextEditingController();

  String? amountError;

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(builder: (context, game, child) {
      game.getGameFromHive();

      return AlertDialog(
        title: const Text(
          "Transfer Money 💵",
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      widget.fromPlayer == "__BANK__"
                          ? "BANK"
                          : widget.fromPlayer,
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_right_alt),
                  const SizedBox(width: 10),
                  Text(widget.toPlayer == "__BANK__" ? "BANK" : widget.toPlayer,
                      style: const TextStyle(fontSize: 17)),
                ],
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  label: const Text("Amount"),
                  errorText: amountError,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    if (int.tryParse(amountController.text) == null) {
                      setState(() {
                        amountError = "Amount can only be a number";
                      });
                    } else {
                      setState(() {
                        amountError = null;
                      });

                      // Add transaction
                      game.addTransaction(
                        widget.fromPlayer,
                        widget.toPlayer,
                        int.parse(amountController.text),
                      );

                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Transfer"),
              )
            ],
          ),
        ),
      );
    });
  }
}
