import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:identity/identity.dart';

class FirebaseGithubAuthenticator
    with WillNotify, WillConvertUser
    implements Authenticator {
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final String scope;
  final bool allowSignUp;
  final bool clearCache;
  final String userAgent;

  FirebaseGithubAuthenticator(
      {@required this.clientId,
      @required this.clientSecret,
      @required this.redirectUrl,
      this.scope = "user,user:email",
      this.allowSignUp = true,
      this.clearCache = true,
      this.userAgent});

  @override
  WidgetBuilder get action => (context) => ActionButton(
      onPressed: () => authenticate(context),
      color: Colors.black,
      textColor: Colors.white,
      icon: Image.asset("images/github.png",
          package: "identity_firebase_github", width: 24, height: 24),
      text: "Sign in with GitHub");

  @override
  Future<void> authenticate(BuildContext context, [Map parameters]) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUrl: redirectUrl,
        scope: scope,
        allowSignUp: allowSignUp,
        clearCache: clearCache,
        userAgent: userAgent);
    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        notify(context, "Processing result ...");
        return FirebaseAuth.instance
            .signInWithCredential(
                GithubAuthProvider.getCredential(token: result.token))
            .then((result) => convert(result.user))
            .then((user) => Identity.of(context).user = user)
            .catchError(Identity.of(context).error);

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        Identity.of(context).error(result.errorMessage);
        break;
    }
  }
}
