import './map_providers.dart';
import 'package:latlong2/latlong.dart';

String serverIP = "localhost";

bool demoMode = false;
String companyName = "مشوارك";
String appName = "مشوارك";
MapProvider mapProvider = MapProvider.openStreetMap;

// MapBox Configuration (Only if Map Provider is set to mapBox)
String mapBoxAccessToken = "AIzaSyAoGgM3gJ0-BV4LVainn06-3QuRp8sR89o";
String mapBoxUserId = "mapbox";
String mapBoxTileSetId = "streets-v11";

String loginTermsAndConditionsUrl = "";

String defaultCurrency = "USD";
String defaultCountryCode = "+966";
const List<double> tipPresets = [10, 20, 50];

LatLng fallbackLocation = LatLng(37.3382, -121.8863);

// Menu website url
String? websiteUrl;
