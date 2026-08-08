import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leaf_notes/core/widgets/app_icon.dart';
import 'package:leaf_notes/features/notes/data/models/note_model.dart';
import 'package:leaf_notes/features/notes/presentation/utils/quill_util.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final bool isSelecting;
  final bool isSelected;
  const NoteCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.isSelecting,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'EEEE, dd MMM',
    ).format(widget.note.createdAt);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xFFBDE0F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.isSelecting) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSelected
                        ? const Color(0xFF3AACDF)
                        : const Color(0xFFE8F4FD),
                    border: Border.all(
                      color: widget.isSelected
                          ? const Color(0xFF3AACDF)
                          : const Color(0xFF0D3B5C).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: widget.isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: Text(
                  widget.note.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 19,
                    fontFamily: 'ManRope',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B3A2F),
                  ),
                ),
              ),
              AppIcon(iconName: widget.note.mood),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            child: widget.note.isLocked
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0E9DF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 20,
                            color: Color(0xFFA48B56),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap to unlock',
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'ManRope',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFA48B56),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    getPreviewText(widget.note.content),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "ManRope",
                      fontSize: 13,
                      fontWeight: FontWeight.w100,
                      color: Color(0xFF7A6656),
                    ),
                  ),
          ),

          const Divider(color: Color(0xFF4B3A2F), thickness: 1, height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'IosevkaCharon',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A5276),
                ),
              ),
              widget.note.isFavourite
                  ? const Icon(Icons.favorite, color: Color(0xFFE56B7A))
                  : const Icon(Icons.favorite_border_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
