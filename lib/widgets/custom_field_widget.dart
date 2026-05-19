import 'package:aula/global/ITColors.dart';
import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  String label = "";
  TextEditingController? ctrl;
  IconData? icon;
  bool obscure = false;
  String? hint;
  CustomField(this.label, TextEditingController this.ctrl, IconData this.icon,
      {this.obscure = false, this.hint});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(widget.label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ITColors.gray700)),
          ),
          Container(
            decoration: BoxDecoration(
              color: ITColors.gray100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ITColors.gray200),
            ),
            child: TextField(
              controller: widget.ctrl,
              obscureText: widget.obscure,
              style: const TextStyle(fontSize: 14, color: ITColors.gray900),
              decoration: InputDecoration(
                hintText: widget.hint ?? widget.label,
                hintStyle:
                    const TextStyle(color: ITColors.gray500, fontSize: 13),
                prefixIcon: Icon(widget.icon, color: ITColors.gray500, size: 20),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}