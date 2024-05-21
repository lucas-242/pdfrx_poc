import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class ThumbCard extends StatefulWidget {
  const ThumbCard({
    super.key,
    required this.controller,
    required this.obfuscate,
    required this.document,
    required this.page,
  });

  final PdfViewerController controller;
  final bool obfuscate;
  final PdfDocument? document;
  final int page;

  @override
  State<ThumbCard> createState() => _ThumbCardState();
}

class _ThumbCardState extends State<ThumbCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.controller.goToPage(pageNumber: widget.page),
      child: Opacity(
        opacity: widget.obfuscate ? .5 : 1,
        child: PdfPageView(
          document: widget.document,
          pageNumber: widget.page,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
