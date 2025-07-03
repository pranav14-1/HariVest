class Scheme {
  final String id;
  final String name;
  final String description;
  final String launchDate;
  final String status; // 'previous' | 'upcoming' | 'newly-launched'
  final String? link;
  final List<String> benefits;
  final List<String> eligibility;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.launchDate,
    required this.status,
    this.link,
    required this.benefits,
    required this.eligibility,
  });
}