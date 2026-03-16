export function fnbBalikpapan(map) { //cth data yg digunakan
    const layers = { //buat fungsi biar ga harcode nampilin data
        fnbLayer: 'FNB Balikpapan Layer'
    }

    map.addSource(layers.fnbLayer, {
        type: 'geojson',
        data: 'http://localhost:8081/geoserver/WebGIS_Mapid/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=WebGIS_Mapid%3Anorm_lokasi_fnb&maxFeatures=50&outputFormat=application%2Fjson'
    }); 
    return layers
}