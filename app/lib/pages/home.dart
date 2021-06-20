import 'package:app/on_context_ready.dart';
import 'package:app/widgets/address_search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomePage extends StatefulWidget {
  static const route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with OnContextReady {
  final snappingPositions = [
    SnappingPosition.pixels(
      positionPixels: 181.0,
      snappingCurve: Curves.easeOutExpo,
      snappingDuration: const Duration(seconds: 1),
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
    SnappingPosition.factor(
      positionFactor: .85,
      snappingCurve: Curves.easeOutQuart,
      snappingDuration: const Duration(milliseconds: 400),
    ),
  ];

  final sheetController = SnappingSheetController();
  final listScrollController = ScrollController();

  final scaffold = GlobalKey<ScaffoldState>();

  @override
  void onContextReady() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffold,
      body: SnappingSheet(
        lockOverflowDrag: true,
        controller: sheetController,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.9896144, 23.7350773),
            zoom: 13.0,
          ),
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          rotateGesturesEnabled: false,
        ),
        onSnapCompleted: (positionData, snappingPosition) {
          if (positionData.relativeToSheetHeight < 0.85) {
            FocusScope.of(context).unfocus();
          }
        },
        sheetBelow: SnappingSheetContent(
          draggable: true,
          sizeBehavior: const SheetSizeFill(),
          childScrollController: listScrollController,
          child: AddressSearchSheet(
            scrollController: listScrollController,
            onSearchFocus: () {
              sheetController.snapToPosition(snappingPositions[1]);
            },
          ),
        ),
        snappingPositions: snappingPositions,
      ),
    );
  }
}
