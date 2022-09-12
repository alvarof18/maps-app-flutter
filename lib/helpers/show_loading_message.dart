import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  //Android

  if (Platform.isAndroid) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Espere por favor'),
              content: Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(top: 30),
                child: Column(
                  children: const [
                    Text('Calculando Ruta'),
                    CircularProgressIndicator(
                        strokeWidth: 3, color: Colors.black)
                  ],
                ),
              ),
            ));
  } else {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const CupertinoAlertDialog(
              title: Text('Espere por favor'),
              content: CupertinoActivityIndicator(),
            ));
  }

  return;
}
