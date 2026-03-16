import { fnbBalikpapan } from "./addSources";

export function addLayers(map) {
    const fnb = fnbBalikpapan(map);

    map.addLayer({
        id: 'fnb-layer',
        type: 'circle',
        source: fnb.fnbLayer,
        paint: {
            'circle-radius': 6,
            'circle-color': '#FF5722'
        }
    });
}