import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trashtrack_user/blocs/analysis/get_analysis/get_analysis_bloc.dart';
import 'package:trashtrack_user/blocs/announcement/get_announcements/get_announcements_bloc.dart';
import 'package:trashtrack_user/blocs/auth/logout/logout_bloc.dart';
import 'package:trashtrack_user/blocs/profile/get_profile/get_profile_bloc.dart';
import 'package:trashtrack_user/blocs/route/get_routes/get_routes_bloc.dart';
import 'package:trashtrack_user/helpers/message_dialog_helper.dart';
import 'package:trashtrack_user/helpers/notification_message_helper.dart';
import 'package:trashtrack_user/models/announcement/announcement.dart';
import 'package:trashtrack_user/models/profile/profile.dart';
import 'package:trashtrack_user/pages/protected/about/about_page.dart';
import 'package:trashtrack_user/pages/protected/analysis/analysis_page.dart';
import 'package:trashtrack_user/pages/protected/forum/posts_page.dart';
import 'package:trashtrack_user/pages/protected/profile/edit_profile_page.dart';
import 'package:trashtrack_user/pages/protected/recycling/recycling_sorting_page.dart';

import 'package:trashtrack_user/pages/protected/schedule/Week_of_Days.dart';
import 'package:trashtrack_user/pages/protected/settings/settings_page.dart';

