import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/viewmodels/mytheme_view_model.dart';
import 'package:weather_app/viewmodels/weather_view_model.dart';

import 'gecisli_arkaplan_renk.dart';
import 'hava_durumu_resim.dart';
import 'location.dart';
import 'max_min_sicaklik.dart';
import 'sehir_sec.dart';
import 'son_guncelleme.dart';

class WeatherApp extends StatelessWidget {
  String kullanicininSectigiSehir = "Ankara";
  WeatherViewModel _weatherViewModel;

  @override
  Widget build(BuildContext context) {
    _weatherViewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                kullanicininSectigiSehir = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SehirSecWidget()));
                debugPrint("Seçilen sehir: " + kullanicininSectigiSehir);
                _weatherViewModel.havaDurumunuGetir(kullanicininSectigiSehir);
              }),
        ],
      ),
      body: Center(
        child: (_weatherViewModel.state == WeatherState.WeatherLoadedState)
            ? HavaDurumuGeldi()
            : (_weatherViewModel.state == WeatherState.WeatherLoadingState)
                ? havaDurumuGetiriliyor()
                : (_weatherViewModel.state == WeatherState.WeatherErrorState)
                    ? havaDurumuGetirHata()
                    : Text("Sehir Seçin"),
      ),
    );
  }

  havaDurumuGetiriliyor() {
    return CircularProgressIndicator();
  }

  havaDurumuGetirHata() {
    return Text("Hava durumu getirilirken hata olustu");
  }
}

class HavaDurumuGeldi extends StatefulWidget {
  @override
  _HavaDurumuGeldiState createState() => _HavaDurumuGeldiState();
}

class _HavaDurumuGeldiState extends State<HavaDurumuGeldi> {
  WeatherViewModel _weatherViewModel;
  Completer<void> _refreshIndicator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshIndicator = Completer<void>();
    debugPrint("init state tetiklendi");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var kisaltma =
          Provider.of<WeatherViewModel>(context).havaDurumuKisaltmasi();
      debugPrint("kisaltma kodu:" + kisaltma);
      Provider.of<MyThemeViewModel>(context).temaDegistir(kisaltma);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("widget build tetiklendi");
    _refreshIndicator.complete();
    _refreshIndicator = Completer<void>();

    _weatherViewModel = Provider.of<WeatherViewModel>(context);
    String kullanicininSectigiSehir = _weatherViewModel.getirilenWeather.title;

    return GecisliRenkContainer(
      renk: Provider.of<MyThemeViewModel>(context).myTheme.renk,
      child: RefreshIndicator(
        onRefresh: () {
          _weatherViewModel.havaDurumunuGuncelle(kullanicininSectigiSehir);
          return _refreshIndicator.future;
        },
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: LocationWidget(
                secilenSehir: kullanicininSectigiSehir,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Center(child: SonGuncellemeWidget()), //parametresiz kullanım
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: HavaDurumuResimWidget()),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  16.0), //getirilen hava durumunu parametre olarak geçtik
              child: Center(
                  child: MaxveMinSicaklikWidget(
                bugununDegerleri:
                    _weatherViewModel.getirilenWeather.consolidatedWeather[0],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
