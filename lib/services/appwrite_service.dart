import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final Client client = Client();

  static final Account account = Account(client);

  static void init() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('673e4306000314ab7628');
    // .setProject('6744a0f700127fd3f71b');
  }
}
