
import 'dart:convert';

RequestModel requestModelFromJson(String str) => RequestModel.fromJson(json.decode(str));

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
    int page;
    List<dynamic> results; //pasar a dynamic
    int totalPages;
    int totalResults;

    RequestModel({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        page: json["page"],
        results: json["results"] == null ? [] : List<dynamic>.from(json["results"].map((e) => e)), //evaluando si esta null
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