import 'package:trashtrack_user/widgets/custom_cached_image.dart';
import 'package:trashtrack_user/widgets/custom_elevated_button.dart';
import 'package:trashtrack_user/models/route/route.dart' as rm;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _getRouteList(BuildContext context) {
    BlocProvider.of<GetRoutesBloc>(context).add(
      GetRoutesEvent(),
    );
  }

  void _getProfileDetails(BuildContext context, rm.Route route) {
    BlocProvider.of<GetProfileBloc>(context).add(
      GetProfileEvent(route.id),
    );
  }

  void _getAnnouncementsList(BuildContext context) {
    BlocProvider.of<GetAnnouncementsBloc>(context).add(
      GetAnnouncementsEvent(),
    );
  }

  void _getAnalysisDetails(BuildContext context) {
    BlocProvider.of<GetAnalysisBloc>(context).add(
      GetAnalysisEvent(),
    );
  }

  void _signoutAuthAccount(BuildContext context) {
    BlocProvider.of<LogoutBloc>(context).add(
      LogoutAccountEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simulate getting route list
    _getRouteList(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF02413C),
        title: Image.asset(
          'lib/assets/images/logo-trashtrack.png', // Path to your logo image
          fit: BoxFit.contain, // Adjust to fit the AppBar
          height: 40, // Adjust the height to fit the AppBar nicely
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      drawer: buildAppDrawer(context), // Call to the drawer
      body: buildGetRoutesBC(), // Placeholder for your main content
    );
  }

  Widget buildDrawerHeader(BuildContext context, Profile? profile) {
    String displayName = '';
    String displayMail = '';
    if (profile != null) {
      displayName =
          '${profile.firstname ?? ''} ${profile.lastname ?? ''}'.trim();
      displayMail = (profile.email ?? '').trim();
    }

    return UserAccountsDrawerHeader(
      accountName: Text(displayName.isNotEmpty ? displayName : 'User'),
      accountEmail:
          Text(displayMail.isNotEmpty ? displayMail : 'user@example.com'),
      decoration: const BoxDecoration(
        color: Color(0xFF02413C),
      ),
    );
  }

  Widget buildMotivationalQuote() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Together, we can make a difference in our environment!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Method to build the app drawer
  Drawer buildAppDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Drawer Header using the provided buildDrawerHeader function
                  BlocBuilder<GetProfileBloc, GetProfileState>(
                    builder: (context, state) {
                      if (state is GetProfileSuccessfulState) {
                        return buildDrawerHeader(context, state.profile);
                      } else if (state is GetProfileErrorState) {
                        return const ListTile(
                          title: Text('Error loading profile'),
                          subtitle: Text('user@example.com'),
                        );
                      } else {
                        return const ListTile(
                          title: Text('Loading...'),
                          subtitle: Text('user@example.com'),
                        );
                      }
                    },
                  ),
                  // Recycling and Sorting Item
                  _buildDrawerItem(
                    icon: Icons.recycling_rounded,
                    text: 'Recycling and Sorting',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RecyclingPage(),
                        ),
                      );
                    },
                  ),
                  // Settings Item
                  _buildDrawerItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: buildLogoutBC(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          // About App Item (at the bottom)
          _buildDrawerItem(
            icon: Icons.info,
            text: 'About App',
            onTap: () => _navigateTo(context, const AboutPage()),
          ),
          const SizedBox(height: 20), // Add some padding at the bottom
        ],
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.1),
        child: Icon(icon, color: const Color(0xFF02413C)),
      ),
      title: Text(text),
      onTap: onTap,
    );
  }

  BlocConsumer buildGetRoutesBC() {
    return BlocConsumer<GetRoutesBloc, GetRoutesState>(
      listener: (context, state) {
        if (state is GetRoutesSuccessfulState) {
          final routes = state.routes;
          rm.Route route = routes.first;

          _getProfileDetails(context, route);
        }
      },
      builder: (context, state) {
        if (state is GetRoutesSuccessfulState) {
          final routes = state.routes;

          return buildGetProfileBC(routes);
        } else if (state is GetRoutesErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 17),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  BlocConsumer buildGetProfileBC(List<rm.Route> routes) {
    return BlocConsumer<GetProfileBloc, GetProfileState>(
      listener: (context, state) async {
        // Make listener async
        if (state is GetProfileSuccessfulState) {
          // Check and request notification permission
          await _requestNotificationPermission();

          // Check and request location permission
          await _requestLocationPermission();

          _getAnnouncementsList(context);
          _getAnalysisDetails(context);

          Profile profile = state.profile;
          String? firstname = profile.firstname;
          String? lastname = profile.lastname;

          if (firstname == 'Firstname' && lastname == 'Lastname') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => EditProfilePage(
                  profile: profile,
                  routes: routes,
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is GetProfileSuccessfulState) {
          Profile profile = state.profile;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  buildGetAnnouncementsBC(),
                  const SizedBox(height: 20),
                  buildMenuRow(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return EditProfilePage(
                            profile: profile,
                            routes: routes,
                          );
                        },
                      ),
                    ),
                    Icons.people,
                    'Profile',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const AnalysisPage(),
                      ),
                    ),
                    Icons.bar_chart,
                    'Trash Analysis',
                  ),
                  const SizedBox(height: 10),
                  buildMenuRow(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const WeekOfDays(),
                        // return const SchedulesPage();
                      ),
                    ),
                    Icons.schedule,
                    'Routes and Schedules',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const PostsPage(),
                      ),
                    ),
                    Icons.forum,
                    'Community Forum',
                  ),
                  const SizedBox(height: 10),
                  buildMotivationalQuote(),
                ],
              ),
            ),
          );
        } else if (state is GetProfileErrorState) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(fontSize: 17),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  BlocConsumer<GetAnnouncementsBloc, GetAnnouncementsState>
      buildGetAnnouncementsBC() {
    return BlocConsumer<GetAnnouncementsBloc, GetAnnouncementsState>(
      listener: (context, state) {
        if (state is GetAnnouncementsSuccessfulState) {
          final announcements = state.announcements;

          if (announcements.isNotEmpty) {
            final announcement = announcements.first;

            NotificationMessageHelper.showMessageNotification(
              announcement.id,
              announcement.title,
              announcement.body,
            );
          }
        }
      },
      builder: (context, state) {
        if (state is GetAnnouncementsSuccessfulState) {
          final announcements = state.announcements;
          return buildAnnouncesSlider(announcements);
        } else if (state is GetAnnouncementsErrorState) {
          return Center(child: Text(state.message)); // Display error message
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  CarouselSlider buildAnnouncesSlider(List<Announcement> announcements) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250, // Increased height to accommodate content
        enableInfiniteScroll: false,
        autoPlay: true,
        reverse: true,
        autoPlayInterval: const Duration(seconds: 5),
        enlargeCenterPage: true,
        viewportFraction: 0.85, // Adjusted to show more of each card
      ),
      items: announcements.map((announcement) {
        return Builder(
          builder: (BuildContext context) {
            return buildAnnounceCard(context, announcement);
          },
        );
      }).toList(),
    );
  }

  GestureDetector buildAnnounceCard(
      BuildContext context, Announcement announcement) {
    return GestureDetector(
      onTap: () {
        // Trigger modal to show the full post when the card is tapped
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomCachedImage(
                          url: announcement.url,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          announcement.body,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: CustomElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            labelText: 'Close',
                            backgroundColor: Colors.red,
                            icon: const Icon(Icons.close), // Example icon
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF02413C),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomCachedImage(
                url: announcement.url,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          announcement.body,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildMenuRow(
    void Function() action1,
    IconData icon1,
    String title1,
    void Function() action2,
    IconData icon2,
    String title2,
  ) {
    return Row(
      children: <Widget>[
        buildMenuCard(action1, icon1, title1),
        const SizedBox(width: 10),
        buildMenuCard(action2, icon2, title2),
      ],
    );
  }

  Expanded buildMenuCard(
    void Function() action,
    IconData icon,
    String title,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: action,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Icon(
                  icon,
                  size: 50,
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  title,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer buildLogoutBC() {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutErrorState) {
          MessageDialogHelper.showErrorDialog(
            context,
            'Logout Error',
            state.message,
          );
        }
      },
      builder: (context, state) {
        if (state is LogoutProcessingState) {
          return const CircularProgressIndicator();
        } else {
          return buildLogoutButton(context);
        }
      },
    );
  }

  ListTile buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red.withOpacity(0.1),
        child: const Icon(Icons.logout, color: Colors.red),
      ),
      title: const Text('Signout', style: TextStyle(color: Colors.red)),
      onTap: () => _signoutAuthAccount(context),
    );
  }
}
