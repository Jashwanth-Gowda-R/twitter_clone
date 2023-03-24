// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import 'package:twitter_clone/models/tweet_model.dart';

class TweeterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) {
          return TweeterReplyScreen(
            tweet: tweet,
          );
        },
      );
  final Tweet tweet;
  const TweeterReplyScreen({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                    data: (data) {
                      final latestTweet = Tweet.fromMap(data.payload);
                      bool isTweetAlreadyPresent = false;
                      for (final tweetModel in tweets) {
                        if (tweetModel.id == latestTweet.id) {
                          isTweetAlreadyPresent = true;
                          break;
                        }
                      }

                      if (!isTweetAlreadyPresent &&
                          latestTweet.repliedTo == tweet.id) {
                        if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                        )) {
                          tweets.insert(0, Tweet.fromMap(data.payload));
                        } else if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                        )) {
                          // get id of original tweet
                          final startingPoint =
                              data.events[0].lastIndexOf('documents.');
                          final endPoint =
                              data.events[0].lastIndexOf('.update');
                          final tweetId = data.events[0]
                              .substring(startingPoint + 10, endPoint);

                          var tweet = tweets
                              .where((element) => element.id == tweetId)
                              .first;

                          final tweetIndex = tweets.indexOf(tweet);
                          tweets.removeWhere(
                              (element) => element.id == tweetId);

                          tweet = Tweet.fromMap(data.payload);
                          tweets.insert(tweetIndex, tweet);
                        }
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            final tweet = tweets[index];
                            return TweetCard(
                              tweet: tweet,
                            );
                          },
                          itemCount: tweets.length,
                        ),
                      );
                    },
                    error: (e, st) {
                      return ErrorText(
                        error: e.toString(),
                      );
                    },
                    loading: () {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, index) {
                            final tweet = tweets[index];
                            return TweetCard(
                              tweet: tweet,
                            );
                          },
                          itemCount: tweets.length,
                        ),
                      );
                    },
                  );
                },
                error: (e, st) {
                  return ErrorText(
                    error: e.toString(),
                  );
                },
                loading: () => const Loader(),
              )
        ],
      ),
      bottomNavigationBar: TextField(
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
            images: [],
            text: value,
            context: context,
            repliedTo: tweet.id,
            repliedToUserId: tweet.uid,
          );
        },
      ),
    );
  }
}
