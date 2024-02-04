import 'package:flutter/material.dart';
import 'package:monopoly_banker/class_structure/player.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: CircleAvatar(
            child: Text(
              player.name[0],
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(player.name),
        const SizedBox(height: 5),
        Text(
          "${player.accountBalance}\$",
          style: TextStyle(
            color: player.accountBalance <= 0 ? Colors.red : Colors.white,
          ),
        ),
      ],
    );
  }
}
