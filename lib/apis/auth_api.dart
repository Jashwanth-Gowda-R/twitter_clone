// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';

import 'package:twitter_clone/core/type_defs.dart';

// auth API Provider
final authAPIProvider = Provider((ref) {
  var account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

// abstract class for auth api
abstract class IAuthAPI {
  FutureEither<models.Account> signUp({
    required String email,
    required String password,
  });

  FutureEither<models.Session> login({
    required String email,
    required String password,
  });

  Future<models.Account?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({
    required Account account,
  }) : _account = account;

  @override
  FutureEither<models.Account> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: 'unique()',
        email: email,
        password: password,
      );
      return right(account);
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither<models.Session> login(
      {required String email, required String password}) async {
    try {
      final account = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(account);
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  Future<models.Account?> currentUserAccount() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }
}
