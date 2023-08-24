class ReviewModel {
  final DateTime createdAt;
  final String docId;
  final String reviewerId;
  final String reviewerFirstName;
  final double rating;
  final String description;

  ReviewModel({
    required this.createdAt,
    required this.docId,
    required this.reviewerId,
    required this.reviewerFirstName,
    required this.rating,
    required this.description,
  });
}

final List<ReviewModel> reviewsDummyList = [
  ReviewModel(
    createdAt: DateTime.now().subtract(const Duration(days: 35)),
    docId: 'docId',
    reviewerId: "reviewerId",
    reviewerFirstName: 'James',
    rating: 3,
    description: 'I really like the watch. It ships quickly, has'
        ' good quality, and is the same as described. The watch has'
        ' many functions, such as heart rate, sleep, step counting,'
        ' and multiple exercise modes, which basically meet my daily'
        ' needs.,very nice.,works good.,it was great.',
  ),
  ReviewModel(
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    docId: 'docId',
    reviewerId: "reviewerId",
    reviewerFirstName: 'Lucy',
    rating: 4.5,
    description: 'Such as heart rate, sleep, step counting,'
        ' and multiple exercise modes, which basically meet my daily'
        ' needs.,very nice.,works good.,it was great.',
  ),
  ReviewModel(
    createdAt: DateTime.now().subtract(const Duration(days: 1)),

    docId: 'docId',
    reviewerId: "reviewerId",
    reviewerFirstName: 'Dickson',
    rating: 4,
    description: 'Multiple exercise modes, which basically meet my daily'
        ' needs.,very nice.,works good.,it was great.',
  ),
];
