import maplibregl from 'maplibre-gl' //ini jd dependensi

export function addHandlers(map) {
    console.log("Box zoom", map.boxZoom.isEnabled());
}