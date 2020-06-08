import 'package:fhir/fhir_r4.dart';
import 'package:vax_cast/src/9_shared/shared.dart';

import 'getRemotePatient.dart';

void main() async {
  var totalWrong = 0;
  var total = 0;
  // var patientIdList = patientTestList;
  var patientIdList = patientFullList;
  for (final patientId in patientIdList) {
    var newBundles = await GetRemotePatientData(patientId);

    var vaccineForecast = await Forecast().cast(
      FHIR_V.r4,
      true,
      newBundles[0],
      newBundles[1],
      newBundles[2],
      newBundles[3],
      null,
    );
    total += 1;
    var rec = ImmunizationRecommendation.fromJson(
        newBundles[2].entry[0].resource.toJson());

    if (vaccineForecast[0].seriesVaccineGroup == rec.recommendation[0].series) {
      //   // printAntigen(vaccineForecast, 'Diphtheria');
      //   // printAntigen(vaccineForecast, 'Pertussis');
      //   // printAntigen(vaccineForecast, 'Tetanus');
      //   // printAntigen(vaccineForecast[0], 'Influenza');
      printAntigen(vaccineForecast[0], 'HPV');
      //   // printAntigen(vaccineForecast, 'HepB');
      //   // printAntigen(vaccineForecast, 'Hib');
      //   // printAntigen(vaccineForecast, 'Measles');
      //   // printAntigen(vaccineForecast, 'Mumps');
      //   // printAntigen(vaccineForecast, 'Rubella');
      //   // printAntigen(vaccineForecast, 'Polio');
      if (differentThanCDC(vaccineForecast[0], rec)) {
        print(rec.recommendation[0].series);
        totalWrong += 1;
        print(printEarliest(vaccineForecast[0], rec));
        print(printRecommended(vaccineForecast[0], rec));
        print(printPastDue(vaccineForecast[0], rec));
      }
    }
    // print('***************************************************************');
    // print(
    //     'patient: ${Patient.fromJson(newBundles[0].entry[0].resource.toJson()).id}');
    // print('***************************************************************');
    // for (var forecast in vaccineForecast) {
    //   print(forecast.targetDisease);
    //   print(forecast.seriesVaccineGroup);
    //   print('earliest date: ${printEarliest(vaccineForecast[0], rec)}');
    //   print('recommended date: ${printRecommended(vaccineForecast[0], rec)}');
    //   print('past due date: ${printPastDue(vaccineForecast[0], rec)}');
    // }
    print(Patient.fromJson(newBundles[0].entry[0].resource.toJson()).id);
    // print('\n\n');
  }
  print('total wrong: $totalWrong');
  print('total: $total');
}

void printAntigen(GroupForecast vaccineForecast, String antigen) {
  print(vaccineForecast.seriesName.toString());
}

String printEarliest(GroupForecast group, ImmunizationRecommendation rec) {
  return ('${group.groupEarliestDate == null ? null : group.groupEarliestDate.toString().substring(0, 10)}:'
      '${rec.recommendation[0].dateCriterion[0].value.toString().substring(0, 10)}');
}

String printRecommended(GroupForecast group, ImmunizationRecommendation rec) {
  return ('${group.groupAdjRecDate == null ? null : group.groupAdjRecDate.toString().substring(0, 10)}:'
      '${rec.recommendation[0].dateCriterion[1].value.toString().substring(0, 10)}');
}

String printPastDue(GroupForecast group, ImmunizationRecommendation rec) {
  return ('${group.groupAdjPastDueDate == null ? null : group.groupAdjPastDueDate.toString().substring(0, 10)}:'
      '${rec.recommendation[0].dateCriterion[2].value.toString().substring(0, 10)}');
}

void printNullEarliest(GroupForecast group, ImmunizationRecommendation rec) {
  print('null:'
      '${rec.recommendation[0].dateCriterion[0].value.toString().substring(0, 10)}');
}

void printNullRecommended(GroupForecast group, ImmunizationRecommendation rec) {
  print('null:'
      '${rec.recommendation[0].dateCriterion[1].value.toString().substring(0, 10)}');
}

