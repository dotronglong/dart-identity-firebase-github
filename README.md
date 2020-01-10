# dart-identity-firebase-github
Github SSO by Firebase for Identity package

## Getting Started

Create GitHub app and enable GitHub in Firebase project

Add package dependency

```yaml
identity_firebase_github: ^0.1.0
```

Configure Identity Firebase

```dart
import 'package:identity/identity.dart';
import 'package:identity_firebase/identity_firebase.dart';
import 'package:identity_firebase_github/identity_firebase_github.dart';

// ...

@override
  void initState() {
    super.initState();

    Identity.of(context).init(
        FirebaseProvider([
          FirebaseGithubAuthenticator(
              clientId: "[client_id]",
              clientSecret: "[client_secret]",
              redirectUrl: "[firebae_redirect_url]",
              scope: "user:email",
              clearCache: false) // set to false to allow to reuse current session, default is true
        ]),
        (context) => HomePage());
  }
```
