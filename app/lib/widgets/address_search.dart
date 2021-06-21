import 'package:app/blocs/main_bloc.dart';
import 'package:app/models/atm.dart';
import 'package:app/on_context_ready.dart';
import 'package:app/value_observer.dart';
import 'package:app/widgets/atm_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class AddressSearchWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final VoidCallback onSearchFocus;
  final VoidCallback onUseLocation;
  final ValueChanged<List<ATM>> onShowOnMap;

  const AddressSearchWidget({
    Key? key,
    this.scrollController,
    required this.onUseLocation,
    required this.onSearchFocus,
    required this.onShowOnMap,
  }) : super(key: key);

  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> with OnContextReady {
  final showIndicator = ValueObserver<bool>(false);
  final atmsController = BehaviorSubject<List<ATM>>()..value = [];

  late MainBloc bloc;

  @override
  void onContextReady() {
    bloc = context.read<MainBloc>();
  }

  @override
  void dispose() {
    super.dispose();

    atmsController.close();
  }

  void searchAtms(String address) async {
    showIndicator.value = true;

    final response = await bloc.searchWithAddress(address);

    showIndicator.value = false;

    if (response.ok) {
      atmsController.value = response.data!;
    } else {
      atmsController.value = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 6.0,
                width: 48.0,
                margin: EdgeInsets.only(top: 12.0, bottom: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Αναζήτηση',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.search,
                  onTap: widget.onSearchFocus,
                  onSubmitted: (address) async {
                    searchAtms(address);
                  },
                ),
              ),
            ),
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Αναζήτηση με βάση την τοποθεσία μου'),
                  const SizedBox(width: 8.0),
                  Icon(Icons.location_on),
                ],
              ),
              onPressed: widget.onUseLocation,
            ),
            StreamBuilder<List<ATM>>(
              stream: atmsController,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();

                return TextButton(
                  child: Text('Προβολή αποτελεσμάτων στον χάρτη'),
                  onPressed: () {
                    widget.onShowOnMap(snapshot.data!);
                    atmsController.value = [];
                  },
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showIndicator,
              builder: (context, showIndicator, child) {
                if (showIndicator) return Center(child: const CircularProgressIndicator());

                return Expanded(
                  child: StreamBuilder<List<ATM>>(
                    stream: atmsController,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      final atms = snapshot.data!;

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        controller: widget.scrollController,
                        itemBuilder: (_, index) {
                          return AtmWidget(atm: atms[index]);
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 4.0),
                        itemCount: atms.length,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