void printNullPastDue(GroupForecast group, ImmunizationRecommendation rec) {
  print('null:'
      '${rec.recommendation[0].dateCriterion[2].value.toString().substring(0, 10)}');
}

bool differentThanCDC(GroupForecast group, ImmunizationRecommendation rec) {
  return (differentEarliest(group, rec) ||
      differentRecommended(group, rec) ||
      differentPastDue(group, rec));
}

bool differentEarliest(GroupForecast group, ImmunizationRecommendation rec) {
  var vaxDate =
      rec.recommendation[0].dateCriterion[0].value.toString().substring(0, 10);
  return group.groupEarliestDate == null
      ? vaxDate.contains('9999') ? false : true
      : group.groupEarliestDate.toString().substring(0, 10) != vaxDate;
}

bool differentRecommended(GroupForecast group, ImmunizationRecommendation rec) {
  var vaxDate =
      rec.recommendation[0].dateCriterion[1].value.toString().substring(0, 10);
  return group.groupAdjRecDate == null
      ? vaxDate.contains('9999') ? false : true
      : group.groupAdjRecDate.toString().substring(0, 10) != vaxDate;
}

bool differentPastDue(GroupForecast group, ImmunizationRecommendation rec) {
  var vaxDate =
      rec.recommendation[0].dateCriterion[2].value.toString().substring(0, 10);
  return group.groupAdjPastDueDate == null
      ? vaxDate.contains('9999') ? false : true
      : group.groupAdjPastDueDate.toString().substring(0, 10) != vaxDate;
}

var patientTestList = [
  '2018-0022',
  '2013-0346',
  '2013-0348',
  '2013-0416'
      '2013-0423',
  '2013-0424',
  '2013-0426',
  '2013-0430',
  '2013-0437',
  '2013-0438',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
  '20-',
];

