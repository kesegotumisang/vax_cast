part of 'a_vax_cast.dart';

Map<VaxAg, Antigen> sortByAntigen(VaxPatient patient) {
  Map<VaxAg, Antigen> ag = <VaxAg, Antigen>{};
  for (final vaccine in patient.pastImmunizations) {
    for (final association in SupportingData
        .scheduleSupportingData.cvxToAntigenMap[vaccine.cvx].association) {
      if (datesApply(patient.dob, vaccine.dateGiven,
          association.associationBeginAge, association.associationEndAge)) {
        ag.keys.contains(getVaxAg(association.antigen))
            ? ag[getVaxAg(association.antigen)].pastDoses.add(vaccine)
            : ag[getVaxAg(association.antigen)] =
                Antigen(pastDoses: <Dose>[vaccine]);
      }
    }
  }
  return ag;
}

bool datesApply(
        VaxDate dob, VaxDate compareDate, String startAge, String endAge) =>
    dob.minIfNull(startAge) <= compareDate &&
    compareDate < dob.maxIfNull(endAge);