import 'package:app/blocs/main_bloc.dart';
import 'package:app/models/atm.dart';
import 'package:app/on_context_ready.dart';
import 'package:app/value_observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class AddressSearchSheet extends StatefulWidget {
  final ScrollController? scrollController;
  final VoidCallback onSearchFocus;

  const AddressSearchSheet({
    Key? key,
    this.scrollController,
    required this.onSearchFocus,
  }) : super(key: key);

  @override
  _AddressSearchSheetState createState() => _AddressSearchSheetState();
}

class _AddressSearchSheetState extends State<AddressSearchSheet> with OnContextReady {
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
              onPressed: () {},
            ),
            StreamBuilder<List<ATM>>(
              stream: atmsController,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();

                return TextButton(
                  child: Text('Προβολή αποτελεσμάτων στον χάρτη'),
                  onPressed: () {},
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
                          return _AtmEntry(atm: atms[index]);
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

class _AtmEntry extends StatelessWidget {
  final ATM atm;

  const _AtmEntry({
    Key? key,
    required this.atm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.atm_outlined),
                const SizedBox(width: 4.0),
                Text(
                  atm.name,
                  style: theme.textTheme.bodyText2,
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on_sharp),
                const SizedBox(width: 4.0),
                Flexible(
                  child: Text(
                    atm.fullAddress,
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                const Icon(Icons.work_outline, size: 20.0),
                const SizedBox(width: 8.0),
                Text(
                  'Ώρες λειτουργίας: ${atm.workingHours == '24_7' ? 'Ολή μέρα' : '-'}',
                  style: theme.textTheme.caption,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
