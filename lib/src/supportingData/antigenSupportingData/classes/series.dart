import 'seriesDose.dart';
import 'indication.dart';

class Series {
  String seriesName;
  String targetDisease;
  String seriesVaccineGroup;
  String seriesAdminGuidance;
  String seriesType;
  String equivalentSeriesGroups;
  String requiredGender;
  String defaultSeries;
  String productPath;
  String seriesGroupName;
  String seriesGroup;
  String seriesPriority;
  String seriesPreference;
  String minAgeToStart;
  String maxAgeToStart;
  Map<String, Indication> indication;
  List<SeriesDose> seriesDose;

  Series({
    this.seriesName,
    this.targetDisease,
    this.seriesVaccineGroup,
    this.seriesAdminGuidance,
    this.seriesType,
    this.equivalentSeriesGroups,
    this.requiredGender,
    this.defaultSeries,
    this.productPath,
    this.seriesGroupName,
    this.seriesGroup,
    this.seriesPriority,
    this.seriesPreference,
    this.minAgeToStart,
    this.maxAgeToStart,
    this.indication,
    this.seriesDose,
  });

  Series.fromJson(Map<String, dynamic> json) {
    seriesName = json['seriesName'] as String;
    targetDisease = json['targetDisease'] as String;
    seriesVaccineGroup = json['seriesVaccineGroup'] as String;
    seriesAdminGuidance = json['seriesAdminGuidance'];
    seriesType = json['seriesType'] as String;
    equivalentSeriesGroups = json['equivalentSeriesGroups'] as String;
    requiredGender = json['requiredGender'] as String;
    defaultSeries = json['defaultSeries'] as String;
    productPath = json['productPath'] as String;
    seriesGroupName = json['seriesGroupName'] as String;
    seriesGroup = json['seriesGroup'] as String;
    seriesPriority = json['seriesPriority'] as String;
    seriesPreference = json['seriesPreference'] as String;
    minAgeToStart = json['minAgeToStart'] as String;
    maxAgeToStart = json['maxAgeToStart'] as String;
    if (json['indication'] != null) {
      indication = <String, Indication>{};
      json['indication'].forEach((k, v) {
        indication[k] = Indication.fromJson(v);
      });
    }
    if (json['seriesDose'] != null) {
      seriesDose = <SeriesDose>[];
      json['seriesDose'].forEach((v) {
        seriesDose.add(SeriesDose.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['seriesName'] = seriesName;
    data['targetDisease'] = targetDisease;
    data['seriesVaccineGroup'] = seriesVaccineGroup;
    data['seriesAdminGuidance'] = seriesAdminGuidance;
    data['seriesType'] = seriesType;
    data['equivalentSeriesGroups'] = equivalentSeriesGroups;
    data['requiredGender'] = requiredGender;
    data['defaultSeries'] = defaultSeries;
    data['productPath'] = productPath;
    data['seriesGroupName'] = seriesGroupName;
    data['seriesGroup'] = seriesGroup;
    data['seriesPriority'] = seriesPriority;
    data['seriesPreference'] = seriesPreference;
    data['minAgeToStart'] = minAgeToStart;
    data['maxAgeToStart'] = maxAgeToStart;
    if (indication != null) {
      data['indication'] = <String, dynamic>{};
      indication.forEach((k, v) {
        data['indication'][k] = v.toJson();
      });
    } else {
      data['indication'] = null;
    }
    if (seriesDose != null) {
      data['seriesDose'] = seriesDose.map((v) => v.toJson()).toList();
    } else {
      data['seriesDose'] = null;
    }
    return data;
  }
}
