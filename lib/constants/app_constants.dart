class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String image;
  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
  });
}

class AppConstants {
  AppConstants._();

  static const List<OnboardingData> onboardingData = [
    OnboardingData(
      title: 'Discover the world,\none journey at a time.',
      subtitle: 'Discover the World',
      description:
          'From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today.',
      image: 'assets/images/on_one.png',
    ),
    OnboardingData(
      title: 'Explore new horizons,\none step at a time.',
      subtitle: 'Explore Horizons',
      description:
          'Every trip holds a story waiting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.',
      image: 'assets/images/on_two.png',
    ),
    OnboardingData(
      title: 'See the beauty, one\njourney at a time.',
      subtitle: 'See the Beauty',
      description:
          'Travel made simple and exciting—discover places you\'ll love and moments you\'ll never forget.',
      image: 'assets/images/on_three.png',
    ),
  ];

  static const String hiveAlarmsBox = 'alarms';
  static const String hiveLocationBox = 'location';
  static const String locationKey = 'saved_location';
}
