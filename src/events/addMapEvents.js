import { addLayers } from "../sources/addLayers";
import { FnbPopup } from "../popup/addGeojsonPopup";

export function addMapEvents(map) {
    map.on('load', function() {
        addLayers(map);
    });


map.on("click", 'fnb-layer', function(event) {
    FnbPopup(event).addTo(map);
    })
}