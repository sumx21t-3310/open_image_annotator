import 'dart:io';
import 'dart:ui';

import 'package:open_image_annotator/presentation/editor/dialogs/clipping.dart';
import 'package:flutter/material.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

class BubbleView extends StatefulWidget {
  const BubbleView({
    super.key,
    required this.image,
    required this.onTapDown,
    this.clipPos,
    this.enableBlur = true,
    this.blurAmount = 10,
    this.bubbleRadius = 10,
  });

  final File image;
  final bool enableBlur;
  final double blurAmount;
  final double bubbleRadius;
  final Offset? clipPos;

  final void Function(TapDownDetails) onTapDown;

  @override
  State<BubbleView> createState() => _BubbleViewState();
}

class _BubbleViewState extends State<BubbleView> {
  @override
  Widget build(BuildContext context) {
    final imageSize = ImageSizeGetter.getSizeResult(FileInput(widget.image));

    final shortSide = imageSize.shortSide;

    final relativeRadius = shortSide * (widget.bubbleRadius / 100);

    final targetImage = Image.file(widget.image);
    return FittedBox(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTapDown: widget.onTapDown,
              child: targetImage,
            ),
            if (widget.enableBlur)
              IgnorePointer(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Transform.scale(
                    scale: 1,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                          sigmaY: widget.blurAmount, sigmaX: widget.blurAmount),
                      child: targetImage,
                    ),
                  ),
                ),
              ),
            if (widget.clipPos != null)
              IgnorePointer(
                child: Clipping(
                  localPosition: widget.clipPos!,
                  radius: relativeRadius,
                  child: targetImage,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension on SizeResult {
  int get shortSide {
    return size.width < size.height ? size.width : size.height;
  }
}
