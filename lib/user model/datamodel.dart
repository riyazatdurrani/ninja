// To parse this JSON data, do
//
//     final jsonData = jsonDataFromJson(jsonString);

import 'dart:convert';

JsonData jsonDataFromJson(String str) => JsonData.fromJson(json.decode(str));

String jsonDataToJson(JsonData data) => json.encode(data.toJson());

class JsonData {
    JsonData({
        this.restaurant,
    });

    List<Restaurant>? restaurant;

    factory JsonData.fromJson(Map<String, dynamic> json) => JsonData(
        restaurant: List<Restaurant>.from(json["restaurant"].map((x) => Restaurant.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "restaurant": List<dynamic>.from(restaurant??[].map((x) => x.toJson())),
    };
}

class Restaurant {
    Restaurant({
        this.bot,
        this.human,
    });

    String? bot;
    String? human;

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        bot: json["bot"],
        human: json["human"],
    );

    Map<String, dynamic> toJson() => {
        "bot": bot,
        "human": human,
    };
}
