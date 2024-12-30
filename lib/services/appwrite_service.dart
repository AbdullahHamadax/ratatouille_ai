import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final Client client = Client();

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Storage storage = Storage(client);

  static void init() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6772e13e0030e088531f');
    // .setProject('6744a0f700127fd3f71b');
  }

  static String getImageUrl(String fileId) {
    return 'https://cloud.appwrite.io/v1/storage/buckets/your_bucket_id/files/$fileId/view?project=your_project_id';
  }
}
