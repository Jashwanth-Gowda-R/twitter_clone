import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return TweetAPI(
    db: db,
  );
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  // final Realtime _realtime;
  TweetAPI({
    required Databases db,
    // required Realtime realtime,
  }) : _db = db;
  // _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      // queries: [
      //   Query.orderDesc('tweetedAt'),
      // ],
    );
    return documents.documents;
  }
}
