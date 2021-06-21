import 'package:app/models/atm.dart';
import 'package:flutter/material.dart';

class AtmWidget extends StatelessWidget {
  final ATM atm;

  const AtmWidget({
    Key? key,
    required this.atm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
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
