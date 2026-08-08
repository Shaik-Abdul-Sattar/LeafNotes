import 'package:flutter/material.dart';
import 'package:leaf_notes/core/constants/app_icons.dart';
import 'package:leaf_notes/core/widgets/app_icon.dart';

class NoteMenuButton extends StatelessWidget {
  final VoidCallback onLock;
  final VoidCallback onDelete;
  final BuildContext parentContext;

  const NoteMenuButton({
    super.key,
    required this.onLock,
    required this.onDelete,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      popUpAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      icon: const Icon(Icons.more_vert_outlined),
      onSelected: (value) {
        FocusScope.of(parentContext).unfocus();
        switch (value) {
          case 'lock':
            onLock();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => [
        _buildItem('lock', AppIcons.lock, 'Set lock'),
        _buildItem('delete', AppIcons.deleteBin, 'Delete Diary'),
      ],
    );
  }
}

PopupMenuItem<String> _buildItem(
  String value,
  String? iconName,
  String label, {
  Color? color,
  Widget? toggle,
}) {
  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        AppIcon(iconName: iconName!),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color)),
        if (toggle != null) toggle,
      ],
    ),
  );
}
