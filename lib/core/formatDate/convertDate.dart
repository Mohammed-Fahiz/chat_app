import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ConvertDateTime {
  static String convertDate_DDMMtoYYYYMM({required String inputDate}) {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    DateTime parsedDate = inputFormat.parse(inputDate);
    String formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  }

  static String convertDate_YYYYMMtoDDMM({required String inputDate}) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat = DateFormat('dd-MM-yyyy');

    DateTime parsedDate = inputFormat.parse(inputDate);
    String formattedDate = outputFormat.format(parsedDate);
    return formattedDate;
  }

  static String convertDateTime_toYYYYMMDD({required DateTime dateTime}) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }

  static String convertDateTime_toDDMMYYYY({required DateTime dateTime}) {
    DateFormat outputFormat = DateFormat('dd-MM-yyyy');
    String formattedDate = outputFormat.format(dateTime);
    return formattedDate;
  }

  static String convertTimeStampToReadable({required Timestamp timestamp}) {
    final Timestamp firestoreTimestamp = timestamp;

    DateTime dateTime = firestoreTimestamp.toDate();

    String formattedDateTime = DateFormat('hh:mm a dd/MM/yy').format(dateTime);

    return formattedDateTime;
  }

  static String convertTimeStampToReadableNoDate(
      {required Timestamp timestamp}) {
    final Timestamp firestoreTimestamp = timestamp;

    DateTime dateTime = firestoreTimestamp.toDate();

    String formattedDateTime = DateFormat('hh:mm a').format(dateTime);

    return formattedDateTime;
  }
}
