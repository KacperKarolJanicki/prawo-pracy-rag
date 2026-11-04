import 'package:flutter/material.dart';
import 'package:prawo_pracy/my_list.dart';

class MyForm extends StatelessWidget {

  final bool submittable;
  final void Function()? onSubmit;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const MyForm({super.key,
    this.submittable=true, this.onSubmit,
    this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.6,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Zapytaj o coś...',
              ),
              onChanged: onChanged,
            ),
          ),
          ElevatedButton(
            onPressed: submittable ? requestWaiting ? null : onSubmit : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withAlpha(150),
                elevation: 10,
              minimumSize: Size(20, 55),
            ),
            child: const Icon(Icons.arrow_upward, color: Colors.black, size: 25),
          )
        ]
    );
  }
}
