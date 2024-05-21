import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfrx_poc/components/thumb_card.dart';

class Thumbnails extends StatelessWidget {
  const Thumbnails({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.onTapBack,
    required this.onTapNext,
  });

  final PdfViewerController controller;
  final ValueNotifier<int> currentPage;
  final VoidCallback onTapBack;
  final VoidCallback onTapNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: currentPage,
                builder: (context, value, child) {
                  return Text(
                    '$value / ${controller.document.pages.length}',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onTapBack,
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: onTapNext,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          color: Colors.black,
          height: 240,
          child: PdfDocumentViewBuilder(
            documentRef: controller.documentRef,
            builder: (context, document) => ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: document?.pages.length ?? 0,
              itemBuilder: (context, index) {
                return ValueListenableBuilder<int>(
                  valueListenable: currentPage,
                  builder: (context, value, child) {
                    final page = index + 1;

                    return Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 12),
                      child: SizedBox(
                        height: 150,
                        child: ThumbCard(
                          controller: controller,
                          obfuscate: currentPage.value != page,
                          document: document,
                          page: index + 1,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
