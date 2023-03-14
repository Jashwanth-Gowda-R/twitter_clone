// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/views/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

// providers
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI: authAPI, userApi: userAPI);
});

// current user
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

// user details
final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// current user details
final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserID = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserID));
  return userDetails.value;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  AuthController({
    required AuthAPI authAPI,
    required UserAPI userApi,
  })  : _authAPI = authAPI,
        _userAPI = userApi,
        super(false);

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold(
            (l) => showSnackBar(
                  context,
                  l.message,
                ), (r) {
          showSnackBar(
            context,
            'Accounted created! Please login.',
          );
          Navigator.push(
            context,
            LoginView.route(),
          );
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = true;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => {
        showSnackBar(context, "Account has been created!"),
        Navigator.push(context, HomeView.route())
      },
    );
  }

  Future<models.Account?> currentUser() => _authAPI.currentUserAccount();

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
