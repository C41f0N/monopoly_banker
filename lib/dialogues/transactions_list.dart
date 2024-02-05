import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/game.dart';
import 'package:monopoly_banker/class_structure/transaction.dart';
import 'package:provider/provider.dart';

class TransactionsListDialogue extends StatefulWidget {
  const TransactionsListDialogue({super.key});

  @override
  State<TransactionsListDialogue> createState() =>
      _TransactionsListDialogueState();
}

class _TransactionsListDialogueState extends State<TransactionsListDialogue> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(builder: ((context, game, child) {
      game.getGameFromHive();
      return AlertDialog(
        title: const Text(
          "Transactions",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: game.transactions.length,
              itemBuilder: (context, index) {
                index = game.transactions.length - index - 1;
                return TransactionTile(transaction: game.transactions[index]);
              }),
        ),
      );
    }));
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${transaction.fromPlayer == "__BANK__" ? "BANK" : transaction.fromPlayer} to ${transaction.toPlayer == "__BANK__" ? "BANK" : transaction.toPlayer}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${transaction.transactionTime}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Text(
                "${transaction.amount}\$",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
