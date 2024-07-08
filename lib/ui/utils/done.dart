import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qaza_e_umri/constants/app_constants.dart';
import 'package:qaza_e_umri/constants/assets_path.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(2.h),

        /// today
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                   Text(
                    AppLocalizations.of(context)!.today,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Gap(.4.h),
                  Text(getDateOfToday()),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  openDialog();
                },
                child: const Icon(
                  mInfoIcon,
                  color: colorsGreen,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/images/done.png',
          scale: 3,
        ),
        const Spacer()
      ],
    ));
  }

  String getDateOfToday() {
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    return formattedDate.toString();
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.learnAboutDailyPrayer,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF000000)),
            ),
            content: Text(
              '${AppLocalizations.of(context)!.tickMarkAgainstThePrayerNameAnd}\n\n${AppLocalizations.of(context)!.ifAnyPrayerIsNotMarkedTick}\n\n${AppLocalizations.of(context)!.updateTheRecordOfDailyPrayers}\n\n${AppLocalizations.of(context)!.userMayChangeThePrayerTimeAsPerTheirTimeZone}',
            ),
            actions: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          //margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              //border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(5),
                              color: colorsGreen),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.ok,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
