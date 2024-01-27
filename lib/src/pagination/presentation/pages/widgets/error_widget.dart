import 'package:flutter/material.dart';

class ErrorButtonWidget extends StatelessWidget {
  final String error;
  final Function() reload;
  const ErrorButtonWidget({super.key, required this.error, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(error),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: reload,
            child: const Center(
              child: Text('reload'),
            ),
          ),
        ),
      ],
    );
  }
}
