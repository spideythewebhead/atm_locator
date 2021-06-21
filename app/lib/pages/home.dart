import 'dart:async';

import 'package:app/blocs/main_bloc.dart';
import 'package:app/models/atm.dart';
import 'package:app/on_context_ready.dart';
import 'package:app/value_observer.dart';
import 'package:app/widgets/address_search.dart';
import 'package:app/widgets/atm_widget.dart';
import 'package:app/widgets/finding_your_location_dialog.dart';
import 'package:app/widgets/location_request_dialog.dart';
import 'package:app/widgets/location_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

enum _AtmMethodFinder {
  address,
  location,
}

class HomePage extends StatefulWidget {
  static const route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with OnContextReady {
  final sheetController = SnappingSheetController();
  final listScrollController = ScrollController();
  final atmsPageController = PageController(viewportFraction: .90);

  final scaffold = GlobalKey<ScaffoldState>();

  final mapCompleter = Completer<GoogleMapController>();

  late MainBloc bloc;

  var atmMethodFinder = _AtmMethodFinder.address;
  late List<SnappingPosition> snappingPositions;

  Marker? myLocationMarker;

  var markers = <Marker>{};
  var circles = <Circle>{};

  var searchRadius = 3.0;

  @override
  void onContextReady() {
    changeSnappingPositions();

    bloc = context.read<MainBloc>();
  }

  void onGetMyLocation() async {
    final isGranted = await Permission.location.isGranted;

    if (isGranted) {
      onLocationPermissionGranted();
      return;
    }

    await showDialog(
      context: context,
      builder: (_) => LocationRequestDialog(
        onAccept: () async {
          final status = await Permission.locationWhenInUse.request();

          if (status.isGranted) {
            onLocationPermissionGranted();
            Navigator.pop(context);
          }
        },
        onDecline: () => Navigator.pop(context),
      ),
      barrierDismissible: false,
    );
  }

  void onLocationPermissionGranted() async {
    late StreamSubscription subscription;

    await Location.instance.changeSettings(distanceFilter: 0.0, accuracy: LocationAccuracy.high);

    void onGotLocation(LocationData location) {
      final latLng = LatLng(
        location.latitude!,
        location.longitude!,
      );

      mapCompleter.future.then((ctrl) {
        ctrl.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16.0));
      });

      myLocationMarker = Marker(
        markerId: MarkerId('my_location'),
        position: latLng,
        infoWindow: InfoWindow(title: 'Εγώ'),
      );

      circles = {
        Circle(
          circleId: CircleId('radius'),
          center: latLng,
          fillColor: Theme.of(context).accentColor.withAlpha(125),
          strokeWidth: 0,
          radius: searchRadius * 1000,
        )
      };

      setState(() {});
    }

    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          child: FindingYourLocationDialog(),
          onWillPop: () => Future.value(false),
        );
      },
    );

    subscription = await Location.instance.onLocationChanged
        .skipWhile((l) => (l.accuracy ?? 100) <= 50)
        .timeout(const Duration(seconds: 5))
        .listen((location) {
      subscription.cancel();
      onGotLocation(location);
      Navigator.pop(context);
    }, onError: (e) async {
      onGotLocation(await Location.instance.getLocation());
      Navigator.pop(context);
    });

    changeAtmMethodFinder(_AtmMethodFinder.location);
    changeSnappingPositions();
    setState(() {});

    sheetController.snapToPosition(snappingPositions.first);
  }

  void changeAtmMethodFinder(_AtmMethodFinder method) {
    atmMethodFinder = method;
  }

  void changeSnappingPositions() {
    snappingPositions = atmMethodFinder == _AtmMethodFinder.address
        ? [
            SnappingPosition.pixels(
              positionPixels: 185.0,
              snappingCurve: Curves.easeOutExpo,
              snappingDuration: const Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            SnappingPosition.factor(
              positionFactor: .85,
              snappingCurve: Curves.easeOutQuart,
              snappingDuration: const Duration(milliseconds: 400),
            ),
          ]
        : [
            SnappingPosition.pixels(
              positionPixels: 170.0,
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffold,
      body: SnappingSheet(
        lockOverflowDrag: true,
        controller: sheetController,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.9896144, 23.7350773),
                zoom: 13.0,
              ),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              onMapCreated: (ctrl) {
                mapCompleter.complete(ctrl);
              },
              markers: {
                ...markers,
                if (myLocationMarker != null) myLocationMarker!,
              },
              circles: circles,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              bottom: atmMethodFinder == _AtmMethodFinder.address ? 200.0 : 180.0,
              left: 0.0,
              right: 0.0,
              height: 145.0,
              child: StreamBuilder<List<ATM>>(
                stream: bloc.atmsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();

                  final atms = snapshot.data!;

                  return PageView.builder(
                    controller: atmsPageController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => AtmWidget(atm: atms[index]),
                    itemCount: atms.length,
                    onPageChanged: (page) {
                      final latLng = LatLng(
                        atms[page].latitude,
                        atms[page].longitude,
                      );

                      mapCompleter.future.then((ctrl) {
                        ctrl.animateCamera(CameraUpdate.newLatLng(latLng));
                      });

                      markers = {
                        Marker(
                          markerId: MarkerId('atm'),
                          position: latLng,
                          infoWindow: InfoWindow(title: atms[page].fullAddress),
                        )
                      };

                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
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
          child: AnimatedSwitcher(
            child: atmMethodFinder == _AtmMethodFinder.address
                ? AddressSearchWidget(
                    scrollController: listScrollController,
                    onSearchFocus: () {
                      sheetController.snapToPosition(snappingPositions[1]);
                    },
                    onUseLocation: onGetMyLocation,
                    onShowOnMap: (atms) {
                      bloc.publishAtms(atms);
                      sheetController.snapToPosition(snappingPositions.first);
                    },
                  )
                : LocationSearchWidget(
                    initialRadius: searchRadius,
                    scrollController: listScrollController,
                    onBack: () {
                      changeAtmMethodFinder(_AtmMethodFinder.address);
                      changeSnappingPositions();
                      myLocationMarker = null;
                      circles.clear();
                      sheetController.snapToPosition(snappingPositions.first);
                      setState(() {});
                    },
                    onRadiusChanged: (radius) {
                      searchRadius = radius;

                      if (markers.isNotEmpty && circles.isNotEmpty) {
                        circles = {circles.first.copyWith(radiusParam: radius * 1000)};
                        setState(() {});
                      }
                    },
                    onWrongLocation: () {
                      myLocationMarker = null;
                      circles.clear();
                      setState(() {});
                      onLocationPermissionGranted();
                    },
                    onSearch: () async {
                      if (myLocationMarker == null) return;

                      final didUpdate = await bloc.searchWithLocation(myLocationMarker!.position, searchRadius);

                      if (!didUpdate) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Αποτυχία εύρεσης!'),
                          ),
                        );
                      }
                    },
                  ),
            duration: const Duration(milliseconds: 200),
          ),
        ),
        snappingPositions: snappingPositions,
      ),
    );
  }
}
