import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trashtrack_user/blocs/profile/get_profile/get_profile_bloc.dart';
import 'package:trashtrack_user/blocs/schedule/get_schedules/get_schedules_bloc.dart';
import 'package:trashtrack_user/extensions/timestamp_formatter.dart';
import 'package:trashtrack_user/models/profile/profile.dart';
import 'package:trashtrack_user/models/schedule/schedule.dart';
import 'package:trashtrack_user/pages/protected/route/route_page.dart';
import 'package:trashtrack_user/widgets/custom_app_bar.dart';

class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  void _gotoRoutePage(BuildContext context, Schedule schedule) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RoutePage(
            schedule: schedule,
          ),
        ),
      );
    } catch (e) {
      _showErrorDialog(
          context, 'An error occurred while navigating: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Today\'s Schedules'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: buildGetProfileBB(),
      ),
    );
  }

  BlocBuilder<GetProfileBloc, GetProfileState> buildGetProfileBB() {
    return BlocBuilder<GetProfileBloc, GetProfileState>(
      builder: (context, state) {
        if (state is GetProfileSuccessfulState) {
          Profile profile = state.profile;
          String barangay = profile.barangay ?? '';

          BlocProvider.of<GetSchedulesBloc>(context).add(
            GetSchedulesEvent(barangay),
          );

          return buildGetSchedulesBB();
        } else if (state is GetProfileErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 17, color: Colors.red),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  BlocBuilder<GetSchedulesBloc, GetSchedulesState> buildGetSchedulesBB() {
    return BlocBuilder<GetSchedulesBloc, GetSchedulesState>(
      builder: (context, state) {
        if (state is GetSchedulesSuccessfulState) {
          final List<Schedule> schedules = state.schedules;

          // Get today's day name
          String today = DateFormat('EEEE').format(DateTime.now());

          // Filter schedules to show only today's schedules
          final List<Schedule> todaysSchedules =
              schedules.where((schedule) => schedule.day == today).toList();

          if (todaysSchedules.isEmpty) {
            return const Center(
              child: Text(
                'No schedules available for today.',
                style: TextStyle(fontSize: 17, color: Colors.red),
              ),
            );
          }

          return buildAllSchedulesLB(todaysSchedules, context);
        } else if (state is GetSchedulesErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 17, color: Colors.red),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildAllSchedulesLB(List<Schedule> schedules, BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (BuildContext context, int index) {
        Schedule schedule = schedules[index];

        return ListTile(
          onTap: () => _gotoRoutePage(context, schedule),
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.schedule,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            '${schedule.day}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${schedule.time.toFormattedTime()}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
