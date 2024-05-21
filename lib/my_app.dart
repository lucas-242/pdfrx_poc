import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfrx_poc/components/thumbnails.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = PdfViewerController();

  final _currentPage = ValueNotifier<int>(1);
  final _canShowThumbnails = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              FutureBuilder(
                future: rootBundle.load('assets/sample.pdf'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!.buffer.asUint8List();
                    return PdfViewer.data(
                      data,
                      params: PdfViewerParams(
                        onPageChanged: _onPageChanged,
                        onViewerReady: _onViewerReady,
                        layoutPages: _getHorizontalPageLayout,
                      ),
                      controller: _controller,
                      sourceName: 'Test',
                    );
                  }

                  return Text('Error: ${snapshot.error}');
                },
              ),
              ValueListenableBuilder(
                valueListenable: _canShowThumbnails,
                builder: (context, value, child) => value
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Thumbnails(
                          controller: _controller,
                          currentPage: _currentPage,
                          onTapBack: _onTapBack,
                          onTapNext: _onTapNext,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int? page) {
    if (page == null) return;
    _currentPage.value = page;
  }

  void _onViewerReady(PdfDocument document, PdfViewerController controller) {
    _canShowThumbnails.value = true;
  }

  void _onTapBack() {
    if (_currentPage.value == 1) return;

    _controller.goToPage(pageNumber: _currentPage.value - 1);
  }

  void _onTapNext() {
    if (_currentPage.value >= _controller.document.pages.length) return;

    _controller.goToPage(pageNumber: _currentPage.value + 1);
  }

  PdfPageLayout _getHorizontalPageLayout(
    List<PdfPage> pages,
    PdfViewerParams params,
  ) {
    final height = pages.fold(0.0, (prev, page) => max(prev, page.height)) +
        params.margin * 2;

    final pageLayouts = <Rect>[];
    var x = params.margin;

    for (var page in pages) {
      pageLayouts.add(
        Rect.fromLTWH(
          x,
          (height - page.height) / 2,
          page.width,
          page.height,
        ),
      );
      x += page.width + params.margin;
    }

    return PdfPageLayout(
      pageLayouts: pageLayouts,
      documentSize: Size(x, height),
    );
  }
}
