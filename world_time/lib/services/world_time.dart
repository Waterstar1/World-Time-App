import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {

  String location;
  DateTime time;
  String flag;
  String url;
  bool isDayTime;

  WorldTime( { this.location, this.flag, this.url} );

  Future<void> getTime() async {

    // Try the request
    try {
      Response response = await get(
          'http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      // Parse utc time and offset
      String dateTime = data['utc_datetime'];
      bool shouldAdd = data['utc_offset'].substring(0, 1) == '+';
      String offset = data['utc_offset'].substring(1, 3);
      DateTime now = DateTime.parse(dateTime);

      // Checks if you need to add or substract offset
      if (shouldAdd) {
        now = now.add(Duration(hours: int.parse(offset)));
      } else {
        now = now.subtract(Duration(hours: int.parse(offset)));
      }

      // Set day or night
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = now;

    } catch(e) {
      // If fails set values to error values
      print('caught error: $e');
      time = null;
      isDayTime = true;
    }
  }

}