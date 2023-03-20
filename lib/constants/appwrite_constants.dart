class AppwriteConstants {
  static const String databaseId = '640a0bde80bdca86186b';
  static const String projectId = '640a0adadbfeb4d86afa';
  static const String endpoint = 'http://192.168.0.106:80/v1';
  // static const String endpoint = 'http://localhost:80/v1';
  static const String userCollectionId = '64102d9d8ec92eaa31c8';

  static const String tweetsCollection = '6418669b2f3d31261de9';
  // static const String notificationsCollection = '63cd5ff88b08e40a11bc';

  static const String imagesBucket = '6418745be5983496ed4d';

  static String imageUrl(String imageId) =>
      '$endpoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
