import maplibregl from 'maplibre-gl'
import 'maplibre-gl/dist/maplibre-gl.css' 

export function createMap() { //export biar bisa dipanggil di main.js
    return new maplibregl.Map({ //const diubah jd return untuk panggil map di bawah
        container: 'map', //container id
        style: { //style URL ini  ambil dari tampilan yg beda
        version:8,
        sources: {osm: {
              type: 'raster',
              tiles: ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
              tileSize: 256}},
        layers: [{id: 'osm',
                type: 'raster',
                source: 'osm'}]}, 
        center: [116.84674168745062, -1.2106138556202204], //harus bujur, trus lintang
        zoom: 11.5,
        hash: true
    })
}