var patientFullList = [
  // '2013-0001',
  // '2013-0002',
  // '2013-0003',
  // '2013-0004',
  // '2013-0005',
  // '2013-0007',
  // '2013-0008',
  // '2013-0010',
  // '2013-0011',
  // '2013-0012',
  // '2013-0013',
  // '2013-0014',
  // '2013-0015',
  // '2013-0016',
  // '2013-0017',
  // '2013-0019',
  // '2013-0020',
  // '2013-0021',
  // '2013-0022',
  // '2013-0023',
  // '2013-0024',
  // '2013-0025',
  // '2013-0026',
  // '2013-0027',
  // '2013-0028',
  // '2013-0029',
  // '2013-0030',
  // '2013-0031',
  // '2013-0032',
  // '2013-0033',
  // '2013-0034',
  // '2013-0035',
  // '2013-0036',
  // '2013-0037',
  // '2013-0038',
  // '2013-0039',
  // '2013-0040',
  // '2013-0041',
  // '2013-0042',
  // '2013-0043',
  // '2013-0044',
  // '2013-0045',
  // '2013-0046',
  // '2013-0047',
  // '2013-0049',
  // '2013-0050',
  // '2013-0052',
  // '2013-0053',
  // '2013-0054',
  // '2013-0055',
  // '2013-0056',
  // '2013-0057',
  // '2013-0058',
  // '2013-0059',
  // '2013-0060',
  // '2013-0061',
  // '2013-0062',
  // '2013-0063',
  // '2013-0064',
  // '2013-0065',
  // '2013-0066',
  // '2013-0067',
  // '2013-0068',
  // '2013-0069',
  // '2013-0070',
  // '2013-0074',
  // '2013-0075',
  // '2013-0076',
  // '2013-0077',
  // '2013-0078',
  // '2013-0079',
  // '2013-0080',
  // '2013-0081',
  // '2013-0082',
  // '2013-0083',
  // '2013-0084',
  // '2013-0085',
  // '2013-0086',
  // '2013-0087',
  // '2013-0088',
  // '2013-0089',
  // '2013-0090',
  // '2013-0091',
  // '2013-0092',
  // '2013-0093',
  // '2013-0094',
  // '2013-0095',
  // '2013-0096',
  // '2013-0097',
  // '2013-0099',
  // '2013-0100',
  // '2013-0101',
  // '2013-0102',
  // '2013-0103',
  // '2013-0104',
  // '2013-0105',
  // '2013-0106',
  // '2013-0107',
  // '2013-0108',
  // '2013-0109',
  // '2013-0110',
  // '2013-0111',
  // '2013-0112',
  // '2013-0113',
  // '2013-0114',
  // '2013-0115',
  // '2013-0116',
  // '2013-0117',
  // '2013-0118',
  // '2013-0120',
  // '2013-0121',
  // '2013-0122',
  // '2013-0123',
  // '2013-0124',
  // '2013-0127',
  // '2013-0128',
  // '2013-0129',
  // '2013-0130',
  // '2013-0131',
  // '2013-0132',
  // '2013-0133',
  // '2013-0134',
  // '2013-0135',
  // '2013-0136',
  // '2013-0137',
  // '2013-0138',
  // '2013-0139',
  // '2013-0140',
  // '2013-0141',
  // '2013-0142',
  // '2013-0143',
  // '2013-0144',
  // '2013-0145',
  // '2013-0146',
  // '2013-0147',
  // '2013-0148',
  // '2013-0149',
  // '2013-0150',
  // '2013-0152',
  // '2013-0153',
  // '2013-0155',
  // '2013-0156',
  // '2013-0157',
  // '2013-0161',
  // '2013-0162',
  // '2013-0163',
  // '2013-0164',
  // '2013-0165',
  // '2013-0166',
  // '2016-0001',
  // '2016-0002',
  // '2016-0003',
  // '2016-0004',
  // '2016-0005',
  // '2016-0006',
  // '2016-0007',
  // '2016-0008',
  // '2016-0009',
  // '2016-0010',
  // '2017-0003',
  // '2017-0005',
  // '2020-0002',
  // '2020-0003',
  // '2020-0004',
  // '2020-0005',
  // '2020-0006',
  // '2020-0007',
  // '2020-0008',
  // '2020-0009',
  // '2020-0010',
  // '2013-0167',
  // '2013-0168',
  // '2013-0169',
  // '2013-0170',
  // '2013-0171',
  // '2013-0172',
  // '2013-0178',
  // '2013-0179',
  // '2013-0183',
  // '2013-0184',
  // '2016-0012',
  // '2018-0024',
  // '2018-0025',
  // '2018-0026',
  // '2019-0004',
  // '2019-0005',
  // '2019-0015',
  // '2019-0016',
  // '2013-0185',
  // '2013-0186',
  // '2013-0188',
  // '2013-0189',
  // '2013-0190',
  // '2013-0191',
  // '2013-0192',
  // '2013-0193',
  // '2013-0194',
  // '2013-0196',
  // '2013-0197',
  // '2019-0010',
  // '2019-0011',
  // '2019-0012',
  // '2019-0013',
  // '2019-0014',
  // '2020-0001',
  // '2013-0198',
  // '2013-0199',
  // '2013-0200',
  // '2013-0201',
  // '2013-0202',
  // '2013-0203',
  // '2013-0204',
  // '2013-0205',
  // '2013-0206',
  // '2013-0207',
  // '2013-0208',
  // '2013-0209',
  // '2013-0210',
  // '2013-0211',
  // '2013-0212',
  // '2013-0213',
  // '2013-0216',
  // '2013-0219',
  // '2013-0220',
  // '2013-0221',
  // '2013-0222',
  // '2013-0223',
  // '2013-0224',
  // '2013-0225',
  // '2013-0227',
  // '2013-0228',
  // '2013-0229',
  // '2013-0230',
  // '2013-0231',
  // '2013-0232',
  // '2013-0233',
  // '2013-0234',
  // '2013-0235',
  // '2013-0236',
  // '2013-0237',
  // '2013-0238',
  // '2013-0239',
  // '2013-0241',
  // '2013-0243',
  // '2013-0244',
  // '2013-0245',
  // '2013-0246',
  // '2013-0247',
  // '2013-0248',
  // '2013-0249',
  // '2013-0250',
  // '2013-0251',
  // '2013-0255',
  // '2013-0256',
  // '2013-0257',
  // '2013-0258',
  // '2013-0259',
  // '2013-0260',
  // '2013-0261',
  // '2013-0262',
  // '2013-0263',
  // '2013-0264',
  // '2013-0266',
  // '2013-0267',
  // '2013-0268',
  // '2013-0269',
  // '2013-0270',
  // '2013-0271',
  // '2016-0022',
  // '2017-0002',
  // '2018-0015',
  // '2018-0016',
  // '2018-0017',
  // '2018-0018',
  // '2018-0019',
  // '2018-0020',
  // '2018-0021',
  // '2018-0022',
  // '2018-0023',
  // '2013-0273',
  // '2013-0274',
  // '2013-0275',
  // '2013-0276',
  // '2013-0277',
  // '2013-0278',
  // '2013-0279',
  // '2013-0280',
  // '2013-0281',
  // '2013-0282',
  // '2013-0283',
  // '2013-0284',
  // '2013-0285',
  // '2013-0286',
  // '2013-0287',
  // '2013-0288',
  // '2013-0289',
  // '2013-0290',
  // '2013-0291',
  // '2013-0292',
  // '2013-0293',
  // '2013-0294',
  // '2013-0295',
  // '2013-0296',
  // '2013-0297',
  // '2013-0298',
  // '2013-0299',
  // '2013-0300',
  // '2013-0301',
  // '2013-0302',
  // '2013-0303',
  // '2013-0304',
  // '2013-0305',
  // '2013-0306',
  // '2013-0307',
  // '2013-0308',
  // '2013-0309',
  // '2013-0310',
  // '2013-0313',
  // '2013-0314',
  // '2013-0315',
  // '2013-0317',
  // '2013-0318',
  // '2013-0319',
  // '2013-0320',
  // '2013-0321',
  // '2013-0322',
  // '2013-0323',
  // '2013-0324',
  // '2013-0325',
  // '2013-0326',
  // '2013-0327',
  // '2013-0328',
  // '2013-0329',
  // '2013-0330',
  // '2013-0331',
  // '2013-0332',
  // '2013-0333',
  // '2013-0334',
  // '2013-0335',
  // '2013-0336',
  // '2013-0337',
  // '2013-0338',
  // '2013-0339',
  // '2013-0340',
  // '2013-0341',
  // '2013-0342',
  // '2013-0343',
  // '2013-0344',
  // '2013-0346',
  // '2013-0347',
  // '2013-0348',
  // '2013-0349',
  // '2013-0350',
  // '2013-0351',
  // '2013-0352',
  // '2013-0353',
  // '2013-0354',
  // '2013-0355',
  // '2013-0356',
  // '2013-0357',
  // '2013-0358',
  // '2013-0359',
  // '2013-0360',
  // '2013-0365',
  // '2013-0366',
  // '2013-0367',
  // '2013-0368',
  // '2013-0369',
  // '2013-0370',
  // '2013-0371',
  // '2013-0372',
  // '2013-0373',
  // '2013-0374',
  // '2013-0375',
  // '2013-0376',
  // '2013-0378',
  // '2013-0379',
  // '2013-0380',
  // '2013-0381',
  // '2013-0382',
  // '2013-0383',
  // '2013-0384',
  // '2013-0392',
  // '2013-0394',
  // '2013-0395',
  // '2013-0396',
  // '2013-0398',
  // '2013-0399',
  // '2013-0400',
  // '2013-0402',
  // '2013-0403',
  // '2013-0404',
  // '2013-0405',
  // '2013-0406',
  // '2013-0407',
  // '2013-0409',
  // '2013-0410',
  // '2013-0411',
  // '2013-0413',
  // '2013-0414',
  // '2013-0415',
  '2013-0416',
  '2013-0418',
  '2013-0421',
  '2013-0422',
  '2013-0423',
  '2013-0424',
  '2013-0425',
  '2013-0426',
  '2013-0427',
  '2013-0428',
  '2013-0429',
  '2013-0430',
  '2013-0433',
  '2013-0434',
  '2013-0437',
  '2013-0438',
  '2013-0439',
  '2013-0440',
  '2013-0441',
  '2013-0442',
  '2013-0443',
  '2013-0444',
  '2013-0445',
  '2013-0446',
  '2013-0447',
  '2013-0448',
  '2013-0450',
  '2013-0451',
  '2013-0452',
  '2013-0453',
  '2013-0454',
  '2013-0455',
  '2013-0456',
  '2013-0457',
  '2013-0458',
  '2013-0459',
  '2013-0460',
  '2013-0462',
  '2013-0463',
  '2013-0465',
  '2013-0466',
  '2013-0467',
  '2013-0468',
  '2013-0469',
  '2013-0470',
  '2013-0471',
  '2013-0472',
  '2013-0473',
  '2013-0474',
  '2013-0475',
  '2013-0476',
  '2013-0477',
  '2013-0478',
  '2013-0480',
  '2013-0481',
  '2013-0482',
  '2013-0483',
  '2013-0484',
  '2013-0485',
  '2013-0486',
  '2016-0013',
  '2016-0015',
  '2016-0016',
  '2016-0017',
  '2016-0018',
  '2016-0019',
  '2016-0020',
  '2016-0021',
  '2016-0023',
  '2016-0024',
  '2017-0001',
  '2019-0006',
  '2019-0007',
  '2013-0487',
  '2013-0488',
  '2013-0489',
  '2013-0491',
  '2013-0495',
  '2013-0497',
  '2013-0498',
  '2013-0499',
  '2013-0500',
  '2013-0501',
  '2013-0502',
  '2013-0503',
  '2013-0504',
  '2013-0505',
  '2013-0507',
  '2013-0508',
  '2013-0509',
  '2013-0510',
  '2013-0511',
  '2013-0512',
  '2013-0523',
  '2013-0524',
  '2013-0525',
  '2013-0528',
  '2013-0530',
  '2013-0531',
  '2013-0534',
  '2013-0535',
  '2013-0536',
  '2013-0537',
  '2013-0538',
  '2013-0539',
  '2013-0540',
  '2013-0541',
  '2013-0542',
  '2013-0543',
  '2013-0544',
  '2013-0545',
  '2013-0546',
  '2013-0547',
  '2013-0548',
  '2013-0549',
  '2013-0550',
  '2013-0551',
  '2013-0552',
  '2013-0554',
  '2013-0555',
  '2013-0556',
  '2013-0557',
  '2013-0558',
  '2013-0559',
  '2013-0562',
  '2013-0563',
  '2013-0565',
  '2013-0570',
  '2013-0571',
  '2013-0572',
  '2013-0573',
  '2013-0574',
  '2015-0024',
  '2019-0017',
  '2019-0018',
  '2019-0019',
  '2019-0020',
  '2019-0021',
  '2019-0022',
  '2013-0575',
  '2013-0576',
  '2013-0577',
  '2013-0578',
  '2013-0579',
  '2013-0580',
  '2013-0581',
  '2013-0582',
  '2013-0583',
  '2013-0584',
  '2013-0585',
  '2013-0587',
  '2013-0588',
  '2013-0589',
  '2013-0590',
  '2013-0591',
  '2013-0592',
  '2013-0593',
  '2013-0594',
  '2013-0595',
  '2013-0596',
  '2013-0597',
  '2013-0598',
  '2013-0599',
  '2013-0600',
  '2013-0601',
  '2013-0602',
  '2013-0603',
  '2013-0604',
  '2013-0605',
  '2013-0606',
  '2013-0607',
  '2013-0608',
  '2013-0609',
  '2013-0610',
  '2013-0611',
  '2013-0612',
  '2013-0613',
  '2013-0614',
  '2013-0615',
  '2013-0616',
  '2013-0617',
  '2013-0618',
  '2013-0619',
  '2013-0622',
  '2013-0624',
  '2013-0625',
  '2015-0021',
  '2015-0022',
  '2015-0023',
  '2019-0008',
  '2019-0009',
  '2013-0626',
  '2013-0627',
  '2013-0628',
  '2013-0629',
  '2013-0630',
  '2013-0631',
  '2013-0632',
  '2013-0633',
  '2013-0634',
  '2013-0635',
  '2013-0636',
  '2013-0637',
  '2013-0638',
  '2013-0639',
  '2013-0640',
  '2013-0641',
  '2013-0642',
  '2013-0643',
  '2013-0644',
  '2013-0645',
  '2013-0646',
  '2013-0647',
  '2013-0648',
  '2013-0649',
  '2013-0650',
  '2013-0651',
  '2013-0652',
  '2013-0653',
  '2013-0654',
  '2013-0655',
  '2013-0656',
  '2013-0657',
  '2013-0658',
  '2013-0659',
  '2013-0660',
  '2013-0661',
  '2013-0662',
  '2013-0664',
  '2013-0665',
  '2013-0666',
  '2013-0667',
  '2013-0668',
  '2013-0669',
  '2013-0670',
  '2013-0671',
  '2013-0672',
  '2013-0673',
  '2013-0674',
  '2013-0675',
  '2013-0676',
  '2013-0677',
  '2013-0678',
  '2013-0679',
  '2013-0680',
  '2013-0681',
  '2013-0682',
  '2013-0683',
  '2013-0684',
  '2013-0685',
  '2013-0686',
  '2013-0687',
  '2013-0688',
  '2013-0689',
  '2013-0690',
  '2013-0691',
  '2013-0692',
  '2013-0693',
  '2013-0694',
  '2013-0695',
  '2013-0696',
  '2013-0697',
  '2013-0698',
  '2013-0699',
  '2013-0700',
  '2013-0701',
  '2013-0702',
  '2013-0704',
  '2013-0707',
  '2013-0708',
  '2013-0709',
  '2013-0712',
  '2013-0713',
  '2013-0714',
  '2013-0715',
  '2013-0716',
  '2013-0717',
  '2013-0718',
  '2013-0719',
  '2013-0720',
  '2013-0721',
  '2013-0722',
  '2013-0723',
  '2013-0724',
  '2013-0725',
  '2013-0726',
  '2013-0727',
  '2013-0728',
  '2013-0729',
  '2013-0730',
  '2013-0731',
  '2013-0732',
  '2013-0733',
  '2013-0734',
  '2013-0735',
  '2013-0736',
  '2013-0737',
  '2013-0739',
  '2013-0740',
  '2013-0743',
  '2013-0744',
  '2013-0747',
  '2013-0748',
  '2013-0749',
  '2013-0750',
  '2013-0751',
  '2013-0752',
  '2013-0753',
  '2013-0754',
  '2013-0755',
  '2013-0756',
  '2013-0757',
  '2013-0758',
  '2013-0759',
  '2013-0760',
  '2013-0761',
  '2013-0762',
  '2013-0763',
  '2013-0764',
  '2013-0765',
  '2013-0766',
  '2013-0767',
  '2013-0768',
  '2013-0769',
  '2013-0770',
  '2013-0771',
  '2013-0772',
  '2013-0773',
  '2013-0774',
  '2013-0775',
  '2013-0776',
  '2013-0777',
  '2013-0778',
  '2013-0781',
  '2013-0782',
  '2013-0783',
  '2013-0784',
  '2013-0785',
  '2013-0786',
  '2013-0789',
  '2013-0795',
  '2013-0798',
  '2013-0803',
  '2013-0804',
  '2013-0806',
  '2013-0807',
  '2013-0808',
  '2013-0809',
  '2013-0810',
  '2013-0811',
  '2013-0812',
  '2013-0813',
  '2013-0814',
  '2013-0815',
  '2013-0816',
  '2013-0817',
  '2013-0818',
  '2013-0819',
  '2013-0820',
  '2013-0821',
  '2013-0822',
  '2013-0823',
  '2013-0824',
  '2013-0825',
  '2013-0826',
  '2013-0827',
  '2013-0829',
  '2013-0831',
  '2013-0832',
  '2013-0833',
  '2013-0840',
  '2013-0842',
  '2013-0843',
  '2013-0844',
  '2015-0001',
  '2015-0002',
  '2019-0023',
  '2019-0024',
  '2019-0025',
  '2019-0026',
  '2015-0013',
  '2015-0014',
  '2015-0016',
  '2015-0018',
  '2015-0019',
  '2018-0001',
  '2018-0002',
  '2018-0003',
  '2018-0004',
  '2018-0005',
  '2018-0006',
  '2018-0008',
  '2018-0009',
  '2018-0011',
  '2018-0012',
  '2018-0013',
  '2018-0014',
  '2019-0001',
  '2019-0002',
  '2019-0003',
];
