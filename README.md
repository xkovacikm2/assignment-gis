# General course assignment

Build a map-based application, which lets the user see geo-based data on a map and filter/search through it in a meaningfull way. Specify the details and build it in your language of choice. The application should have 3 components:

1. Custom-styled background map, ideally built with [mapbox](http://mapbox.com). Hard-core mode: you can also serve the map tiles yourself using [mapnik](http://mapnik.org/) or similar tool.
2. Local server with [PostGIS](http://postgis.net/) and an API layer that exposes data in a [geojson format](http://geojson.org/).
3. The user-facing application (web, android, ios, your choice..) which calls the API and lets the user see and navigate in the map and shows the geodata. You can (and should) use existing components, such as the Mapbox SDK, or [Leaflet](http://leafletjs.com/).

## Example projects

- Showing nearby landmarks as colored circles, each type of landmark has different circle color and the more interesting the landmark is, the bigger the circle. Landmarks are sorted in a sidebar by distance to the user. It is possible to filter only certain landmark types (e.g., castles).

- Showing bicykle roads on a map. The roads are color-coded based on the road difficulty. The user can see various lists which help her choose an appropriate road, e.g. roads that cross a river, roads that are nearby lakes, roads that pass through multiple countries, etc.

## Data sources

- [Open Street Maps](https://www.openstreetmap.org/)

## My project

Fill in (either in English, or in Slovak):

**Application description**: Aplikácia pracuje s dátami z hláseniami San Franciskej polície o kriminálnej aktivite. Zobrazuje na mape regióny, kde sa najčastejšie dejú zločiny a umožňuje filtrovanie nad typmi zločinov.

Príklad prípadu použitia: 
- Zobraz zóny s vysokou koncetráciou hlásení o prostitúcií v okolí budov bánk v prvom kvartály roku 2006.
- Vyhľadaj najbližší zločin k miestu kliknutia na mape a nájdi cestu z najbližšej policajnej stanice k miestu činu, pričom po ceste naviguj k najbližšej kaviarni, aby sa zásahové jednotky mohli občerstviť.
- Zobraz administratívne oblasti San Francisca a zafarbi ich podľa počtu zločinov, ktoré sa odohrali v danej oblasti.
- Zobraz heatmapu násilných trestných činov za rok 2006.

**Data source**: [Open Street Maps](https://www.openstreetmap.org/), [Kaggle](https://www.kaggle.com/san-francisco/sf-police-calls-for-service-and-incidents)

**Technologies used**: Ruby on rails, postgis, mapbox

### Technický popis
Rails aplikácia obsahuje jeden map controller so 4 akciami, každá pre 1 popísaný prípad použitia.
Pripojenie na mapbox api sprostredkúva súbor `assets/javascripts/map.coffee`

Všetky dopyty do databázy sú v servisných triedach v zložke `app/services` pričom každému prípadu použitia prislúcha 1 servisná trieda.

#### Amenities.rb
V queryne sa vykonáva sekvenčný sken nad tabuľkou categories s cenou 22, pri filtrovaní podľa mena. Pridávať index nemá zmysel,
 lebo je to číselník a index by bola rovnako veľká tabuľka. Zároveň pri cene cez 5000 by bola blbosť optimalizovať cost 22. 
 Pri ostatných joinoch a podmienkach sa používa bitmap index scan, čo je super.
 
#### CrimeHeatmap.rb
Opäť sa sekvenčný sken vykonáva len nad tabuľkou číselníka, inak sa vykonávajú Bitmap scany a bitmap andy pre vyhodnocovanie podmienok.

#### PolicePath.rb
Obsahuje najzložitejšiu querynu celého systému, vyhľadávanie trasy k zločinu, k čomu používa dijkstrov algoritmus.
Táto query opäť využíva najmä bitové scany indexu, sekvenčné prehľadávanie sa vykonáva iba nad číselníkmi.

#### RegionHeatmap.rb
- Vykonáva sekvečný scan nad planet_osm_polygon, kde cost je 72000. Pridaním indexu na admin_level sa miesto sekvenčného scanu používa Index scan a cena sa znížila na 0.42.
- V query Podmienka 
```SQL
AND (i.date >= '2004/01/01' OR i.date IS NULL)
AND (i.date <= '2005/01/01' OR i.date IS NULL)
```
vykonáva sekvenčné skenovanie incidentov s cenou 53341. Dátum, ale už indexovaný je, ale preto, že sa to filtrovanie robí až potom nad LEFT JOINnutými dátami (left join lebo chcem zobraziť aj zóny bez incidentov), kvôli null, ktorý môže vzniknúť až dodatočne.
Preto som miesto podmienky po joine, urobil join na subselect s už odfiltrovanými incidentami, kde to viem urobiť bitmap indexovým scanom.
Tým som sa dostal z costu 561848 na 84276 čo je zlepšenie o celý rád.