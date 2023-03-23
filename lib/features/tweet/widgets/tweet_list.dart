import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ListView.builder(
              itemBuilder: (BuildContext context, index) {
                final tweet = tweets[index];
                return TweetCard(
                  tweet: tweet,
                );
              },
              itemCount: tweets.length,
            );
          },
          error: (e, st) {
            return ErrorText(
              error: e.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }
}
