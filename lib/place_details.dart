class PlaceDetails {
  String? administrativeArea;
  String? postalCode;
  String? subThoroughfare;
  String? country;
  String? name;
  String? subAdministrativeArea;
  String? subLocality;
  String? thoroughfare;
  String? locality;
  String? isoCountryCode;

  PlaceDetails({
    this.administrativeArea,
    this.postalCode,
    this.subThoroughfare,
    this.country,
    this.name,
    this.subAdministrativeArea,
    this.subLocality,
    this.thoroughfare,
    this.locality,
    this.isoCountryCode,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      administrativeArea: json['administrativeArea'],
      postalCode: json['postalCode'],
      subThoroughfare: json['subThoroughfare'],
      country: json['country'],
      name: json['name'],
      subAdministrativeArea: json['subAdministrativeArea'],
      subLocality: json['subLocality'],
      thoroughfare: json['thoroughfare'],
      locality: json['locality'],
      isoCountryCode: json['isoCountryCode'],
    );
  }

  @override
  String toString() {
    return 'PlaceDetails{administrativeArea: $administrativeArea, postalCode: $postalCode, subThoroughfare: $subThoroughfare, country: $country, name: $name, subAdministrativeArea: $subAdministrativeArea, subLocality: $subLocality, thoroughfare: $thoroughfare, locality: $locality, isoCountryCode: $isoCountryCode}';
  }
}
