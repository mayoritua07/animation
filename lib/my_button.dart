import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({super.key, required this.child, required this.isSelected});
  final Widget child;
  final bool isSelected;
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withAlpha(190)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            width: 2,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withAlpha(widget.isSelected ? 255 : 190)),
      ),
      child: widget.child,
    );
  }
}
